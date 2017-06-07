#!/bin/bash
set -em

# generate mongo_key
touch /etc/mongo_key && chmod 600 /etc/mongo_key && chown mongodb /etc/mongo_key
echo -n "$MONGODB_USER:$MONGODB_PASS" | base64 > /etc/mongo_key


if [ "${1:0:1}" = '-' ]; then
    set -- mongod "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'mongod' -a "$(id -u)" = '0' ]; then
    chown -R mongodb /data/configdb /data/db
    exec gosu mongodb "$BASH_SOURCE" "$@"
fi

if [ "$1" = 'mongod' ]; then
    numa='numactl --interleave=all'
    if $numa true &> /dev/null; then
        set -- $numa "$@"
    fi
fi

# exec mongod
(exec $@) &


if [[ $PRIMARY -eq 1 ]];then
    sleep 1
    /portcheck

    RET=1
    while [[ RET -ne 0 ]]; do
        echo "=> Waiting for confirmation of MongoDB service startup"
        sleep 5
        mongo admin --eval "help" >/dev/null 2>&1
        RET=$?
    done

    echo "=> Inintialing MongoDB Replica Set"
    mongo admin << EOF
cfg={ _id:"${replSet:-rs0}", members:[ {_id:0,host:'mongop0:27017', priority:1}] };
rs.initiate(cfg);
EOF

    is_primary=0
    while [[ $is_primary -eq 0 ]]; do
        echo "=> Waiting node to be primary.."
        sleep 2
        state=$(mongo --eval 'rs.status().members[0].stateStr' | tail -1)
        if [[ "$state" == "PRIMARY" ]]; then
            is_primary=1
        elif [[ $(echo $state | grep failed) ]]; then
            fg # node restart, just fg
        fi
    done
    echo "=> Setting Password Authentication"
    USER=${MONGODB_USER:-"admin"}
    DATABASE=${MONGODB_DATABASE:-"admin"}
    PASS=${MONGODB_PASS:-$(pwgen -s 12 1)}
    _word=$( [ ${MONGODB_PASS} ] && echo "preset" || echo "random" )
    echo "=> Creating an ${USER} user with a ${_word} password in MongoDB"
    mongo admin --eval "db.createUser({user: '$USER', pwd: '$PASS', roles:[{role:'root',db:'admin'}]});"
    if [ "$DATABASE" != "admin" ]; then
        echo "=> Creating an ${USER} user with a ${_word} password in MongoDB"
        mongo admin -u $USER -p $PASS << EOF
use $DATABASE
db.createUser({user: '$USER', pwd: '$PASS', roles:[{role:'dbOwner',db:'$DATABASE'}]})
db.delete_me.insertOne({})
db.delete_me.find()
db.delete_me.deleteOne({})
EOF
    fi
    echo "=> Done!"
    echo "========================================================================"
    echo "You can now connect to this MongoDB server using:"
    echo ""
    echo "    mongo $DATABASE -u $USER -p $PASS --host <host> --port <port>"
    echo ""
    echo "========================================================================"
    mongo admin -u $USER -p $PASS <<  EOF
rs.add("192.168.1.71:30022");
rs.add("192.168.1.181:30072");
rs.status();
EOF
fi
# put mongod in forground
fg

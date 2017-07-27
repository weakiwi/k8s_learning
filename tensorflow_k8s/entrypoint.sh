#!/bin/bash
set -ex
#cat /etc/hosts | tail -1 >> /data/hosts
function check_env() {
    if [ -z $1 ];
    then
        exit 1
    fi
}

check_env $WORKDIR
check_env $PS_HOST
check_env $WORK_HOST

export TASK_INDEX=$(hostname| grep -o '[0-9]')
export JOB_NAME=$(hostname| grep -o -e "worker" -e "ps")
#if [ $ADDRESS ];
#then
##/ping.py
#fi
#cd $(dirname $WORKDIR)
#sleep 10
#cat /data/hosts >> /etc/hosts
tmp_str="ping -c1 "
tmp_str_1=$(echo $ADDRESS| sed 's/\,/\&\& ping -c1 /g')
new_str=${tmp_str}${tmp_str_1}
while /bin/true
do
        echo $new_str
        eval $new_str
        if [ $? -eq 0 ];
        then
                break
        fi
done
python $(basename $WORKDIR) --ps_hosts=$PS_HOST --worker_hosts=$WORK_HOST --job_name=$JOB_NAME --task_index=$TASK_INDEX

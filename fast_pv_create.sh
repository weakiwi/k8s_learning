#!/bin/bash

MOUNTPATH="/var/lib/mysql"
PVPATH="/tmp/data"
PVCAP="500Mi"
PVMODE="ReadWriteOnce"
PVNUM=3


createYaml()
{
	cat <<EOF > 'pv'$1'.yaml'
kind: PersistentVolume
apiVersion: v1
metadata:
  name: pv${1}
  namespace: myns
spec:
  capacity:
    storage: ${2}
  accessModes:
    - ${3}
  nfs:
    server: 192.168.2.216
    path: "/tmp/data${1}"
EOF
}
for (( i=0; i<$PVNUM ; i++ ))
do
	createYaml $i $PVCAP $PVMODE $PVPATH
done
for (( i=0; i<$PVNUM ; i++ ))
do
	kubectl --kubeconfig /etc/kubernetes/admin.conf	create -f pv${i}.yaml
done
for (( i=0; i<$PVNUM ; i++ ))
do
	mkdir -p $PVPATH${i}
done
for (( i=0; i<$PVNUM ; i++ ))
do
	mv pv${i}.yaml /tmp
done

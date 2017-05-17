#!/bin/bash

getId() {
	tmpResult=$(kubectl --kubeconfig /etc/kubernetes/admin.conf get $1|awk '{print $1}')
	tmpArr=($tmpResult)
	for i in ${tmpArr[@]}
	do
		echo "${i}" | grep -q "$2"
		if [[ $? -eq 0 ]]
		then
			echo $i
		fi
	done
}

tmpId=$(getId $2 $3)
if [ "$1"x == "describe"x ]
then
	for i in ${tmpId[@]}
	do
		kubectl --kubeconfig /etc/kubernetes/admin.conf $1 $2 $i
	done
fi
if [ "$1"x == "get"x ]
then
	kubectl --kubeconfig /etc/kubernetes/admin.conf $1 $2
fi

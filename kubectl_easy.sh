#!/bin/bash

getId() {
	tmpResult=$(kubectl --kubeconfig /etc/kubernetes/admin.conf get $1|awk '{print $1}')
	tmpArr=($tmpResult)
	for i in ${tmpArr[@]}
	do
		echo "${i}" | grep -iq "$2"
		if [[ $? -eq 0 ]]
		then
			echo $i
		fi
	done
}

getAll() {
	tmpStr="empty"
	kubectl --kubeconfig /etc/kubernetes/admin.conf get $1|while read line;do
		echo "${line}" | grep -iq "$2"
		if [[ $? -eq 0 ]]
		then
			tmpStr=`echo $line|awk '{print $1}'`
			echo $tmpStr
		fi
	done
}

tmpId=$(getId $2 $3)
lastArg=`echo $@|awk '{print $(NF)}'`
if [ "$4"x == "all"x ]
then
	tmpId=$(getAll $2 $3)
	if [ "$tmpId"x != "empty" ]
	then
		kubectl --kubeconfig /etc/kubernetes/admin.conf $1 $2 $tmpId
		echo -e "\033[31m ############################################################## \033[0m"
	fi
elif [ "$lastArg"x == "show"x ]
then
	for i in ${tmpId[@]}
	do
		kubectl --kubeconfig /etc/kubernetes/admin.conf describe $2 $i
		echo -e "\033[31m ############################################################## \033[0m"
	done
elif [ "$lastArg"x == "delete"x ]
then
	for i in ${tmpId[@]}
	do
		kubectl --kubeconfig /etc/kubernetes/admin.conf delete $2 $i
		echo -e "\033[31m ############################################################## \033[0m"
	done

elif [ "$1"x == "create"x ] && [ "$2"x == "all"x ]
then
	for file in ./*.yaml
	do
		kubectl --kubeconfig /etc/kubernetes/admin.conf create -f $file
		echo -e "\033[31m ############################################################## \033[0m"
	done
else
	kubectl --kubeconfig /etc/kubernetes/admin.conf $@
fi

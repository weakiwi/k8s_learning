#!/bin/bash

alias kubed="kubectl --kubeconfig /etc/kubernetes/admin.conf"

for file in ./*
do
	 kubectl --kubeconfig /etc/kubernetes/admin.conf create -f $file --validate=false
done

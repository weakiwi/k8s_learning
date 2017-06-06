#!/bin/sh
for i in $*
do
	until nslookup $i; do echo waiting for $i; sleep 2; done;
done


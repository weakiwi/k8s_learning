#!/bin/sh
for i in $*
do
	until nslookup $1; do echo waiting for $1; sleep 2; done;
done


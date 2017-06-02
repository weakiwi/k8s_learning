#!/bin/bash

TEST_CLIENT=(8 1)
TEST_BYTES=(15 1)
TEST_REQUEST=(50000 1)
TEST_OPTION=2
TEST_RANGE=10
TEST_IP=192.168.2.216
TEST_PORT=30011
REPORT_FILE=/tmp/report.csv

while (($TEST_RANGE>0))
do
	redis-benchmark -h $TEST_IP -p $TEST_PORT -c ${TEST_CLIENT[0]} -n ${TEST_REQUEST[0]} -d ${TEST_DATA[0]} -t get > /tmp/result
	case $TEST_OPTION in
		1) 
		tmpnum=`cat /tmp/result | grep complete| awk '{print $5}'`
		echo "${tmpnum},${TEST_CLIENT[0]}" >> $REPORT_FILE
		TEST_CLIENT=(`echo | awk -v tmpVar1=${TEST_CLIENT[0]} -v tmpVar2=${TEST_CLIENT[1]} '{print tmpVar1*tmpVar2}'` ${TEST_CLIENT[1]})
		;;
		2) 
		tmpnum=`cat /tmp/result | grep complete| awk '{print $5}'`
		echo "${tmpnum},${TEST_BYTES[0]}" >> $REPORT_FILE
		TEST_BYTES=(`echo | awk -v tmpVar1=${TEST_BYTES[0]} -v tmpVar2=${TEST_BYTES[1]} '{print tmpVar1*tmpVar2}'` ${TEST_BYTES[1]})
		;;
		3) 
		tmpnum=`cat /tmp/result | grep complete| awk '{print $5}'`
		echo "${tmpnum},${TEST_REQUEST[0]}" >> $REPORT_FILE
		TEST_REQUEST=(`echo | awk -v tmpVar1=${TEST_REQUEST[0]} -v tmpVar2=${TEST_REQUEST[1]} '{print tmpVar1*tmpVar2}'` ${TEST_REQUEST[1]})
		;;
	esac
	TEST_RANGE=`echo | awk -v tmpVar=$TEST_RANGE '{print tmpVar-1}'`
done


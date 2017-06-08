#!/bin/bash

isPort=0
tmpfilename=`echo "service-${RANDOM}.yaml"`
cat mongo-swarm.yaml | while read line

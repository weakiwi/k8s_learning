#!/bin/bash
set -ex

function check_env() {
    if [ -z $1 ];
    then
        exit 1
    fi
}

check_env $WORKDIR
check_env $PS_HOST
check_env $WORK_HOST
check_env $ADDRESS

export TASK_INDEX=$(hostname| grep -o '[0-9]')
export JOB_NAME=$(hostname| grep -o -e "worker" -e "ps")
./portcheck
python $WORKDIR --ps_hosts=$PS_HOST --worker_hosts=$WORK_HOST --job_name=$JOB_NAME --task_index=$TASK_INDEX

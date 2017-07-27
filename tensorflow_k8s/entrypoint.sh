#!/bin/bash
set -ex
WORKDIR=
PS_HOST=
WORK_HOST=
JOB_NAME=
TASK_INDEX=
OTHER_COMMAND=

function check_env() {
    if [ -z $1 ];
    then
        exit 1
    fi
}

check_env $WORKDIR
check_env $PS_HOST
check_env $WORK_HOST
check_env $JOB_NAME

export TASK_INDEX=$(hostname| grep -o '[0-9]')
export JOB_NAME=$(hostname| grep -o -e "worker" -e "ps")
python $WORKDIR --ps_hosts=$PS_HOST --worker_hosts=$WORK_HOST --job_name=$JOB_NAME --task_index=$TASK_INDEX

#!/bin/bash

# Usage: ./run.sh [master|worker] [MASTER_IP] [WORKER_IP] [linux|mac]
ROLE=$1
MASTER_IP=$2
WORKER_IP=$3
OS=$4

if [ "$ROLE" == "master" ]; then
    export MASTER_IP=$MASTER_IP
    bash master/deploy/linux_mac.sh
elif [ "$ROLE" == "worker" ]; then
    export MASTER_IP=$MASTER_IP
    export WORKER_IP=$WORKER_IP
    if [ "$OS" == "mac" ]; then
        bash worker/deploy/mac.sh
    else
        bash worker/deploy/linux.sh
    fi
else
    echo "Usage: ./run.sh [master|worker] [MASTER_IP] [WORKER_IP] [linux|mac]"
fi

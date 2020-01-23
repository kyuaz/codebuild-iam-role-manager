#!/bin/bash

source ./param.sh
source ./${DIR_NAME}/param.sh

aws cloudformation delete-stack --stack-name $STACK_NAME
aws cloudformation wait stack-delete-complete --stack-name $STACK_NAME

aws cloudformation describe-stacks --stack-name $STACK_NAME 2>&1 1>/dev/null | grep error > /dev/null
if [ $? = 0 ]; then
    echo -e "\ndelete stack completed"
else
    echo -e "\nddelete stack error"
    exit 1
fi

#!/bin/bash

source ./param.sh
source ./${DIR_NAME}/param.sh

echo "TEMPLATE_URL: ${TEMPLATE_URL}"

echo "validate template file"
aws cloudformation validate-template --template-url $TEMPLATE_URL 3>&1 1>&2 2>&3 | grep ValidationError
if [ $? = 0 ]; then
    echo "cloudformation template validate error"
    exit 1
fi
echo -e "validate template file OK\n"

aws cloudformation describe-stacks --stack-name $STACK_NAME 3>&1 1>&2 2>&3 | grep error >/dev/null
if [ $? = 0 ]; then
    echo "creating new stack."
    aws cloudformation create-stack --stack-name $STACK_NAME --template-url $TEMPLATE_URL --tags Key=COST,Value=$TAG_COST_VALUE --capabilities CAPABILITY_NAMED_IAM --region ${REGION} --parameters file://${TEMPLATE_PARAMETER_FILE}
    echo "waiting stack create complete..."
    aws cloudformation wait stack-create-complete --stack-name $STACK_NAME
else
    echo "stack exists."
    if [ $MODE = $ENV_MODE_CREATE_ROLE ]; then
        echo "stack already exists error. if you want to update IAM Role, use update MODE instead."
        exit 1
    elif [ $MODE = $ENV_MODE_UPDATE_ROLE ]; then
        aws cloudformation describe-stacks --stack-name $STACK_NAME 2>&1 | grep ROLLBACK_COMPLETE
        if [ $? = 0 ]; then
            echo "stack state is ROLLBACK_COMPLETE. deleting stack.."
            aws cloudformation delete-stack --stack-name $STACK_NAME
            aws cloudformation wait stack-delete-complete --stack-name $STACK_NAME
            echo "creating stack.."
            aws cloudformation create-stack --stack-name $STACK_NAME --template-url $TEMPLATE_URL --tags Key=COST,Value=$TAG_COST_VALUE --capabilities CAPABILITY_NAMED_IAM --region ${REGION} --parameters file://${TEMPLATE_PARAMETER_FILE}
            echo "waiting stack create complete..."
            aws cloudformation wait stack-create-complete --stack-name $STACK_NAME
        else
            echo "updating stack.."
            aws cloudformation update-stack --stack-name $STACK_NAME --template-url $TEMPLATE_URL --tags Key=COST,Value=$TAG_COST_VALUE --capabilities CAPABILITY_NAMED_IAM --region ${REGION} --parameters file://${TEMPLATE_PARAMETER_FILE} 2>&1 1>/dev/null | grep error
            if [ $? = 0 ]; then
                echo "update stack error"
                exit 1
            else
                echo "waiting stack update complete..."
                aws cloudformation wait stack-update-complete --stack-name $STACK_NAME
            fi
        fi
    fi
fi

aws cloudformation describe-stacks --stack-name $STACK_NAME

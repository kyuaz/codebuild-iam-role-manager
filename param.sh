#!/bin/bash

if [ -z $IS_EXECUTED ]; then
    ENV_MODE_CREATE_ROLE="create"
    ENV_MODE_DELETE_ROLE="delete"
    ENV_MODE_UPDATE_ROLE="update"
    ENV_ROLE_BASIC_LAMBDA_ROLE="lambda"
    ENV_ROLE_DYNAMODB_READONLY_ROLE="dynamodb-readonly-lambda"

    S3_BUCKET_NAME="build-bucket"
    S3_PRJ_NAME="iam-role-manager"
    S3_TEMPLATE_DIR="s3://${S3_BUCKET_NAME}/${S3_PRJ_NAME}/template/"
    REGION="ap-northeast-1"
    TEMPLATE_URL="https://s3-${REGION}.amazonaws.com/${S3_BUCKET_NAME}/${S3_PRJ_NAME}/template/template.yaml"

    if [ -z $MODE ]; then
        echo "ERROR: MODE is required"
        exit 1
    fi
    if [ -z $ROLE ]; then
        echo "ERROR: ROLE is required"
        exit 1
    fi
    echo "MODE = ${MODE}"
    echo "ROLE = ${ROLE}"

    if [ $ROLE = $ENV_ROLE_BASIC_LAMBDA_ROLE ]; then
        DIR_NAME="iam-role-lambda"
    elif [ $ROLE = $ENV_ROLE_DYNAMODB_READONLY_ROLE ]; then
        DIR_NAME="iam-role-dynamodb-readonly-lambda"
    else
        echo "invalid ROLE"
        exit 1
    fi

    IS_EXECUTED=1
fi

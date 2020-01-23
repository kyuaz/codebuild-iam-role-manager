#!/bin/bash

source ./param.sh
source ./${DIR_NAME}/param.sh

echo "S3_TEMPLATE_DIR: ${S3_TEMPLATE_DIR}"
aws s3 cp ./${DIR_NAME}/template.yaml $S3_TEMPLATE_DIR
aws s3 ls $S3_TEMPLATE_DIR

#!/bin/bash

source ./param.sh

TEMPLATE_PARAMETER_FILE="./${DIR_NAME}/template_param.json"

POSTFIX="${ROLE}-role"
STACK_NAME="${S3_PRJ_NAME}-${POSTFIX}"
TAG_COST_VALUE="cf-${S3_PRJ_NAME}-${POSTFIX}"

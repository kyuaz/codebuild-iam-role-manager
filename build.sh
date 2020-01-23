#!/bin/bash

source ./param.sh
source ./${DIR_NAME}/param.sh

if [ $MODE = $ENV_MODE_CREATE_ROLE ] || [ $MODE = $ENV_MODE_UPDATE_ROLE ]; then
    bash ./upload.sh
    bash ./deploy.sh
elif [ $MODE = $ENV_MODE_DELETE_ROLE ]; then
    bash ./delete.sh
fi

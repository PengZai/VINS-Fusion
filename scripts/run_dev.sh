#!/bin/bash


IMAGE_NAME="vins-fusion:noetic-ros"
DATA_PATH="/media/${USER}/zhipeng_usb/datasets"
# Pick up config image key if specified
if [[ ! -z "${CONFIG_DATA_PATH}" ]]; then
    DATA_PATH=$CONFIG_DATA_PATH
fi


PROJECT_DIR=$(pwd)
PROJECT_NAME=$(basename "$PWD")


docker build -t $IMAGE_NAME -f "${HOME}/vscode_projects/VINS-Fusion/catkin_ws/src/VINS-Fusion/Dockerfile_for_dev" .


xhost +local:docker

docker run \
    -e DISPLAY \
    -v ~/.Xauthority:/root/.Xauthority:rw \
    --network host \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v ${HOME}/vscode_projects/VINS-Fusion/catkin_ws:/root/catkin_ws \
    -v ${DATA_PATH}:/root/datasets \
    --privileged \
    --cap-add sys_ptrace \
    --runtime=nvidia \
    --gpus all \
    -it --name $PROJECT_NAME $IMAGE_NAME /bin/bash

xhost -local:docker
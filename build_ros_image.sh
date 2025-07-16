#!/bin/bash
IMAGE_NAME="ros2-raspi-dev"
IMAGE_TAG="latest"
DOCKERFILE_DIR="."

sudo docker buildx build --platform linux/arm64 -t "${IMAGE_NAME}:${IMAGE_TAG}" --load "${DOCKERFILE_DIR}"


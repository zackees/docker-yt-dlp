#!/bin/bash

# Define your image name
IMAGE_NAME=docker-yt-dlp

# Check if the image already exists
docker image inspect $IMAGE_NAME > /dev/null 2>&1

# If the image doesn't exist, build it
if [ $? -ne 0 ]; then
    docker build -t $IMAGE_NAME .
fi

# Run your Docker container with the necessary arguments
# Replace 'your-arguments-here' with the actual arguments for yt-dlp
docker run $IMAGE_NAME "$@"

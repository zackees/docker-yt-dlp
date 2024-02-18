#!/bin/bash

# Define your image and container names
IMAGE_NAME=docker-yt-dlp
CONTAINER_NAME=container-docker-yt-dlp

# Check if the container already exists
container_exists=$(docker ps -a -q -f name=^/${CONTAINER_NAME}$)
if [[ -n $container_exists ]]; then
    echo "Container already exists, starting it if not already running..."
    # Check if the container is already running
    if [ "$(docker inspect -f '{{.State.Running}}' $CONTAINER_NAME)" = "false" ]; then
        docker start $CONTAINER_NAME
    fi
else
    echo "Container does not exist, building and creating it..."

    # Build the Docker image if it doesn't exist
    if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
        echo "Image does not exist, building..."
        docker build -t $IMAGE_NAME .
    fi

    # Run your Docker container with the necessary arguments
    # Replace 'your-arguments-here' with the actual arguments for yt-dlp
    docker run --name $CONTAINER_NAME -v "$(pwd)":/host_dir $IMAGE_NAME "$@"
fi

#!/bin/bash

# Define your image name
IMAGE_NAME=docker-yt-dlp

# Remove the previous Docker container and image if they exist
docker rm -f $IMAGE_NAME || true
docker rmi -f $IMAGE_NAME || true

# Build the Docker image
docker build -t $IMAGE_NAME .

# Run your Docker container with the necessary arguments
# Replace 'your-arguments-here' with the actual arguments for yt-dlp
docker run -v "$(pwd)":/host_dir $IMAGE_NAME "$@"


import sys
import os
from typing import Optional
import docker
from docker.models.containers import Container
from docker.models.images import Image

# Define your image and container names
IMAGE_NAME: str = 'docker-yt-dlp'
CONTAINER_NAME: str = 'container-docker-yt-dlp'

# Create a Docker client
client: docker.DockerClient = docker.from_env()

# Function to check if the container exists and return it
def get_container(container_name: str) -> Optional[Container]:
    try:
        return client.containers.get(container_name)
    except docker.errors.NotFound:
        return None

# Function to check if the image exists
def image_exists(image_name: str) -> bool:
    try:
        client.images.get(image_name)
        return True
    except docker.errors.ImageNotFound:
        return False

def main() -> None:
    # Build the Docker image if it doesn't exist
    if not image_exists(IMAGE_NAME):
        print("Image does not exist, building...")
        client.images.build(path=".", tag=IMAGE_NAME)
    
    # Check if the container already exists
    container: Optional[Container] = get_container(CONTAINER_NAME)
    if container:
        container.remove(force=True)  # Force removal if running
    
    # Run your Docker container with the necessary arguments
    container = client.containers.run(
        IMAGE_NAME, 
        " ".join(sys.argv[1:]),
        name=CONTAINER_NAME,
        volumes={os.getcwd(): {'bind': '/host_dir', 'mode': 'rw'}},
        detach=False,
        stream=True,
        remove=True
    )
    for log in container:
        print(log.decode("utf-8"), end="")

if __name__ == "__main__":
    main()

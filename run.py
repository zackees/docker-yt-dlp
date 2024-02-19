import sys
import os
import time
import subprocess
from typing import Optional
import docker
from docker.errors import DockerException
from docker.models.containers import Container

# Define your image and container names
IMAGE_NAME: str = 'docker-yt-dlp'
CONTAINER_NAME: str = 'container-docker-yt-dlp'

HOST_VOLUME = os.getcwd()

WIN_DOCKER_EXE = r"C:\Program Files\Docker\Docker\Docker Desktop.exe"

def check_docker_running() -> bool:
    """Check if Docker service is running on Windows."""
    cmd = "docker ps"
    try:
        subprocess.run(cmd, capture_output=True, text=True, check=True)
        return True
    except subprocess.CalledProcessError:
        return False

def start_docker_service() -> None:
    """Start Docker service on Windows."""
    print("Starting Docker service...")
    #subprocess.run(['sc', 'start', 'com.docker.service'], capture_output=True, text=True)
    subprocess.run(["start", "", WIN_DOCKER_EXE], capture_output=True, text=True, check=True)
    # Wait for Docker to start. Adjust the sleep time as needed.
    print("Waiting for Docker to start...")
    now = time.time()
    future_time = now + 30
    while time.time() < future_time:
        if check_docker_running():
            print("\nDocker started successfully.")
            return
        time.sleep(1)
        print(".", end="", flush=True)
    print("Docker failed to start.")
    raise OSError("Docker failed to start.")

def get_container(client: docker.DockerClient, container_name: str) -> Optional[Container]:
    try:
        return client.containers.get(container_name)
    except docker.errors.NotFound:
        return None

def image_exists(client: docker.DockerClient, image_name: str) -> bool:
    try:
        client.images.get(image_name)
        return True
    except docker.errors.ImageNotFound:
        return False

def main() -> None:
    if not check_docker_running():
        start_docker_service()
    try:
        client: docker.DockerClient = docker.from_env()
    except DockerException:
        print("Docker is not running. Please start Docker and try again.")
        return
    
    if not image_exists(client, IMAGE_NAME):
        print("Image does not exist, pulling...")
        client.images.pull(IMAGE_NAME)
    
    container: Optional[Container] = get_container(client, CONTAINER_NAME)
    if container:
        print("Removing existing container...")
        container.remove(force=True)  # Force removal if running or stopped
    
    print("Running Docker container with the necessary arguments...")
    container = client.containers.run(
        IMAGE_NAME, 
        " ".join(sys.argv[1:]),
        name=CONTAINER_NAME,
        volumes={HOST_VOLUME: {'bind': '/host_dir', 'mode': 'rw'}},
        detach=True,
        auto_remove=True
    )

    for log in container.logs(stream=True):
        print(log.decode("utf-8"), end="")

if __name__ == "__main__":
    main()

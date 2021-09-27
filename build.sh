#!/bin/sh

cmd="run --rm -it -v $(pwd):/antora:z docker.io/antora/antora --html-url-extension-style=indexify site.yml"

container_launch() {
    # Use podman if available on Linux, otherwise use docker
    if hash podman 2>/dev/null; then
        echo "This build script is using Podman to run the build in an isolated environment."
        podman $1

    elif hash docker 2>/dev/null; then

        if groups | grep -wq "docker"; then
            echo "This build script is using Docker to run the build in an isolated environment."
            docker $1

        else
            echo "This build script is using $runtime to run the build in an isolated environment. You might be asked for your password."
            echo "You can avoid this by adding your user to the 'docker' group, but be aware of the security implications. See https://docs.docker.com/install/linux/linux-postinstall/."
            sudo docker $1
        fi

    else
        echo "Error: No container runtimes were found."
        echo "Please install either podman or docker"
        exit 1
    fi
}

if [ "$(uname)" = "Darwin" ]; then
    # Running on macOS.
    # Let's assume that the user has the Docker CE installed
    # which doesn't require a root password.
    echo "This build script is using Docker container runtime to run the build in an isolated environment."
    docker run $cmd

elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
    # Running on Linux.
    # Build the documentation using the container_launch function
    container_launch "$cmd"
fi

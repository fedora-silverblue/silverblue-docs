#!/bin/sh

cmd="run --rm -v $(pwd):/antora:ro -v $(pwd)/nginx.conf:/etc/nginx/conf.d/default.conf:ro -p 8080:80 docker.io/nginx"

container_launch() {
    # Use podman if available on Linux, otherwise use docker
    if hash podman 2>/dev/null; then
        echo "Podman is launching the preview."
        echo "The preview will be available at http://localhost:8080/"
        podman $1

    elif hash docker 2>/dev/null; then
    
	if groups | grep -wq "docker"; then
            echo "Docker is launching the preview in an isolated environment."
	    echo "The preview will be available at http://localhost:8080/"
            docker $1

        else
            echo "This preview script is using $runtime to run the preview in an isolated environment. You might be asked for your password."
            echo "You can avoid this by adding your user to the 'docker' group, but be aware of the security implications. See https://docs.docker.com/install/linux/linux-postinstall/."
	    echo "The preview will be available at http://localhost:8080/"
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
    echo ""
    echo "The preview will be available at http://localhost:8080/"
    echo ""
    docker "$cmd"

elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
    # Running on Linux.
    # Run the preview using the container_launch function
    echo ""
    container_launch "$cmd"
fi

#!/bin/bash
set -e

# Functions to list images.

list_docker_images() {
    echo "Listing the available docker images..."
    docker images
}

# Function to delete a docker image.

delete_docker_image() {
    read -p "Name the docker image that you would like to delete: " image_name_to_delete
    stop_container "${image_name_to_delete}"
    if docker images --format "{{.Repository}}:{{.Tag}}" | grep -q "^${image_name_to_delete}$"; then
        echo "Removing the image: ${image_name_to_delete}..."
        docker rmi "${image_name_to_delete}"
        echo "Successfully deleted ${image_name_to_delete}"
    else
        echo "Image not found. Skipping deletion..."
    fi
}

# Function to build a docker image

build_image() {
    read -p "Enter the path to the Docker File: " path_to_dockerfile
    read -p "Enter the name for the image with the tag [image_name:tag]: " image_name
    if ! cd "${path_to_dockerfile}"; then
        echo "Invalid path..."
        exit 1
    else
        echo "Building the image..."
        docker build -t "${image_name}" .
        echo "Successfully created image, ${image_name}."
    fi
}

# Function to run a Docker Container

run_container() {
    read -p "Do you want to run any image as a container? [y/N]: " choice
    if [[ "${choice}" == "y" || "${choice}" == "Y" ]]; then
        read -p "Enter the image name and tag to containerize: " image_to_container
        read -p "Enter the port to expose: " container_port
        if ! [[ "${container_port}" =~ ^[0-9]+$ ]]; then
            echo "Invalid port number."
            exit 1
        fi
        docker run -d -p "${container_port}:${container_port}" "${image_to_container}"
        if [[ $? -ne 0 ]]; then
            echo "Container creation failed."
            exit 1
        else
            echo "Container created successfully."
            docker ps --filter "ancestor=${image_to_container}" --format "table {{.ID}}\t{{.Image}}\t{{.Ports}}"
        fi
    else
        echo "Thank you. Bye!!!"
    fi
}

# Function to stop a container.

stop_container() {
    local image="$1"
    containers=$(docker ps -q --filter "ancestor=${image}")
    if [[ -n "${containers}" ]]; then
        echo "Stopping the container: "
        docker stop $containers
        read -p "Would you like to remove the container? [y/N]: " remove_container_choice
        if [[ "${remove_container_choice}" == "y" || "${remove_container_choice}" == "Y" ]]; then
            remove_container $containers
            echo "Removed the container successfully"
            if [[ $? -ne 0 ]]; then
                echo "FAILED: Couldn't Remove Container."
                exit 1
            fi
        else
            echo "Since no permission to remove the container, exiting the process."
            exit 0
        fi
    else
        echo "No containers running using this image."
    fi
}

# Function to remove the container.
remove_container() {
    echo "Removing the container..."
    docker rm "$@"
}

# Main execution flow
main(){
    echo ""
    read -p "Welcome!!! Would you like to:

1) Delete an existing image.
2) Create a new image.
3) Stop and remove a container.
4) Run a new Container
5) Exit the script.

Please Enter your requirement [1-5 or q/Q/exit/Exit the script]: " requirement
    case "${requirement}" in
        1)
            list_docker_images
            delete_docker_image
            read -p "Do you want to create a new image? [y/N]: " create_choice
            if [[ "${create_choice}" == "y" || "${create_choice}" == "Y" ]]; then
                build_image
                run_container
            else
                echo "Thank you. Bye!!!"
                exit 0
            fi
            ;;
        2)
            build_image
            run_container
            ;;
        3)
            list_docker_images        
            read -p "Enter the image name to stop its containers: " image_name
            stop_container "$image_name"
            ;;
        4)
            run_container
            ;;
        5|q|Q|exit|Exit)
            echo "Exiting the script, Thank you!"
            exit 0
            ;;
        *)
            echo "Invalid choice... Please enter a number between 1 and 5: "
            ;;
    esac
}

while true; do
    main
    read -p "Would you like to perform another operation? [y/N]: " operation_choice
    [[ "${operation_choice}" =~ ^[Yy]$ ]] || break
done
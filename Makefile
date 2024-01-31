# Name of the image
IMAGE_NAME=ubuntu-setup

# Base directory to mount in the container
MOUNT_DIR=/home/macke/dev/github.com/arubertoson/zsh

# Define phony targets to avoid conflicts with files of the same name
.PHONY: build run

# Build command
build:
	docker build -t $(IMAGE_NAME) .

# Run command
run:
	docker run -it --rm -v "$(PWD)":$(MOUNT_DIR) $(IMAGE_NAME)

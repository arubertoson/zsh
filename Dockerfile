# Use the official Ubuntu 24.04 image as a base
FROM ubuntu:24.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install sudo
RUN apt-get update && apt-get install -y sudo

# Give the macke user passwordless sudo privileges
RUN useradd -m macke
RUN chown -R macke:macke /home/macke
RUN echo 'macke:macke' | chpasswd
RUN echo 'macke ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Set the working directory to macke's home directory
WORKDIR /home/macke

# Switch to user "macke"
USER macke
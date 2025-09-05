# Use an Ubuntu base image
FROM ubuntu:20.04

# Set non-interactive mode for apt-get to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    git \
    curl \
    ca-certificates \
    libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda
WORKDIR /root
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /root/miniconda && \
    rm miniconda.sh

# Set environment variables for Conda
ENV PATH="/root/miniconda/bin:$PATH"
RUN conda init bash

# Copy your Conda environment YAML file
COPY bsarec_env.yaml /root/

# Create the Conda environment
RUN conda env create -f /root/bsarec_env.yaml

# Set the default shell to bash and activate the environment
SHELL ["/bin/bash", "-c"]

# Activate the environment automatically in container
RUN echo "conda activate bsarec" >> ~/.bashrc

# Set the default command to keep the container running
CMD ["bash"]
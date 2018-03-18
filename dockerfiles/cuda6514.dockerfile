
FROM ubuntu:14.04

# Modified version of powerjg/gpgpu-sim-build.
# This Dockerfile builds GPGPU-Sim correctly, but does not run programs correctly.

# This Dockerfile makes the following changes:

# Ubuntu 12.04 -> 14.04
# 14.04 is the last LTS that has GCC 4.6 available as a package in apt.

# CUDA 3.2.16 -> 6.5.14
# 6.5.14 is the first version that offically supports Ubuntu 14.04.
# The last version that does so is 8.0 GA2, so any within that range is potentially an option.
# However, GPGPU-Sim only works with up to 8.0 (and officially supports only up to 4.0), so 8.0 GA1 is probably the last version that can be used.

# GPU Computing SDK 3.2.16 -> 4.0.17
# 4.0.17 appears to be the last version available.

MAINTAINER Justin Perona <jlperona@ucdavis.edu>

##################
# UPDATE SECTION #
##################

# GCC version 4.6.4 is the last version that GPGPU-Sim compiles on.
RUN apt-get update -y && apt-get install -y \
    bison \
    build-essential \
    flex \
    g++-4.6 \
    gcc-4.6 \
    libglu1-mesa-dev \
    libxi-dev \
    libxmu-dev \
    wget \
    xutils-dev \
    zlib1g-dev

# Change symlinks to point to GCC 4.6.
RUN rm /usr/bin/gcc && ln -s /usr/bin/gcc-4.6 /usr/bin/gcc
RUN rm /usr/bin/g++ && ln -s /usr/bin/g++-4.6 /usr/bin/g++

################
# CUDA SECTION #
################

# Download CUDA version 6.5.14.
RUN wget http://developer.download.nvidia.com/compute/cuda/6_5/rel/installers/cuda_6.5.14_linux_64.run

# Download GPU Computing SDK version 4.0.17.
RUN wget http://developer.download.nvidia.com/compute/cuda/4_0/sdk/gpucomputingsdk_4.0.17_linux.run

# Install CUDA version 6.5.14, and the samples.
# Use the default install location for both.
RUN bash cuda_6.5.14_linux_64.run --silent --toolkit --samples

# Install GPU Computing SDK version 4.0.17.
RUN bash gpucomputingsdk_4.0.17_linux.run

RUN mv /root/NVIDIA_GPU_Computing_SDK/C /usr/local/cuda && \
    mv /root/NVIDIA_GPU_Computing_SDK/shared /usr/local/cuda

RUN echo " \
    export CUDAHOME=/usr/local/cuda; \
    export PATH=$PATH:/usr/local/cuda/bin; \
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/lib; \
    export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/cuda/C/lib:/usr/local/cuda/shared/lib; \
    export CUDA_INSTALL_PATH=/usr/local/cuda; \
    export NVIDIA_COMPUTE_SDK_LOCATION=/usr/local/cuda; \
    " >> /root/env

# Needed for this to work with an interactive shell.
RUN echo "source /root/env" >> /root/.bashrc

WORKDIR /usr/local/cuda/C/common
RUN make 2> /dev/null
WORKDIR /usr/local/cuda/shared
RUN make 2> /dev/null

WORKDIR /

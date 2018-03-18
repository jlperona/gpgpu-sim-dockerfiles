
FROM ubuntu:14.04

# Modified version of powerjg/gpgpu-sim-build.
# This Dockerfile updates the version of Ubuntu from 12.04 to 14.04.

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

# Download CUDA Toolkit version 3.2.16.
RUN wget http://developer.download.nvidia.com/compute/cuda/3_2_prod/toolkit/cudatoolkit_3.2.16_linux_64_ubuntu10.04.run

# Download GPU Computing SDK version 3.2.16.
RUN wget http://developer.download.nvidia.com/compute/cuda/3_2_prod/sdk/gpucomputingsdk_3.2.16_linux.run

# Install the CUDA toolkit.
RUN bash cudatoolkit_3.2.16_linux_64_ubuntu10.04.run

# Install the GPU Computing SDK toolkit.
RUN bash gpucomputingsdk_3.2.16_linux.run

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

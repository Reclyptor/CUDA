#! /bin/bash

# Set Up CUDA Toolkit on WSL2
wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.4.0/local_installers/cuda-repo-wsl-ubuntu-11-4-local_11.4.0-1_amd64.deb
sudo dpkg -i cuda-repo-wsl-ubuntu-11-4-local_11.4.0-1_amd64.deb
sudo apt-key add /var/cuda-repo-wsl-ubuntu-11-4-local/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda
export PATH="${PATH}:/usr/local/cuda-11.4/bin"

# Create a Temporary FFMPEG Directory and Download Source Code
mkdir -P ffmpeg && cd ffmpeg
git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git nv-codec-headers
git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg

# Install Necessary Dependencies and Build Binaries
sudo apt-get install build-essential yasm cmake libtool libc6 libc6-dev unzip wget libnuma1 libnuma-dev
cd nv-codec-headers && sudo make install && cd ..
cd ffmpeg && ./configure --enable-nonfree --enable-cuda-nvcc --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 && make -j 8 && sudo make install

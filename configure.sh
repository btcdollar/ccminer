#!/bin/bash

# Get CPU information
arch=$(lscpu | awk '/Architecture:/ { print $2 }')
model_name=$(lscpu | awk -F ': +' '/Model name:/ { print $2 }')

# Common compiler flags
common_flags="-O3 -ffinite-loops -ffast-math -D_REENTRANT -finline-functions -falign-functions=16 -fomit-frame-pointer -fpic -pthread -flto -fuse-ld=lld -fno-stack-protector"

cpu_flags="-march=armv8-a+crypto -mtune=cortex-a77 -mtune=cortex-a55"
# Set vectorization flags
vectorization_flags="-Rpass-missed=loop-vectorize -Rpass-analysis=loop-vectorize -Wl"

# Combine all flags
all_flags="$common_flags $cpu_flags $vectorization_flags"


# Configure and build
./configure --target=aarch64-linux-gnu --host=x86_64-linux-gnu --build=x86_64-linux-gnu \
            CXXFLAGS="-Wl,-hugetlbfs-align -funroll-loops -finline-functions $all_flags" \
            CFLAGS="-Wl,-hugetlbfs-align -finline-functions $all_flags" \
            CXX=clang++ CC=clang LDFLAGS="-v -flto -Wl,-hugetlbfs-align"

# Configure and build with GCC
 # ./configure  --build x86_64-pc-linux-gnu --host aarch64-linux-gnu --target aarch64-linux-gnu  CXXFLAGS="-Wl, -funroll-loops -finline-functions $all_flags" \
 #             CFLAGS="-finline-functions $all_flags" \
 #             CXX=g++ CC=gcc"



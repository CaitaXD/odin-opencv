#!/bin/bash
set -e

OPENCV_PKG=$(pkg-config --list-all | grep -oE '^opencv[0-9]*' | head -n 1)

if [ -z "$OPENCV_PKG" ]; then
    echo "Error: OpenCV not found via pkg-config." >&2
    exit 1
fi

OPENCV_INC=$(pkg-config --variable=includedir_new "$OPENCV_PKG")

if [ -z "$OPENCV_INC" ]; then
    OPENCV_INC=$(pkg-config --cflags-only-I "$OPENCV_PKG" | awk '{print $1}' | sed 's/^-I//')
fi

g++ -O3 -c opencv.cpp -I"$OPENCV_INC" -I"$OPENCV_INC/opencv2" -fPIC -o opencv.o
ar rcs libopencv_wrapper.a opencv.o
rm -f opencv.o
echo "OpenCV wrapper built successfully ($OPENCV_PKG at $OPENCV_INC): libopencv_wrapper.a"


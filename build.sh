#!/bin/bash
set -e

# Compile C++ OpenCV wrapper to static library
g++ -O2 -c opencv.cpp -I/usr/include/opencv5 -fPIC -o opencv.o
ar rcs libopencv_wrapper.a opencv.o
rm -f opencv.o
echo "OpenCV wrapper built successfully: libopencv_wrapper.a"

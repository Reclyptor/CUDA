#! /bin/bash

INPUT="${1}"
OUTPUT="${2}"

ffmpeg -y -vsync 0                               \
       -hwaccel_device 0                         \
       -hwaccel_output_format cuda               \
       -hwaccel cuvid                            \
       -c:v h264_cuvid                           \
       -i "${INPUT}"                             \
       -vf scale_cuda=1280:720                   \
       -c:a copy                                 \
       -c:v h264_nvenc                           \
       -b:v 5M                                   \
       -preset slow                              \
       "${OUTPUT}"

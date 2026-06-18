#!/bin/bash
ffmpeg -framerate 25 -i 'frame-%04d.png' -vf format=yuv420p -movflags +faststart output.mp4
sleep 1
rm frame-*.png
cvlc output.mp4

#!/bin/bash

audiosistema=alsa_output.pci-0000_00_1b.0.analog-stereo.monitor
audiomic=alsa_input.pci-0000_00_1b.0.analog-stereo

ffmpeg \
 -f pulse -i "$audiomic" \
 -f pulse -i "$audiosistema" \
 -f x11grab -video_size 1024x768 -framerate 30 -i :0.0+0,0 \
 -filter_complex \
   "[0:a]adelay=0|0,volume=5dB[mic]; \
    [1:a]adelay=150|150,volume=-10dB[sistema]; \
    [mic][sistema]amix=inputs=2:duration=longest[audio_final]" \
 -map 2:v -map "[audio_final]" \
 -c:v libx264 -preset veryfast \
 -c:a aac -b:a 128k \
 output.mkv

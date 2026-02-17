#!/bin/bash

audiosistema=$(grep '^audiosource=' ~/.sourcesdotrec.txt | cut -d'=' -f2 | tr -d '"')
audiomic=$(grep '^micsource=' ~/.sourcesdotrec.txt | cut -d'=' -f2 | tr -d '"')

volsystem=-10

read -p "-video_size (1366x768, 10124x768): " videoSize

read -p "-framerate: " fps

read -p "Coordenadas de Monitor (-i :0.0+X,Y) -i :0.0+" coordenadas

read -p "Nombre de archivo: " nombregrabacion

nombregrabacionfinal=${nombregrabacion:-output.mkv}

ffmpeg \
 -f pulse -i "$audiomic" \
 -f pulse -i "$audiosistema" \
 -f x11grab -video_size $videoSize -framerate $fps -i :0.0+$coordenadas \
 -filter_complex \
   "[0:a]adelay=0|0,volume=5dB[mic]; \
    [1:a]adelay=150|150,volume="$volsystem"dB[sistema]; \
    [mic][sistema]amix=inputs=2:duration=longest[audio_final]" \
 -map 2:v -map "[audio_final]" \
 -c:v libx264 -preset veryfast \
 -c:a aac -b:a 128k \
 "$nombregrabacionfinal.mkv"

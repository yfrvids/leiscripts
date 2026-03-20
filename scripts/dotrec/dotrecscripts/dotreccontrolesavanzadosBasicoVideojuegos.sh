#!/bin/bash

clear

echo "Lista de Monitores"

xrandr | grep " connected"

echo "Display: $DISPLAY"

echo ""

audiosistema=$(grep '^audiosource=' ~/.sourcesdotrec.txt | cut -d'=' -f2 | tr -d '"')
audiomic=$(grep '^micsource=' ~/.sourcesdotrec.txt | cut -d'=' -f2 | tr -d '"')
display=$(grep '^display=' ~/.sourcesdotrec.txt | cut -d'=' -f2 | tr -d '"')

read -p "-video_size (1366x768, 1024x768): " videoSize

read -p "-framerate: " fps

read -p "Coordenadas de Monitor (-i :0.0+X,Y) -i $display+" coordenadas

read -p "Volumen Mic (5=5dB): " volmic

read -p "Volumen Audio Interno (-10=-10dB): " volsystem

crf=23

read -p "Nombre de archivo: " nombregrabacion

nombregrabacionfinal=${nombregrabacion:-output-$(date +%Y%m%d_%H%M%S)}

ffmpeg \
 -f pulse -i "$audiomic" \
 -f pulse -i "$audiosistema" \
 -thread_queue_size 512 \
 -f x11grab -video_size $videoSize -framerate $fps -i $display+$coordenadas \
 -filter_complex \
   "[0:a]adelay=0|0,volume="$volmic"dB[mic]; \
    [1:a]adelay=150|150,volume="$volsystem"dB[sistema]; \
    [mic][sistema]amix=inputs=2:duration=longest[audio_final]" \
 -map 2:v -map "[audio_final]" \
 -c:v libx264 -preset ultrafast -tune fastdecode -crf $crf \
 -c:a aac -b:a 128k \
 "$nombregrabacionfinal.mkv"

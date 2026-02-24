#!/bin/bash

clear

echo "Lista de Monitores"

xrandr | grep " connected"

echo $DISPLAY

echo ""

audiosistema=$(grep '^audiosource=' ~/.sourcesdotrec.txt | cut -d'=' -f2 | tr -d '"')
audiomic=$(grep '^micsource=' ~/.sourcesdotrec.txt | cut -d'=' -f2 | tr -d '"')
display=$(grep '^display=' ~/.sourcesdotrec.txt | cut -d'=' -f2 | tr -d '"')

read -p "-video_size (1366x768, 10124x768): " videoSize

read -p "-framerate: " fps

read -p "Coordenadas de Monitor (-i :0.0+X,Y) -i :0.0+" coordenadas

read -p "Volumen Mic (5=5dB): " volmic

read -p "Volumen Audio Interno (-10=-10dB): " volsystem

read -p "Nombre de archivo: " nombregrabacion

nombregrabacionfinal=${nombregrabacion:-output-$(date +%Y%m%d_%H%M%S)}

ffmpeg \
 -f pulse -i "$audiomic" \
 -f pulse -i "$audiosistema" \
i -f x11grab -video_size $videoSize -framerate $fps -i $display.0+$coordenadas \
 -filter_complex \
   "[0:a]adelay=0|0,volume="$volmic"dB[mic]; \
    [1:a]adelay=150|150,volume="$volsystem"dB[sistema]; \
    [mic][sistema]amix=inputs=2:duration=longest[audio_final]" \
 -map 2:v -map "[audio_final]" \
 -c:v libx264 -preset veryfast -crf 18 \
 -c:a aac -b:a 192k \
 "$nombregrabacionfinal.mkv"

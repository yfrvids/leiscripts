#!/bin/bash

clear

echo "Valores por defecto: "

cat ~/.defaultdotrec.txt

echo ""

echo "Lista de Monitores"

xrandr | grep " connected"

echo ""

audiosistema=$(grep '^audiosource=' ~/.sourcesdotrec.txt | cut -d'=' -f2 | tr -d '"')
audiomic=$(grep '^micsource=' ~/.sourcesdotrec.txt | cut -d'=' -f2 | tr -d '"')

videoSize=$(grep '^videosize=' ~/.defaultdotrec.txt | cut -d'=' -f2 | tr -d '"')

fps=$(grep '^fps=' ~/.defaultdotrec.txt | cut -d'=' -f2 | tr -d '"')

display=$(grep '^display=' ~/.sourcesdotrec.txt | cut -d'=' -f2 | tr -d '"')

coordenadas=$(grep '^coordenadas=' ~/.defaultdotrec.txt | cut -d'=' -f2 | tr -d '"')

volmic=$(grep '^volmic=' ~/.defaultdotrec.txt | cut -d'=' -f2 | tr -d '"')

volsystem=$(grep '^volsystem=' ~/.defaultdotrec.txt | cut -d'=' -f2 | tr -d '"')

nombregrabacionfinal=output-$(date +%Y%m%d_%H%M%S)

videoformat=$(grep '^videoformat=' ~/.defaultdotrec.txt | cut -d'=' -f2 | tr -d '"')

ffmpeg \
 -f pulse -i "$audiomic" \
 -f pulse -i "$audiosistema" \
 -f x11grab -video_size $videoSize -framerate $fps -i $display.0+$coordenadas \
 -filter_complex \
   "[0:a]adelay=0|0,volume="$volmic"dB[mic]; \
    [1:a]adelay=150|150,volume="$volsystem"dB[sistema]; \
    [mic][sistema]amix=inputs=2:duration=longest[audio_final]" \
 -map 2:v -map "[audio_final]" \
 -c:v libx264 -preset veryfast -crf 18 \
 -c:a aac -b:a 192k \
 "$nombregrabacionfinal.$videoformat"

#!/bin/bash

clear

read -p "-framerate de Cámara (default=30): " fpscamaraparcial

echo ""

echo "Lista de Dispositivos de Video"

ls /dev/video*

echo ""

echo "¿Qué dispositivo de video deseas usar?: "

read -p "/dev/" dispositivoDeVideo

read -p "Nombre de Archivo de Grabación: " nombrearchivowebcam

fpscamarafinal=${fpscamaraparcial:-30}
# para conocer Framerate de la camara v4l2-ctl --list-formats-ext -d /dev/video0

nombregrabacionfinal=${nombrearchivowebcam:-webcam-$(date +%Y%m%d_%H%M%S)}

webcamFormat=mkv

ffmpeg -f v4l2 -framerate $fpscamarafinal -video_size 1366x768 -i /dev/$dispositivoDeVideo -vf "hflip" "$nombregrabacionfinal.$webcamFormat"

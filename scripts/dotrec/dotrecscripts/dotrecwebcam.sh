#!/bin/bash

clear

echo
echo "Lista de Dispositivos de Video"
echo

ls /dev/video*



echo
echo "¿Qué dispositivo de video deseas usar?"
echo

read -p "/dev/" dispositivoDeVideo

webcamFramerate=30 # para conocer Framerate de la camara v4l2-ctl --list-formats-ext -d /dev/video0
read -p "Nombre de Archivo de Grabación: " nombreDeArchivoDeGrabacion
nombreDeArchivoFinal=${nombreDeArchivoDeGrabacion:-webcam} # Esta variable de "Final" se crea con el objetivo de que si el valor del nombre de grabación solicitado al usuario es vacio, pues para no causar errores se le asigna un valor por defecto
webcamFormat=mkv

ffmpeg -f v4l2 -framerate $webcamFramerate -video_size 1366x768 -i /dev/$dispositivoDeVideo -vf "hflip" "$HOME/$nombreDeArchivoFinal.$webcamFormat"

#ffmpeg -fflags +genpts \
  #-f v4l2 -framerate $webcamFramerate -video_size 640x480 -input_format yuyv422 -i /dev/$dispositivoDeVideo \
  #-f pulse -i alsa_input.pci-0000_03_00.6.analog-stereo \
  #-f pulse -i alsa_output.pci-0000_03_00.6.analog-stereo.monitor \
  #-filter_complex "\
  #  [0:v]hflip[v]; \
  #  [1:a][2:a]amix=inputs=2[a]\
  #" \
  #-map "[v]" -map "[a]" \
  #-c:v libx264 -preset fast -pix_fmt yuv420p \
  #"$HOME/$nombreDeArchivoFinal.$webcamFormat"

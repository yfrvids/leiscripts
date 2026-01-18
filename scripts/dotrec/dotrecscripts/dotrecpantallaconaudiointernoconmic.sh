#!/bin/bash

clear

echo "Lista de Monitores"

xrandr | grep " connected"

echo

read -p "-video_size (1366x768, 1093x768, 2459x768): " resolucionDeMonitor
read -p "-framerate: " framerateDeGrabacion
read -p "Coordenadas de Monitor (-i :0.0+X,Y) -i :0.0+" coordenadasDeGrabacion
read -p "Nombre de Archivo de Grabación: " nombreDeArchivoDeGrabacion
nombreDeArchivoFinal=${nombreDeArchivoDeGrabacion:-salida} # Esta variable de "Final" se crea con el objetivo de que si el valor del nombre de grabación solicitado al usuario es vacio, pues para no causar errores se le asigna un valor por defecto

ffmpeg \
  -f x11grab -video_size $resolucionDeMonitor -framerate $framerateDeGrabacion -i :0.0+$coordenadasDeGrabacion \
  -f pulse -i alsa_input.pci-0000_03_00.6.analog-stereo \
  -f pulse -i alsa_output.pci-0000_03_00.6.analog-stereo.monitor \
  -filter_complex amix=inputs=2 \
  "$HOME/$nombreDeArchivoFinal.mkv"

#!/bin/bash

clear

echo "Lista de Monitores"

xrandr | grep " connected"

echo

read -p "-video_size (1366x768, 1093x768, 2459x768): " resolucionDeMonitor
read -p "-framerate: " framerateDeGrabacion
read -p "Coordenadas de Monitor (-i :0.0+X,Y) -i :0.0+" coordenadasDeGrabacion
read -p "Nombre de Archivo de Grabación: " nombreDeArchivoDeGrabacion
read -p "Volumen Mic (130=130% Ó -5, +3 = en dB): " volumenFinalGrabacionMic
read -p "Volumen Audio Interno (100=100% Ó -10, +2 = en dB): " volumenFinalGrabacionAudioInterno
nombreDeArchivoFinal=${nombreDeArchivoDeGrabacion:-salida} # Esta variable de "Final" se crea con el objetivo de que si el valor del nombre de grabación solicitado al usuario es vacio, pues para no causar errores se le asigna un valor por defecto
volumenMicFinal=${volumenFinalGrabacionMic:-100}
volumenAudioInternoFinal=${volumenFinalGrabacionAudioInterno:-100}

# Función para convertir volumen automáticamente a porcentajes o dB
convertir_volumen() {
    if [[ $1 =~ ^[+-] ]]; then
        # Si empieza con + o -, se interpreta como dB
        echo "${1}dB"
    else
        # Si es número normal, se interpreta como porcentaje
        awk "BEGIN {printf \"%.2f\", $1/100}"
    fi
}

volMicProcesado=$(convertir_volumen "$volumenMicFinal")
volAudioInternoProcesado=$(convertir_volumen "$volumenAudioInternoFinal")

ffmpeg \
  -use_wallclock_as_timestamps 1 \
  -f x11grab -video_size $resolucionDeMonitor -framerate $framerateDeGrabacion -i :0.0+$coordenadasDeGrabacion \
  -f pulse -thread_queue_size 4096 -i alsa_input.pci-0000_03_00.6.analog-stereo \
  -f pulse -thread_queue_size 4096 -i alsa_output.pci-0000_03_00.6.analog-stereo.monitor \
  -filter_complex "\
  [1:a]volume=${volMicProcesado},alimiter=limit=0.95[mic]; \
  [2:a]volume=${volAudioInternoProcesado}[audiointerno]; \
  [audiointerno][mic]amix=inputs=2:normalize=0[aout]" \
  -map 0:v -map "[aout]" \
  -c:v libx264 -preset veryfast -crf 18 \
  -c:a aac -b:a 192k \
  -async 1 \
  "$HOME/$nombreDeArchivoFinal.mkv"

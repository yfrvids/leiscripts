#!/bin/bash

sudo cp -r dotrec /usr/local/bin/

chmod +x dotrecscripts/*

cp -r dotrecscripts/ ~/

read -p "¿Establecer sources de Audio y Mic? (s/N): " actualizarSources

if [[ "$actualizarSources" =~ ^[Ss]$ ]]; then
    cp -r .sourcesdotrec.txt ~/
fi

echo ""

read -p "¿Establecer valores por defecto de grabación con dotrec? (s/N): " actualizarValoresPorDefecto

if [[ "$actualizarValoresPorDefecto" =~ ^[Ss]$ ]]; then
    cp -r .defaultdotrec.txt ~/
fi




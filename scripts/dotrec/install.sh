#!/bin/bash

sudo cp -r dotrec /usr/local/bin/

chmod +x dotrecscripts/*

read -p "¿Actualizar sources de Audio y Mic? (s/N): " actualizarSources

if [[ "$actualizarSources" =~ ^[Ss]$ ]]; then
    cp -r .sourcesdotrec.txt ~/
fi

cp -r dotrecscripts/ ~/

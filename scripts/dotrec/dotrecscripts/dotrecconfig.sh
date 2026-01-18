#!/bin/bash

clear

echo "Parametros de ejecución:"
echo "> Mover el archivo dotrec y carpeta dotrecscripts a HOME (si es que no estan allí)"
echo "> Darle permisos de ejecución al archivo dotrec => chmod +x dotrec"
echo "> Darle permisos de ejecución a los archivos de la carpeta dotrecscripts => chmod +x dotrecscripts/*"
echo "> Copiar y pegar el archivo dotrec => sudo cp -r dotrec /usr/local/bin/"

echo
echo "Parametros de configuración:"
echo "> Mediante el siguiente comando identificar cuales son las fuentes de salida o de entrada del sistema => pactl list short sources"
echo "Las fuentes output .monitor corresponden al sonido del sistema"
echo "Las fuentes input analog-stereo corresponden a dispositivos de entrada como microfonos"
echo "> Modificar dichas fuentes en sus respectivos scripts de la carpeta ~/dotrecscripts (dotREC tiene tres variantes distintas dependiendo los siguientes casos:)"
echo "1. Grabar pantalla sin audio interno con Mic"
echo "2. Grabar pantalla con Audio interno sin Mic"
echo "3. Grabar pantalla con Audio interno con Mic"

echo
echo "> Las grabaciones por defecto serán guardadas en el directorio HOME, en caso de querer modificar esto, se puede llevar a cabo en el archivo script respectivo de la carpeta ~/dotrecscripts, especificamente en el apartado en donde se indica la ruta y nombre de archivo de grabación bajo la extensión .mkv"
echo "> Si la carpeta de dotrecscripts no se encuentra en el directorio HOME, se debe especificar entonces la ruta adecuada en el archivo dotrec para cada una de las opciones condicionales, por que cada una de estas opciones ejecuta un script diferente"

echo
echo "Parametro de comenzar dotREC:"
echo "> Ejecutar el comando dotrec"

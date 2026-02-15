# quickSetup-yt-dlp
Personal config/setup

## Conda

- Descargar el instalador de Miniconda para linux `wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh`
- Ejecutar el instalador `bash Miniconda3-latest-Linux-x86_64.sh`
- Seguir las instrucciones, aceptar la licencia y elegir la carpeta de instalación
- Inicializar conda `conda init` (en caso de no solicitarlo)
- En caso de no querer que el entorno (base) de Conda se active automaticamente al iniciar sesión en una terminal, entonces ingresar `conda config --set auto_activate_base false` (En donde `false` puede tambien ser cambiado por true para activarlo automaticamente)
Crear entorno virtual con una versión de Python en especifico
- Entrar en la carpeta del proyecto
- Mediante el siguiente comando: `conda create -n nombreDelEntorno python=3.xx`

En donde `nombreDelEntorno` corresponde al nombre a determinarle a dicho entorno virtual del proyecto.
En donde `python=3.xx` debe corresponder a la versión especifica de python a instalar en dicho proyecto.

- Activar entorno virtual `conda activate nombreDelEntorno` (Puedes desactivar/cerrar un entorno virtual con conda mediante el comando `conda deactivate`)

- Instalar los paquetes de pip (`pip install ...`) deseados.

## nodejs

```sh
sudo apt install nodejs
```

## yt-dlp

- Crear un entorno en Music con conda y activarlo para poder instalar su respectivo paquete con Pip
- Instalar yt-dlp `pip install yt-dlp`
- Usar links preferiblemente de YoutubeMusic
> Para descargar audio (comando básico): `yt-dlp -t mp3 "linkDelVideoDeYoutube"` (mp3 puede ser reemplazado por otros formatos de audio), se aconsejar revisar la documentación o el [repo en github](https://github.com/yt-dlp/yt-dlp)

### Usar yt-dlp forma manual

#### Para descargar audio con metadatos (portada, etc):

- **Versión 1**
```sh
yt-dlp "linkDeYoutubeOYoutubeMusic" \
  -x --audio-format mp3 --audio-quality 0 \
  --add-metadata --embed-thumbnail \
  --convert-thumbnails png \
  --ppa "EmbedThumbnail+ffmpeg_o:-c:v png -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\"" \
  --output "%(title)s.%(ext)s"
```

- **Version 2** para forzar cliente android en caso de que Youtube haga rollouts por regiones / IP

```sh
yt-dlp \
  --extractor-args "youtube:player_client=android" \
  "linkDeYoutubeOYoutubeMusic" \
  -x --audio-format mp3 --audio-quality 0 \
  --add-metadata --embed-thumbnail \
  --convert-thumbnails png \
  --ppa "EmbedThumbnail+ffmpeg_o:-c:v png -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\"" \
  --output "%(title)s.%(ext)s"
```

### Usar yt-dlp forma automatizada con script

- Darle permisos al archivo dotyt `chmod +x dotyt`
- Mover el archivo `sudo cp -r dotyt /usr/local/bin/`
- Usar el comando `dotyt`

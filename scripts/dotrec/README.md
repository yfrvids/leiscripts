# dotrec

## Instalación ffmpeg

- Linux (Almalinux):
	Activar repositorio EPEL: `sudo dnf install epel-release`
	Instalar RPM Fusion (free): `sudo dnf install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm`
	Instalar RPM Fusion (nonfree): `sudo dnf install --nogpgcheck https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm`
	Instalar ffmpeg: `sudo dnf install ffmpeg ffmpeg-devel`

- Windows:
	- Install chocolatey with admin privileges on powershell
 	- With Admin privileges install `choco install ffmpeg`
 	- Install [VB-CABLE software](https://vb-audio.com/Cable/)
 	- Settings -> Sound -> Change the output to 'CABLE Input (VB-Audio Virtual Cable)'
 	- Control Panel -> Sound -> Recording tab -> Cable Output -> Properties -> Listen Tab -> Activate Listen to this device (Choosing the playback device ex. speakers) -> Apply
  	- Exec file dotrec

## Instalar PulseAudio-utils (únicamente en caso de estar usando PipeWire)

- Linux (AlmaLinux):
	Instalar: `sudo dnf install pulseaudio-utils`

## Listar fuentes de Audio/Microfono

### Linux:
	- Mediante el comando `pactl list short sources` copiar y pegar las distintas fuentes de audio y micrófono en el archivo `.sourcesdotrec.txt`

### Windows:
	- `ffmpeg -list_devices true -f dshow -i dummy`

# dotrec

### Instalación ffmpeg

- Linux (Almalinux):
	Activar repositorio EPEL: `sudo dnf install epel-release`
	Instalar RPM Fusion (free): `sudo dnf install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm`
	Instalar RPM Fusion (nonfree): `sudo dnf install --nogpgcheck https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm`
	Instalar ffmpeg: `sudo dnf install ffmpeg ffmpeg-devel`

### Instalar PulseAudio-utils (únicamente en caso de estar usando PipeWire)

- Linux (AlmaLinux):
	Instalar: `sudo dnf install pulseaudio-utils`

### Listar fuentes de Audio/Microfono

Mediante el comando `pactl list short sources` copiar y pegar las distintas fuentes de audio y micrófono en el archivo `.sourcesdotrec.txt`

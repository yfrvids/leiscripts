# dotrec

Created by Yofre (yfrvids)

- [Contexto](#contexto)
- [Guía](#guia)
- [Script](#script)

## Contexto

En esta corta sección de contexto se explicarán conceptos básicos acerca del uso aplicado de ffmpeg con respecto a dotrec, y además de eso, se explicará que tipo de configuraciones especiales hay que tener en cuenta. Al mismo tiempo se verán comandos independientes que quizás no formen parte de un comando final, pero que son presentados como una alternativa a tareas en específico que exponen una aplicación progresiva en lugar de un comando extenso sin comprensión previa.

### Grabación de Pantalla y Micrófono

En cuanto a la grabación de pantalla, hay aspectos importantes a tener en cuenta como lo puede ser la identificación de coordenadas de cada uno de los monitores, o del monitor en si. Y al momento de llevar a cabo este proceso se podrá identificar el siguiente parámetro `-i :0.0+X,Y` el cual se predefine como un input `-i` y luego espera determinadas coordenadas con respecto a X y Y `+X,Y`.

Un ejemplo común sería: `-i :0.0+0,0`, ya que en la prática esta refiriendose al monitor principal, y esto se puede notar ya que su valor en X es 0, osea, la posición del monitor con respecto a X inicia en 0 (cero). Pero en un caso distinto como lo puede ser un segundo monitor, el valor de X o Y puede variar dependiendo su ubicación en un plano físico o virtual.

**Ejemplo:** Un monitor principal con una resolución de 1366x768, y un segundo monitor con una resolución de 1366x768. Si el primer monitor se encuentra a la izquierda entonces su valor en X será 0 (cero) y el valor de X del segundo monitor comenzará en la misma posición en donde el primer monitor "terminó". En otras palabras, se puede hacer uso de la siguiente "nomenclatura":

- Primer monitor: `-i :0.0+0,0`
- Segundo monitor: `-i :0.0+1366,0` (`-i :0.0+AnchoDelPrimerMonitor,0`)

> En cuanto a las ubicaciones y coordenadas pueden variar demasiado, ya depende del número de monitores y de la ubicación de cada uno de ellos. Pero todo eso se puede llevar a cabo ingresando sus respectivos valores de X y Y. (Si un monitor en lugar de estar a un lado, esta debajo o encima, pues entonces en este caso se hará uso del valor de Y, y si traemos a colación el ejemplo anterior: pues diriamos que el monitor de abajo tendría su valor de Y en 768, y 0 en su valor de X si es que esta literalmente debajo)

#### Ejemplo de comando (Grabación de pantalla + micrófono)

```sh
ffmpeg -video_size 1093x768 -i :0.0+1366,0 -framerate 25 -f x11grab -f pulse -ac 2 -i default salida.mkv
```

#### Ejemplo de comando (Grabación de un segundo monitor)

```sh
ffmpeg -f x11grab -video_size 1093x768 -framerate 25 -i :0.0+1366,0 -f pulse -ac 2 -i default salida.mkv
```

En este caso al seleccionar un monitor distinto al principal, se debe tener en cuenta que coordenadas son las adecuadas. En el parametro de `-i :0.0` se ha adicionado un `+1366,0` que en teoria son las coordenadas **+X, Y** (Por eso en este caso cuando se quiere capturar el segundo monitor, el valor de X no empieza desde cero, sino desde 1366 que es el ancho del primer monitor (`+anchoDelPrimerMonitor,0`) correspondiente al valor de X. Si se quisiese grabar el monitor principal pues X comenzaría en la posición 0, asi: `-i :0.0+0,0`

Cuando se ingresa en la terminal `xrandr | grep " connected"`, se tiene que tener en cuenta que primero se mostrarán las medidas de cada monitor, y luego las posiciones de cada monitor con referencia a sus posiciones en X y Y. (Ejemplo de un segundo monitor a la derecha de un monitor principal: `HDMI-A-0 connected 1093x615+1366+0` en donde el primer valor corresponde al Ancho x Alto + PosicionDelMonitorConRespectoAX + PosicionDelMonitorConRespectoAY. Por lo tanto en un primer monitor a la izquierda se veria asi: `eDP connected primary 1366x768+0+0` en donde obviamente su posición en X es 0)

Por lo tanto en el caso de un segundo monitor al lado derecho, las coordenadas serían las siguientes: `-i :0.0+1366,0`

El parametro de `-video_size ...x...` debe corresponder a las medidas del monitor a grabar.

## Guia

Esta sección de guía se diferencia tanto de la siguiente sección (Script) ya que aporta los elementos necesarios antes de "configurar" el script, como de la sección anterior (Contexto) ya que no proporciona "teoría" sino instrucciones a ejecutar y preparar los ajustes indispensables para ejecutar el script.

- Listar las fuentes (input/output) del sistema: `pactl list short sources`

Como resultado se puede obtener algo similar a lo siguiente:

```sh
56  alsa_output.pci-0000_03_00.6.analog-stereo.monitor   PipeWire
57  alsa_input.pci-0000_03_00.6.analog-stereo            PipeWire
77390 alsa_output.pci-0000_03_00.1.hdmi-stereo.monitor   PipeWire
```

En donde:

- El micrófono corresponde al `alsa_input.pci-0000_03_00.6.analog-stereo`
- El audio interno del equipo (salida analógica) corresponde al `alsa_output.pci-0000_03_00.6.analog-stereo.monitor`
- El audio interno del equipo (por HDMI, en caso de que la salida de HDMI tenga salida de audio) corresponde al `alsa_output.pci-0000_03_00.1.hdmi-stereo.monitor`

Nótese que los outputs de sonido interno del equipo, tienen un `.monitor` al final.

### Ejemplo de comando (Grabación de pantalla NO audio interno SI micrófono 

```sh
ffmpeg \
  -f x11grab -video_size 1093x768 -framerate 25 -i :0.0+1366,0 \
  -f pulse -i alsa_input.pci-0000_03_00.6.analog-stereo \
  salida.mkv
```

> El segundo input predefinido bajo el formato pulse (`-f pulse`) es el micrófono `-i alsa_input.pci-0000_03_00.6.analog-stereo`

### Ejemplo de comando (Grabación de pantalla SI audio interno NO micrófono)

```sh
ffmpeg \
  -f x11grab -video_size 1093x768 -framerate 25 -i :0.0+1366,0 \
  -f pulse -i alsa_output.pci-0000_03_00.6.analog-stereo.monitor \
  salida.mkv
```

> El segundo input predefinido bajo el formato pulse (`-f pulse`) es el audio interno del sistema `-i alsa_output.pci-0000_03_00.6.analog-stereo.monitor`

### Ejemplo de comando (Grabación de pantalla SI audio interno SI micrófono)

```sh
ffmpeg \
  -f x11grab -video_size 1093x768 -framerate 25 -i :0.0+1366,0 \
  -f pulse -i alsa_input.pci-0000_03_00.6.analog-stereo \
  -f pulse -i alsa_output.pci-0000_03_00.6.analog-stereo.monitor \
  -filter_complex amix=inputs=2 \
  salida.mkv
```

En este caso hay dos inputs de audio predefinidos cada uno con un formato pulse (`-f pulse`):

1. `-i alsa_input.pci-0000_03_00.6.analog-stereo` El micrófono
2. `-i alsa_output.pci-0000_03_00.6.analog-stereo.monitor` el audio interno del sistema

> El `-filter_complex amix=inputs=2` como tal es un filtro que trabaja con más de un input, o más de una salida, y lo que hace es mezclar varias fuentes de audio para convertirlas en una sola pista. Ahora, el valor de `=2` debe ser configurado dependiendo el número de entradas de audio (en este último caso se usa el valor de 2 porque esta trabajando tanto con el audio del micrófono como con el audio del sistema y se necesita que los dos vayan mezclados en una única pista de audio)

## Script

### Parámetros de ejecución:

- Mover el archivo dotrec y carpeta dotrecscripts a HOME (si es que no estan allí)

- Darle permisos de ejecución al archivo dotrec: `chmod +x dotrec`

- Darle permisos de ejecución a los archivos de la carpeta dotrecscripts: `chmod +x dotrecscripts/*`

- Copiar y pegar el archivo dotrec: `sudo cp -r dotrec /usr/local/bin/`

<br>

### Parámetros de configuración:

- Mediante el siguiente comando identificar cuales son las fuentes de salida o de entrada del sistema: `pactl list short sources`

Las fuentes output `.monitor` corresponden al sonido del sistema

Las fuentes input `analog-stereo` corresponden a dispositivos de entrada como micrófonos

- Modificar dichas fuentes en sus respectivos scripts de la carpeta ~/dotrecscripts (dotrec tiene tres variantes distintas dependiendo los siguientes casos:

1. Grabar pantalla sin audio interno con Micrófono
2. Grabar pantalla con Audio interno sin Micrófono
3. Grabar pantalla con Audio interno con Micrófono

<br>

> Las grabaciones por defecto serán guardadas en el directorio HOME, en caso de querer modificar esto, se puede llevar a cabo en el archivo script respectivo de la carpeta ~/dotrecscripts, especificamente en el apartado en donde se indica la ruta y nombre de archivo de grabación bajo la extensión .mkv

> Si la carpeta de dotrecscripts no se encuentra en el directorio HOME, se debe especificar entonces la ruta adecuada en el archivo dotrec para cada una de las opciones condicionales, por que cada una de estas opciones ejecuta un script diferente.

<br>

### Parámetro para comenzar dotrec:

- Ejecutar el comando `dotrec`

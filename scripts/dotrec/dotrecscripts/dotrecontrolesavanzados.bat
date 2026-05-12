@echo off
cls

echo ====================================
echo        FFMPEG WINDOWS REC
echo ====================================
echo.

set /p videoSize="Resolucion (1366x768): "
set /p fps="FPS (60): "
set /p offsetX="Offset X (0): "
set /p offsetY="Offset Y (0): "
set /p volmic="Volumen Mic dB (5): "
set /p volsystem="Volumen Sistema dB (0): "
set /p nombregrabacion="Nombre archivo: "

if "%videoSize%"=="" set videoSize=1366x768
if "%fps%"=="" set fps=60
if "%offsetX%"=="" set offsetX=0
if "%offsetY%"=="" set offsetY=0
if "%volmic%"=="" set volmic=5
if "%volsystem%"=="" set volsystem=0
if "%nombregrabacion%"=="" set nombregrabacion=output

ffmpeg ^
-f dshow ^
-i audio="Microphone (Realtek(R) Audio)" ^
-f dshow ^
-i audio="CABLE Output (VB-Audio Virtual Cable)" ^
-f gdigrab ^
-framerate %fps% ^
-offset_x %offsetX% ^
-offset_y %offsetY% ^
-video_size %videoSize% ^
-i desktop ^
-filter_complex "[0:a]volume=%volmic%dB[mic];[1:a]volume=%volsystem%dB[sistema];[mic][sistema]amix=inputs=2:duration=longest[audio_final]" ^
-map 2:v ^
-map "[audio_final]" ^
-c:v libx264 ^
-preset veryfast ^
-crf 18 ^
-c:a aac ^
-b:a 192k ^
"%nombregrabacion%.mkv"

pause
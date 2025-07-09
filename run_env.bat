@echo off
setlocal

:: 🟢 Cambia esto a true para producción o false para desarrollo
set FLAG=false

if "%FLAG%"=="true" (
    echo 🔵 Ejecutando en modo PRODUCCIÓN...
    flutter run -d chrome -t lib/main.dart
) else (
    echo 🟡 Ejecutando en modo DESARROLLO con emuladores...

    echo ✅ Iniciando Firebase Emulators...
    start "Firebase Emulators" cmd /k "firebase emulators:start"

    echo 🕒 Espera unos segundos a que los emuladores estén listos...
    timeout /t 5 > nul

    echo 🚀 Ejecutando Flutter con emuladores...
    flutter run -d chrome -t lib/main_emuladores.dart
)

endlocal
pause

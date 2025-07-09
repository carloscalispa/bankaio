@echo off
REM Script para subir tu proyecto local a GitHub

cd /d C:\zara\bankaio

git rev-parse --is-inside-work-tree 2>NUL
IF %ERRORLEVEL% NEQ 0 (
    git init
)

git add .

git commit -m "Subida automática a GitHub" || echo "Nada nuevo para commitear"

git remote -v | findstr /C:"origin" >nul
IF %ERRORLEVEL% NEQ 0 (
    git remote add origin https://github.com/carloscalispa/bankaio.git
)

git branch -M main

git push -u origin main

pause
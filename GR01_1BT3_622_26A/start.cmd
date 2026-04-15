@echo off
cd /d "%~dp0"

echo.
echo ========================================
echo   Sistema de Adopciones
echo ========================================
echo.

REM Verificar Docker
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo WARNING: Docker no está instalado o no está en el PATH
    echo Instalar desde: https://www.docker.com/products/docker-desktop
    echo.
    pause
    exit /b
)

REM Iniciar Docker
echo Iniciando contenedores de Docker...
docker compose -f compose.yaml up -d

if %errorlevel% neq 0 (
    echo ERROR al iniciar Docker
    pause
    exit /b
)

echo.
echo Esperando a MySQL...
timeout /t 10 >nul

REM Crear carpeta faltante
if not exist src\main\resources\graphql-client (
    echo Creando carpeta graphql-client...
    mkdir src\main\resources\graphql-client
)

REM Compilar
echo.
echo Compilando proyecto...
call mvnw.cmd clean install

if %errorlevel% neq 0 (
    echo ERROR en compilacion
    pause
    exit /b
)

REM Ejecutar
echo.
echo Ejecutando aplicacion...
call mvnw.cmd spring-boot:run

echo.
echo Sistema en http://localhost:8080
pause
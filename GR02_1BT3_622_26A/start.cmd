@echo off
REM Script para iniciar el proyecto - Windows

echo.
echo ========================================
echo   Sistema de Adopciones
echo ========================================
echo.

REM Verificar si Docker está instalado
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo WARNING: Docker no está instalado o no está en el PATH
    echo Por favor, instálalo desde: https://www.docker.com/products/docker-desktop
    echo.
)

REM Iniciar Docker Compose
echo Iniciando contenedores de Docker...
docker-compose up -d

echo.
echo Esperando a que MySQL esté listo...
timeout /t 10

REM Compilar el proyecto
echo.
echo Compilando el proyecto...
call mvn clean install

REM Ejecutar la aplicación
echo.
echo Ejecutando la aplicación...
call mvn spring-boot:run

echo.
echo Sistema de Adopciones iniciado en http://localhost:8080
pause


@echo off
<<<<<<< Updated upstream
cd /d "%~dp0"
=======
REM ========================================
REM   Sistema de Adopciones - Inicio
REM ========================================
>>>>>>> Stashed changes

echo.
echo ========================================
echo   Sistema de Adopciones
echo ========================================
echo.

<<<<<<< Updated upstream
REM Verificar Docker
=======
REM ================================
REM Verificar Docker
REM ================================
>>>>>>> Stashed changes
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo WARNING: Docker no está instalado o no está en el PATH
    echo Instalar desde: https://www.docker.com/products/docker-desktop
    echo.
    pause
    exit /b
)

<<<<<<< Updated upstream
REM Iniciar Docker
echo Iniciando contenedores de Docker...
docker compose -f compose.yaml up -d

if %errorlevel% neq 0 (
    echo ERROR al iniciar Docker
    pause
    exit /b
)
=======
REM ================================
REM Levantar contenedores
REM ================================
echo Iniciando contenedores de Docker...
docker compose -f compose.yaml up -d
>>>>>>> Stashed changes

if %errorlevel% neq 0 (
    echo.
    echo ERROR al iniciar Docker
    pause
    exit /b
)

REM ================================
REM Esperar base de datos
REM ================================
echo.
<<<<<<< Updated upstream
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
=======
echo Esperando a que MySQL esté listo...
timeout /t 10 >nul

<<<<<<< Updated upstream
REM ================================
REM Crear carpeta faltante GraphQL
REM ================================
if not exist src\main\resources\graphql-client (
    echo.
    echo Creando carpeta faltante: graphql-client
    mkdir src\main\resources\graphql-client
)

REM ================================
REM Compilar proyecto
REM ================================
=======
REM Crear carpeta GraphQL si no existe
if not exist src\main\resources\graphql-client (
    echo.
    echo Creando carpeta graphql-client...
    mkdir src\main\resources\graphql-client
)

REM Compilar el proyecto
>>>>>>> Stashed changes
echo.
echo Compilando el proyecto...
call mvnw.cmd clean install

if %errorlevel% neq 0 (
    echo.
    echo ERROR en la compilacion
    pause
    exit /b
)

REM ================================
REM Ejecutar aplicación
REM ================================
echo.
<<<<<<< Updated upstream
echo Ejecutando la aplicacion...
call mvnw.cmd spring-boot:run

echo.
echo ========================================
echo Sistema iniciado en:
echo http://localhost:8080
echo ========================================
echo.

>>>>>>> Stashed changes
pause
=======
echo Ejecutando la aplicación...
call mvnw.cmd spring-boot:run

echo.
echo Sistema de Adopciones iniciado en http://localhost:8080
pause
>>>>>>> Stashed changes

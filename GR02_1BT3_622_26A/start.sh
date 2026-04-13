#!/bin/bash
# Script para iniciar el proyecto - Linux/Mac

set -e

echo "🚀 Iniciando Sistema de Adopciones..."

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "⚠️  Docker no está instalado. Por favor, instálalo desde https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Iniciar Docker Compose
echo "🐳 Iniciando contenedores de Docker..."
docker-compose up -d

echo "⏳ Esperando a que MySQL esté listo..."
sleep 10

# Compilar el proyecto
echo "🔨 Compilando el proyecto..."
mvn clean install

# Ejecutar la aplicación
echo "▶️  Ejecutando la aplicación..."
mvn spring-boot:run

echo "✅ Sistema de Adopciones iniciado en http://localhost:8080"


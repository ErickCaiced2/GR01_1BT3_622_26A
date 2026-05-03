# Multi-stage Dockerfile para Sistema de Adopciones de Mascotas
# ============================================================

# STAGE 1: Build (opcional, si Jenkins necesita compilar dentro del contenedor)
# Comentado porque Jenkins compilará el JAR antes de construir la imagen
# FROM maven:3.9-eclipse-temurin-21 AS builder
# WORKDIR /build
# COPY . .
# RUN mvn clean package -DskipTests

# STAGE 2: Runtime
# Imagen base con Java 21 (compatible con Spring Boot 4.0.5)
FROM eclipse-temurin:21-jre-jammy

# Labels para metadatos del contenedor
LABEL maintainer="Sistema de Adopciones"
LABEL description="Contenedor Docker para Sistema de Adopciones de Mascotas"
LABEL version="0.0.1-SNAPSHOT"

# Crear usuario no-root por seguridad
RUN useradd -m -u 1000 appuser

# Directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar el JAR generado por Maven (compilado por Jenkins)
COPY target/GR01_1BT3_622_26A-0.0.1-SNAPSHOT.jar app.jar

# Cambiar propietario del JAR al usuario appuser
RUN chown appuser:appuser app.jar

# Cambiar al usuario no-root
USER appuser

# Exposer puerto 8090 (configurado en la aplicación)
EXPOSE 8090

# Healthcheck para verificar que la aplicación está corriendo
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8090/actuator/health || exit 1

# Variables de entorno por defecto para conectar a MySQL
# Estas pueden ser sobrescritas al ejecutar el contenedor
ENV SPRING_DATASOURCE_URL=jdbc:mysql://mysql-adopciones:3306/sistema_adopciones
ENV SPRING_DATASOURCE_USERNAME=root
ENV SPRING_DATASOURCE_PASSWORD=1234
ENV SERVER_PORT=8090

# Comando que se ejecuta al arrancar el contenedor
# Spring Boot genera un JAR ejecutable con el main manifest
ENTRYPOINT ["java", "-jar", "app.jar"]

# Parámetros por defecto (pueden ser sobrescritos)
CMD ["--spring.profiles.active=prod"]


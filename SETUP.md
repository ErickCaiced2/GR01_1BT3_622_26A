# Guía de configuración del entorno — Sistema de Adopciones

## Requisitos previos

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado y corriendo
- Git

---

## 1. Clonar el repositorio

```bash
git clone https://github.com/ErickCaiced2/GR01_1BT3_622_26A.git
cd GR01_1BT3_622_26A
```

---

## 2. Crear la red compartida de Docker

Ambos contenedores (MySQL y Jenkins) deben estar en la misma red para que puedan comunicarse por nombre de host.

```bash
docker network create adopciones-network
```

---

## 3. Levantar el contenedor de MySQL

```bash
docker run -d \
  --name mysql-adopciones \
  --network adopciones-network \
  -e MYSQL_ROOT_PASSWORD=1234 \
  -e MYSQL_DATABASE=sistema_adopciones \
  -p 3306:3306 \
  mysql:8.0
```

Verificar que está corriendo:

```bash
docker ps
```

Esperar unos segundos hasta que MySQL esté listo (se puede verificar con):

```bash
docker exec mysql-adopciones mysqladmin ping -h localhost -u root -p1234
```

---

## 4. Levantar el contenedor de Jenkins CON DOCKER IN DOCKER

> **IMPORTANTE:** Este contenedor necesita capacidad Docker in Docker (DinD) para crear y ejecutar contenedores desde sus pipelines.

### 4.1 Crear el contenedor Jenkins con DinD

```bash
docker run -d \
  --name jenkins \
  --network adopciones-network \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts
```

**Parámetros:**
- `-p 8080:8080` → Puerto web de Jenkins
- `-p 50000:50000` → Comunicación con agentes Jenkins
- `-v jenkins_home:/var/jenkins_home` → Persistencia de configuración
- `-v /var/run/docker.sock:/var/run/docker.sock` → **Acceso a Docker del host (DinD)**

### 4.2 Instalar Docker CLI dentro de Jenkins

```bash
# Actualizar paquetes
docker exec -u root jenkins apt-get update

# Instalar Docker CLI
docker exec -u root jenkins apt-get install -y docker.io

# Verificar instalación
docker exec jenkins docker --version
```

### 4.3 Configurar permisos para Jenkins

```bash
# Agregar usuario jenkins al grupo docker
docker exec -u root jenkins usermod -aG docker jenkins

# Ajustar permisos del socket
docker exec -u root jenkins chmod 666 /var/run/docker.sock
```

### 4.4 Verificar que DinD funciona

```bash
docker exec jenkins docker ps
```

**Salida esperada:**
```
CONTAINER ID   IMAGE              STATUS             NAMES
b7b4b8fbec45   jenkins/jenkins    Up About a minute  jenkins
68af4fc0e7c7   mysql:8.0          Up X hours         mysql-adopciones
```

---

## 4.5 Estructura del Docker in Docker

```
Host (Windows/Linux/Mac)
  └── Docker Desktop
        ├── Jenkins Container (DinD habilitado)
        │    ├── Maven
        │    ├── Java
        │    └── Docker CLI → acceso a /var/run/docker.sock
        │
        ├── MySQL Container
        │    └── Puerto 3306
        │
        └── Aplicación Container (creado por Jenkins)
             └── Puerto 8090
```

---

## 5. Descargar e instalar Maven en Jenkins

Antes de configurar Jenkins, necesitas tener Maven disponible.

### 5.1 Descargar Maven

```bash
# Ir a Administrar Jenkins → Configurar sistema
# Ir a "Global Tool Configuration"
# En "Maven installations" → "Add Maven"
#   Nombre: Maven 3.9.x
#   Instalar automáticamente ✓
#   Versión: 3.9.6 (o la más reciente)
```

---

## 6. Crear el Dockerfile

El archivo `Dockerfile` ya debe estar en la raíz del proyecto. Si no existe, créalo:

**Archivo:** `Dockerfile` (sin extensión)

```dockerfile
# Multi-stage Dockerfile para Sistema de Adopciones de Mascotas
FROM eclipse-temurin:21-jre-jammy

LABEL maintainer="Sistema de Adopciones"
LABEL description="Contenedor Docker para Sistema de Adopciones de Mascotas"
LABEL version="0.0.1-SNAPSHOT"

# Crear usuario no-root por seguridad
RUN useradd -m -u 1000 appuser

WORKDIR /app

# Copiar el JAR generado por Maven
COPY target/GR01_1BT3_622_26A-0.0.1-SNAPSHOT.jar app.jar

RUN chown appuser:appuser app.jar

USER appuser

EXPOSE 8090

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8090/actuator/health || exit 1

# Variables de entorno
ENV SPRING_DATASOURCE_URL=jdbc:mysql://mysql-adopciones:3306/sistema_adopciones
ENV SPRING_DATASOURCE_USERNAME=root
ENV SPRING_DATASOURCE_PASSWORD=1234
ENV SERVER_PORT=8090

ENTRYPOINT ["java", "-jar", "app.jar"]
CMD ["--spring.profiles.active=prod"]
```

---

## 7. Configurar el Pipeline en Jenkins

### 7.1 Acceder a Jenkins

Abrir el navegador en: **http://localhost:8080**

Obtener la contraseña inicial:

```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

### 7.2 Crear el Job

1. Click en **Nueva tarea**
2. Nombre: `EjecucionSistemaAdopciones`
3. Tipo: **Proyecto de estilo libre**
4. Click en **Crear**

### 7.3 Configurar Gestión del Código Fuente

1. **Gestión del código fuente** → **Git**
2. **URL del repositorio:**
   ```
   https://github.com/ErickCaiced2/GR01_1BT3_622_26A.git
   ```
3. **Rama:** `*/Prueba` (o `*/main` según corresponda)

### 7.4 PASO 1: Compilación con Maven

1. **Pasos de construcción** → **Agregar paso** → **Invocar targets de Maven de nivel superior**
2. **Configurar:**
   - Versión de Maven: `Maven 3.9.x` (la instalada)
   - Goals: `clean package`
   - POM: (dejar vacío)
3. **Guardar**

### 7.5 PASO 2: Construir e Ejecutar Contenedor Docker

1. **Pasos de construcción** → **Agregar paso** → **Ejecutar shell**
2. **Pegar el siguiente script:**

```bash
#!/bin/bash
set -e

echo "=== Sistema de Adopciones - Build Pipeline ==="

# 1. Verificar Docker
echo "=== [1/5] Verificando Docker ==="
docker --version

# 2. Limpiar contenedores anteriores
echo "=== [2/5] Limpiando contenedores anteriores ==="
docker stop adopciones-app 2>/dev/null || true
docker rm adopciones-app 2>/dev/null || true

# 3. Construir imagen Docker
echo "=== [3/5] Construyendo imagen Docker ==="
docker build -t adopciones-sistema:latest -t adopciones-sistema:${BUILD_NUMBER} .

# 4. Ejecutar contenedor
echo "=== [4/5] Ejecutando contenedor Docker ==="
docker run \
  --rm \
  --detach \
  --name adopciones-app \
  --network adopciones-network \
  -p 8090:8090 \
  -e SPRING_DATASOURCE_URL=jdbc:mysql://mysql-adopciones:3306/sistema_adopciones \
  -e SPRING_DATASOURCE_USERNAME=root \
  -e SPRING_DATASOURCE_PASSWORD=1234 \
  adopciones-sistema:latest

# 5. Esperar y verificar
echo "=== [5/5] Esperando que la aplicación inicie ==="
sleep 15

docker logs adopciones-app || true

if docker ps | grep -q adopciones-app; then
    echo "✓ Aplicación corriendo en http://localhost:8090"
else
    echo "✗ Error: contenedor no está corriendo"
    exit 1
fi
```

3. **Guardar**

### 7.6 Resultado Final

Tu Job tiene 2 pasos de construcción:

| Paso | Tipo | Acción |
|------|------|--------|
| 1 | Maven | Compila código, ejecuta tests, genera JAR |
| 2 | Shell | Construye imagen Docker y ejecuta contenedor |

---

## 8. Configurar Actualización Automática (Opcional)

### 8.1 Con GitHub Webhook

1. **Jenkins → Configuración del Job → Desencadenadores**
2. ☑ **GitHub hook trigger for GITScm polling**

En GitHub:
1. `Settings` → `Webhooks` → `Add webhook`
2. Payload URL: `http://tu-jenkins:8080/github-webhook/`
3. Eventos: `Push events`

### 8.2 Con Polling Manual

1. **Jenkins → Configuración del Job → Desencadenadores**
2. ☑ **Sondear el repositorio SCM**
3. Expresión: `H/5 * * * *` (cada 5 minutos)

---

## 9. Flujo de Desarrollo Automatizado

```
1. TÚ haces git push
           ↓
2. GitHub notifica a Jenkins (webhook)
           ↓
3. Jenkins ejecuta automáticamente:
   └── Maven compila
   └── Docker construye imagen
   └── Docker ejecuta contenedor
           ↓
4. Aplicación actualizada en http://localhost:8090
   └── Conectada a MySQL
   └── Con todos tus cambios
```

**Tiempo total:** ~1-2 minutos desde push hasta producción

---

## 10. Verificar que todo funciona

| Servicio       | URL                          |
|----------------|------------------------------|
| Jenkins        | http://localhost:8080        |
| Aplicación web | http://localhost:8090        |
| MySQL          | localhost:3306               |

---

## 11. Estructura de contenedores

```
adopciones-network (Red Docker Compartida)
│
├── mysql-adopciones (mysql:8.0)
│   └── Puerto 3306 → Base de datos
│
├── jenkins (jenkins:lts con DinD)
│   ├── Puerto 8080 → Interfaz web
│   ├── Puerto 50000 → Agentes
│   ├── /var/run/docker.sock → Acceso a Docker
│   └── Genera automáticamente:
│
└── adopciones-app (creado por Jenkins)
    └── Puerto 8090 → Aplicación Spring Boot
```

---

## 12. Notas importantes

### Instalación Inicial

- ✅ El Dockerfile debe estar en la raíz del proyecto
- ✅ Maven debe estar configurado en Jenkins
- ✅ Jenkins DEBE tener Docker in Docker habilitado
- ✅ El socket de Docker debe tener permisos 666

### Persistencia de Datos

- El volumen `jenkins_home` persiste la configuración entre reinicios
- El volumen `mysql_data` persiste la BD (si lo agregaste)
- **Nunca eliminar estos volúmenes** a menos que quieras resetear todo

### Recuperación

Si algo falla, puedes resetear todo:

```bash
# Detener todos los contenedores
docker-compose down  # si usas compose
docker stop $(docker ps -aq)

# Limpiar volúmenes
docker volume rm jenkins_home

# Reiniciar desde cero
docker network create adopciones-network
# ... seguir los pasos 3-7 arriba
```

### Troubleshooting

**Jenkins no ve Docker:**
```bash
docker exec -u root jenkins chmod 666 /var/run/docker.sock
```

**Aplicación no conecta a MySQL:**
```bash
docker exec adopciones-app ping mysql-adopciones
```

**El contenedor anterior no se detiene:**
```bash
docker stop adopciones-app
docker rm adopciones-app
```

---

## 13. Comandos útiles para desarrollo

```bash
# Ver logs de Jenkins
docker logs jenkins

# Ver logs de la aplicación
docker logs adopciones-app

# Acceder a MySQL
docker exec -it mysql-adopciones mysql -u root -p1234 -D sistema_adopciones

# Ejecutar un build manualmente en Jenkins
curl -X POST http://localhost:8080/job/EjecucionSistemaAdopciones/build

# Ver todas las imágenes Docker creadas
docker images | grep adopciones

# Eliminar imagen (para reconstruir)
docker image rm adopciones-sistema:latest
```

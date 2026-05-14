# 📚 Guía Completa de Instalación y Configuración
## Sistema de Adopciones de Mascotas

> **Versión:** 2026-05-14 | **Estado:** ✅ Completamente Funcional  
> **Arquitectura:** Docker Compose + Spring Boot 4.0.5 + MySQL 8.0 + Jenkins (Opcional)

---

## 🎯 ¿Cómo Funciona Este Proyecto?

```
┌─────────────────────────────────────────┐
│  TU MÁQUINA (Windows / macOS / Linux)  │
├─────────────────────────────────────────┤
│                                         │
│  1️⃣  REQUISITO: Docker Desktop         │
│      └─ Ejecuta contenedores Linux     │
│                                         │
│  2️⃣  Jenkins (Opcional en tu máquina)  │
│      └─ Orquesta todo el pipeline      │
│         ├─ Compila código (mvnw)       │
│         ├─ Generawar (Maven)           │
│         └─ Ejecuta: docker compose up  │
│                                         │
│  3️⃣  Docker Compose (AUTOMÁTICO)       │
│      Levanta DOS servicios:             │
│                                         │
│      🐳 MySQL 8.0 (Contenedor)          │
│      ├─ Ejecuta: 01-schema.sql (auto)  │
│      └─ BD lista con tablas             │
│                                         │
│      🐾 Spring Boot App (Contenedor)    │
│      ├─ Construido desde Dockerfile    │
│      ├─ Conecta a MySQL                │
│      └─ Escucha en :8090               │
│                                         │
└─────────────────────────────────────────┘
```

---

## 📋 Checklist de Requisitos

### Hardware Mínimo
- ✅ **RAM:** 4 GB (6+ recomendado para desarrollo cómodo)
- ✅ **Disco:** 8 GB libres
- ✅ **CPU:** 64-bit (ARM64 también soportado)
- ✅ **Virtualizacion:** Hyper-V (Windows) o equivalente habilitado

### Software Requerido (EN TU MÁQUINA)

| Componente | Versión | Instalado | Notas |
|-----------|---------|-----------|-------|
| **Docker Desktop** | 29.4.1+ | ❌ Ver paso 1 | Windows/macOS/Linux |
| **Git** | 2.40+ | ✅ | Descarga código |
| **Java/Maven** | No necesita | ✅ | Incluido en proyecto |

---

## 🚀 PASO 1: Instalar Docker Desktop (CRÍTICO)

Este es el **requisito más importante**. Todo lo demás ocurre dentro de Docker.

### Windows 10/11

#### 1.1 Descargar Docker Desktop

- URL: https://www.docker.com/products/docker-desktop
- Click en **"Download for Windows"**
- Se descarga: `Docker Desktop Installer.exe (~500 MB)`

#### 1.2 Instalar

```powershell
# El instalador puede pedirte permisos de administrador
# Haz click derecho → "Ejecutar como Administrador"

# Espera a que se complete (~5 minutos)
```

#### 1.3 Habilitar WSL 2 (Windows Subsystem for Linux)

Si aparece un diálogo, sigue estos pasos:

```powershell
# En PowerShell como Administrador ejecuta:
wsl --install

# Luego reinicia el sistema
Restart-Computer
```

#### 1.4 Ejecutar Docker Desktop

```powershell
# Después de reiniciar, busca "Docker" en el menú de inicio
# Click en "Docker Desktop"
# Espera a que el ícono en la bandeja muestre ✅ "Docker is running"
# (~1 minuto)
```

### macOS

#### 1.1 Descargar
- URL: https://www.docker.com/products/docker-desktop
- Click en **"Download for Mac"** (elige **Apple Silicon** si tienes M1/M2 o **Intel**)

#### 1.2 Instalar
```bash
# Se descarga Docker.dmg
# Haz click en Docker.dmg
# Arrastra el ícono Docker a Applications
# Espera instalación (~2 minutos)
```

#### 1.3 Ejecutar
```bash
# Applications → Docker
# Permite acceso (puede pedir contraseña)
# Espera ícono ✅ en la barra de estado
```

### Linux (Ubuntu/Debian)

```bash
# Instalar Docker Engine
sudo apt-get update
sudo apt-get install -y docker.io docker-compose

# Agregar tu usuario al grupo docker (sin sudo)
sudo usermod -aG docker $USER

# Aplicar cambios
newgrp docker

# Verificar
docker ps
```

---

## ✅ PASO 2: Verificar Instalación de Docker

Abre **PowerShell** (Windows), **Terminal** (macOS) o **Bash** (Linux) y ejecuta:

### 2.1 Script de Validación

```powershell
# Windows PowerShell

Write-Host "🔍 Verificando Docker..."
docker --version
docker-compose --version
docker ps

Write-Host ""
Write-Host "✅ Docker está listo si ves versiones arriba"
```

```bash
# macOS / Linux Bash

echo "🔍 Verificando Docker..."
docker --version
docker-compose --version
docker ps

echo ""
echo "✅ Docker está listo si ves versiones arriba"
```

**Salida esperada:**
```
Docker version 29.4.1, build 055a478
Docker Compose version v5.1.3
CONTAINER ID   IMAGE   COMMAND   CREATED   STATUS   PORTS   NAMES
(lista vacía es ok)
✅ Docker está listo si ves versiones arriba
```

**Si hay error:** 
- ❌ "docker: command not found" → Docker Desktop no está en PATH, reinicia o agrega manualmente
- ❌ "error during connect" → Docker no está corriendo, abre Docker Desktop
- ❌ "permission denied" → En Linux, ejecuta: `sudo usermod -aG docker $USER && newgrp docker`

---

## ✅ PASO 3: Instalar Git (Si No Lo Tienes)

Git es necesario para descargar el código del repositorio.

### Windows

```powershell
# Descargar desde: https://git-scm.com/download/win
# Ejecutar instalador git-*.exe
# Usar valores por defecto
# Verificar:
git --version
# Debería mostrar: git version 2.45.1.windows.1 (o similar)
```

### macOS

```bash
# Con Homebrew
brew install git

# O desde: https://git-scm.com/download/mac

# Verificar:
git --version
```

### Linux

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y git

# Verificar:
git --version
```

---

## 🚀 PASO 4: Descargar el Código del Proyecto

```bash
# Abre tu terminal favorita en la carpeta donde quieras trabajar

git clone https://github.com/ErickCaiced2/GR01_1BT3_622_26A.git
cd GR01_1BT3_622_26A

# Verificar que descargó correctamente
ls -la  # macOS/Linux
dir     # Windows

# Debería ver: compose.yaml, pom.xml, Dockerfile, src/, etc.
```

---

## 🔨 PASO 5: Compilar la Aplicación (Maven)

Ahora compilamos el código Java en un WAR que Docker ejecutará.

```powershell
# Windows PowerShell
.\mvnw clean package -DskipTests

# macOS/Linux Bash
./mvnw clean package -DskipTests
```

**Esto hace:**
1. Descarga dependencias Maven (~500 MB primera vez)
2. Compila código Java
3. Genera: `target/GR01_1BT3_622_26A-0.0.1-SNAPSHOT.war`
4. **Tiempo:** ~3 min primera vez, ~30 seg después (caché)

**Espera hasta ver:**
```
[INFO] BUILD SUCCESS
```

---

## 🎯️ PASO 6: El Flujo Automático de Docker Compose

**IMPORTANTE:** Esto es lo que hace Docker Compose automáticamente:

```
Tu comando: docker compose up -d
             └─ Lee compose.yaml
                ├─ SERVICIO 1: MySQL
                │  ├─ Descarga imagen: mysql:8.0
                │  ├─ Crea contenedor: adopciones-mysql
                │  ├─ Monta volumen con: 01-schema.sql
                │  ├─ Ejecuta AUTOMÁTICAMENTE: 01-schema.sql
                │  │  (crea tablas: usuario, mascota, solicitud, etc.)
                │  ├─ Bind Puerto: 3306 → 3306
                │  └─ Espera healthcheck (mysqladmin ping)
                │
                ├─ SERVICIO 2: Spring Boot App
                │  ├─ Lee Dockerfile
                │  ├─ Construye imagen desde WAR compilado
                │  ├─ Crea contenedor: adopciones-app
                │  ├─ Establece variables de entorno:
                │  │  ├─ SPRING_DATASOURCE_URL=mysql://adopciones-mysql:3306
                │  │  ├─ SPRING_DATASOURCE_USERNAME=myuser
                │  │  └─ SPRING_DATASOURCE_PASSWORD=secret
                │  ├─ Solo inicia DESPUÉS que MySQL esté listo
                │  │  (depends_on: mysql.service_healthy)
                │  └─ Bind Puerto: 8090 → 8090
                │
                └─ RESULTADO: Servicios listos en segundos ⏱️
```

---

## ✅ PASO 7: Levantar Todo con Docker Compose

Ahora que ya compilaste el código, ejecuta Docker Compose:

```bash
# Levanta MySQL + App
docker compose up -d

# Ver estado
docker compose ps

# Espera 20-30 segundos
```

**Salida esperada:**
```
CONTAINER ID  IMAGE                      STATUS
abc123        mysql:8.0                  Up 1 second (health: starting)
def456        adopciones-sistema:latest  Up 1 second
```

**Espera a que MySQL muestre:**
```
(health: healthy)  ← MySQL lista
```

---

## 🎉 PASO 8: ¡LISTO! Accede a la Aplicación

Abre tu navegador:

| Servicio | URL | Credenciales |
|----------|-----|--------------|
| 🐾 **App** | http://localhost:8090 | Admin precargado |
| 💾 **MySQL** | localhost:3306 | `myuser` / `secret` |

**Para ver logs en tiempo real:**

```bash
docker compose logs -f adopciones-app
```

Cuando veas:
```
✅ Started GR01_1BT3_622_26AApplication
```

¡Funciona! 🚀

---

---

## ✅ PASO 9: Verificar que Todo Funciona Correctamente

Después de ejecutar `docker compose up -d` y esperar 20-30 segundos:

### 9.1 Verificar Estado de Servicios

```bash
docker compose ps
```

**Debería ver:**
```
CONTAINER ID  NAMES              STATUS              PORTS
abc123        adopciones-mysql   Up 45 seconds (healthy)  0.0.0.0:3306->3306/tcp
def456        adopciones-app     Up 30 seconds            0.0.0.0:8090->8090/tcp
```

### 9.2 Verificar que MySQL Inició Correctamente

```bash
docker exec adopciones-mysql mysql -u root -p1234 -e "SHOW DATABASES;"
```

**Debería ver:**
```
+--------------------+
| Database           |
+--------------------+
| information_schema |
| adopciones_db      |  ← ✅ Nuestra BD
| mysql              |
| performance_schema |
| sys                |
+--------------------+
```

### 9.3 Verificar que las Tablas se Crearon

```bash
docker exec -it adopciones-mysql mysql -u myuser -psecret -D adopciones_db -e "SHOW TABLES;"
```

**Debería ver:**
```
+---------------------------+
| Tables_in_adopciones_db   |
+---------------------------+
| usuario                   |  ← ✅ Tabla creada por 01-schema.sql
| mascota                   |
| solicitud                 |
| solicitud_estado          |
| foto                      |
| adopcion                  |
| mascota_compatibilidad    |
| spring_session            |
| spring_session_attributes |
+---------------------------+
```

### 9.4 Verificar que la App está Corriendo

**Opción A: Desde el navegador**
```
http://localhost:8090
```

**Opción B: Desde terminal**

```powershell
# Windows PowerShell
(Invoke-WebRequest -Uri http://localhost:8090/actuator/health).Content

# macOS/Linux
curl http://localhost:8090/actuator/health
```

**Debería retornar:**
```json
{"status":"UP"}
```

### 9.5 Ver Logs de la Aplicación

```bash
docker compose logs -f adopciones-app
```

**Cuando veas:**
```
✅ Started GR01_1BT3_622_26AApplication in X.XXX seconds
```

¡LA APLICACIÓN ESTÁ LISTA! 🎉

---

## 🔄 Ciclo de Desarrollo Local

Cuando cambies código Java y quieras ver los cambios:

```bash
# 1. Compila nuevamente (genera nuevo WAR)
.\mvnw clean package -DskipTests

# 2. Reconstruye la imagen Docker usando el nuevo WAR
docker compose up -d --build

# 3. Espera 30 segundos
# 4. Ver que se actualizó
docker compose logs -f adopciones-app

# Cuando veas el mensaje de "Started" = cambios listos
```

---

## 📊 Acceso a Servicios (EN TU MÁQUINA AHORA)

| Componente | URL/Host | Credenciales | Descripción |
|-----------|----------|--------------|-------------|
| 🐾 **App Web** | http://localhost:8090 | Admin (precargado) | Interfaz web de adopciones |
| 💾 **MySQL CLI** | localhost:3306 | `myuser` / `secret` | Base de datos |
| 📊 **Health Check** | http://localhost:8090/actuator/health | No requiere | Estado de app |

---

## 📁 Estructura del Proyecto

```
GR01_1BT3_622_26A/
│
├── compose.yaml .................. 🔧 Orquestación: MySQL + App
├── Dockerfile .................... 📦 Especificación imagen Docker
├── pom.xml ....................... 📚 Dependencias Maven (Spring Boot, etc.)
│
├── src/main/
│   ├── java/
│   │   └── com/example/gr01_1bt3_622_26a/
│   │       ├── controller/ ....... 🎮 Controladores MVC (rutas HTTP)
│   │       ├── entity/ ........... 📊 Modelos (Mascota, Solicitud, etc.)
│   │       ├── repository/ ....... 🗄️  Acceso a BD (JPA)
│   │       └── service/ .......... ⚙️  Lógica de negocio
│   │
│   └── resources/
│       ├── 01-schema.sql ......... 📋 CRÍTICO: Estructura BD (auto-ejecutado)
│       ├── 02-data.sql ........... 🌱 Datos de ejemplo
│       └── application.properties  ⚙️  Configuración Spring Boot
│
├── mvnw / mvnw.cmd ............... 🔨 Maven Wrapper (sin instalar mvn)
│
└── README.md / SETUP.md .......... 📖 Documentación
```

---

## 🚨 Solución de Problemas

### ❌ Error: "Connection refused on port 8090"

**Causa:** MySQL aún no está listo

```bash
# Ver logs de MySQL
docker compose logs mysql

# Espera hasta ver:
# "ready for acceptance of connections"

# Verifica con:
docker compose ps
# Debería mostrar: mysql STATUS (healthy)
```

**Solución:** Espera 30-60 segundos completos

---

### ❌ Error: "Port 8090 already in use"

**Causa:** Hay otro contenedor en puerto 8090

```bash
# Detén todo
docker compose down

# Elimina volumen (si quieres resetear datos)
docker compose down -v

# Reinicia
docker compose up -d
```

---

### ❌ Error: "mvnw: permission denied" (macOS/Linux)

**Causa:** Archivo no tiene permisos de ejecución

```bash
chmod +x ./mvnw
./mvnw clean package -DskipTests
```

---

### ❌ Error: "Docker Desktop not running"

**Causa:** Docker no está iniciado

```bash
# Windows: Abre el Menu de Inicio → "Docker"
# macOS: Abre Applications → Docker
# Linux: docker systemctl start

# Verifica:
docker ps
```

---

### ❌ Error: "mysql: command not found"

**Causa:** MySQL CLI no está instalado (normal, lo ejecutamos en Docker)

```bash
# CORRECTO: Usar desde Docker
docker exec -it adopciones-mysql mysql -u root -p1234

# NO: ejecutar directamente mysql
```

---

### 🔧 Limpiar y Resetear Completamente

```bash
# ⚠️ ESTO BORRA TODO

# Detener todos los contenedores
docker compose down

# Eliminar volúmenes (BD se borra)
docker compose down -v

# Eliminar imágenes
docker image rm adopciones-sistema:latest mysql:8.0

# Limpiar volúmenes huérfanos
docker volume prune -f

# Ahora puedes volver a empezar desde cero
docker compose up -d
```

---

### 📊 Diagnosticar Problemas

```bash
# 1. Ver estado de servicios
docker compose ps

# 2. Ver logs completos
docker compose logs

# 3. Logs en tiempo real
docker compose logs -f adopciones-app
docker compose logs -f mysql

# 4. Entrar en contenedor
docker compose exec adopciones-app bash
docker compose exec mysql bash

# 5. Verificar conectividad desde app a MySQL
docker exec adopciones-app ping adopciones-mysql

# 6. Ver procesos en contenedor
docker compose top mysql
docker compose top adopciones-app
```

---

## 📖 Comandos Útiles


```bash
# Ver estado actual
docker compose ps

# Ver logs en tiempo real
docker compose logs -f adopciones-app
docker compose logs -f mysql

# Acceder a MySQL directamente
docker exec -it adopciones-mysql mysql -u myuser -psecret -D adopciones_db

# Detener servicios (mantiene datos)
docker compose down

# Detener y eliminar datos (CUIDADO)
docker compose down -v

# Reiniciar servicios
docker compose restart

# Reconstruir imagen y levantar
docker compose up -d --build

# Ver volúmenes
docker volume ls

# Red de Docker
docker network ls
```

---

## 🔧 Configuración de Variables de Entorno

Si necesitas cambiar credenciales, crea un archivo `.env` en la raíz del proyecto:

```env
MYSQL_ROOT_PASSWORD=tu_password_root
MYSQL_USER=tu_usuario
MYSQL_PASSWORD=tu_password
MYSQL_DATABASE=tu_bd
```

Luego: `docker compose up -d`

---

## 📦 Estructura del Proyecto Spring Boot

```
src/main/java/com/example/gr01_1bt3_622_26a/
├── controller/      # Controladores MVC
├── entity/          # Entidades JPA (Mascota, Solicitud, etc.)
├── repository/      # Acceso a base de datos
└── service/         # Lógica de negocio
```

---

## 🤖 Automatización con Jenkins (OPCIONAL - Para CI/CD)

> Esta sección explica cómo **Jenkins automatiza TODO** lo que hiciste manualmente arriba.  
> Es **OPCIONAL** - usa esto cuando quieras que cada push a GitHub dispare un deploy automático.

### Conceptual: Qué Hace Jenkins

```
┌─────────────────────────────────────────┐
│  REPOSITORIO GitHub (tu código)         │
│  ↑ Haces push                           │
└─────────────────────────────────────────┘
         ↓ Webhook notification
┌─────────────────────────────────────────┐
│  JENKINS (ejecutándose en tu máquina)   │
│                                         │
│  Job: "Adopciones-Deploy"               │
│  ├─ git clone (descarga código)         │
│  ├─ ./mvnw clean package  (compila)     │
│  │  └─ genera WAR en target/            │
│  ├─ docker compose down  (limpia)       │
│  ├─ docker compose up -d  (levanta)     │
│  │  ├─ MySQL se inicia                  │
│  │  ├─ 01-schema.sql se ejecuta         │
│  │  └─ App se construye y levanta       │
│  └─ docker compose ps  (verifica)       │
└─────────────────────────────────────────┘
         ↓
┌─────────────────────────────────────────┐
│  RESULTADO: App actualizada en :8090    │
│  ✅ Automáticamente, sin tocar nada     │
└─────────────────────────────────────────┘
```

### 1️⃣ Instalar Jenkins (Contenedor)

```bash
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts
```

Espera ~2 minutos a que Jenkins inicie.

### 2️⃣ Acceder a Jenkins y Obtener Token

```bash
# Abre en navegador
http://localhost:8080

# En terminal, obtén el token de administrador inicial
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

Copia el token, pégalo en Jenkins, instala plugins recomendados y crea usuario admin.

### 3️⃣ Instalar Docker CLI en Jenkins

Jenkins necesita `docker` y `docker-compose` para ejecutar comandos:

```bash
# Actualizar paquetes
docker exec -u root jenkins apt-get update

# Instalar Docker CLI
docker exec -u root jenkins apt-get install -y docker.io

# Agregar al grupo docker
docker exec -u root jenkins usermod -aG docker jenkins

# Verificar acceso
docker exec jenkins docker ps
docker exec jenkins docker-compose --version
```

### 4️⃣ Crear Job en Jenkins

**En Jenkins (http://localhost:8080):**

1. Click en **Nueva Tarea**
2. **Nombre:** `Adopciones-Deploy`
3. **Tipo:** Proyecto de estilo libre → **Crear**

### 5️⃣ Configurar Job

#### Sección: "Gestión del Código Fuente"

- ✅ Click en **Git**
- URL Repositorio: `https://github.com/ErickCaiced2/GR01_1BT3_622_26A.git`
- Rama: `*/main`

#### Sección: "Pasos de Construcción"

Click en **Agregar paso** → **Ejecutar shell**

**Pega este SCRIPT EXACTO** (esto replica lo que hiciste manualmente):

```bash
#!/bin/bash
set -e

echo ""
echo "╔════════════════════════════════════════╗"
echo "║  🚀 JENKINS DEPLOY AUTOMÁTICO         ║"
echo "║     Sistema de Adopciones             ║"
echo "╚════════════════════════════════════════╝"
echo ""

# ==========================================================
# PASO 1: Compilar código Java (genera WAR)
# ==========================================================
echo "[1/4] 🔨 Compilando código Java..."
./mvnw clean package -DskipTests
test -f target/GR01_1BT3_622_26A-0.0.1-SNAPSHOT.war && echo "✅ WAR generado" || exit 1

# ==========================================================
# PASO 2: Limpiar contenedores anteriores
# ==========================================================
echo "[2/4] 🧹 Limpiando contenedores previos..."
docker compose down 2>/dev/null || true
sleep 3

# ==========================================================
# PASO 3: Levantar stack (MySQL + App automáticamente)
# ==========================================================
echo "[3/4] 🐳 Levantando Docker Compose..."
docker compose up -d

# Esperar a MySQL (healthcheck)
echo "⏳ Esperando a MySQL..."
for i in {1..30}; do
  if docker exec adopciones-mysql mysqladmin ping -h localhost -u root -p1234 &>/dev/null; then
    echo "✅ MySQL listo"
    break
  fi
  echo -n "."
  sleep 2
done

# Esperar a que App inicie
sleep 10

# ==========================================================
# PASO 4: Verificar que todo funciona
# ==========================================================
echo "[4/4] ✅ Verificando servicios..."
docker compose ps
docker compose logs --no-log-prefix adopciones-app | grep "Started GR01_1BT3_622_26AApplication" && echo "✅ ¡APP INICIADA!" || echo "⚠️ Revisar logs"

echo ""
echo "╔════════════════════════════════════════╗"
echo "║  ✅ DEPLOY COMPLETADO                  ║"
echo "╚════════════════════════════════════════╝"
echo ""
echo "📱 Servicios disponibles:"
echo "   🐾 App: http://localhost:8090"
echo "   💾 BD:  localhost:3306"
echo ""
```

Click en **Guardar**

### 6️⃣ Ejecutar Deploy Manual

**En Jenkins:**
- Click en el job `Adopciones-Deploy`
- Click en **Construir ahora**
- Ver logs en tiempo real

**Desde terminal:**
```bash
curl -X POST http://localhost:8080/job/Adopciones-Deploy/build
```

### 7️⃣ (Opcional) Disparar Automáticamente con Webhooks

Para que cada push a GitHub dispare Jenkins automáticamente:

**En GitHub:**
1. Settings → Webhooks → Add webhook
2. Payload URL: `http://tu-ip-jenkins:8080/github-webhook/`
3. Content type: `application/json`
4. Selecciona "Push events"
5. Click "Add webhook"

**En Jenkins:**
1. Job Settings → Desencadenadores
2. ✅ **GitHub hook trigger for GITScm polling**

Ahora cada push dispara automáticamente el deploy.

---

## 📖 Resumen: Comandos del Día a Día

```bash
# 🔍 Ver qué está corriendo
docker compose ps

# 📊 Ver logs en vivo
docker compose logs -f adopciones-app

# 🔧 Acceder a MySQL CLI
docker exec -it adopciones-mysql mysql -u myuser -psecret -D adopciones_db

# 🔄 Después de cambiar código
./mvnw clean package -DskipTests
docker compose up -d --build

# 🛑 Detener (mantiene datos)
docker compose down

# 🧹 Limpiar todo (borra datos)
docker compose down -v

# 🔌 Conectar a contenedor interactivamente
docker compose exec adopciones-app bash
docker compose exec mysql bash
```

---

## 📊 Credenciales por Defecto

Cambiar en `.env` si lo necesitas:

```env
MYSQL_ROOT_PASSWORD=1234
MYSQL_USER=myuser
MYSQL_PASSWORD=secret
MYSQL_DATABASE=adopciones_db
```

---

## ✨ Características de Esta Configuración

✅ **Simple:** Sin buildx ni complejidades innecesarias  
✅ **Reproducible:** Funciona igual en Windows, macOS, Linux  
✅ **Automática:** Docker Compose maneja todas las dependencias  
✅ **Rápida:** Caché de Maven acelera builds posteriores  
✅ **Segura:** Usuario no-root en Docker, healthchecks automáticos  
✅ **Escalable:** Fácil agregar más servicios  

---

## 📞 Soporte

Si tienes problemas:

1. **Ver logs:** `docker compose logs -f [servicio]`
2. **Verificar conectividad:** `docker compose exec mysql mysqladmin ping`
3. **Resetear:** `docker compose down -v && docker compose up -d`
4. **Revisar QUICK_START.md** para soluciones rápidas

---

## 📚 Recursos Adicionales

- [README.md](README.md) - Documentación del proyecto
- [QUICK_START.md](QUICK_START.md) - Setup en 2 minutos
- [Docker Compose Docs](https://docs.docker.com/compose/)
- [Spring Boot Docs](https://spring.io/projects/spring-boot)

---

## 🎯 Checklist Final

Después de completar el setup, verifica:

- [ ] ✅ Docker Desktop instalado y ejecutándose
- [ ] ✅ `docker ps` funciona sin errores
- [ ] ✅ Git instalado (`git --version`)
- [ ] ✅ Código descargado (`git clone`)
- [ ] ✅ Compilación exitosa (`./mvnw clean package`)
- [ ] ✅ `docker compose up -d` levantó servicios
- [ ] ✅ MySQL healthcheck ahora muestra "healthy"
- [ ] ✅ App accesible en http://localhost:8090
- [ ] ✅ Logs muestran "Started GR01_1BT3_622_26AApplication"

**Si todo está marcado: ¡Tu ambiente está 100% funcional! 🎉**

---

**¡Listo! Ya tienes tu ambiente funcionando. ¡A desarrollar! 🚀**

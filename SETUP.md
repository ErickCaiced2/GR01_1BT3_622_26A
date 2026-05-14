# 📚 Guía Completa - Sistema de Adopciones de Mascotas

> **Versión:** 2026-05-14 | **Estado:** ✅ Funcionando | **Autor:** Equipo de Desarrollo

## 🚀 ¡COMIENZA AQUÍ!

### ⚡ **Para Empezar en 2 Minutos**

Si solo quieres que funcione **rápidamente**: 👉 **[VER QUICK_START.md](QUICK_START.md)**

```bash
# 3 comandos y listo:
git clone https://github.com/ErickCaiced2/GR01_1BT3_622_26A.git
cd GR01_1BT3_622_26A
docker compose up -d
```

---

## 📋 Requisitos Previos

### Hardware
- **RAM:** 4 GB mínimo (6+ recomendado)
- **Disco:** 8 GB libres
- **CPU:** Procesador 64-bit

### Software Requerido

| Herramienta | Versión | Estado |
|------------|---------|--------|
| **Docker Desktop** | 29.4.1+ | ✅ Validado |
| **Git** | 2.40+ | ✅ Cualquier versión reciente |
| **Java** | 21+ | ✅ Incluido en el proyecto |

**No necesitas instalar Maven** - El proyecto incluye `./mvnw` (wrapper)

### Instalar Docker Desktop

1. Descarga desde: https://www.docker.com/products/docker-desktop
2. Instala y ejecuta
3. Espera a que el ícono muestre "Docker is running"
4. Verifica:

```bash
docker --version
docker-compose --version
```

---

## ✅ Validación Rápida

Abre tu terminal/PowerShell y ejecuta:

```bash
docker ps && docker-compose --version && git --version
```

Si ves versiones sin errores: **¡Estás listo!** ✅

---

## 🛠️ Configuración de Desarrollo Local (SIN Jenkins)

### Paso 1: Clonar el Repositorio

```bash
git clone https://github.com/ErickCaiced2/GR01_1BT3_622_26A.git
cd GR01_1BT3_622_26A
```

### Paso 2: Compilar la Aplicación

```bash
# Windows (PowerShell)
.\mvnw clean package -DskipTests

# macOS/Linux (Bash)
./mvnw clean package -DskipTests
```

**Tiempo:** ~3 minutos la primera vez, ~30 segundos después (con cache)

### Paso 3: Levantar Servicios

```bash
docker compose up -d
```

**Espera 20-30 segundos** a que MySQL esté listo y la app inicie.

### Paso 4: Verificar que Funciona

```bash
# Ver estado
docker compose ps

# Ver logs
docker compose logs -f adopciones-app
```

**Cuando veas:** `Started GR01_1BT3_622_26AApplication` = ✅ ¡Funcionando!

---

## 📊 Acceso a Servicios

Abre tu navegador:

| Servicio | URL | Credenciales |
|----------|-----|--------------|
| **App Web** | http://localhost:8090 | Admin precargado |
| **MySQL** | localhost:3306 | `myuser` / `secret` |

---

## 🔄 Ciclo de Desarrollo

Después de cambiar código:

```bash
# 1. Compilar nuevamente
.\mvnw clean package -DskipTests

# 2. Reconstruir imagen Docker
docker compose up -d --build

# 3. Ver logs
docker compose logs -f adopciones-app
```

---

## ✅ Verificar que Todo Funciona

### Verificar MySQL

```bash
docker exec -it adopciones-mysql mysql -u myuser -psecret -D adopciones_db -e "SELECT * FROM usuario LIMIT 1;"
```

### Verificar Aplicación

```bash
# Windows
Invoke-WebRequest -Uri http://localhost:8090/actuator/health

# macOS/Linux
curl http://localhost:8090/actuator/health
```

Debería retornar: `{"status":"UP"}`

### Comprobar Tablas Creadas

```bash
docker exec -it adopciones-mysql mysql -u myuser -psecret -D adopciones_db -e "SHOW TABLES;"
```

---

## 📁 Estructura de Directorios

```
GR01_1BT3_622_26A/
├── src/
│   ├── main/
│   │   ├── java/          # Código fuente
│   │   └── resources/
│   │       ├── 01-schema.sql         # Estructura BD (auto-ejecutado)
│   │       ├── 02-data.sql           # Datos de ejemplo
│   │       └── application.properties
│   └── test/              # Tests
├── compose.yaml           # Orquestación de servicios
├── Dockerfile             # Imagen Docker
├── pom.xml                # Dependencias Maven
├── mvnw / mvnw.cmd       # Maven wrapper (sin instalar)
└── QUICK_START.md        # Setup rápido
```

---

## 🚨 Solución de Problemas

### ❌ "Connection refused on port 8090"

```bash
# MySQL tarda 20-30 seg en estar listo
docker compose logs mysql
# Espera a ver "ready for acceptance of connections"
```

### ❌ "Port 8090 already in use"

```bash
# Detén contenedores anteriores
docker compose down -v

# O usa otro puerto en compose.yaml
```

### ❌ "Permission denied on mvnw"

```bash
# Windows: Usa powershell como admin, o
.\mvnw --version

# macOS/Linux:
chmod +x ./mvnw
./mvnw --version
```

### ❌ "Docker Desktop not running"

```bash
# Abre Docker Desktop manualmente y espera el ícono verde
# Luego:
docker ps
```

### 🔄 Resetear Todo Completamente

```bash
# Detener y eliminar todo
docker compose down -v

# Eliminar volúmenes (¡pierde datos!)
docker volume rm gr01_1bt3_622_26a_mysql_data

# Volver a empezar
docker compose up -d
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

## 🚀 (Opcional) Configurar CI/CD con Jenkins

Para automatizar builds con Jenkins, consulta la **Sección Avanzada** más abajo.

---

---

## 🎯 Sección Avanzada: CI/CD con Jenkins

> ⚠️ Esta sección es **OPCIONAL** y para entornos más complejos.
> Para desarrollo local, usa la sección anterior.

### Requisitos para Jenkins

- Docker Desktop funcionando
- Jenkins image: `jenkins/jenkins:lts`
- Docker socket accesible desde Jenkins

### Configurar Jenkins

#### 1. Crear Contenedor Jenkins

```bash
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts
```

#### 2. Obtener Token Inicial

```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

#### 3. Configurar Jenkins (UI)

1. Abre http://localhost:8080
2. Pega el token obtenido
3. Instala plugins recomendados
4. Crea usuario admin

#### 4. Instalar Docker CLI en Jenkins

```bash
docker exec -u root jenkins apt-get update
docker exec -u root jenkins apt-get install -y docker.io
docker exec -u root jenkins usermod -aG docker jenkins
```

#### 5. Crear Job en Jenkins

1. **Nueva Tarea** → Nombre: `Adopciones-Deploy`
2. **Tipo:** Proyecto de estilo libre
3. **Gestión código fuente:**
   - URL: `https://github.com/ErickCaiced2/GR01_1BT3_622_26A.git`
   - Rama: `*/main`

4. **Build Steps** → **Ejecutar shell:**

```bash
#!/bin/bash
set -e

echo "🔨 Compilando..."
./mvnw clean package -DskipTests

echo "🐳 Reconstruyendo imagen y servicios..."
docker compose down 2>/dev/null || true
docker compose up -d
sleep 20

echo "✅ ¡DEPLOY COMPLETADO!"
docker compose ps
```

5. **Guardar**

#### 6. Ejecutar Job Manualmente

```bash
# Opción: Disparar desde terminal
curl -X POST http://localhost:8080/job/Adopciones-Deploy/build
```

O en Jenkins UI → Click en **Construir ahora**

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

## ✨ Notas Importantes

### ✅ Características de Esta Configuración

- ✅ **Simple:** Sin buildx ni complejidades innecesarias
- ✅ **Reproducible:** Funciona igual en Windows, macOS, Linux
- ✅ **Automática:** Docker Compose maneja dependencias
- ✅ **Rápida:** Caché de Maven acelera builds
- ✅ **Escalable:** Fácil agregar más servicios

### 🔒 Seguridad

- Usuario no-root en Docker (`appuser`)
- Healthchecks automáticos
- Credenciales configurables

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

**¡Listo! Ya tienes tu ambiente funcionando. ¡A desarrollar! 🚀**

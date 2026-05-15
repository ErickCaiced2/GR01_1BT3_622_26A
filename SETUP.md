# Guía de Configuración del Entorno - Sistema de Adopciones de Mascotas

> **Versión actualizada:** 2026-05-03  
> **Estado:** ✅ Completamente funcional con Docker + Jenkins + MySQL

---

## 📋 Requisitos Previos

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado y ejecutándose
- Git
- PowerShell (Windows) o Bash (Linux/Mac)
- ~5 GB de espacio en disco

---

## 1️⃣ Clonar el Repositorio

```bash
git clone https://github.com/ErickCaiced2/GR01_1BT3_622_26A.git
cd GR01_1BT3_622_26A
```

---

## 2️⃣ Crear la Red Compartida de Docker

```bash
docker network create adopciones-network
```

Verifica que se creó correctamente:
```bash
docker network inspect adopciones-network
```

---

## 3️⃣ Levantar MySQL 8.0

```bash
docker run -d \
  --name adopciones-mysql \
  --network adopciones-network \
  -e MYSQL_ROOT_PASSWORD=1234 \
  -e MYSQL_DATABASE=adopciones_db \
  -e MYSQL_USER=myuser \
  -e MYSQL_PASSWORD=secret \
  -p 3306:3306 \
  mysql:8.0
```

**Esperar a que MySQL esté listo (15-20 segundos):**

```bash
docker exec adopciones-mysql mysqladmin ping -h localhost -u root -p1234
```

Debería mostrar:
```
mysqld is alive
```

---

## 4️⃣ Levantar Jenkins con Docker in Docker (DinD)

### 4.1 Crear el Contenedor Jenkins

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

### 4.2 Instalar Docker CLI + Docker Compose en Jenkins

```bash
# Actualizar repositorios
docker exec -u root jenkins apt-get update

# Instalar Docker CLI (sin daemon)
docker exec -u root jenkins apt-get install -y docker.io

# Descargar Docker Compose v2 binario (más confiable que plugin)
docker exec -u root jenkins sh -c 'curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose'

# Hacer ejecutable
docker exec -u root jenkins chmod +x /usr/local/bin/docker-compose

# Verificar instalación
docker exec jenkins docker --version
docker exec jenkins docker-compose --version
```

### 4.3 Configurar Permisos (con persistencia)

```bash
docker exec -u root jenkins usermod -aG docker jenkins
docker exec -u root jenkins chmod 666 /var/run/docker.sock
```

> ⚠️ **Nota:** `chmod 666` se aplica en el momento pero se pierde si Docker Desktop reinicia el socket.  
> Para que persista en cada reinicio del contenedor Jenkins, recuerda volver a ejecutar:
> ```bash
> docker exec -u root jenkins chmod 666 /var/run/docker.sock
> ```
> O bien, al recrear Jenkins, agrégale la variable de entorno `-e DOCKER_OPTS=""` o usa un script de inicio.

### 4.4 Verificar que Docker Funciona dentro de Jenkins

```bash
docker exec jenkins docker ps
```

Debería mostrar los contenedores disponibles.

---

## 5️⃣ Acceder a Jenkins

1. Abre el navegador en: **http://localhost:8080**

2. Obtén la contraseña inicial:
```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

3. Copia la contraseña y pégala en Jenkins
4. Completa la instalación (Install Suggested Plugins)
5. Crea tu usuario admin

---

## 6️⃣ Configurar Maven en Jenkins

1. En Jenkins → **Administrar Jenkins** → **Global Tool Configuration**
2. Busca **Maven installations**
3. Click en **Add Maven**
4. Configurar:
   - **Nombre:** `Maven 3.9`
   - ☑ **Install automatically**
   - **Versión:** `3.9.6` (o la más reciente)
5. **Guardar**

---

## 7️⃣ Crear el Job de Jenkins

### 7.1 Nueva Tarea

1. Click en **Nueva tarea**
2. **Nombre:** `EjecucionSistemaAdopciones`
3. **Tipo:** Proyecto de estilo libre
4. Click **Crear**

### 7.2 Configurar Gestión del Código Fuente

1. **Gestión del código fuente** → **Git**
2. **URL del repositorio:**
   ```
   https://github.com/ErickCaiced2/GR01_1BT3_622_26A.git
   ```
3. **Rama:** `*/Prueba` (o `*/main` según sea necesario)
4. **Guardar**

### 7.3 Configurar Desencadenador de Compilación (Opcional)

1. **Desencadenadores** → ☑ **Sondear el repositorio SCM**
2. **Expresión cron:** `H/5 * * * *` (cada 5 minutos)
3. O usar **GitHub hook trigger for GITScm polling** si tienes webhooks configurados

### 7.4 Configurar Pasos de Construcción

**Paso 1: Ejecutar Shell**

1. **Pasos de construcción** → **Agregar paso** → **Ejecutar shell**
2. Pega el script completo abajo:

> ✅ **Nota:** El script usa `docker-compose` (binario descargado en 4.2) para orquestar todos los servicios  
> definidos en `compose.yaml`. Esto automatiza completamente la inicialización de base de datos  
> con todos los scripts SQL ejecutados por Docker al levantar MySQL.

```bash
#!/bin/bash
set -e

echo "=== [1/4] Compilar WAR ==="
bash mvnw clean package
test -f target/GR01_1BT3_622_26A-0.0.1-SNAPSHOT.war

echo "=== [2/4] Detener contenedores anteriores ==="
docker-compose down 2>/dev/null || true
docker rm -f adopciones-mysql adopciones-app 2>/dev/null || true

echo "=== [3/4] Levantar stack completo (MySQL + App) ==="
docker-compose up -d

echo "=== [4/4] Esperar a que servicios estén listos ==="
sleep 15
docker-compose exec -T mysql mysqladmin ping -h localhost -u root -p1234 || sleep 20

echo "=== Estado de servicios ==="
docker-compose ps
echo ""
echo "📊 Dashboard: http://localhost:8080"
echo "🐾 Aplicación:  http://localhost:8090"
echo "💾 MySQL:      localhost:3306"
echo ""
echo "✅ Despliegue completado"
```

3. **Guardar**

---

## 8️⃣ Verificar que Todo Funciona

### Estado de Servicios

| Servicio | URL | Descripción |
|----------|-----|-------------|
| Jenkins | http://localhost:8080 | Orquestador CI/CD |
| Aplicación | http://localhost:8090 | Spring Boot War |
| MySQL | localhost:3306 | Base de datos |

### Verificar MySQL

```bash
docker exec adopciones-mysql mysql -u root -p1234 -e "SHOW DATABASES;"
```

### Verificar Aplicación

Después de ejecutar el build en Jenkins:

```bash
curl http://localhost:8090/actuator/health
```

Debería retornar:
```json
{"status":"UP"}
```

---

## 9️⃣ Estructura de Contenedores (Docker Compose)

```
adopciones-network (Red automática de compose)
│
├── adopciones-mysql (mysql:8.0)
│   ├── Puerto: 3306
│   ├── Base de datos: adopciones_db
│   ├── Usuario app: myuser
│   ├── Contraseñas: myuser/secret, root/1234
│   ├── Volúmenes SQL (auto-ejecutados):
│   │   ├── 01-schema-mysql.sql
│   │   ├── 02-init-database.sql
│   │   ├── 03-V2-SolicitudEstados.sql
│   │   ├── 04-V3-MascotaCompatibilidad.sql
│   │   └── 05-V4-Usuarios.sql
│   └── Healthcheck: mysqladmin ping
│
├── adopciones-app (Spring Boot War)
│   ├── Puerto: 8090
│   ├── Conecta a: adopciones-mysql:3306
│   ├── Depende de: MySQL (service_healthy)
│   └── Reinicio automático
│
└── jenkins (jenkins:lts con DinD)
    ├── Puerto: 8080
    ├── Puerto agentes: 50000
    ├── Volumen: jenkins_home (persistente)
    └── Socket Docker: /var/run/docker.sock (para ejecutar compose)
```

**Ventajas de Docker Compose:**
- ✅ Levanta todos los servicios en orden correcto
- ✅ Ejecuta scripts SQL automáticamente al iniciar MySQL
- ✅ Maneja dependencias entre servicios (healthcheck)
- ✅ Red compartida creada automáticamente
- ✅ Variables de entorno centralizadas en `compose.yaml`
- ✅ Comandos `docker compose down` limpian todo

---

## 🔟 Flujo de Trabajo Automatizado

```
1. Haces git push a rama Prueba
           ↓
2. Jenkins detecta cambios (cada 5 min)
           ↓
3. Jenkins ejecuta automáticamente:
   ✓ Maven compila código (mvnw clean package)
   ✓ Genera WAR empaquetado
   ✓ Ejecuta docker-compose down (limpia previos)
   ✓ Ejecuta docker-compose up -d (levanta stack)
           ↓
4. Docker Compose orquesta:
   ✓ Crea red automática
   ✓ Levanta MySQL con scripts SQL auto-ejecutados
   ✓ Construye imagen Docker de la app
   ✓ Conecta app a MySQL cuando está listo
           ↓
5. Aplicación actualizada en http://localhost:8090
   ✓ Conectada a MySQL con datos inicializados
   ✓ Con últimos cambios del código
   ✓ Base de datos completamente configurada
```

**Tiempo total:** 2-3 minutos desde push hasta producción con BD lista

**Datos inicializados automáticamente:**
- ✅ Tablas creadas (schema-mysql.sql)
- ✅ Migrations ejecutadas (V2, V3, V4)
- ✅ Usuarios de ejemplo insertados
- ✅ Datos de ejemplo para mascotas, solicitantes, etc.

---

## 1️⃣1️⃣ Dockerfile (Incluido en el Proyecto)

El proyecto incluye `Dockerfile` ya configurado con:
- ✅ Java 21
- ✅ Usuario no-root (appuser)
- ✅ curl instalado (para healthcheck)
- ✅ Healthcheck automático
- ✅ Credenciales sobrescribibles

**No necesitas modificarlo.** Las variables de entorno se pasan desde Jenkins.

---

## 1️⃣2️⃣ Troubleshooting

### Error: "Network not found"

```bash
docker network create adopciones-network
```

### Error: "MySQL connection refused"

Espera 30 segundos después de levantar MySQL:
```bash
docker logs adopciones-mysql
```

### Error: "Application not responding"

Revisa los logs:
```bash
docker logs adopciones-app
```

### Error: "Jenkins no ve Docker"

```bash
docker exec -u root jenkins chmod 666 /var/run/docker.sock
docker restart jenkins
```

### Resetear todo

```bash
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker network rm adopciones-network
docker volume rm jenkins_home

# Vuelve a empezar desde el paso 2
```

---

## 1️⃣3️⃣ Comandos Útiles

```bash
# Ver logs en tiempo real
docker logs -f adopciones-app
docker logs -f adopciones-mysql
docker logs -f jenkins

# Acceder a MySQL
docker exec -it adopciones-mysql mysql -u root -p1234 -D adopciones_db

# Listar contenedores
docker ps -a

# Ver estado de red
docker network inspect adopciones-network

# Ejecutar build manualmente en Jenkins
curl -X POST http://localhost:8080/job/EjecucionSistemaAdopciones/build

# Ver imágenes Docker
docker images | grep adopciones

# Limpiar imágenes antiguas
docker image prune -a
```

---

## 1️⃣4️⃣ Credenciales y Configuración

| Componente | Usuario | Contraseña | Host | Puerto |
|-----------|---------|-----------|------|--------|
| MySQL | root / myuser | 1234 / secret | adopciones-mysql | 3306 |
| MySQL BD | - | - | adopciones_db | - |
| Jenkins | (Tu usuario admin) | (Tu contraseña) | localhost | 8080 |
| App | - | - | localhost | 8090 |

---

## 1️⃣5️⃣ Notas Importantes

### ✅ Lo que mantenemos igual

- Dockerfile con usuario no-root (seguridad)
- Spring Boot 4.0.5 con Java 21
- WAR como artefacto final
- MySQL 8.0

### ✅ Lo que cambió

- Deploy con **`docker-compose` orchestration** desde Jenkins (bin en `/usr/local/bin/docker-compose`)
- Script SQL ejecutado automáticamente al iniciar MySQL:
  - `schema-mysql.sql` → Define tablas
  - `init-database.sql` → Datos de ejemplo
  - `V2__SolicitudEstados.sql` → Migrations
  - `V3__MascotaCompatibilidad.sql` → Migrations
  - `V4__Usuarios.sql` → Tabla usuarios con datos
- Archivo `compose.yaml` en raíz del proyecto orquesta MySQL + App
- MySQL container: `adopciones-mysql`
- Base de datos por defecto: `adopciones_db`
- Usuario app por defecto: `myuser/secret`
- Permisos Docker socket: `docker exec -u root jenkins usermod -aG docker jenkins`
- Jenkins puede ejecutar `docker` y `docker-compose` correctamente

### 📝 Ventajas de esta configuración

1. **Reproducibilidad**: El mismo `compose.yaml` funciona en cualquier máquina
2. **Inicialización automática**: No necesitas ejecutar scripts SQL manualmente
3. **Dependencias**: Compose espera a que MySQL esté listo antes de levantar la app
4. **Escalabilidad**: Fácil agregar más servicios al `compose.yaml`
5. **Limpieza**: `docker compose down` elimina todo correctamente

### ⚠️ Para Producción

- Cambiar credenciales MySQL (en `.env` en lugar de valores por defecto)
- No pasar ENV variables sensibles (usar Docker Secrets o Vault)
- Usar HTTPS en lugar de HTTP
- Configurar backups de volumen `jenkins_home`
- Usar base de datos RDS/managed en lugar de contenedor

---

## 🎯 Resumen

1. ✅ Clonar repo
2. ✅ Crear red Docker
3. ✅ Levantar MySQL
4. ✅ Levantar Jenkins
5. ✅ Instalar Docker CLI en Jenkins
6. ✅ Configurar Maven en Jenkins
7. ✅ Crear job con script CI/CD
8. ✅ ¡Listo! Cada push dispara deploy automático

**Tiempo total de configuración: ~30 minutos**

---

## 📞 Soporte

Si tienes problemas:

1. Revisa los logs: `docker logs [container-name]`
2. Verifica la conectividad: `docker exec [container] ping [otro-container]`
3. Limpia y reinicia: `docker-compose down && docker-compose up -d`

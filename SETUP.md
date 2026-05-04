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
  --name mysql-adopciones \
  --network adopciones-network \
  -e MYSQL_ROOT_PASSWORD=1234 \
  -e MYSQL_DATABASE=sistema_adopciones \
  -p 3306:3306 \
  mysql:8.0
```

**Esperar a que MySQL esté listo (15-20 segundos):**

```bash
docker exec mysql-adopciones mysqladmin ping -h localhost -u root -p1234
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

### 4.2 Instalar Docker CLI dentro de Jenkins

```bash
docker exec -u root jenkins apt-get update
docker exec -u root jenkins apt-get install -y docker.io
docker exec jenkins docker --version
```

### 4.3 Configurar Permisos

```bash
docker exec -u root jenkins usermod -aG docker jenkins
docker exec -u root jenkins chmod 666 /var/run/docker.sock
```

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

```bash
#!/bin/bash
set -e

echo "=== [1/7] Verificando Docker ==="
docker --version

echo "=== [2/7] Compilando con Maven ==="
bash mvnw clean package -DskipTests

echo "=== [3/7] Verificando WAR ==="
test -f target/GR01_1BT3_622_26A-0.0.1-SNAPSHOT.war || (echo "ERROR: WAR no encontrado" && exit 1)

echo "=== [4/7] Creando red Docker ==="
docker network create adopciones-network 2>/dev/null || echo "Red ya existe"

echo "=== [5/7] Verificando MySQL ==="
if [ "$(docker inspect -f '{{.State.Running}}' mysql-adopciones 2>/dev/null)" != "true" ]; then
    echo "Levantando MySQL..."
    docker start mysql-adopciones 2>/dev/null || docker run -d \
        --name mysql-adopciones \
        --network adopciones-network \
        -e MYSQL_ROOT_PASSWORD=1234 \
        -e MYSQL_DATABASE=sistema_adopciones \
        -p 3306:3306 \
        mysql:8.0
    echo "Esperando MySQL..."
    sleep 30
else
    echo "MySQL ya corriendo."
fi

echo "=== [6/7] Limpiando contenedor anterior ==="
docker stop adopciones-app 2>/dev/null || true
docker rm adopciones-app 2>/dev/null || true

echo "=== [7/7] Construyendo y ejecutando ==="
docker build -t adopciones-sistema:latest -t adopciones-sistema:${BUILD_NUMBER:-latest} .

docker run -d \
  --name adopciones-app \
  --network adopciones-network \
  -p 8090:8090 \
  -e SPRING_DATASOURCE_URL="jdbc:mysql://mysql-adopciones:3306/sistema_adopciones?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true" \
  -e SPRING_DATASOURCE_USERNAME=root \
  -e SPRING_DATASOURCE_PASSWORD=1234 \
  adopciones-sistema:latest

sleep 10
echo "=== Sistema en http://localhost:8090 ==="
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
docker exec mysql-adopciones mysql -u root -p1234 -e "SHOW DATABASES;"
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

## 9️⃣ Estructura de Contenedores

```
adopciones-network (Red compartida)
│
├── mysql-adopciones (mysql:8.0)
│   ├── Puerto: 3306
│   ├── Base de datos: sistema_adopciones
│   ├── Usuario: root
│   └── Contraseña: 1234
│
├── jenkins (jenkins:lts con DinD)
│   ├── Puerto: 8080
│   ├── Puerto agentes: 50000
│   ├── Volumen: jenkins_home
│   └── Docker Socket: /var/run/docker.sock
│
└── adopciones-app (Creado automáticamente por Jenkins)
    ├── Puerto: 8090
    ├── Conecta a: mysql-adopciones:3306
    └── Deploy: Automático con cada build
```

---

## 🔟 Flujo de Trabajo Automatizado

```
1. Haces git push a rama Prueba
           ↓
2. Jenkins detecta cambios (cada 5 min)
           ↓
3. Jenkins ejecuta automáticamente:
   ✓ Maven compila código
   ✓ Genera WAR
   ✓ Construye imagen Docker
   ✓ Ejecuta contenedor
           ↓
4. Aplicación actualizada en http://localhost:8090
   ✓ Conectada a MySQL
   ✓ Con últimos cambios
```

**Tiempo total:** 1-2 minutos desde push hasta producción

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
docker logs mysql-adopciones
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
docker logs -f mysql-adopciones
docker logs -f jenkins

# Acceder a MySQL
docker exec -it mysql-adopciones mysql -u root -p1234 -D sistema_adopciones

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
| MySQL | root | 1234 | mysql-adopciones | 3306 |
| MySQL BD | - | - | sistema_adopciones | - |
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

- Red: `adopciones-network` (más simple que compose)
- MySQL container: `mysql-adopciones`
- Contraseñas: `root/1234` (para desarrollo local)
- Base de datos: `sistema_adopciones`
- Script de Jenkins: Completamente automatizado

### ⚠️ Para Producción

- Cambiar credenciales MySQL
- No pasar ENV variables sensibles (usar secrets de Docker)
- Usar HTTPS en lugar de HTTP
- Configurar backups de volumen jenkins_home

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

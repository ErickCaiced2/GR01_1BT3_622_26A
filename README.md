# 🐾 Sistema de Adopciones de Mascotas

[![Java](https://img.shields.io/badge/Java-22-orange.svg)](https://www.oracle.com/java/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-4.0.5-brightgreen.svg)](https://spring.io/projects/spring-boot)
[![Maven](https://img.shields.io/badge/Maven-3.6+-blue.svg)](https://maven.apache.org/)
[![Docker](https://img.shields.io/badge/Docker-29.4+-blue.svg)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-Educational-yellow.svg)](#licencia)

Una aplicación web **Spring Boot + JSP** para gestionar de forma integral el proceso de adopción de mascotas. Permite registrar mascotas disponibles, solicitar adopciones, validar solicitantes y realizar seguimiento de adopciones exitosas.

## 🚀 ¿Cómo Empezar? (5 minutos)

### Opción Rápida: Todo Automático

```bash
# 1. Descargar
git clone https://github.com/ErickCaiced2/GR01_1BT3_622_26A.git
cd GR01_1BT3_622_26A

# 2. Compilar
./mvnw clean package -DskipTests  # macOS/Linux
.\mvnw clean package -DskipTests  # Windows

# 3. Ejecutar
docker compose up -d

# 4. ¡Listo!
# Abre: http://localhost:8090
```

### Opción Detallada con Pasos

👉 **[VER QUICK_START.md](QUICK_START.md)** ← Empieza aquí si es tu primer setup

---

## 📚 Documentación

| Documento | Propósito |
|-----------|-----------|
| **[QUICK_START.md](QUICK_START.md)** | Setup en 5 minutos (recomendado para principiantes) |
| **[SETUP.md](SETUP.md)** | Guía completa con todos los pasos, troubleshooting y CI/CD |
| **[ARQUITECTURA.md](ARQUITECTURA.md)** | Diagramas y explicación de cómo funciona todo |

---

## ✨ Características

- ✅ **Gestión de Mascotas**: Registro, edición y eliminación de mascotas disponibles
- ✅ **Formulario de Solicitud**: Proceso simplificado para solicitar adopciones
- ✅ **Validación de Solicitantes**: Verificación de información de adoptantes
- ✅ **Seguimiento de Adopciones**: Historial y estado de cada adopción
- ✅ **Dashboard Administrativo**: Panel de control para administradores
- ✅ **Búsqueda y Filtros**: Funcionalidad para encontrar mascotas
- ✅ **Completamente Dockerizado**: Funciona igual en Windows, macOS, Linux

---

## 📋 Requisitos

### Requisitos Mínimos
- **RAM:** 4 GB (6+ recomendado)
- **Disco:** 8 GB libres
- **CPU:** 64-bit

### Software Requerido
- **Docker Desktop** 29.4.1+ [[Descargar](https://www.docker.com/products/docker-desktop)]
- **Git** 2.40+ [[Descargar](https://git-scm.com/)]

**Eso es todo.** No necesitas instalar Maven, MySQL, Java localmente.

---

## 🛠️ Stack Tecnológico

### Backend
- **Java 22** - Lenguaje de programación
- **Spring Boot 4.0.5** - Framework web
- **Spring Data JPA** - Acceso a datos
- **MySQL 8.0** - Base de datos

### Frontend
- **JSP/JSTL** - Vistas (templates)
- **HTML5 + CSS3** - Markup y estilos
- **Bootstrap** - Framework CSS

### DevOps
- **Docker** - Containerización
- **Docker Compose** - Orquestación
- **Maven** - Build tool (wrapper incluido)
- **Jenkins** (opcional) - CI/CD

---

## 📁 Estructura del Proyecto

```
GR01_1BT3_622_26A/
├── src/main/
│   ├── java/com/example/gr01_1bt3_622_26a/
│   │   ├── controller/        # Controladores MVC
│   │   ├── entity/            # Modelos (Mascota, Solicitud, etc.)
│   │   ├── repository/        # Acceso BD (JPA)
│   │   └── service/           # Lógica de negocio
│   └── resources/
│       ├── 01-schema.sql      # Estructura BD (auto-ejecutado)
│       ├── 02-data.sql        # Datos de ejemplo
│       ├── application.properties
│       └── templates/         # Vistas JSP
│
├── src/main/webapp/WEB-INF/jsp/  # Vistas JSP
│
├── compose.yaml           # Orquestación Docker
├── Dockerfile             # Especificación imagen Docker
├── pom.xml                # Dependencias Maven
├── mvnw / mvnw.cmd       # Maven Wrapper
│
└── DOCUMENTACIÓN
    ├── QUICK_START.md     # 👈 Empieza aquí
    ├── SETUP.md           # Guía completa
    ├── ARQUITECTURA.md    # Diagramas
    └── README.md          # Este archivo
```

---

## 🚀 Flujo Automatizado

```
Tu máquina
   ↓
Docker Desktop + Git
   ↓
git clone (descarga código)
   ↓
./mvnw clean package (compila JAR/WAR)
   ↓
docker compose up -d (levanta)
   ├─ MySQL 8.0 inicia
   ├─ 01-schema.sql se ejecuta automáticamente
   ├─ Spring Boot App se construye
   └─ Se conectan automáticamente
   ↓
✅ http://localhost:8090 LISTO
```

---

## 📊 Acceso a Servicios

| Servicio | URL | Credenciales | Descripción |
|----------|-----|--------------|-------------|
| **App Web** | http://localhost:8090 | Admin precargado | Interfaz principal |
| **MySQL** | localhost:3306 | `myuser` / `secret` | Base de datos |
| **Jenkins** (opt) | http://localhost:8080 | Tu user admin | CI/CD |

---

## 🔄 Ciclo de Desarrollo

```bash
# Editas código
# ↓
./mvnw clean package -DskipTests

# ↓
docker compose up -d --build

# ↓
http://localhost:8090 actualizado
```

---

## 📖 Comandos Útiles

```bash
# Ver estado de servicios
docker compose ps

# Ver logs en vivo
docker compose logs -f adopciones-app

# Acceder a MySQL CLI
docker exec -it adopciones-mysql mysql -u myuser -psecret -D adopciones_db

# Detener servicios (mantiene datos)
docker compose down

# Limpiar todo (borra datos)
docker compose down -v

# Reiniciar después de cambios
./mvnw clean package -DskipTests && docker compose up -d --build
```

---

## 🆘 Solución de Problemas

### "Connection refused on port 8090"
```bash
# Espera 30 seg más a que MySQL esté listo
docker compose logs mysql | tail -20
```

### "Port 8090 already in use"
```bash
docker compose down -v
docker compose up -d
```

### "Docker Desktop not running"
```bash
# Abre manualmente: Menu de inicio → Docker
# Espera a que muestre ✅
docker ps
```

👉 **Para más soluciones:** [Ver SETUP.md → Solución de Problemas](SETUP.md#--solución-de-problemas)

---

## 🔒 Seguridad

- ✅ Usuario no-root en contenedores (`appuser`)
- ✅ Healthchecks automáticos
- ✅ Contraseñas configurables en `.env`
- ⚠️ Para producción: usar secrets, no ENV variables

---

## 🤖 CI/CD con Jenkins (OPCIONAL)

Para automatizar deploys con cada push a GitHub:

👉 **[Ver SETUP.md → Automatización con Jenkins](SETUP.md#-automatización-con-jenkins-opcional---para-cicd)**

---

## 📞 Soporte

Si tienes problemas:

1. **Revisa los logs:** `docker compose logs -f [servicio]`
2. **Lee SETUP.md:** Tiene troubleshooting detallado
3. **Limpiar y reintentar:** `docker compose down -v && docker compose up -d`

---

## 📝 Licencia

Proyecto educativo GR01_1BT3_622_26A

---

## 👨‍💻 Autor

**Erick Caicedo**
- GitHub: [@ErickCaiced2](https://github.com/ErickCaiced2)
- Proyecto: [GR01_1BT3_622_26A](https://github.com/ErickCaiced2/GR01_1BT3_622_26A)

---

## 🎯 Siguientes Pasos

1. **Primero:** Lee **[QUICK_START.md](QUICK_START.md)** (5 min)
2. **Luego:** Explora la app en http://localhost:8090
3. **Después:** Lee **[SETUP.md](SETUP.md)** para entender todo en detalle
4. **Finalmente:** Mira **[ARQUITECTURA.md](ARQUITECTURA.md)** para diagramas

---

**¡Listo! Ya tienes todo lo que necesitas. ¡A adoptar mascotas! 🐾**

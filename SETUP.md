# Guía de Configuración - Sistema de Adopciones (Paws & Home)

> Última actualización: 2026-07-02 — refleja el estado actual del proyecto (Sprint 4 y 5: contratos PDF, WhatsApp, bienestar post-adopción, estadísticas y reportes).

Guía simple para levantar **toda la aplicación con Docker** desde cero, en cualquier máquina.

---

## 1. Requisitos previos

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado y ejecutándose
- [JDK 21](https://adoptium.net/) instalado (solo para compilar el `.war` con Maven; Docker Compose no compila el código, corre el artefacto ya compilado)
- Git

No necesitas instalar Maven ni MySQL — el proyecto trae su propio Maven Wrapper (`mvnw`) y MySQL corre dentro de un contenedor.

---

## 2. Clonar el repositorio

```powershell
git clone https://github.com/ErickCaiced2/GR01_1BT3_622_26A.git
cd GR01_1BT3_622_26A
```

---

## 3. Compilar el `.war`

Docker Compose arma la imagen de la app a partir de un `.war` ya compilado (no compila código Java dentro del contenedor), así que primero hay que generarlo con Maven:

```powershell
.\mvnw.cmd clean package -DskipTests
```

(En Mac/Linux: `./mvnw clean package -DskipTests`)

Esto debe dejar el archivo en `target\GR01_1BT3_622_26A-0.0.1-SNAPSHOT.war`.

> `-DskipTests` es solo para que el primer arranque sea rápido. Para correr los tests: `.\mvnw.cmd test`.

---

## 4. Levantar todo con Docker Compose

```powershell
docker compose up -d --build
```

Esto levanta dos contenedores:

| Contenedor | Imagen | Puerto | Qué hace |
|---|---|---|---|
| `adopciones-mysql` | `mysql:8.0` | `3306` | Base de datos. En el **primer arranque** (volumen vacío) ejecuta automáticamente `01-schema.sql` (crea todas las tablas, incluida `actualizaciones_bienestar`) y `02-data.sql` (carga usuarios, mascotas, solicitudes y adopciones de ejemplo). |
| `adopciones-app` | construida desde `Dockerfile` con el `.war` del paso 3 | `8090` | La aplicación Spring Boot. Espera a que MySQL esté "healthy" antes de arrancar. |

Espera unos 20-30 segundos y verifica que ambos estén corriendo:

```powershell
docker compose ps
```

Deberías ver `adopciones-mysql` como `healthy` y `adopciones-app` como `Up`.

Si `adopciones-app` no queda `Up`, revisa sus logs (ver sección 7).

---

## 5. Acceder a la aplicación

Abre **http://localhost:8090**

### Usuarios de prueba (vienen precargados por `02-data.sql`)

| Rol | Email | Contraseña |
|---|---|---|
| Admin | `admin@pawshome.com` | `admin123` |
| Staff | `staff@pawshome.com` | `staff123` |
| Solicitante | `carlos.garcia@email.com` | `password123` |
| Solicitante | `maria.lopez@email.com` | `password123` |
| Solicitante | `juan.rodriguez@email.com` | `password123` |

Entra por **http://localhost:8090/acceso** y elige "Soy Solicitante" o "Soy Administrador".

---

## 6. Qué puedes probar (funcionalidades actuales)

| Función | Ruta | Notas |
|---|---|---|
| Ver/aprobar/rechazar solicitudes | `/admin/solicitudes/gestionar` | Login como admin |
| Descargar contrato de adopción (PDF autocompletado) | Botón "Descargar Contrato PDF" en el detalle de una solicitud **Aprobada**, o botón "Contrato" en `/admin/solicitudes/gestionar` | HU11-13 |
| Contactar al refugio por WhatsApp | Botón en el detalle de una solicitud (`/solicitudes/{id}`) | HU14 |
| Registrar actualización de bienestar de la mascota | Formulario en el detalle de una adopción (`/adopciones/{id}`) | HU15, login como el solicitante dueño de esa adopción |
| Ver actualizaciones de bienestar (admin) | `/admin/bienestar` | HU16 |
| Estadísticas generales del sistema | `/admin/estadisticas` | HU17 |
| Reporte de mascotas (ver + descargar PDF) | `/admin/reporte/mascotas` | HU18 |

---

## 7. Comandos útiles

```powershell
# Ver logs en tiempo real
docker compose logs -f adopciones-app
docker compose logs -f adopciones-mysql

# Detener todo (conserva los datos)
docker compose stop

# Volver a levantar sin reconstruir
docker compose start

# Bajar todo (conserva los datos en el volumen)
docker compose down

# Entrar a MySQL directamente
docker exec -it adopciones-mysql mysql -u myuser -psecret adopciones_db

# Reconstruir la imagen de la app después de un cambio de código
.\mvnw.cmd clean package -DskipTests
docker compose up -d --build adopciones-app
```

---

## 8. Reiniciar completamente desde cero

`01-schema.sql` y `02-data.sql` **solo se ejecutan cuando el volumen de MySQL está vacío** (primer arranque). Si ya tienes un volumen con datos viejos y quieres una base 100% limpia con el esquema y los datos más recientes:

```powershell
docker compose down -v   # -v borra también el volumen de MySQL (se pierden los datos)
docker compose up -d --build
```

> Si solo agregaste una tabla/columna nueva (por ejemplo, al actualizar el código), normalmente **no** hace falta borrar el volumen: como `spring.jpa.hibernate.ddl-auto=update`, Hibernate crea las tablas/columnas que falten automáticamente al arrancar la app.

---

## 9. Troubleshooting

**`adopciones-app` no arranca / reinicia en bucle**
```powershell
docker compose logs adopciones-app
```
Lo más común es que MySQL no estaba listo a tiempo o el `.war` no se compiló antes del `docker compose up --build` (ver paso 3).

**Cambié código pero no se ve reflejado**
Falta recompilar el `.war` y reconstruir la imagen — Docker Compose no ve tu código fuente, solo el `.war`:
```powershell
.\mvnw.cmd clean package -DskipTests
docker compose up -d --build adopciones-app
```

**Puerto 3306 u 8090 ya en uso**
Verifica qué lo está usando y detén ese proceso, o cambia el puerto publicado en `compose.yaml` (ej. `'8091:8090'`).

**Quiero borrar todo y empezar de cero**
```powershell
docker compose down -v
docker rmi adopciones-sistema:latest
```

---

## 10. Estructura de archivos relevantes

```
compose.yaml          → Orquesta MySQL + la app
Dockerfile             → Empaqueta el .war en una imagen con Java 21
src/main/resources/
  01-schema.sql         → Esquema de BD (se ejecuta solo en el primer arranque de MySQL)
  02-data.sql           → Datos de ejemplo (usuarios, mascotas, solicitudes, adopciones)
  application.properties → Perfil por defecto (usado dentro del contenedor)
```
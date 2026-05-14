# ⚡ QUICK START - Sistema de Adopciones de Mascotas

> **¡Funciona en minutos!** Solo 3 pasos para que todo esté listo.

## ✅ Verificación Rápida (30 segundos)

Abre PowerShell y ejecuta:

```powershell
docker --version
docker-compose --version
git --version
```

Si ves versiones (Docker 29+, Compose 5+, Git 2+), ¡estás listo! 🎉

## 🚀 Opción 1: Script Automático (Recomendado - 2 minutos)

### Windows (PowerShell)

```powershell
# Copiar y ejecutar en PowerShell (como administrador es suficiente)
$ErrorActionPreference = "Stop"

Write-Host "📦 Clonando repositorio..." -ForegroundColor Green
git clone https://github.com/ErickCaiced2/GR01_1BT3_622_26A.git
cd GR01_1BT3_622_26A

Write-Host "🔨 Compilando con Maven..." -ForegroundColor Green
.\mvnw clean package -DskipTests

Write-Host "🐳 Levantando servicios Docker..." -ForegroundColor Green
docker compose up -d
Start-Sleep -Seconds 5

Write-Host "📊 Estado:" -ForegroundColor Green
docker compose ps

Write-Host "`n✅ ¡LISTO!" -ForegroundColor Green
Write-Host "🐾 App:   http://localhost:8090" -ForegroundColor Cyan
Write-Host "💾 DB:    localhost:3306 (myuser/secret)" -ForegroundColor Cyan
Write-Host "`nPara ver logs: docker compose logs -f adopciones-app" -ForegroundColor Yellow
```

### macOS/Linux (Bash)

```bash
#!/bin/bash
set -e

echo "📦 Clonando repositorio..."
git clone https://github.com/ErickCaiced2/GR01_1BT3_622_26A.git
cd GR01_1BT3_622_26A

echo "🔨 Compilando con Maven..."
./mvnw clean package -DskipTests

echo "🐳 Levantando servicios Docker..."
docker compose up -d
sleep 5

echo "📊 Estado:"
docker compose ps

echo -e "\n✅ ¡LISTO!"
echo "🐾 App:   http://localhost:8090"
echo "💾 DB:    localhost:3306 (myuser/secret)"
echo -e "\nPara ver logs: docker compose logs -f adopciones-app"
```

---

## 🛠️ Opción 2: Pasos Manuales (5 minutos)

### Paso 1: Clonar el Repositorio

```bash
git clone https://github.com/ErickCaiced2/GR01_1BT3_622_26A.git
cd GR01_1BT3_622_26A
```

### Paso 2: Compilar

```bash
# Windows
.\mvnw clean package -DskipTests

# macOS/Linux
./mvnw clean package -DskipTests
```

### Paso 3: Iniciar Servicios

```bash
# Levanta MySQL + Aplicación
docker compose up -d
```

### Paso 4: Esperar (20-30 segundos)

```bash
# Ver el estado
docker compose ps

# Ver logs en vivo
docker compose logs -f adopciones-app
```

Cuando veas "**Application started successfully**" ✅ ¡Puedes usar la app!

---

## 📱 ¡Ya Funciona!

| Componente | URL/Host | Credenciales |
|-----------|----------|--------------|
| **App Web** | http://localhost:8090 | Sin login (admin por defecto) |
| **MySQL** | localhost:3306 | `myuser` / `secret` |
| **BD** | adopciones_db | - |

---

## 🆘 Si Algo No Funciona

### ❌ "Connection refused"
```bash
# Espera un poco más
sleep 30
docker compose logs adopciones-mysql
```

### ❌ "Port 8090 already in use"
```bash
# Detén contenedores anteriores
docker compose down
```

### ❌ "Maven not found"
```bash
# Windows: Usa el wrapper del proyecto
.\mvnw --version

# macOS/Linux:
./mvnw --version
```

### 🔄 Resetear Todo

```bash
# Detener todo
docker compose down

# Eliminar datos de BD
docker volume rm gr01_1bt3_622_26a_mysql_data

# Volver a empezar desde Paso 2
```

---

## 📚 Comandos Útiles Después

```bash
# Ver logs en tiempo real
docker compose logs -f adopciones-app

# Ver logs de MySQL
docker compose logs -f mysql

# Acceder a MySQL
docker exec -it adopciones-mysql mysql -u myuser -psecret -D adopciones_db

# Detener todo
docker compose down

# Reiniciar servicios
docker compose restart

# Limpiar todo (cuidado!)
docker compose down -v
```

---

## 🎯 Próximos Pasos

1. Abre http://localhost:8090 en tu navegador
2. Explora la aplicación
3. Revisa los logs si necesitas debug: `docker compose logs -f`
4. Para cambios de código, compila de nuevo: `.\mvnw clean package -DskipTests`

---

## 📖 Para Más Info

- [SETUP.md](SETUP.md) - Configuración avanzada y CI/CD con Jenkins
- [README.md](README.md) - Documentación del proyecto
- Logs: `docker compose logs -f [servicio]`

**¡Listo! Ya tienes el ambiente funcionando. ¡A desarrollar! 🚀**


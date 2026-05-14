# ⚡ QUICK START - Sistema de Adopciones de Mascotas

> **¡Funciona en 5 minutos!** Sin complicaciones, solo esenciales.  
> **Para info detallada:** 📖 [VER SETUP.md](SETUP.md)

---

## ⚠️ PRIMERO: Requisitos Previos (Solo UNA VEZ)

### 1. Descargar e Instalar Docker Desktop

**CRÍTICO:** Sin Docker, nada funciona

- **URL:** https://www.docker.com/products/docker-desktop
- Descarga según tu SO (Windows/Mac/Linux)
- Instala y ejecuta
- Espera a que el ícono muestre ✅ "Docker is running"

### 2. Instalar Git

- **Windows/macOS:** https://git-scm.com/download
- **Linux:** `sudo apt-get install git`

### 3. Verificar Instalación

```bash
docker --version
docker-compose --version
git --version
```

Si ves versiones: **¡Estás listo!** ✅

---

## 🚀 Pasos de Setup (5 minutos)

### Paso 1: Descargar Código

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

**Espera:** ~3 min primera vez, ~30 seg después

### Paso 3: Levanta TODO

```bash
docker compose up -d
```

**Espera:** 30 segundos

### Paso 4: ¡Listo!

```bash
docker compose ps
```

Si ves 2 contenedores UP, abre: **http://localhost:8090**

---

## 📱 Acceso

| Servicio | URL | Credenciales |
|----------|-----|--------------|
| 🐾 App | http://localhost:8090 | Cargado |
| 💾 BD | localhost:3306 | `myuser` / `secret` |

---

## 📖 Comandos Esenciales

```bash
# Ver logs (diagnóstico)
docker compose logs -f adopciones-app

# Detener todo
docker compose down

# Reiniciar después de cambios de código
./mvnw clean package -DskipTests && docker compose up -d --build

# Conectar a MySQL
docker exec -it adopciones-mysql mysql -u myuser -psecret -D adopciones_db
```

---

## 🆘 Si Algo Falla

1. **Puerto 8090 en uso:** `docker compose down -v`
2. **MySQL no responde:** Espera 30 seg más, luego: `docker compose logs mysql`
3. **mvnw falla:** En Linux: `chmod +x mvnw`, luego `./mvnw ...`

---

## 📚 Para Más Info

👉 **[Abre SETUP.md](SETUP.md)** para:
- Instalación paso a paso
- Troubleshooting detallado  
- Configuración de Jenkins (CI/CD)
- Explicación completa de cada servicio

---

**¡Eso es! Ya está funcionando. ¡A desarrollar! 🚀**


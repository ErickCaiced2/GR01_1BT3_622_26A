# 🏗️ Arquitectura del Sistema

## 📊 Diagrama de Flujo Completo

```
┌──────────────────────────────────────────────────────────────────┐
│                    TU MÁQUINA (Laptop)                           │
│                    Windows / macOS / Linux                       │
└──────────────────────────────────────────────────────────────────┘
                              │
                              │
                ┌─────────────┴──────────────┐
                │                            │
                ▼                            ▼
        ┌───────────────┐         ┌──────────────────┐
        │ Docker Desktop│         │   Git / IDE      │
        │ (Con WSL 2)   │         │   Tu código      │
        └───────────────┘         └──────────────────┘
                │                            │
                │ Ejecuta contenedores       │
                │ Linux virtuales            │ Editas y haces push
                │                            │
                ▼                            ▼
        ┌──────────────────────────────────────┐
        │  DOCKER COMPOSE                      │
        │  (Orquestador de servicios)          │
        │                                      │
        │  compose.yaml ← Lee configuración   │
        │      │                               │
        │      ├─ Crea Red Interna            │
        │      ├─ Levanta MySQL               │
        │      └─ Levanta Spring Boot App     │
        └──────────────────────────────────────┘
            │                          │
            ▼                          ▼
        ┌──────────────┐    ┌──────────────────────┐
        │  MYSQL 8.0   │    │  SPRING BOOT APP     │
        │  (Contenedor)│    │  (Contenedor)        │
        │              │    │                      │
        │ :3306        │    │ :8090                │
        │              │    │                      │
        │ Volumen:     │    │ Conecta a:           │
        │ mysql_data   │    │ adopciones-mysql:    │
        │              │    │ 3306                 │
        │ Inicia con:  │    │                      │
        │ 01-schema.   │    │ Variables de Entorno:│
        │ sql (auto)   │    │ DATASOURCE_URL       │
        │              │    │ DATASOURCE_USERNAME  │
        │ Crea tablas: │    │ DATASOURCE_PASSWORD  │
        │ usuario      │    │                      │
        │ mascota      │    │ WAR: Que compiló     │
        │ solicitud    │    │ Maven desde src/     │
        │ adopcion     │    └──────────────────────┘
        │ foto         │            │
        └──────────────┘            │
                │                    │
                │                    ▼
                │        ┌──────────────────┐
                │        │  TU NAVEGADOR    │
                │        │                  │
                │        │ http://loc...    │
                │        │ :8090            │
                │        │                  │
                │        │ Usuario interactúa
                │        │ con interfaz JSP │
                │        └──────────────────┘
                │                    │
                └────────────────────┘
                 Solicitudes a BD
                 (JPA + Spring Data)
```

---

## 🔄 Flujo de Compilación y Despliegue

```
[1] Haces push a GitHub
    │
    ▼
[2] Jenkins detecta cambios (webhook)
    │
    ├─ git clone (descarga código)
    │
    ├─ ./mvnw clean package (Maven compila)
    │  └─ target/*.war ← Artefacto compilado
    │
    ├─ docker compose down (limpia previos)
    │
    ├─ docker compose up -d
    │  ├─ MySQL inicia
    │  │  ├─ 01-schema.sql se ejecuta
    │  │  └─ Tablas creadas
    │  │
    │  ├─ App construida desde Dockerfile
    │  │  ├─ Lee target/*.war compilado
    │  │  ├─ Embebido en imagen Docker
    │  │  └─ Levanta en :8090
    │  │
    │  └─ Ambos conectados en red "adopciones-network"
    │
    └─ App lista en http://localhost:8090 ✅
```

---

## 📁 Flujo de Archivos

```
Tu carpeta del proyecto:
│
├── src/main/java/ ......................... 🔨 CÓDIGO FUENTE JAVA
│   └── com/example/gr01_1bt3_622_26a/
│       ├── controller/ ................... MVC (Rutas HTTP)
│       ├── entity/ ....................... Modelos (Mascota, Solicitud)
│       ├── repository/ ................... JPA (Acceso BD)
│       └── service/ ...................... Lógica de negocio
│
├── src/main/resources/
│   ├── 01-schema.sql ..................... 📋 CRÍTICO: Estructura BD
│   │                                      (Ejecutado automáticamente
│   │                                       por MySQL al iniciar)
│   │
│   ├── 02-data.sql ....................... 🌱 Datos de ejemplo
│   │                                      (Datos iniciales: usuarios,
│   │                                       mascotas, etc.)
│   │
│   └── application.properties ............ ⚙️  Config Spring Boot
│                                          (Puerto, BD, logging)
│
├── pom.xml ............................... 📚 DEPENDENCIAS
│   └── spring-boot-starter-*
│       mysql-connector
│       lombok
│       thymeleaf
│       etc.
│
├── Dockerfile ............................ 📦 RECETA IMAGEN DOCKER
│   ├─ FROM eclipse-temurin:21-jre
│   ├─ Copia target/*.war → app.war
│   ├─ Expone puerto 8090
│   └─ CMD: java -jar app.war
│
├── compose.yaml .......................... 🐳 ORQUESTACIÓN
│   ├─ mysql: image: mysql:8.0
│   │  └─ Monta ./src/main/resources/01-schema.sql
│   │
│   └─ app: build: Dockerfile
│      └─ Depende de mysql.service_healthy
│
└── mvnw / mvnw.cmd ....................... 🔨 Maven Wrapper
    (Descarga y ejecuta Maven sin instalarlo)
```

---

## 🔄 Ciclo de Desarrollo Típico

```
┌─────────────────────────────────────┐
│ 1️⃣  Editas código en IDE            │
│    (src/main/java/...)              │
└──────────────────┬──────────────────┘
                   │
                   ▼
┌─────────────────────────────────────┐
│ 2️⃣  Compilas con Maven              │
│    ./mvnw clean package -DskipTests │
│    └─ Genera: target/*.war          │
└──────────────────┬──────────────────┘
                   │
                   ▼
┌─────────────────────────────────────┐
│ 3️⃣  Reconstruyes imagen Docker      │
│    docker compose up -d --build     │
│    └─ Lee el WAR nuevo              │
│    └─ Crea imagen nueva             │
│    └─ Reinicia contenedor           │
└──────────────────┬──────────────────┘
                   │
                   ▼
┌─────────────────────────────────────┐
│ 4️⃣  Vuelve a compilarse en Docker   │
│    y se reinicia automáticamente    │
│    (Espera ~30 segundos)            │
└──────────────────┬──────────────────┘
                   │
                   ▼
┌─────────────────────────────────────┐
│ ✅ Cambios listos en :8090          │
│    Verifica con: docker compose    │
│    logs -f adopciones-app           │
└─────────────────────────────────────┘
```

---

## 🔌 Conexiones Internas (Red Docker)

```
┌─────────────────────────────────────────────────┐
│  Red: adopciones-network (bridge)               │
│                                                 │
│  ┌──────────────────┐  ┌────────────────────┐  │
│  │  adopciones-mysql│  │ adopciones-app     │  │
│  │  (host: mysql)   │  │ (Spring Boot)      │  │
│  │                  │  │                    │  │
│  │ IP: 172.xx.x.x   │  │ IP: 172.xx.x.y    │  │
│  │ Puerto interno: 3306  │ Puerto interno: 8090│  │
│  │                  │  │                    │  │
│  │ Accesible como:  │  │ Accesible como:    │  │
│  │ adopciones-mysql │  │ adopciones-app     │  │
│  │ (via DNS Docker) │  │ (via DNS Docker)   │  │
│  └────────────┬─────┘  └────────────┬───────┘  │
│               │                     │          │
│               └─────────────────────┘          │
│                                                 │
│  La app conecta a MySQL usando:                │
│  SPRING_DATASOURCE_URL=                        │
│  jdbc:mysql://adopciones-mysql:3306/...       │
│             ╰─ Nombre del servicio en compose │
└─────────────────────────────────────────────────┘
```

---

## 📊 Tabla: Quién es Responsable de Qué

| Componente | Responsabilidad | Ubicación |
|-----------|----------------|-----------|
| **Git** | Descargar código | Tu máquina |
| **Maven (mvnw)** | Compilar Java → WAR | Tu máquina |
| **Docker Desktop** | Virtualizar Linux | Tu máquina |
| **Docker Compose** | Orquestar servicios | Lo ejecutas en terminal |
| **Dockerfile** | Definir imagen Docker | `./Dockerfile` |
| **MySQL** | Almacenar datos | Contenedor Linux |
| **01-schema.sql** | Crear estructura BD | Ejecutado por MySQL auto |
| **Spring Boot** | API + Web | Contenedor Linux |
| **JSP Templates** | Frontend (vistas) | archivo `.html/.jsp` en app |

---

## 🚀 Resumen: Por Qué Funciona Todo Junto

1. **Maven** → Compila Java → Genera WAR ejecutable
2. **Dockerfile** → Empaqueta WAR en imagen Linux
3. **Docker Compose** → Levanta MySQL + App conectados
4. **MySQL** → Auto-ejecuta SQL scripts al iniciar
5. **Spring Boot** → Se conecta automáticamente a MySQL
6. **Red Docker** → Servicios se comunican por DNS

= **Todos los pasos automatizados** = **Reproducible en cualquier máquina** ✅

---

## 🎯 Lo Importante

- **No necesitas instalar MySQL** → Corre en contenedor
- **No necesitas instalar Java localmente** → La app corre en contenedor  
- **No necesitas configurar manualmente nada** → Todo en archivos (compose.yaml, etc.)
- **Solo necesitas:** Docker + Git + Código

= **Setup reproducible en 5 minutos en cualquier máquina** 🚀


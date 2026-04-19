# Sistema de Adopciones - GR02_1BT3_622_26A

Una aplicación Spring Boot para gestionar el proceso de adopción de mascotas.

## Requisitos

- Java 17 o superior
- Maven 3.6+
- Docker y Docker Compose (opcional)
- MySQL 8.0 (o usar Docker)

## Instalación

### 1. Clonar el repositorio

```bash
git clone https://github.com/tuusuario/SistemaDeAdopciones.git
cd SistemaDeAdopciones/GR02_1BT3_622_26A
```

### 2. Configurar la base de datos

#### Opción A: Usar Docker Compose (Recomendado)

```bash
docker-compose up -d
```

#### Opción B: MySQL local

Crea una base de datos manualmente:

```sql
CREATE DATABASE adopciones_db;
CREATE USER 'myuser'@'localhost' IDENTIFIED BY 'secret';
GRANT ALL PRIVILEGES ON adopciones_db.* TO 'myuser'@'localhost';
FLUSH PRIVILEGES;
```

### 3. Compilar y ejecutar

```bash
# Compilar
mvn clean install

# Ejecutar
mvn spring-boot:run
```

La aplicación estará disponible en `http://localhost:8080`

## Estructura del Proyecto

```
GR02_1BT3_622_26A/
├── src/
│   ├── main/
│   │   ├── java/com/example/gr02_1bt3_622_26a/
│   │   └── resources/
│   │       ├── application.properties
│   │       ├── graphql-client/
│   │       ├── static/
│   │       └── templates/
│   └── test/
├── pom.xml
├── compose.yaml
├── .env
└── mvnw
```

## Tecnologías Utilizadas

- **Spring Boot 4.0.5**
- **Spring Data JPA**
- **Spring Web**
- **MySQL Connector**
- **Project Lombok**
- **Spring Modulith**

## Configuración

Edita `src/main/resources/application.properties` para personalizar:
- Puerto del servidor
- Credenciales de la base de datos
- Niveles de logging

## Detener Docker Compose

```bash
docker-compose down
```

Para eliminar volúmenes también:

```bash
docker-compose down -v
```

## Licencia

Este proyecto es parte del trabajo educativo GR02_1BT3_622_26A.


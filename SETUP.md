# Guía de configuración del entorno — Sistema de Adopciones

## Requisitos previos

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado y corriendo
- Git

---

## 1. Clonar el repositorio

```bash
git clone https://github.com/ErickCaiced2/GR01_1BT3_622_26A.git
cd GR01_1BT3_622_26A
```

---

## 2. Crear la red compartida de Docker

Ambos contenedores (MySQL y Jenkins) deben estar en la misma red para que puedan comunicarse por nombre de host.

```bash
docker network create adopciones-network
```

---

## 3. Levantar el contenedor de MySQL

```bash
docker run -d \
  --name mysql-adopciones \
  --network adopciones-network \
  -e MYSQL_ROOT_PASSWORD=1234 \
  -e MYSQL_DATABASE=sistema_adopciones \
  -p 3306:3306 \
  mysql:8.0
```

Verificar que está corriendo:

```bash
docker ps
```

Esperar unos segundos hasta que MySQL esté listo (se puede verificar con):

```bash
docker exec mysql-adopciones mysqladmin ping -h localhost -u root -p1234
```

---

## 4. Levantar el contenedor de Jenkins

```bash
docker run -d \
  --name jenkins \
  --network adopciones-network \
  -p 8080:8080 \
  -p 8090:8090 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts
```

- Puerto **8080**: Interfaz web de Jenkins
- Puerto **8090**: Aplicación Spring Boot (lanzada desde Jenkins)
- Puerto **50000**: Comunicación con agentes Jenkins

---

## 5. Configurar Jenkins

### 5.1 Acceder a Jenkins

Abrir el navegador en: **http://localhost:8080**

Obtener la contraseña inicial:

```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

### 5.2 Crear el pipeline

1. Ir a **Nueva tarea → Proyecto de estilo libre**
2. Nombrar el job, por ejemplo: `EjecucionSistemaAdopciones`
3. En **Gestión del código fuente → Git**, poner la URL del repositorio:
   ```
   https://github.com/ErickCaiced2/GR01_1BT3_622_26A.git
   ```
4. En **Pasos de construcción → Ejecutar shell**, pegar el siguiente comando:

```bash
java -Dspring.datasource.url=jdbc:mysql://mysql-adopciones:3306/sistema_adopciones \
     -Dspring.datasource.username=root \
     -Dspring.datasource.password=1234 \
     -Dserver.port=8090 \
     -jar target/GR01_1BT3_622_26A-0.0.1-SNAPSHOT.jar &
```

> El `&` al final es importante — hace que la app corra en segundo plano y Jenkins pueda marcar el build como exitoso.

5. Guardar y ejecutar el build.

---

## 6. Verificar que todo funciona

| Servicio       | URL                          |
|----------------|------------------------------|
| Jenkins        | http://localhost:8080        |
| Aplicación web | http://localhost:8090        |
| MySQL          | localhost:3306               |

---

## 7. Estructura de contenedores

```
adopciones-network
├── mysql-adopciones  (mysql:8.0)        → puerto 3306
└── jenkins           (jenkins:lts)      → puertos 8080, 8090, 50000
```

---

## Notas importantes

- El JAR (`target/GR01_1BT3_622_26A-0.0.1-SNAPSHOT.jar`) debe estar incluido en el repositorio o compilarse antes de ejecutar el pipeline.
- Si los contenedores se eliminan y se recrean, volver a conectarlos a la red:
  ```bash
  docker network connect adopciones-network mysql-adopciones
  docker network connect adopciones-network jenkins
  ```
- El volumen `jenkins_home` persiste la configuración de Jenkins entre reinicios. No eliminar ese volumen a menos que se quiera resetear Jenkins.

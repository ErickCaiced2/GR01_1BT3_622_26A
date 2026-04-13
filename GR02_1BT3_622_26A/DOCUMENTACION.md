# Sistema de Adopciones - Documentación Completa

Una aplicación web moderna para gestionar el proceso de adopción de mascotas. Desarrollada con **Spring Boot 4.0.5**, **JSP**, **Hibernate/JPA** y **MySQL**.

## 📋 Contenido

- [Requisitos](#requisitos)
- [Instalación](#instalación)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Características](#características)
- [Entidades](#entidades)
- [Controladores](#controladores)
- [Vistas](#vistas)
- [API REST](#api-rest)
- [Uso](#uso)

## 🔧 Requisitos

- **Java 17+**
- **Maven 3.6+**
- **MySQL 8.0+**
- **Docker y Docker Compose** (opcional)

## 🚀 Instalación

### 1. Clonar el Repositorio

```bash
git clone https://github.com/tuusuario/SistemaDeAdopciones.git
cd SistemaDeAdopciones/GR02_1BT3_622_26A
```

### 2. Configurar la Base de Datos

#### Opción A: Docker Compose (Recomendado)

```bash
docker-compose up -d
```

#### Opción B: MySQL Local

```sql
CREATE DATABASE adopciones_db;
CREATE USER 'myuser'@'localhost' IDENTIFIED BY 'secret';
GRANT ALL PRIVILEGES ON adopciones_db.* TO 'myuser'@'localhost';
FLUSH PRIVILEGES;
```

### 3. Compilar el Proyecto

```bash
mvn clean install
```

### 4. Ejecutar la Aplicación

```bash
# Opción A: Con Spring Boot
mvn spring-boot:run

# Opción B: Ejecutar el JAR compilado
java -jar target/GR02_1BT3_622_26A-0.0.1-SNAPSHOT.jar
```

La aplicación estará disponible en: `http://localhost:8080`

## 📁 Estructura del Proyecto

```
src/
├── main/
│   ├── java/com/example/gr02_1bt3_622_26a/
│   │   ├── entity/
│   │   │   ├── Mascota.java          # Entidad principal
│   │   │   └── Foto.java             # Entidad para fotos
│   │   │
│   │   ├── repository/
│   │   │   ├── MascotaRepository.java # CRUD y queries
│   │   │   └── FotoRepository.java    # CRUD para fotos
│   │   │
│   │   ├── service/
│   │   │   └── MascotaService.java   # Lógica de negocio
│   │   │
│   │   ├── controller/
│   │   │   ├── HomeController.java    # Controlador de inicio
│   │   │   └── MascotaController.java # Controlador de mascotas
│   │   │
│   │   └── Gr021Bt362226AApplication.java # Aplicación principal
│   │
│   └── resources/
│       ├── application.properties     # Configuración
│       ├── application-dev.properties # Configuración desarrollo
│       └── templates/
│           ├── index.jsp              # Página de inicio
│           └── mascotas/
│               ├── formularioRegistroMascota.jsp
│               ├── formularioEditarMascota.jsp
│               ├── listaMascotas.jsp
│               ├── listaMascotasDisponibles.jsp
│               ├── detalleMascota.jsp
│               ├── resultadosBusqueda.jsp
│               └── layout.jsp
│
└── test/
    └── java/...
```

## ✨ Características

### 1. **Gestión Completa de Mascotas**
   - Registrar nuevas mascotas
   - Editar información de mascotas
   - Eliminar mascotas
   - Ver lista de todas las mascotas
   - Ver mascotas disponibles
   - Cambiar estado de adopción

### 2. **Búsqueda y Filtros**
   - Búsqueda por nombre
   - Filtro por tipo (Perro, Gato, etc.)
   - Filtro por estado (Disponible, Adoptado, etc.)
   - Filtro por género

### 3. **Galería de Fotos**
   - Cargar fotos para cada mascota
   - Establecer foto principal
   - Visualizar galería

### 4. **Detalles Extensos**
   - Nombre, tipo, raza
   - Edad, género, color
   - Peso
   - Descripción detallada
   - Historial de registro

### 5. **Interfaz Responsiva**
   - Diseño moderno con Bootstrap 5
   - Totalmente responsiva
   - Compatible con dispositivos móviles
   - Iconos Font Awesome

## 📊 Entidades

### Mascota

```java
@Entity
@Table(name = "mascotas")
public class Mascota {
    Long id;                    // ID único
    String nombre;              // Nombre de la mascota
    String tipo;                // Tipo (Perro, Gato, etc.)
    String raza;                // Raza
    Integer edad;               // Edad en años
    String genero;              // Macho/Hembra
    String color;               // Color
    Double pesoKg;              // Peso en kg
    String descripcion;         // Descripción
    LocalDate fechaRegistro;    // Fecha de registro
    String estado;              // Estado (Disponible, Adoptado, etc.)
    List<Foto> fotos;          // Fotos asociadas
}
```

### Foto

```java
@Entity
@Table(name = "fotos")
public class Foto {
    Long id;                    // ID único
    String rutaFoto;            // Ruta del archivo
    String nombreArchivo;       // Nombre del archivo
    String descripcion;         // Descripción
    Boolean esPrincipal;        // Es foto principal
    Mascota mascota;            // Mascota asociada
}
```

## 🎮 Controladores

### HomeController
- `GET /` - Página de inicio

### MascotaController
- `GET /mascotas/lista` - Lista todas las mascotas
- `GET /mascotas/disponibles` - Mascotas disponibles
- `GET /mascotas/registrar` - Formulario de registro
- `POST /mascotas/registrar` - Registrar nueva mascota
- `GET /mascotas/detalle/{id}` - Ver detalle
- `GET /mascotas/editar/{id}` - Formulario de edición
- `POST /mascotas/actualizar/{id}` - Actualizar mascota
- `POST /mascotas/eliminar/{id}` - Eliminar mascota
- `GET /mascotas/buscar?nombre=X` - Buscar mascota
- `POST /mascotas/cargarFoto/{id}` - Subir foto

## 🎨 Vistas (JSP)

| Vista | Descripción |
|-------|------------|
| `index.jsp` | Página de inicio con hero section |
| `formularioRegistroMascota.jsp` | Formulario para registrar mascota |
| `formularioEditarMascota.jsp` | Formulario para editar mascota |
| `listaMascotas.jsp` | Grid de todas las mascotas |
| `listaMascotasDisponibles.jsp` | Grid de mascotas disponibles |
| `detalleMascota.jsp` | Detalle completo con galería |
| `resultadosBusqueda.jsp` | Resultados de búsqueda |

## 📡 Servicios

### MascotaService
- `registrarMascota()` - Registrar nueva mascota
- `obtenerTodasLasMascotas()` - Obtener lista completa
- `obtenerMascotasDisponibles()` - Mascotas disponibles
- `obtenerMascotaPorId()` - Obtener por ID
- `actualizarMascota()` - Actualizar datos
- `eliminarMascota()` - Eliminar mascota
- `buscarPorNombre()` - Búsqueda por nombre
- `obtenerPorTipo()` - Filtrar por tipo
- `obtenerPorEstado()` - Filtrar por estado
- `cambiarEstado()` - Cambiar estado
- `agregarFoto()` - Agregar foto
- `obtenerFotosDeMascota()` - Obtener fotos

## 💾 Repositorios (Queries)

### MascotaRepository
```java
List<Mascota> findByEstado(String estado);
List<Mascota> findByTipo(String tipo);
List<Mascota> findMascotasDisponibles();
List<Mascota> buscarPorNombre(String nombre);
List<Mascota> findByGenero(String genero);
List<Mascota> findByRaza(String raza);
long countByEstado(String estado);
```

### FotoRepository
```java
List<Foto> findByMascotaId(Long mascotaId);
Optional<Foto> findFotoPrincipal(Long mascotaId);
long countByMascotaId(Long mascotaId);
```

## 🔍 Búsqueda y Filtros

### Búsqueda por Nombre
```
GET /mascotas/buscar?nombre=Buddy
```

### Filtros Disponibles
- Por Tipo: Acceso desde lista y repositorio
- Por Estado: Disponible, Adoptado, En proceso
- Por Género: Macho, Hembra

## 📱 Características Responsivas

- Navbar colapsable
- Grid adaptable para móvil
- Formularios optimizados
- Galerías responsive
- Botones táctiles

## 🔐 Validación

### Frontend
- Validación HTML5
- Validación JavaScript Bootstrap
- Previsualizaciones en formularios

### Backend
```java
@NotBlank(message = "El nombre es requerido")
@Size(min = 2, max = 100)
@Min(value = 0)
@Max(value = 50)
```

## 📸 Carga de Archivos

- Formato: Imágenes (jpg, png, gif)
- Tamaño máximo: 10MB
- Directorio: `uploads/fotos/`
- Nombres únicos con timestamp

## 🎯 Casos de Uso Implementados

Según el diagrama UCS:

1. **Registrar Mascota**
   - Actor: Administrador
   - Proceso: Formulario → Validación → Registro

2. **Ver Lista de Mascotas**
   - Actor: Usuario General
   - Proceso: Visualizar grid con todas las mascotas

3. **Ver Detalle de Mascota**
   - Actor: Usuario General
   - Proceso: Ver información completa y galería

4. **Búsqueda**
   - Actor: Usuario General
   - Proceso: Buscar por nombre

5. **Editar Mascota**
   - Actor: Administrador
   - Proceso: Cambiar datos de mascota

6. **Eliminar Mascota**
   - Actor: Administrador
   - Proceso: Remover mascota del sistema

7. **Cargar Fotos**
   - Actor: Administrador
   - Proceso: Subir imágenes de mascota

## 🚨 Manejo de Errores

- Validación de formularios
- Mensajes de error claros
- Redirección inteligente
- Logging detallado
- Transacciones seguras

## 📝 Logging

```properties
logging.level.root=INFO
logging.level.com.example.gr02_1bt3_622_26a=DEBUG
logging.level.org.hibernate=INFO
```

## 🔄 Próximas Mejoras

- [ ] Sistema de usuarios y autenticación
- [ ] Panel de administración
- [ ] Reportes estadísticos
- [ ] Notificaciones por email
- [ ] Seguimiento de adopciones
- [ ] Sistema de calificaciones
- [ ] API REST completa

## 📞 Soporte

Para preguntas o problemas, por favor abre un issue en el repositorio.

## 📄 Licencia

Proyecto educativo - GR02_1BT3_622_26A (2026)

---

**Última actualización:** 12 de Abril, 2026
**Estado:** ✅ Producción


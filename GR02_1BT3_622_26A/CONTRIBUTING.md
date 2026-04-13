# Guía de Contribución

## Configuración del Entorno de Desarrollo

### Requisitos Previos

1. **Java 17+**
   ```bash
   java -version
   ```

2. **Maven 3.6+**
   ```bash
   mvn -version
   ```

3. **Docker y Docker Compose**
   ```bash
   docker --version
   docker-compose --version
   ```

### Paso 1: Clonar el Repositorio

```bash
git clone https://github.com/tuusuario/SistemaDeAdopciones.git
cd SistemaDeAdopciones/GR02_1BT3_622_26A
```

### Paso 2: Crear Rama de Desarrollo

```bash
git checkout -b feature/tu-caracteristica
```

### Paso 3: Iniciar la Base de Datos

```bash
# Opción A: Docker (Recomendado)
docker-compose up -d

# Opción B: MySQL local
# Importar el archivo schema.sql en tu base de datos MySQL
```

### Paso 4: Ejecutar el Proyecto

```bash
mvn spring-boot:run
```

### Paso 5: Ejecutar Tests

```bash
mvn test
```

## Estándares de Código

- Usar convención de nombres: camelCase para variables/métodos, PascalCase para clases
- Máximo 120 caracteres por línea
- Usar Project Lombok para reducir código boilerplate
- Documentar métodos públicos con JavaDoc

## Estructura de Commits

```
[TIPO] Descripción breve

Descripción más detallada si es necesario.

Fixes #123
```

Tipos válidos:
- `feat:` Nueva característica
- `fix:` Corrección de error
- `docs:` Cambios en documentación
- `refactor:` Refactorización de código
- `test:` Adición o modificación de tests

## Ejemplo

```
feat: Agregar modelo de Usuario

- Crear entidad User con validaciones
- Implementar repositorio UserRepository
- Agregar tests unitarios
```

## Before Submitting a Pull Request

1. ✅ Asegurar que todos los tests pasan
2. ✅ Ejecutar `mvn clean install`
3. ✅ Verificar el código con los estándares del proyecto
4. ✅ Actualizar la documentación si es necesario
5. ✅ Rebasar con la rama main

## Preguntas o Problemas

Abre un issue en GitHub describiendo el problema y proporcionando:
- Versión de Java
- Versión del SO
- Pasos para reproducir el problema
- Logs de error


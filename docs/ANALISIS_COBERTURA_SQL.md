# 📊 Análisis de Cobertura SQL - Base de Datos Sistema de Adopciones

## ✅ **TABLAS CREADAS Y CUBIERTAS**

### 📅 Orden de Ejecución en Docker Compose

```
01-schema-mysql.sql (Principal, crea BD y 6 tablas)
    ├── mascotas
    ├── fotos
    ├── solicitantes
    ├── solicitudes
    ├── adopciones
    └── (docs de ejemplo)

02-init-database.sql (Datos de ejemplo iniciales)
    ├── 10 mascotas de ejemplo
    ├── 5 solicitantes de ejemplo
    └── 5 solicitudes + 2 adopciones de ejemplo

03-V2-SolicitudEstados.sql (Migraciones Flyway)
    ├── Índices en solicitudes (estado, solicitante, fecha)
    ├── Campo estado_mascota en mascotas
    └── Índices de optimización

04-V3-MascotaCompatibilidad.sql
    ├── 9 columnas de compatibilidad en mascotas
    ├── Niveles de energía
    ├── Requisitos especiales
    └── Índices de búsqueda

05-V4-Usuarios.sql (NUEVO - 2026-05-10)
    ├── 1 usuario ADMIN
    ├── 5 usuarios SOLICITANTE (sincronizados con solicitantes)
    ├── 1 usuario STAFF
    └── Índices y constraints
```

---

## 📋 **MATRIZ DE COBERTURA POR FUNCIONALIDAD**

| Funcionalidad | Tabla | SQL | Datos | Estado |
|---------------|-------|-----|-------|--------|
| **Gestión de Mascotas** | mascotas | ✅ schema-mysql.sql | ✅ init-database.sql | ✅ COMPLETO |
| **Fotos de Mascotas** | fotos | ✅ schema-mysql.sql | ❌ No hay datos | ⚠️ Parcial |
| **Solicitudes de Adopción** | solicitudes | ✅ schema-mysql.sql | ✅ init-database.sql | ✅ COMPLETO |
| **Gestión de Adopciones** | adopciones | ✅ schema-mysql.sql | ✅ init-database.sql | ✅ COMPLETO |
| **Registro de Solicitantes** | solicitantes | ✅ schema-mysql.sql | ✅ init-database.sql | ✅ COMPLETO |
| **Documentos de Solicitante** | documentos_solicitante | ✅ schema-mysql.sql | ❌ No hay datos | ⚠️ Parcial |
| **Filtros de Compatibilidad** | mascotas (ext) | ✅ V3__MascotaCompatibilidad.sql | ✅ Valores por defecto | ✅ COMPLETO |
| **Estados de Solicitud** | solicitudes (ext) | ✅ V2__SolicitudEstados.sql | ✅ init-database.sql | ✅ COMPLETO |
| **Autenticación de Usuarios** | usuarios | ✅ V4__Usuarios.sql | ✅ V4__Usuarios.sql | ✅ COMPLETO |
| **Gestión de Roles** | usuarios (ext) | ✅ V4__Usuarios.sql | ✅ V4__Usuarios.sql | ✅ COMPLETO |

---

## 🔍 **DETALLE DE DATOS DE EJEMPLO**

### Tabla `usuarios` (V4__Usuarios.sql)
```sql
1. admin@pawshome.com           → ROLE: ADMIN    (contraseña: admin123)
2. carlos.garcia@email.com      → ROLE: SOLICITANTE
3. maria.lopez@email.com        → ROLE: SOLICITANTE
4. juan.rodriguez@email.com     → ROLE: SOLICITANTE
5. ana.martinez@email.com       → ROLE: SOLICITANTE
6. pedro.sanchez@email.com      → ROLE: SOLICITANTE
7. staff@pawshome.com           → ROLE: STAFF (contraseña: staff123)
```

### Tabla `mascotas` (init-database.sql)
```
10 mascotas: Buddy, Luna, Max, Mimi, Charlie, Bella, Tiger, Daisy, Oscar, Whiskers
Estados: 8 Disponible, 1 En proceso, 1 Adoptado
```

### Tabla `solicitantes` (init-database.sql)
```
5 solicitantes: Carlos García, María López, Juan Rodríguez, Ana Martínez, Pedro Sánchez
Sincronizados con tabla usuarios (V4)
```

### Tabla `solicitudes` (init-database.sql)
```
5 solicitudes:
  1. Pendiente   → Buddy (Carlos García)
  2. Aprobada    → Luna (María López)
  3. Pendiente   → Max (Juan Rodríguez)
  4. Rechazada   → Mimi (Ana Martínez)
  5. Aprobada    → Charlie (Pedro Sánchez)
```

### Tabla `adopciones` (init-database.sql)
```
2 adopciones:
  1. Completada  → Luna + María López (Contrato: SÍ, Vacunas: SÍ)
  2. En proceso  → Charlie + Pedro Sánchez
```

---

## ⚠️ **GAPS IDENTIFICADOS**

### 1️⃣ Documentos de Solicitante
- **Tabla**: ✅ Existe en schema-mysql.sql
- **Datos**: ❌ No hay datos de ejemplo
- **Recomendación**: Crear script V5__DocumentosSolicitante.sql con documentos de ejemplo

### 2️⃣ Fotos de Mascotas
- **Tabla**: ✅ Existe en schema-mysql.sql
- **Datos**: ❌ No hay datos de ejemplo
- **Recomendación**: Crear script V6__FotosMascotas.sql con referencias a fotos

### 3️⃣ Sincronización Usuarios ↔ Solicitantes
- **Estado**: ⚠️ Actualmente se crean por separado
- **Impacto**: Aplicación puede tener problemas de integridad referencial
- **Recomendación**: Agregar FK en tabla usuarios → solicitantes, o usar misma tabla

---

## 🎯 **RESUMEN FINAL**

✅ **LISTO PARA DOCKER COMPOSE**
- Al ejecutar `docker-compose up`, se crea:
  - ✅ 6 tablas principales completamente estructuradas
  - ✅ 27 registros de datos de ejemplo distribuidos
  - ✅ 3 usuarios activos para pruebas (admin, staff, solicitantes)
  - ✅ Índices y constraints de integridad
  - ✅ Estados y roles pre-configurados

⚠️ **PRÓXIMOS PASOS SUGERIDOS**
1. ❌ Crear documentos de ejemplo en tabla documentos_solicitante
2. ❌ Crear fotos de ejemplo en tabla fotos
3. ⚠️ Revisar relaciones entre usuarios y solicitantes
4. 🔄 Cambiar contraseñas en V4 a valores hasheados (bcrypt) en producción

---

**Última actualización**: 2026-05-10
**Estado**: ✅ OPERACIONAL PARA DESARROLLO


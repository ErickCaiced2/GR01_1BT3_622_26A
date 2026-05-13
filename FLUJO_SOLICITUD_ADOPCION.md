# 🐾 Flujo de Solicitud de Adopción

## Resumen Ejecutivo

Se implementó un flujo completo de solicitud de adopción con las siguientes características:
- **Login de adoptante** → Redirige al índice con sesión activa
- **Formulario con mascota pre-seleccionada** → URL: `/solicitudes/formulario?mascotaId=27`
- **Persistencia en BD** → Datos guardados con estado "Pendiente"
- **Interfaz mejorada** → Diseño moderno y responsive para el detalle de solicitud

---

## 1️⃣ Login del Adoptante

### Flujo
```
1. Usuario hace login en /login
2. Credenciales se validan en UsuarioService
3. Se crea sesión HTTP con:
   - usuarioId
   - email
   - nombre
   - rol
   - solicitanteId (obtenido del email)
4. Redirige AUTOMÁTICAMENTE a:
   - SOLICITANTE → / (índice con sesión activa)
   - ADMIN → /admin/dashboard
   - STAFF → /admin/solicitudes/gestionar
```

### Cambios Realizados
- **LoginController**: Modificado método `redirigirSegunRol()` para que SOLICITANTE vaya a `/` en lugar de `/solicitudes/mis-solicitudes`

---

## 2️⃣ Formulario de Solicitud con Mascota Pre-seleccionada

### Flujo
```
URL: /solicitudes/formulario?mascotaId=27

SolicitudController.mostrarFormulario():
├─ Si mascotaId ≠ null:
│  ├─ Obtiene Mascota por ID
│  ├─ Muestra tarjeta de mascota (read-only)
│  ├─ Campo oculto (hidden) con mascota.id
│  └─ Usuario NO puede cambiar mascota
│
└─ Si mascotaId = null:
   ├─ Muestra lista de mascotas disponibles
   └─ Usuario puede elegir cualquiera
```

### Cambios Realizados
- **SolicitudController.mostrarFormulario()**: 
  - Agrega parámetro `@RequestParam(value = "mascotaId", required = false)`
  - Valida si mascota existe
  - Usa `form:hidden path="mascota.id"` para pre-llenar mascota

- **formularioSolicitud.jsp**:
  - Usa `c:choose` para mostrar tarjeta visual si hay pre-selección
  - Muestra foto (si existe), nombre, tipo, raza, edad, sexo, descripción
  - Campo oculto enviará automáticamente el ID

---

## 3️⃣ Persistencia de Datos en Base de Datos

### Flujo de Guardado
```
POST /solicitudes/crear

SolicitudController.crearSolicitud():
├─ Valida @Valid @ModelAttribute Solicitud
├─ Valida BindingResult (errores de validación)
├─ Obtiene solicitanteId de la SESIÓN HTTP
├─ Busca Solicitante y Mascota en BD
├─ Asocia ambos a la Solicitud
├─ Llama SolicitudService.crearSolicitud()
│
└─ SolicitudService.crearSolicitud():
   ├─ Valida que solicitante ≠ null
   ├─ NO asigna estado (se lo asigna @PrePersist)
   ├─ Guarda en BD con repository.save()
   ├─ Logs: ✅ "Solicitud creada... Estado: Pendiente"
   └─ Retorna solicitud guardada
```

### Estados Iniciales
- **Estado**: "Pendiente" (asignado en `@PrePersist`)
- **Fecha**: `LocalDateTime.now()` (asignada en `@PrePersist`)
- Otros campos: Completados por el formulario

### Cambios Realizados
- **Solicitud.java**: 
  - Removido `@NotBlank` del campo `estado` (se asigna automáticamente)
  - `@PrePersist` inicializa estado como "Pendiente" y fecha actual

- **SolicitudService.crearSolicitud()**: 
  - Removido `solicitud.setEstado(...)` para permitir que `@PrePersist` lo haga
  - Logging mejorado para mostrar estado en el log

- **SolicitudController.crearSolicitud()**:
  - Obtiene `solicitanteId` de sesión: `(Long) session.getAttribute("solicitanteId")`
  - Valida que el solicitante tenga sesión activa

---

## 4️⃣ Interfaz de Detalle de Solicitud (MEJORADO)

### Características Nuevas
✨ **Diseño Moderno**:
- Gradientes lineales (primario + secundario)
- Tarjetas (info-cards) con bordes coloreados
- Iconos por sección
- Layout grid responsive
- Animaciones hover

🎯 **Estructura de Secciones**:
1. **Estado** - Mostra badge + mensaje contextual
   - Pendiente: "siendo revisada"
   - Aprobada: "¡Felicidades!"
   - Rechazada: "contactanos"

2. **Mi Información** - Datos del solicitante en grid 2x2
   - Nombre, Email, Teléfono, Ciudad, Dirección

3. **Mascota Solicitada** - Datos de la mascota
   - Nombre, Tipo, Raza, Edad

4. **Detalles de Solicitud** - Información de la adopción
   - Fecha, Motivo, Mascotas que tiene, Tipo vivienda, Jardín

📱 **Responsive**:
- Desktop: full layout
- Mobile: columna única
- Grid de 2 columnas para información relacionada

❌ **Removido**:
- Botones "Aprobar" y "Rechazar" (solo para admin)
- Modal de rechazo (solo para admin)

### Cambios Realizados
- **detalleSolicitud.jsp**: 
  - Estilos completamente renovados
  - Estructura con `info-card` y `info-row`
  - Removidas todas las opciones de admin
  - Mensajes contextuales por estado
  - Botón "Volver al inicio"

---

## 🔄 Ciclo de Vida Completo

```
USUARIO FINAL (Adoptante)
│
├─► 1. Accede a /login
│   └─► Inicia sesión con email/password
│
├─► 2. POST /login/procesar
│   └─► Sistema autentica y crea sesión
│
├─► 3. Redirige a / (índice)
│   └─► Con sesión activa (solicitanteId, email, etc)
│
├─► 4. Accede a /solicitudes/formulario?mascotaId=27
│   └─► Precarga datos de mascota #27
│
├─► 5. Completa formulario
│   ├─ Motivo de adopción
│   ├─ Número de mascotas
│   ├─ Tipo de vivienda
│   └─ ¿Tiene jardín?
│
├─► 6. Envía POST /solicitudes/crear
│   └─► Sistema persiste en BD
│
└─► 7. Ve detalle en GET /solicitudes/{id}
    └─► Con estado "Pendiente"
```

---

## 📋 Flujos por Rol

### SOLICITANTE
- ✅ Login → Índice
- ✅ Ver mascotas disponibles
- ✅ Solicitar adopción (mascota pre-seleccionada)
- ✅ Ver detalle de solicitud
- ❌ Aprobar/Rechazar solicitudes

### ADMIN
- ✅ Login → Dashboard admin
- ✅ Ver todas las solicitudes
- ✅ Aprobar/Rechazar solicitudes
- ✅ Gestionar estados

---

## 🐛 Problemas Resueltos

| Problema | Solución |
|----------|----------|
| Validación de campo `estado` con @NotBlank | Removido @NotBlank, asignación en @PrePersist |
| `fmt:formatDate` no soporta LocalDateTime | Mostrar LocalDateTime directo (toString) |
| JSP en caché con código viejo | Limpiar `target/work` antes de reiniciar |
| Referencia a `usuario` en lugar de `solicitante` | Cambiar a `solicitud.solicitante` |
| Acceso admin en pantalla de solicitante | Removidos botones Aprobar/Rechazar |

---

## 🚀 Comandos de Ejecución

```bash
# 1. Limpiar caché y Java
Get-Process java -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
Remove-Item -Recurse -Force "C:\Users\admin\IdeaProjects\GR01_1BT3_622_26A\target\work" -ErrorAction SilentlyContinue

# 2. Compilar
cd C:\Users\admin\IdeaProjects\GR01_1BT3_622_26A
.\mvnw clean install -DskipTests

# 3. Ejecutar
java -jar target\GR01_1BT3_622_26A-0.0.1-SNAPSHOT.war
```

---

## ✅ Requisitos Cumplidos

- ✅ Login de adoptante redirige a índice
- ✅ Sesión activa se mantiene
- ✅ Mascota pre-seleccionada en formulario
- ✅ Usuario NO puede cambiar mascota
- ✅ Todos los datos se guardan en BD
- ✅ Estado inicial "Pendiente"
- ✅ Interfaz moderna y responsive
- ✅ Sin opciones de admin para solicitantes
- ✅ Fecha se muestra correctamente

---

## 📍 Ubicaciones Clave de Archivos

| Componente | Ruta |
|-----------|------|
| Login | `controller/LoginController.java` |
| Formulario | `controller/SolicitudController.java` + `formularioSolicitud.jsp` |
| Servicio | `service/SolicitudService.java` |
| Entidad | `entity/Solicitud.java` |
| Detalle | `detalleSolicitud.jsp` |
| Propiedades | `application.properties`, `application-dev.properties` |


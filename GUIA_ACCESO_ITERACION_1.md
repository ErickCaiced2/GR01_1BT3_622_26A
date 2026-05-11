# 🚀 GUÍA DE ACCESO - Funcionalidades Iteración 1

## 📍 Estado Actual (11/05/2026)

✅ **Login y Sesiones** → Funcional  
✅ **Gestión de Solicitudes** → Funcional  
✅ **Subida de Documentos** → ✨ RECIÉN IMPLEMENTADO  
⚠️ **Filtros de Compatibilidad** → NO Implementado (Próximo)

---

## 🔐 Credenciales de Prueba

### SOLICITANTE
```
Email: carlos.garcia@email.com
Contraseña: password123
Rol: SOLICITANTE
```

### ADMIN
```
Email: admin@pawshome.com
Contraseña: admin123
Rol: ADMIN
```

---

## 📋 FLUJO COMPLETO PARA SOLICITANTE

### 1️⃣ LOGIN
```
URL: http://localhost:8090/
Pasos:
  1. Ir a http://localhost:8090/
  2. Click en botón "Acceder"
  3. Seleccionar "Soy Solicitante"
  4. Ingresar email: carlos.garcia@email.com
  5. Ingresar password: password123
  6. Click "Iniciar Sesión"
  ✅ Redirige a: /solicitudes/mis-solicitudes
```

### 2️⃣ VER SOLICITUDES (Nueva Funcionalidad US.1 ✅)
```
URL: http://localhost:8090/solicitudes/mis-solicitudes
Qué ve:
  - Lista de sus solicitudes
  - Estado actual (En revisión / Aprobada / Rechazada / Cancelada)
  - Botones para ver detalles
  
Estados visibles:
  🟡 En revisión (amarillo)   - Admin está evaluando
  ✅ Aprobada (verde)          - Solicitud aceptada
  ❌ Rechazada (rojo)          - Solicitud denegada
  🔒 Cancelada (gris)          - Solicitud cancelada

Interacción:
  - Click en "Ver" para ver detalles de la solicitud
  - Ver fecha de solicitud
  - Ver mascota asociada
```

### 3️⃣ VER PERFIL
```
URL: http://localhost:8090/solicitantes/{id}
Cómo llegar:
  - Desde navbar: Ir a "Mi Perfil" (si está habilitado)
  - O navegar a: http://localhost:8090/solicitantes/1 (para ID=1)
  
Qué ve:
  - Información personal (email, teléfono, documento)
  - Información de residencia (dirección, ciudad)
  - Estado de cuenta (Activo/Inactivo)
  - 4 botones de acción
```

### 4️⃣ SUBIR DOCUMENTOS (Nueva Funcionalidad US.2 ✅)
```
URL: http://localhost:8090/solicitantes/{id}/documentos
Cómo llegar:
  1. Ir a /solicitudes/mis-solicitudes
  2. Ir a tu perfil
  3. Buscar botón amarillo "🖤 Subir Documentos"
  4. Click → Redirige a /solicitantes/{id}/documentos
  
Qué puede hacer:
  ✅ Drag & Drop de archivos
  ✅ Click en zona para seleccionar archivos
  ✅ Ver lista de documentos cargados
  ✅ Ver estado de verificación
  
Archivos soportados:
  - PNG (imágenes)
  - JPEG (imágenes)
  - PDF (documentos)
  
Límites:
  - Máximo 5 MB por archivo
  
Estados de verificación:
  🟡 Pendiente - Esperando revisión de admin
  ✅ Verificado - Admin aprobó el documento
  ❌ Rechazado - Admin rechazó, ver comentarios
```

### 5️⃣ VER MASCOTAS DISPONIBLES
```
URL: http://localhost:8090/mascotas/disponibles
Cómo llegar:
  1. Desde navbar → "Mascotas" → "Disponibles"
  2. O click en botón del perfil "Ver Mascotas para Adoptar"
  
Qué ve:
  - Grid de tarjetas con mascotas disponibles
  - Foto, nombre, tipo, edad de cada mascota
  - Botón "Ver Detalle"
  - Botón "Solicitar Adopción"
```

### 6️⃣ VER DETALLE DE MASCOTA
```
URL: http://localhost:8090/mascotas/detalle/{id}
Cómo llegar:
  - Click en "Ver Detalle" desde listado
  
Qué ve:
  - Información completa de la mascota
  - Foto principal
  - Descripción y diagnósticos
  - Gallería de fotos
  - Mascotas relacionadas sugeridas
  - Botón "Solicitar Adopción"
  
Botones disponibles:
  ✅ Solicitar Adopción (disponible si mascota está en estado "Disponible")
  ✅ Volver (regresa a listado)
  
NOTA: Botones "Editar" y "Eliminar" solo visibles para ADMIN
NOTA: Sección "Cargar foto" solo visible para ADMIN
```

### 7️⃣ CREAR SOLICITUD DE ADOPCIÓN
```
URL: http://localhost:8090/solicitudes/formulario?mascotaId={id}
Cómo llegar:
  1. Desde detalle de mascota → Click "❤️ Solicitar Adopción"
  2. O navegar a: /solicitudes/formulario?mascotaId=1
  
Qué completa:
  - Mascota: Pre-llenado (si viene con mascotaId)
  - Motivo de la solicitud
  - Información sobre vivienda
  - Número de mascotas que posee
  - Observaciones adicionales
  
Resultados:
  ✅ Exitoso → Redirige a /solicitudes/{id} con mensaje
  ❌ Error → Vuelve a formulario con mensaje de error
```

---

## 👨‍💼 FLUJO PARA ADMINISTRADOR

### 1️⃣ LOGIN ADMIN
```
URL: http://localhost:8090/
Pasos:
  1. Ir a http://localhost:8090/
  2. Click en "Acceder"
  3. Seleccionar "Soy Administrador"
  4. Ingresar email: admin@pawshome.com
  5. Ingresar password: admin123
  6. Click "Iniciar Sesión"
  ✅ Redirige a: /admin/dashboard
```

### 2️⃣ DASHBOARD ADMIN
```
URL: http://localhost:8090/admin/dashboard
Qué ve:
  - Resumen de métricas
  - Widget de solicitudes pendientes
  - Últimas solicitudes en estado "En revisión"
  - Botones para aprobar/rechazar directamente
```

### 3️⃣ GESTIONAR SOLICITUDES
```
URL: http://localhost:8090/admin/solicitudes/gestionar
Cómo llegar:
  - Desde dashboard → Sección "Solicitudes Pendientes"
  - O navegar directo a /admin/solicitudes/gestionar
  
Qué puede hacer:
  ✅ Ver lista de solicitudes por estado
  ✅ Filtrar por: En revisión / Aprobada / Rechazada / Cancelada
  ✅ Click en "Aprobar" → Abre modal
  ✅ Click en "Rechazar" → Abre modal para razón
  
Acciones:
  • Aprobar: 
    - Cambiarà solicitud a "Aprobada"
    - Bloqueará mascota para adopción
    - Rechazará automáticamente otras solicitudes de esa mascota
    - Enviará notificación al solicitante
    
  • Rechazar:
    - Pedirà razón (obligatoria)
    - Cambiará solicitud a "Rechazada"
    - Guardará motivo en BD
    - Enviará notificación al solicitante
```

### 4️⃣ REGISTRAR/EDITAR MASCOTAS
```
URL: http://localhost:8090/mascotas/registrar (Crear)
URL: http://localhost:8090/mascotas/editar/{id} (Editar)

Qué puede hacer:
  ✅ Crear nueva mascota
  ✅ Editar información existente
  ✅ Eliminar mascota
  ✅ Cargar fotos
  
Campos:
  - Nombre, Tipo, Raza
  - Edad, Peso, Color
  - Género
  - Descripción
  - Diagnósticos previos
  - Estado (Disponible, Adoptado, En proceso)
```

---

## 📊 COMPONENTES IMPLEMENTADOS EN ITERACIÓN 1

### ✅ IMPLEMENTADO (US.0 - Login)
**Ubicación**: `/login`, `/login/admin`, `/acceso`
- ✅ Formularios de login
- ✅ Validación de credenciales
- ✅ Sesiones HTTP (30 min timeout)
- ✅ Protección de rutas por rol
- ✅ Interceptor de autenticación

### ✅ IMPLEMENTADO (US.1 - Gestión de Estados)
**Ubicación**: `/solicitudes/`, `/admin/solicitudes/`
- ✅ Máquina de estados (En revisión → Aprobada/Rechazada)
- ✅ Validador de transiciones
- ✅ Endpoints REST para cambio de estado
- ✅ Interfaz web para admin
- ✅ Bloqueo automático de mascota
- ✅ Notificaciones de rechazo automático

### ✅ IMPLEMENTADO (US.2 - Documentos) - 50%
**Ubicación**: `/solicitantes/{id}/documentos`
- ✅ Interfaz drag & drop
- ✅ Validación MIME
- ✅ Validación de tamaño (5MB)
- ✅ Almacenamiento en servidor
- ✅ REST API para documentos
- ⚠️ Integración con vista (en progreso)
- ❌ Verificación de documentos por admin (T.2.7)

### ❌ NO IMPLEMENTADO (US.4 - Filtros)
**Ubicación**: `/mascotas/buscar-compatible`
- ❌ Vista de filtros
- ❌ AJAX de búsqueda
- ❌ Query de compatibilidad
- ❌ Lógica de filtrado

---

## 🔐 PROTECCIONES DE SEGURIDAD

### SOLICITANTE protegido de:
✅ Ver solicitudes de otros solicitantes
✅ Editar/eliminar mascotas (botones ocultos)
✅ Cargar fotos (sección oculta)
✅ Acceder a /admin/** (redirecciona a /acceso)

### ADMIN tiene acceso total a:
✅ Dashboard de métricas
✅ Todas las solicitudes
✅ Cambio de estados
✅ Gestión de mascotas
✅ Gestión de fotos

---

## 🐛 CAMBIOS REALIZADOS HOY (11/05/2026)

### Seguridad
✅ Protegidos endpoints de edición de mascotas
✅ Protegido endpoint de eliminación de mascotas
✅ Protegido endpoint de carga de fotos
✅ Botones ocultos en vista para no-admin

### Correcciones
✅ Fijo: Error 500 en `/solicitudes/mis-solicitudes`
   - Cambió `${solicitud.usuario.nombre}` → `${solicitud.solicitante.nombre}`

✅ Fijo: Error 404 en `/solicitantes/documentos`
   - Agregado endpoint GET `/solicitantes/{id}/documentos`
   - Protegida ruta para solo el solicitante propietario
   - Actualizado link en perfil

---

## 📞 PRÓXIMOS PASOS

### Corto Plazo (Crítico)
❌ Implementar filtros de compatibilidad (US.4)
⚠️ Completar verificación de documentos por admin (T.2.7)

### Mediano Plazo
❌ Implementar generación de contratos PDF (US.3)
⚠️ Mejorar vista de documentos con integración real

### Largo Plazo
❌ Integración WhatsApp (Iter. 2)
❌ Dashboard de métricas avanzadas (Iter. 2)

---

## ✅ CHECKLIST DE PRUEBA RÁPIDA

```
□ Login como solicitante funciona
□ Dashboard de solicitudes muestra estados correcto
□ Puedo acceder a subir documentos
□ Drag & drop de documentos funciona
□ No puedo ver botones de editar mascotas
□ No puedo cargar fotos en mascotas
□ Login como admin funciona
□ Admin puede cambiar estados de solicitudes
□ Admin puede registrar mascotas
```



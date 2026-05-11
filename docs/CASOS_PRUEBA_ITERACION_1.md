# 🧪 Casos de Prueba - Iteración 1: Trust & Legal Foundation

## 📋 Información General

| Aspecto | Detalle |
|--------|---------|
| **Release** | Paws & Home 1.0 |
| **Iteración** | 1 (Semanas 1-2) |
| **Objetivo** | Trust & Legal Foundation |
| **Duración Total** | 160 horas |
| **Fecha Inicio** | 2026-05-10 |
| **Fecha Fin Estimada** | 2026-05-24 |

---

## 🎯 Flujos de la Iteración

### **US.0** - Sistema de Login y Gestión de Sesiones
### **US.1** - Gestión de Estados de Solicitud
### **US.2** - Módulo de Documentación y Validación
### **US.3** - Generación de Contratos PDF
### **US.4** - Filtros de Compatibilidad

---

## 📌 US.0 - Sistema de Login y Gestión de Sesiones

### 🧪 CP.0.1 - Flujo Unificado de Login Inteligente (Solicitante y Admin)

#### **Descripción**
Un usuario ingresa sus credenciales en un único formulario de login. El sistema verifica el rol en la BD y redirige automáticamente:
- **SOLICITANTE** → `/solicitudes/mis-solicitudes`
- **ADMIN** → `/admin/dashboard`
- **STAFF** → `/admin/solicitudes/gestionar`

#### **Pasos de Ejecución**

| # | Paso | Acción | Resultado Esperado |
|----|------|--------|-------------------|
| 1 | Navegar a inicio | GET `/` | HTTP 200, página de inicio visible |
| 2 | Click en acceso | Click en botón "Acceder" o GET `/login` | HTTP 200, `/login` carga formulario único simple |
| 3 | Validación cliente - email vacío | Dejar email vacío + click submit | Validación client-side: "Email requerido" sin enviar request |
| 4 | Validación cliente - contraseña vacía | Llenar email, dejar contraseña vacía + submit | Validación client-side: "Contraseña requerida" sin enviar request |
| 5 | Login SOLICITANTE: email válido | Email: `carlos.garcia@email.com`, Contraseña: `password123` | HTTP 302 redirect a `/solicitudes/mis-solicitudes` |
| 6 | Verificar sesión solicitante | GET `/solicitudes/mis-solicitudes` | HTTP 200, contenido privado visible, sesión activa |
| 7 | Verificar rol en sesión | Inspeccionar parámetros | `usuarioId=X`, `email=carlos.garcia@email.com`, `rol=SOLICITANTE` |
| 8 | Logout | GET `/logout` | HTTP 302 redirect a `/login`, sesión invalidada |
| 9 | Login ADMIN: email válido | Email: `admin@pawshome.com`, Contraseña: `admin123` | HTTP 302 redirect a `/admin/dashboard` |
| 10 | Verificar sesión admin | GET `/admin/dashboard` | HTTP 200, dashboard con widgets de métricas visible, sesión activa |
| 11 | Verificar rol en sesión | Inspeccionar parámetros | `usuarioId=X`, `email=admin@pawshome.com`, `rol=ADMIN` |
| 12 | Login STAFF: email válido | Email: `staff@pawshome.com`, Contraseña: `staff123` | HTTP 302 redirect a `/admin/solicitudes/gestionar` |
| 13 | Verificar sesión staff | GET `/admin/solicitudes/gestionar` | HTTP 200, panel de gestión de solicitudes visible |

**Criterios de Aceptación**  
✅ Único formulario de login para todos los roles  
✅ Validación client-side de campos requeridos  
✅ POST `/login/procesar` redirige según rol automáticamente  
✅ SOLICITANTE → `/solicitudes/mis-solicitudes`  
✅ ADMIN → `/admin/dashboard`  
✅ STAFF → `/admin/solicitudes/gestionar`  
✅ Sesión HTTP se crea con 30 minutos de timeout  
✅ Cookie `JSESSIONID` con rol en atributos  
✅ Sin página intermedia de selección (`/acceso` eliminado)  

---

## 🧪 CP.0.2 - Errores de Autenticación y Manejo de Excepciones

#### **Descripción**
Se validan los casos de error: email no existe, contraseña incorrecta, demasiados intentos fallidos, y su manejo mediante mensajes y limitación de intentos.

#### **Pasos de Ejecución**

| # | Paso | Acción | Resultado Esperado |
|----|------|--------|-------------------|
| 1 | Email no existe en BD | Email: `noexiste@example.com`, Contraseña: `cualquiera` | HTTP 302 redirect a `/login` + flash message rojo: "Email no registrado" |
| 2 | Contraseña incorrecta | Email: `carlos.garcia@email.com`, Contraseña: `wrongpass` | HTTP 302 redirect a `/login` + flash message rojo: "Contraseña incorrecta" |
| 3 | Verificar contador de intentos fallidos | 2 POST fallidos al mismo email | BD registra: `intentos_fallidos = 2` |
| 4 | Bloqueo tras 5 intentos fallidos | 5 POST fallidos consecutivos al mismo email | HTTP 429 Too Many Requests + mensaje: "Cuenta bloqueada temporalmente (15 minutos)" |
| 5 | Desbloqueo automático | Esperar 15 minutos | POST `/login/procesar` al mismo email funciona normalmente |
| 6 | Reseteo de intentos tras login exitoso | Login correcto tras fallos previos | Campo `intentos_fallidos = 0` en BD, contador resetea |
| 7 | Log de intentos fallidos | Revisar logs en aplicación | Contiene: "WARN: Failed login attempt for [email] from IP [x.x.x.x]" |

**Criterios de Aceptación**  
✅ Mensajes de error claros y específicos  
✅ No exponer si email existe o no (por seguridad)  
✅ Bloqueo tras 5 intentos fallidos por 15 minutos  
✅ Contador se resetea tras login exitoso  
✅ Todos los intentos se registran en BD (audit trail)  
✅ HTTP 429 en caso de bloqueo  

---

## 🧪 CP.0.3 - Logout y Expiración de Sesión

#### **Descripción**
Un usuario autenticado cierra sesión manualmente, y después se verifica que la sesión expira correctamente tras 30 minutos de inactividad.

#### **Pasos de Ejecución**

| # | Paso | Acción | Resultado Esperado |
|----|------|--------|-------------------|
| 1 | Autenticarse | Login exitoso (ver CP.0.1, paso 5) | Sesión activa, usuario en `/solicitudes/mis-solicitudes` |
| 2 | Hacer logout | Click en botón "Cerrar Sesión" o GET `/logout` | HTTP 302 redirect a `/` (página de inicio) |
| 3 | Verificar sesión invalidada | GET `/solicitudes/mis-solicitudes` | HTTP 302 redirect a `/login` (sesión no válida) |
| 4 | Inspeccionar cookies | Abrir DevTools → Application → Cookies | Cookie de sesión (`JSESSIONID`) no existe o expirada |
| 5 | Esperar 31 minutos de inactividad | (Opcional: modificar timeout en config para test rápido a 5 min) | - |
| 6 | Intentar acceso tras expiración | GET `/solicitudes/**` después de timeout | HTTP 302 redirect a `/login` + sesión expirada |
| 7 | Verificar logging | Revisar logs | Contiene: "AUDIT: Logout exitoso para usuario [email]" |

**Criterios de Aceptación**  
✅ `/logout` invalida sesión inmediatamente  
✅ Redirect a `/` (homepage) tras logout  
✅ Rutas protegidas redirigen a `/login` cuando sesión expira  
✅ Timeout de sesión = 30 minutos de inactividad  
✅ Cookie se elimina o marca como expirada  
✅ Logs contienen eventos de logout  

---

## 🧪 CP.0.4 - Protección de Rutas y Control de Acceso por Rol

#### **Descripción**
Se verifican las restricciones de acceso a rutas públicas, privadas y administrativas según el estado de autenticación y rol del usuario.

#### **Pasos de Ejecución**

| # | Paso | Acción | Resultado Esperado |
|----|------|--------|-------------------|
| 1 | Sin sesión: GET `/` | Acceder a página de inicio | HTTP 200 (ruta pública) |
| 2 | Sin sesión: GET `/mascotas` | Acceder a listado de mascotas | HTTP 200 (ruta pública) |
| 3 | Sin sesión: GET `/solicitudes/crear` | Intentar crear solicitud | HTTP 302 redirect a `/login` (ruta privada) |
| 4 | Sin sesión: GET `/admin/dashboard` | Intentar acceder a admin | HTTP 302 redirect a `/login` (ruta admin) |
| 5 | Con sesión SOLICITANTE: GET `/admin/dashboard` | Solicitante intenta acceder admin | HTTP 403 Forbidden + mensaje: "No tienes permiso para acceder a esta sección" |
| 6 | Con sesión SOLICITANTE: GET `/solicitudes/mis-solicitudes` | Solicitante accede su área | HTTP 200 (rol autorizado) |
| 7 | Con sesión ADMIN: GET `/admin/dashboard` | Admin accede dashboard | HTTP 200 (rol autorizado) |
| 8 | Con sesión ADMIN: GET `/solicitudes/mis-solicitudes` (solicitante) | Admin accede área de solicitante | HTTP 200 (admin puede ver todo) |
| 9 | Recurso estático sin sesión: GET `/static/css/style.css` | Solicitar CSS o JavaScript | HTTP 200 sin redireccion (estático excluido de interceptor) |
| 10 | Verificar logging | Revisar logs de intentos no autorizados | Contiene: "WARN: Unauthorized attempt to /admin/dashboard from solicitante rol (IP: x.x.x.x)" |

**Criterios de Aceptación**  
✅ Rutas públicas (`/`, `/mascotas`) sin autenticación  
✅ Rutas privadas (`/solicitudes/**`) requieren login  
✅ Rutas admin (`/admin/**`) requieren rol ADMIN  
✅ Solicitante no puede acceder `/admin/**` (HTTP 403)  
✅ Admin puede acceder todas las áreas  
✅ Recursos estáticos (`/static/**`) no se bloquean  
✅ Todos los intentos no autorizados se registran en audit trail  
✅ Mensajes de error claros y consistentes  

---

## 📌 US.1 - Gestión de Estados de Solicitud

### 🧪 CP.1.1 - Transiciones Válidas de Estados

#### **Descripción**
Se verifica que todas las transiciones de estado válidas se ejecutan correctamente sin errores.

#### **Pasos de Ejecución**

| # | Paso | Acción | Resultado Esperado |
|----|------|--------|-------------------|
| 1 | Crear solicitud en estado "En revisión" | POST `/solicitudes/crear` con datos válidos | Solicitud creada con estado "En revisión" |
| 2 | Aprobar solicitud | POST `/solicitudes/1/aprobar` (admin autenticado) | HTTP 200, estado cambia a "Aprobada" en BD |
| 3 | Verificar estado en BD | SELECT estado FROM solicitudes WHERE id=1 | Resultado: `Aprobada` |
| 4 | Cancelar solicitud aprobada | POST `/solicitudes/1/cancelar` | HTTP 200, estado cambia a "Cancelada" |
| 5 | Crear otra solicitud | POST `/solicitudes/crear` | Nueva solicitud en "En revisión" |
| 6 | Rechazar solicitud | POST `/solicitudes/2/rechazar?razon=No+cumple+requisitos` | HTTP 200, estado "Rechazada", razon_rechazo guardada |
| 7 | Intentar cancelar rechazada | POST `/solicitudes/2/cancelar` | HTTP 200, estado "Cancelada" |

**Criterios de Aceptación**  
✅ Transición En revisión → Aprobada exitosa  
✅ Transición En revisión → Rechazada exitosa  
✅ Transición Aprobada/Rechazada → Cancelada exitosa  
✅ Parámetro `razon` se persiste en BD  
✅ Response contiene `timestamp`, `message`, `statusCode`  

---

## 🧪 CP.1.2 - Rechazo de Transiciones Inválidas

#### **Descripción**
Se verifica que transiciones de estado inválidas son rechazadas con mensajes de error claros.

#### **Pasos de Ejecución**

| # | Paso | Acción | Resultado Esperado |
|----|------|--------|-------------------|
| 1 | Crear solicitud en "Pendiente" | POST `/solicitudes/crear` | Solicitud en "Pendiente" |
| 2 | Intentar aprobar directo | POST `/solicitudes/1/aprobar` | HTTP 400, error: "Transición no permitida de Pendiente a Aprobada" |
| 3 | Verificar estado no cambió | SELECT estado FROM solicitudes WHERE id=1 | Sigue siendo "Pendiente" |
| 4 | Crear solicitud en "En revisión" | POST `/solicitudes/crear` | Nueva solicitud, estado "En revisión" |
| 5 | Aprobar | POST `/solicitudes/2/aprobar` | HTTP 200, estado "Aprobada" |
| 6 | Intentar aprobar de nuevo | POST `/solicitudes/2/aprobar` | HTTP 400, error: "Transición no permitida de Aprobada a Aprobada" |
| 7 | Verificar audit log | Revisar logs | Contiene: "AUDIT: Transición rechazada..." |

**Criterios de Aceptación**  
✅ Transiciones inválidas retornan HTTP 400  
✅ Mensaje de error describe claramente el problema  
✅ Estado en BD NO cambia en caso de error  
✅ Todos los rechazos se registran en audit trail  

---

## 🧪 CP.1.3 - Bloqueo de Mascota al Aprobar Solicitud

#### **Descripción**
Cuando una solicitud es aprobada, la mascota se bloquea para adopción y otras solicitudes pendientes se rechazan automáticamente.

#### **Pasos de Ejecución**

| # | Paso | Acción | Resultado Esperado |
|----|------|--------|-------------------|
| 1 | Crear mascota con estado "Disponible" | INSERT en BD o API | Mascota creada, estado_mascota = "Disponible" |
| 2 | Crear 3 solicitudes para la misma mascota | POST `/solicitudes/crear` x3 (usuarios diferentes) | 3 solicitudes en estado "En revisión" para mascota X |
| 3 | Aprobar primera solicitud | POST `/solicitudes/1/aprobar` | HTTP 200 |
| 4 | Verificar mascota bloqueada | SELECT estado_mascota FROM mascotas WHERE id=X | Resultado: `Bloqueada para adopción` |
| 5 | Verificar otras solicitudes rechazadas | SELECT estado FROM solicitudes WHERE mascota_id=X AND estado!='Aprobada' | 2 solicitudes con estado "Rechazada" |
| 6 | Verificar razón de rechazo | SELECT razon_rechazo FROM solicitudes WHERE id=2 | Contiene: "Mascota asignada a otro solicitante" |
| 7 | Verificar emails enviados | Revisar logs de email | 2 mails enviados a solicitantes rechazados |

**Criterios de Aceptación**  
✅ Mascota cambia a estado "Bloqueada para adopción"  
✅ Otras solicitudes se rechazan automáticamente  
✅ Razón de rechazo se guarda correcta  
✅ Notificaciones por email se envían  
✅ Solo una solicitud aprobada por mascota  

---

## 📌 US.2 - Módulo de Documentación y Validación

### 🧪 CP.2.1 - Flujo Completo de Carga de Documentos

#### **Descripción**
Un solicitante sube documentos de verificación (cédula, servicio básico) y el sistema los valida y almacena correctamente.

#### **Pasos de Ejecución**

| # | Paso | Acción | Resultado Esperado |
|----|------|--------|-------------------|
| 1 | Navigar a formulario de documentos | GET `/solicitantes/1/documentos` (autenticado) | HTTP 200, página con drop zone y lista de documentos |
| 2 | Validación cliente - tipo MIME inválido | Arrastrar archivo `.exe` a drop zone | Toast de error: "Tipo de archivo no permitido (solo PNG, JPEG, PDF)" |
| 3 | Validación cliente - archivo > 5MB | Intentar drag & drop archivo 10MB | Toast de error: "Archivo demasiado grande (máximo 5MB)" |
| 4 | Subir cédula válida (PNG 2MB) | Arrastrar `mi_cedula.png` a drop zone | Barra de progreso, descarga completa, toast success |
| 5 | Verificar documento en BD | SELECT * FROM documentos_solicitante WHERE solicitante_id=1 | Registro creado, estado_verificacion="Pendiente" |
| 6 | Verificar archivo en servidor | Revisar `/var/uploads/documentos/1/` | Archivo con nombre único (UUID) existe |
| 7 | Subir comprobante duplicado | Subir mismo archivo `mi_cedula.png` nuevamente | Hash duplicado detectado, excepción `DocumentoDuplicadoException` |
| 8 | Verificar lista actualizada | Página muestra documentos en tabla | 1 documento visible con badge "pending" |
| 9 | Subir 2do documento (PDF) | Arrastrar `recibo_servicios.pdf` | Progreso y success toast |
| 10 | Verificar 2 documentos en tabla | GET `/solicitantes/1/documentos` | 2 documentos listados con estados |

**Criterios de Aceptación**  
✅ Drop zone funciona en Chrome, Firefox, Safari  
✅ Validación MIME en cliente y servidor  
✅ Archivos guardados con UUID único  
✅ Duplicados detectados por hash SHA-256  
✅ Ruta persistida en BD correctamente  
✅ Lista se actualiza sin F5  
✅ Responsive en móvil  

---

## 🧪 CP.2.2 - Verificación de Documentos por Admin

#### **Descripción**
Un administrador accede al panel de documentos pendientes, verifica los documentos de un solicitante y marca como aprobados o rechazados con comentarios.

#### **Pasos de Ejecución**

| # | Paso | Acción | Resultado Esperado |
|----|------|--------|-------------------|
| 1 | Admin accede verificación | GET `/admin/documentos/pendientes` (admin autenticado) | HTTP 200, tabla con documentos estado "Pendiente" |
| 2 | Click en documento | Click en fila de documento cédula | Modal/panel con preview del PDF/imagen y botones |
| 3 | Rechazar con comentario | Click "Rechazar" + llenar comentario "Foto borrosa, reenviar" | HTTP 200, estado cambia a "Rechazada", comentario guardado |
| 4 | Verificar cambio en BD | SELECT estado_verificacion, comentarios_verificador FROM documentos_solicitante WHERE id=X | Estado="Rechazada", comentario visible |
| 5 | Verificar email al solicitante | Revisar logs/inbox test | Email enviado: "Tu documento ha sido rechazado. Motivo: Foto borrosa, reenviar" |
| 6 | Solicitante sube documento nuevo | Nuevo upload de cédula mejorada | Nuevo registro en BD |
| 7 | Admin verifica nuevo documento | Click "Verificar" + comentario "Aceptado" | HTTP 200, estado="Verificado", fecha_verificacion refrescada |
| 8 | Verificar email de aprobación | Revisar inbox test | Email: "Tu documento ha sido verificado correctamente" |

**Criterios de Aceptación**  
✅ Admin ve solo documentos en estado "Pendiente"  
✅ Transiciones: Pendiente → Verificado / Rechazada  
✅ Comentarios se guardan y envían por email  
✅ Solicitante recibe notificaciones  
✅ Audit trail registra verificador y timestamp  

---

## 📌 US.3 - Generación de Contratos PDF

### 🧪 CP.3.1 - Flujo de Descarga de Contrato PDF

#### **Descripción**
Un administrador genera y descarga el contrato PDF de una adopción completa con todos los datos del adoptante y mascota.

#### **Pasos de Ejecución**

| # | Paso | Acción | Resultado Esperado |
|----|------|--------|-------------------|
| 1 | Crear adopción completada | POST `/adopciones` con solicitud aprobada | Adopción creada, estado "En proceso" |
| 2 | Admin accede detalles de adopción | GET `/adopciones/1` (admin) | HTTP 200, botón "Descargar Contrato PDF" visible |
| 3 | Click en botón de descarga | Click "Descargar Contrato PDF" | Navegador descarga `contrato_adopcion_1.pdf` |
| 4 | Verificar headers HTTP | Inspeccionar Network tab | `Content-Type: application/pdf`, `Content-Disposition: attachment` |
| 5 | Abrir PDF descargado | Abrir en Adobe Reader o navegador | Contrato visible, profesional, todas las secciones presentes |
| 6 | Verificar datos interpolados | Revisar contenido del PDF | **Partes**: Nombre adoptante, cédula, refugio, nombre mascota (ej: "Firulais"), tipo (perro), raza, edad |
| 7 | Verificar caracteres españoles | Buscar en PDF por "María", "García", "Niño" | Rendering correcto de ñ, á, é, í, ó, ú |
| 8 | Verificar firmas y fechas | Revisar secciones finales | Espacios para firma vacíos, líneas de firma con `border-top`, fecha generada visible |
| 9 | Imprimir PDF | Ctrl+P / Cmd+P | Impresión se ve profesional, sin cortes |

**Criterios de Aceptación**  
✅ PDF se genera sin timeout  
✅ Nombre de archivo correcto: `contrato_adopcion_{id}.pdf`  
✅ Todos los datos del adoptante y mascota interpolados  
✅ Caracteres especiales españoles rendean correctamente  
✅ MIME type aplicación/pdf correcto  
✅ Formato profesional y legible  
✅ Espacios para firmas presentes  
✅ Solo admin/propietario puede descargar  

---

## 📌 US.4 - Filtros de Compatibilidad

### 🧪 CP.4.1 - Filtrado Completo de Mascotas por Compatibilidad

#### **Descripción**
Un usuario busca mascotas aplicando múltiples filtros de compatibilidad (niños, otros animales, tamaño, energía) y obtiene resultados personalizados.

#### **Pasos de Ejecución**

| # | Paso | Acción | Resultado Esperado |
|----|------|--------|-------------------|
| 1 | Acceder a página de filtros | GET `/mascotas/filtrar` | HTTP 200, formulario de filtros visible con dropdowns |
| 2 | Validación: sin filtros | Click "Buscar" sin seleccionar nada | Muestra todas las mascotas disponibles |
| 3 | Filtro simple: "¿Tienes niños?" | Seleccionar "Sí" + click Buscar | Página no recarga (AJAX), resultados actualizan con mascotas `compatible_ninos=true` |
| 4 | Múltiples filtros | Seleccionar: Niños=Sí, Nivel Energía=Media, Tamaño=Mediano | AJAX request con parámetros, resultados filtran por TODAS las condiciones |
| 5 | Resultados en cards | Verificar UI | Cada mascota en card: foto, nombre, tipo, raza, botón "Solicitar" |
| 6 | Botón "Solicitar Adopción" | Click en "Solicitar" de una mascota | Navega a `/solicitudes/crear?mascotaId=X` con prefill |
| 7 | Sin resultados | Aplicar filtros sin coincidencias (ej: hipoalergénico + energía alta) | Mensaje: "No se encontraron mascotas que coincidan con tus criterios" |
| 8 | Botón "Limpiar" | Seleccionar múltiples filtros → click "Limpiar" | Todos los dropdowns vuelven a "Cualquiera/vacío" |
| 9 | Responsive móvil | Abrir en iPhone (375px) | Filtros en columna única, resultados scrollable, clickeables |
| 10 | Performance | Ejecutar con 1000+ mascotas | Búsqueda responde en <500ms |

**Criterios de Aceptación**  
✅ Filtros sin F5 (AJAX)  
✅ Múltiples filtros funcionan combinados (AND logic)  
✅ Parámetros opcionales funcionan solos o combinados  
✅ Cards con foto/info de mascota  
✅ Solicitar adopción pre-llena mascota  
✅ Sin resultados muestra mensaje claro  
✅ Botón Limpiar resetea todos  
✅ Responsive 320px-1920px  
✅ Query < 500ms con índices  

---

## 📊 Resumen de Casos de Prueba (Consolidado)

| ID | User Story | Descripción | Pasos | Estado |
|----|-----------|-----------|-------|--------|
| **CP.0.1** | US.0 | Flujo Unificado de Login Inteligente | 13 pasos | ⏳ Pendiente |
| **CP.0.2** | US.0 | Errores de Autenticación y Bloqueos | 7 pasos | ⏳ Pendiente |
| **CP.0.3** | US.0 | Logout y Expiración de Sesión | 7 pasos | ⏳ Pendiente |
| **CP.0.4** | US.0 | Protección de Rutas y Control de Acceso | 10 pasos | ⏳ Pendiente |
| **CP.1.1** | US.1 | Transiciones Válidas | 7 pasos | ⏳ Pendiente |
| **CP.1.2** | US.1 | Rechazo de Transiciones Inválidas | 7 pasos | ⏳ Pendiente |
| **CP.1.3** | US.1 | Bloqueo de Mascota | 7 pasos | ⏳ Pendiente |
| **CP.2.1** | US.2 | Carga de Documentos | 10 pasos | ⏳ Pendiente |
| **CP.2.2** | US.2 | Verificación de Documentos | 8 pasos | ⏳ Pendiente |
| **CP.3.1** | US.3 | Descarga de Contrato PDF | 9 pasos | ⏳ Pendiente |
| **CP.4.1** | US.4 | Filtrado de Mascotas | 10 pasos | ⏳ Pendiente |
| **TOTAL ITERACIÓN 1** | - | **11 Casos Consolidados** | **101 pasos** | **0%** |

---

## 👤 Credenciales de Prueba

### ADMIN
```
Email: admin@pawshome.com
Contraseña: admin123
Rol: ADMIN
```

### SOLICITANTES
```
1. carlos.garcia@email.com / password123
2. maria.lopez@email.com / password123
3. juan.rodriguez@email.com / password123
4. ana.martinez@email.com / password123
5. pedro.sanchez@email.com / password123
```

### STAFF
```
Email: staff@pawshome.com
Contraseña: staff123
Rol: STAFF
```

---

## 🐾 Datos de Prueba - Mascotas

| ID | Nombre | Tipo | Raza | Edad | Compatible Niños | Nivel Energía |
|----|--------|------|------|------|-----------------|---------------|
| 1 | Firulais | Perro | Labrador | 3 | ✓ Sí | Media |
| 2 | Miau | Gato | Persa | 2 | ✓ Sí | Baja |
| 3 | Boxer | Perro | Boxer | 5 | ✗ No | Alta |
| 4 | Luna | Gato | Siamés | 1 | ✓ Sí | Media |
| 5 | Max | Perro | Pastor Alemán | 4 | ✗ No | Alta |

---

## 📝 Notas Importantes

### Ambiente de Prueba
- **Base de Datos**: MySQL 8.0 (Docker)
- **Aplicación**: Spring Boot 4.0.5
- **Navegadores**: Chrome, Firefox, Safari (versiones recientes)
- **Dispositivos**: Desktop, Tablet (iPad), Mobile (iPhone, Android)
- **URL Base**: `http://localhost:8090`

### Cómo Ejecutar las Pruebas
1. **Iniciar Docker**: `docker-compose up -d`
2. **Ejecutar aplicación**: `mvn clean install && mvn spring-boot:run`
3. **Acceder a aplicación**: http://localhost:8090
4. **Usar credenciales** de la sección anterior

### Criterios de Aceptación Global
- ✅ Todos los 11 casos deben pasar antes de release
- ✅ Coverage de tests ≥ 80% en clases críticas
- ✅ Logs no contienen ERROR inesperados
- ✅ Soporte UTF-8 para caracteres españoles (ñ, acentos)
- ✅ Responsive en breakpoints: 320px, 768px, 1024px, 1920px
- ✅ No más de 2 WARNING en logs durante flujos

### Conformidad Legal y Seguridad
- ✅ Contratos PDF cumplen formato profesional
- ✅ Documentos se almacenan con acceso restringido
- ✅ Hashes SHA-256 previenen duplicados
- ✅ Sesiones expiran correctamente (30 min)
- ✅ Audit trail registra todas las acciones críticas
- ✅ Solo admin puede cambiar estados de solicitudes

### Rollback en Caso de Fallo
- Restaurar backup de BD: `docker exec adopciones-mysql mysql -u root -p1234 adopciones_db < backup.sql`
- Limpiar sesiones: `redis-cli FLUSHALL` (si usa Redis)
- Limpiar archivos subidos: `rm -rf /var/uploads/documentos/*`

---

**Documento generado**: 2026-05-10  
**Versión**: 3.0 (Flujo de Login Unificado)  
**Autor**: Equipo de QA - Paws & Home  
**Total Casos**: 11 flujos e2e  
**Total Pasos**: 101 pasos de ejecución



# 🐾 Planificación de Release: Paws & Home 1.0

## 📊 Información General

| Aspecto | Detalle |
|--------|---------|
| **Proyecto** | Paws & Home - Sistema de Adopción de Mascotas |
| **Versión** | 1.0 |
| **Tipo** | Release |
| **Duración Total** | 2 iteraciones x 2 semanas cada una |
| **Capacidad Estimada** | 160 horas hombre por iteración |
| **Stack Técnico** | Spring Boot 4.0.5, Spring Data JPA, MySQL 8.0, JSP, Maven |

---

## 🎯 Objetivo Comercial del Release

Profesionalizar el proceso de adopción mediante la **formalización legal de contratos** y la **optimización de la comunicación refugio-adoptante** para asegurar el bienestar animal a largo plazo.

---

## 📋 Épicas & Features

| Épica | Feature | Valor Comercial |
|-------|---------|-----------------|
| **Formalización Legal** | Generación de Contratos Automatizada | Reduce tiempos burocráticos y asegura el compromiso legal. ✅ Prioritario |
| | Verificación de Perfiles | Minimiza riesgos de fraude o maltrato al validar la identidad. ✅ Prioritario |
| **Operación y Filtros** | Gestión de Flujo de Solicitudes | Permite al refugio gestionar múltiples procesos sin perder el control. ⚠️ Parcial |
| **Retención y Seguimiento** | Canal de Comunicación y Post-adopción | Garantiza que la mascota esté bien tras la entrega. ❌ No Iniciado |

---

## 📈 Estado Actual del Proyecto

### ✅ Funcionalidades Implementadas

| Componente | Estado | Ubicación |
|-----------|--------|-----------|
| **Gestión de Solicitudes** | ✅ Completo | `SolicitudService`, `SolicitudController` |
| **Estados de Solicitud** | ✅ Completo | Entidad `Solicitud` con estados: Pendiente, Aprobada, Rechazada, En revisión |
| **Registro de Solicitantes** | ✅ Completo | `SolicitanteService`, `SolicitanteController` |
| **Dashboard Admin** | ✅ Básico | `AdminController` + JSP `dashboard.jsp` |
| **Reporte de Mascotas** | ✅ Básico | `AdminController` + JSP `reporteMascotas.jsp` |
| **Búsqueda de Mascotas** | ⚠️ Parcial | Solo filtrado básico sin compatibilidad |
| **Gestión de Adopciones** | ✅ Parcial | CRUD básico sin seguimiento post-adopción |

### ❌ Funcionalidades Pendientes

| Componente | Prioridad | Iteración |
|-----------|-----------|-----------|
| **Sistema de Login y Sesiones** | 🔴 Alta | Iteración 1 (Fundamental) |
| **Generación de Contratos PDF** | 🔴 Alta | Iteración 1 |
| **Subida y Validación de Documentos** | 🔴 Alta | Iteración 1 |
| **Filtros de Compatibilidad Avanzados** | 🟡 Media | Iteración 1 |
| **Integración WhatsApp** | 🟡 Media | Iteración 2 |
| **Dashboard de Métricas Avanzadas** | 🟡 Media | Iteración 2 |
| **Diario de Seguimiento Post-adopción** | 🟡 Media | Iteración 2 |
| **Sección Finales Felices** | 🟢 Baja | Iteración 2 |

---

## 🔄 Iteración 1: Trust & Legal Foundation (Semanas 1-2)

### 🎯 Objetivo de Valor
**Lograr que un proceso de interés se convierta en un compromiso legal formal y seguro**, minimizando riesgos de fraude y asegurando trazabilidad legal completa.

### 📋 User Stories

---

### 📌 US.0 - Sistema de Login y Gestión de Sesiones (24 horas) ⭐ FUNDAMENTAL

**Descripción:**  
Como usuario (solicitante o administrador), quiero autenticarme con email y contraseña para acceder a mi área personal manteniendo una sesión segura sin necesidad de logearme repetidamente.

**Valor Comercial:** Fundamental - Sin login, el sistema no es usable. Asegura seguridad y validación de identidad.

#### 🔧 Desglose de Tareas Técnicas

**T.0.1 - Crear Controlador de Login y Endpoints de Autenticación (6 horas)**

- **Objetivo:** Exponer endpoints para login, logout y gestión de sesiones HTTP

- **Tareas Técnicas:**
  - Crear `LoginController.java` con endpoints:
    ```java
    @GetMapping("/login") → Mostrar formulario login solicitante
    @GetMapping("/login/admin") → Mostrar formulario login admin
    @GetMapping("/acceso") → Página de selección (solicitante vs admin)
    @PostMapping("/login/procesar") → Procesar credenciales (solicitante)
    @PostMapping("/login/admin/procesar") → Procesar credenciales (admin)
    @GetMapping("/logout") → Cerrar sesión e invalidar sesión HTTP
    ```
  - Invocar `UsuarioService.iniciarSesion(email, password)` para validar credenciales
  - Crear sesión HTTP con `session.setAttribute()` almacenando: `usuarioId`, `email`, `nombre`, `rol`
  - Configurar tiempo de expiración: 30 minutos de inactividad
  - Manejar excepciones con `@ExceptionHandler` para credenciales inválidas
  - Redirigir según rol: `/admin/dashboard` (ADMIN) vs `/solicitudes/mis-solicitudes` (SOLICITANTE)

- **Criterios de Aceptación:**
  - ✅ GET `/login` retorna formulario de solicitante
  - ✅ GET `/login/admin` retorna formulario de admin
  - ✅ POST `/login/procesar` con credenciales válidas crea sesión y redirige a `/solicitudes/mis-solicitudes`
  - ✅ POST con credenciales inválidas redirige a `/login` con mensaje de error flash
  - ✅ Usuario con rol SOLICITANTE no puede acceder a `/login/admin`
  - ✅ GET `/logout` invalida sesión e redirige a `/acceso`
  - ✅ Sesión expira después de 30 minutos sin actividad

---

**T.0.2 - Crear Formularios JSP de Login (8 horas)**

- **Objetivo:** Proporcionar UI atractiva y responsive para autenticación

- **Tareas Técnicas:**
  - Crear `src/main/webapp/WEB-INF/jsp/login/acceso.jsp` (página de selección):
    - Card para "Soy Solicitante" con link a `/login`
    - Card para "Soy Administrador" con link a `/login/admin`
    - Diseño responsive CSS (móvil, tablet, desktop)
    - Colores corporativos gradientes
  
  - Crear `src/main/webapp/WEB-INF/jsp/login/loginSolicitante.jsp`:
    - Formulario con campos: email, password
    - Botón "Iniciar Sesión" con ícono
    - Link a registro (`/solicitantes/registro`)
    - Bootstrap/CSS personalizado
    - Mostrar mensajes de error con color rojo
    - Campo email con autofocus
  
  - Crear `src/main/webapp/WEB-INF/jsp/login/loginAdmin.jsp`:
    - Formulario idéntico a solicitante pero con estilos rojos (ADMIN)
    - Badge "🔒 Acceso Restringido"
    - Cuadro de seguridad informando que se registran accesos
    - Link de regreso (`/acceso`)

- **Criterios de Aceptación:**
  - ✅ Formularios validan que email no sea vacío
  - ✅ Formularios validan que contraseña no sea vacía
  - ✅ Mensaje de error se muestra en rojo si credenciales fallan
  - ✅ Diseño responsive en móvil (max-width: 600px)
  - ✅ POST form action apunta a endpoint correcto
  - ✅ Todos los links funcionan correctamente

---

**T.0.3 - Crear Interceptor de Autenticación y Protección de Rutas (6 horas)**

- **Objetivo:** Proteger automáticamente rutas que requieren autenticación

- **Tareas Técnicas:**
  - Crear `AuthInterceptor.java` implementando `HandlerInterceptor`:
    - Implementar `preHandle()` para verificar sesión en cada request
    - Definir rutas públicas (sin sesión):
      ```
      /, /login, /login/admin, /acceso, /solicitantes/registro, /mascotas, etc.
      ```
    - Definir rutas de admin (requieren rol ADMIN):
      ```
      /admin/**
      ```
    - Definir rutas autenticadas (requieren cualquier rol):
      ```
      /solicitudes/**, /adopciones/**, /solicitantes/{id}/editar**
      ```
    - Si no hay sesión: redirigir a `/login` (o `/login/admin` si intenta `/admin`)
    - Si hay sesión pero no tiene rol correcto: redirigir a `/acceso`
    - Validar: `Long usuarioId = (Long) session.getAttribute("usuarioId")`

  - Crear `WebMvcConfiguration.java` implementando `WebMvcConfigurer`:
    - Registrar interceptor en `addInterceptors()` para todas las rutas
    - Excluir rutas estáticas (`/static/**`, `/css/**`, `/js/**`, `/actuator/**`)

- **Criterios de Aceptación:**
  - ✅ GET `/solicitudes/mis-solicitudes` sin sesión redirige a `/login`
  - ✅ GET `/admin/dashboard` sin sesión redirige a `/login/admin`
  - ✅ Solicitante intentando `/admin/dashboard` redirige a `/acceso`
  - ✅ Usuario autenticado puede acceder a su área privada
  - ✅ Rotas públicas (`/`, `/mascotas`) accesibles sin sesión
  - ✅ Logging registra cada intento de acceso (debug level)

---

**T.0.4 - Tests Unitarios para Login y Sesiones (4 horas)**

- **Objetivo:** Asegurar que autenticación funciona correctamente

- **Tareas Técnicas:**
  - Crear `LoginControllerTest.java`:
    ```java
    testLoginExitoso() → Usuario válido crea sesión
    testLoginConEmailInvalido() → Error 400 con mensaje
    testLoginConContraInvalida() → Incrementa intentos fallidos
    testLogout() → Invalida sesión HTTP
    testRedirectSegunRol() → Admin va a /admin/dashboard, solicitante a /solicitudes
    ```
  
  - Crear `AuthInterceptorTest.java`:
    ```java
    testRutaPublicaSinSesion() → Permite acceso
    testRutaPrivadaSinSesion() → Redirige a login
    testAdminSinRol() → Redirige a acceso
    testSesionValida() → Permite acceso a ruta protegida
    ```
  
  - Usar `@WebMvcTest` para pruebas de controlador
  - Usar `MockHttpSession` para simular sesión
  - Coverage mínimo 80%

- **Criterios de Aceptación:**
  - ✅ Todos los tests pasan sin errores
  - ✅ Coverage de LoginController > 80%
  - ✅ Coverage de AuthInterceptor > 80%

---

### 📌 US.1 - Gestión de Estados de Solicitud (32 horas)

**Descripción:**  
Como Admin, quiero gestionar estados de solicitud (Pendiente/Aprobada/Rechazada) con validaciones de regla de negocio para evitar transiciones inválidas y garantizar integridad de datos.

**Valor Comercial:** 128 horas totales

#### 🔧 Desglose de Tareas Técnicas

**T.1.1 - Crear Tabla y Migración de Base de Datos (4 horas)**

- **Objetivo:** Asegurar que la estructura de datos soporta todos los estados requeridos
- **Tareas Técnicas:**
  - Verificar esquema actual de tabla `solicitudes` en `schema-mysql.sql`
  - Validar que la columna `estado` soporta valores: `Pendiente`, `En revisión`, `Aprobada`, `Rechazada`, `Cancelada`
  - Agregar índice en columna `estado` para optimizar búsquedas: `CREATE INDEX idx_solicitud_estado ON solicitudes(estado);`
  - Agregar columnas `fecha_respuesta` (TIMESTAMP) y `razon_rechazo` (VARCHAR 500) si no existen
  - Crear script de migración: `src/main/resources/db/migration/V2__SolicitudEstados.sql`

- **Criterios de Aceptación:**
  - ✅ Tabla `solicitudes` tiene índices en `estado`, `fecha_solicitud`, `solicitante_id`
  - ✅ Script de migración ejecuta sin errores
  - ✅ Todos los estados están documentados en comentarios SQL

---

**T.1.2 - Implementar Validador de Transiciones de Estado (8 horas)**

- **Objetivo:** Prevenir transiciones inválidas de estados mediante lógica de negocio centralizada

- **Tareas Técnicas:**
  - Crear clase `SolicitudEstadoValidator.java` en `src/main/java/com/example/gr01_1bt3_622_26a/validation/`
  - Implementar máquina de estados (State Pattern) con transiciones válidas:
    ```
    En revisión → Aprobada ✅
    En revisión → Rechazada ✅
    Aprobada → Cancelada ✅
    Rechazada → Cancelada ✅
    Cualquier otro → Error ❌
    ```
  - Crear excepción personalizada `EstadoInvalidoException extends RuntimeException`
  - Añadir método `validarTransicion(String estadoActual, String estadoNuevo)` que lance excepción si transición es inválida
  - Integrar validador en `SolicitudService.aprobarSolicitud()` y `rechazarSolicitud()`
  - Agregar tests unitarios en `SolicitudEstadoValidatorTest.java`

- **Criterios de Aceptación:**
  - ✅ Todas las transiciones válidas permitidas sin excepción
  - ✅ Transiciones inválidas lanzan `EstadoInvalidoException` con mensaje descriptivo
  - ✅ Tests unitarios cubren 100% de casos de transición
  - ✅ Logging registra todas las transiciones rechazadas (audit trail)

---

**T.1.3 - Endpoint API REST para Cambio de Estados (Control) (8 horas)**

- **Objetivo:** Exponer endpoints REST seguros para actualizar estados de solicitud

- **Tareas Técnicas:**
  - Crear métodos en `SolicitudController`:
    ```java
    @PostMapping("/{id}/aprobar")
    public ResponseEntity<?> aprobarSolicitud(
        @PathVariable Long id,
        @RequestParam(required = false) String observaciones
    )
    
    @PostMapping("/{id}/rechazar")
    public ResponseEntity<?> rechazarSolicitud(
        @PathVariable Long id,
        @RequestParam String razon
    )
    
    @GetMapping("/{estado}/listar")
    public ResponseEntity<List<SolicitudDTO>> obtenerPorEstado(@PathVariable String estado)
    ```
  - Crear DTO `SolicitudDTO` con campos: `id`, `estado`, `fechaSolicitud`, `fechaRespuesta`, `solicitante`, `mascota`
  - Implementar validación de parámetros usando `@Valid` y `BindingResult`
  - Agregar manejo de excepciones con `@ExceptionHandler(EstadoInvalidoException.class)`
  - Retornar `ResponseEntity` con HTTP 200 (éxito), 400 (validación), 404 (no encontrado)
  - Agregar documentación Swagger/OpenAPI

- **Criterios de Aceptación:**
  - ✅ Endpoint GET `/solicitudes/{id}` retorna estado actual
  - ✅ Endpoint POST `/solicitudes/{id}/aprobar` cambia estado a "Aprobada"
  - ✅ Endpoint POST `/solicitudes/{id}/rechazar` cambia estado a "Rechazada" y guarda razón
  - ✅ Response incluye metadata: `timestamp`, `message`, `statusCode`
  - ✅ Errores retornan JSON estructurado con descripción clara

---

**T.1.4 - Interfaz Web Admin para Cambio de Estados (12 horas)**

- **Objetivo:** Proporcionar UI intuitiva para que admin gestione cambios de estado

- **Tareas Técnicas:**
  - Modificar `src/main/resources/templates/admin/dashboard.jsp`:
    - Agregar sección "Solicitudes Pendientes" con tabla las últimas 10 solicitudes en estado "En revisión"
    - Integrar Bootstrap Modal para aprobar/rechazar:
      ```html
      <button class="btn btn-success btn-sm" data-bs-toggle="modal" data-bs-target="#aprobarModal">
        <i class="fas fa-check"></i> Aprobar
      </button>
      <button class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#rechazarModal">
        <i class="fas fa-times"></i> Rechazar
      </button>
      ```
    - Crear archivo `src/main/resources/templates/solicitudes/gestionar-estados.jsp` para vista completa
    - Implementar filtros: por estado, fecha, solicitante
    - Agregar AJAX para actualización sin recargar página
    - Implementar notificaciones toast (Bootstrap Toast) con confirmación de acción
    - Agregar breadcrumb: Dashboard > Solicitudes > Gestionar estados

  - Crear controlador method en `AdminController`:
    ```java
    @GetMapping("/solicitudes/gestionar")
    public String gestionarEstados(
        @RequestParam(defaultValue = "En revisión") String estado,
        Model model
    ) {
        List<Solicitud> solicitudes = solicitudService.obtenerPorEstado(estado);
        model.addAttribute("solicitudes", solicitudes);
        return "solicitudes/gestionar-estados";
    }
    ```

  - Implementar JavaScript para AJAX llamadas:
    ```javascript
    async function cambiarEstado(solicitudId, nuevoEstado, razon = null) {
        const url = `/solicitudes/${solicitudId}/${nuevoEstado === 'Aprobada' ? 'aprobar' : 'rechazar'}`;
        const data = nuevoEstado === 'Rechazada' ? { razon } : {};
        const response = await fetch(url, { method: 'POST', body: JSON.stringify(data) });
        return response.json();
    }
    ```

- **Criterios de Aceptación:**
  - ✅ Admin ve lista de solicitudes en estado "En revisión"
  - ✅ Botones de Aprobar/Rechazar funcionan sin recargar página
  - ✅ Modal de rechazo requiere razón (campo obligatorio)
  - ✅ Confirmación visual con toast después de cambio
  - ✅ Tabla actualiza automáticamente después de acción
  - ✅ Responsive en móvil (Bootstrap grid)

---

**T.1.5 - Lógica de Bloqueo de Mascota en Transición de Estado (8 horas)**

- **Objetivo:** Impedir que mascota sea adoptada por múltiples solicitantes simultáneamente

- **Tareas Técnicas:**
  - Agregar campo `estado_mascota` en tabla `mascotas`: `En evaluación`, `Bloqueada para adopción`, `Disponible`, `Adoptada`
  - Modificar entidad `Mascota.java`:
    ```java
    @Column(name = "estado_mascota", nullable = false)
    @Builder.Default
    private String estadoMascota = "Disponible";
    ```
  - Crear método en `MascotaService.java`:
    ```java
    public void bloquearMascota(Long mascotaId, Long solicitudId) {
        // Cambiar estado a "Bloqueada para adopción"
        // Rechazar automáticamente otras solicitudes pendientes
        // Logging de auditoria
    }
    ```
  - Integrar bloqueo en `SolicitudService.aprobarSolicitud()`:
    - Al aprobar solicitud, llamar `mascotaService.bloquearMascota()`
    - Rechazar automáticamente otras solicitudes para esa mascota con razón: "Mascota asignada a otro solicitante"
  - Crear test unitario verificando que mascota se bloquea correctamente

- **Criterios de Aceptación:**
  - ✅ Cuando solicitud es aprobada, mascota cambia a estado "Bloqueada para adopción"
  - ✅ Otras solicitudes pendientes para esa mascota se rechazan automáticamente
  - ✅ Solicitantes rechazados reciben notificación via email
  - ✅ Base de datos mantiene consistencia: una mascota = máximo una solicitud aprobada

---

### 📌 US.2 - Módulo de Documentación y Validación (40 horas)

**Descripción:**  
Como Usuario, quiero subir fotos de mi cédula y servicios básicos para validar mi hogar, asegurando que el sistema verifica automáticamente la identidad y legitimidad del adoptante.

**Valor Comercial:** 40 horas ideales

#### 🔧 Desglose de Tareas Técnicas

**T.2.1 - Crear Tabla de Documentos en BD (4 horas)**

- **Objetivo:** Establecer estructura para almacenar referencias a documentos verificables

- **Tareas Técnicas:**
  - Crear tabla `documentos_solicitante`:
    ```sql
    CREATE TABLE documentos_solicitante (
        id BIGINT PRIMARY KEY AUTO_INCREMENT,
        solicitante_id BIGINT NOT NULL,
        tipo_documento VARCHAR(50) NOT NULL, -- Cédula, Servicio_Básico, Comprobante_Domicilio, etc.
        ruta_archivo VARCHAR(500) NOT NULL,
        nombre_archivo VARCHAR(255) NOT NULL,
        estado_verificacion VARCHAR(50) DEFAULT 'Pendiente', -- Pendiente, Verificado, Rechazado
        fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        fecha_verificacion TIMESTAMP,
        comentarios_verificador VARCHAR(1000),
        hash_documento VARCHAR(255), -- Para detectar duplicados
        FOREIGN KEY (solicitante_id) REFERENCES solicitantes(id),
        INDEX idx_solicitante_tipo (solicitante_id, tipo_documento),
        INDEX idx_estado_verificacion (estado_verificacion)
    );
    ```
  - Crear script de migración SQL
  - Agregar validación de foreign key en nivel BD

- **Criterios de Aceptación:**
  - ✅ Tabla creada con todas las columnas y constraints
  - ✅ Índices optimizan búsquedas frecuentes
  - ✅ Script de migración versionado con timestamp

---

**T.2.2 - Crear Entidad JPA y Repositorio (4 horas)**

- **Objetivo:** Mapear tabla a entidad Java con validaciones

- **Tareas Técnicas:**
  - Crear clase `DocumentoSolicitante.java`:
    ```java
    @Entity
    @Table(name = "documentos_solicitante")
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public class DocumentoSolicitante {
        @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long id;
        
        @ManyToOne(fetch = FetchType.LAZY)
        @JoinColumn(name = "solicitante_id", nullable = false)
        private Solicitante solicitante;
        
        @NotBlank(message = "Tipo de documento requerido")
        @Column(nullable = false)
        private String tipoDocumento; // ENUM recomendado
        
        @NotBlank(message = "Ruta de archivo requerida")
        @Column(nullable = false)
        private String rutaArchivo;
        
        @Size(max = 255)
        private String nombreArchivo;
        
        @Column(name = "estado_verificacion", nullable = false)
        @Builder.Default
        private String estadoVerificacion = "Pendiente";
        
        @Column(name = "fecha_carga")
        private LocalDateTime fechaCarga;
        
        @Column(name = "fecha_verificacion")
        private LocalDateTime fechaVerificacion;
        
        @Size(max = 1000)
        private String comentariosVerificador;
        
        @Column(length = 255)
        private String hashDocumento;
        
        @PrePersist
        protected void onCreate() {
            fechaCarga = LocalDateTime.now();
        }
    }
    ```
  - Crear `DocumentoSolicitanteRepository extends JpaRepository<DocumentoSolicitante, Long>`
  - Agregar query methods:
    ```java
    List<DocumentoSolicitante> findBySolicitanteIdAndEstadoVerificacion(Long solicitanteId, String estado);
    Optional<DocumentoSolicitante> findBySolicitanteIdAndTipoDocumento(Long solicitanteId, String tipo);
    ```

- **Criterios de Aceptación:**
  - ✅ Entidad mapea correctamente a tabla
  - ✅ Validaciones con `@NotBlank`, `@Size` funcionan
  - ✅ Relación ManyToOne con `Solicitante` lazy loaded
  - ✅ Repository métodos compilados sin errores

---

**T.2.3 - Implementar Servicio de Carga de Archivos (12 horas)**

- **Objetivo:** Manejar subida segura de archivos con validaciones

- **Tareas Técnicas:**
  - Crear clase `DocumentoService.java`:
    ```java
    @Service
    @RequiredArgsConstructor
    @Transactional
    @Slf4j
    public class DocumentoService {
        
        @Value("${app.upload.document.path}")
        private String uploadPath;
        
        @Value("${app.upload.document.max-size}")
        private long maxFileSize;
        
        private final DocumentoSolicitanteRepository documentoRepository;
        private final SolicitanteRepository solicitanteRepository;
        
        public DocumentoSolicitante cargarDocumento(
            Long solicitanteId,
            String tipoDocumento,
            MultipartFile archivo
        ) throws IOException {
            // Validaciones
            if (archivo.isEmpty()) throw new IllegalArgumentException("Archivo vacío");
            if (archivo.getSize() > maxFileSize) throw new FileSizeExceededException(...);
            
            // Validar tipo MIME
            String contentType = archivo.getContentType();
            if (!isAllowedMimeType(contentType)) throw new UnsupportedMediaTypeException(...);
            
            // Generar nombre único
            String nombreUnico = generarNombreUnico(archivo.getOriginalFilename());
            Path rutaCompleta = Path.of(uploadPath, solicitanteId.toString(), nombreUnico);
            
            // Crear directorios si no existen
            Files.createDirectories(rutaCompleta.getParent());
            
            // Guardar archivo
            Files.write(rutaCompleta, archivo.getBytes());
            
            // Calcular hash para detectar duplicados
            String hash = calcularHash(archivo.getBytes());
            
            // Persistir en BD
            DocumentoSolicitante documento = DocumentoSolicitante.builder()
                .solicitante(solicitanteRepository.findById(solicitanteId).orElseThrow())
                .tipoDocumento(tipoDocumento)
                .rutaArchivo(rutaCompleta.toString())
                .nombreArchivo(archivo.getOriginalFilename())
                .hashDocumento(hash)
                .build();
            
            return documentoRepository.save(documento);
        }
        
        private String generarNombreUnico(String nombreOriginal) {
            return UUID.randomUUID() + "_" + nombreOriginal;
        }
        
        private String calcularHash(byte[] contenido) {
            // SHA-256
        }
        
        private boolean isAllowedMimeType(String contentType) {
            return contentType.matches("^image/(png|jpeg)$|^application/pdf$");
        }
    }
    ```
  - Agregar configuración en `application.properties`:
    ```properties
    app.upload.document.path=/var/uploads/documentos
    app.upload.document.max-size=5242880 # 5MB
    ```
  - Implementar detección de duplicados usando hash
  - Crear excepción personalizada `DocumentoDuplicadoException`

- **Criterios de Aceptación:**
  - ✅ Archivo se guarda en servidor en ruta correcta
  - ✅ Nombres de archivo son únicos (UUID)
  - ✅ Solo MIME types permitidos (PNG, JPEG, PDF)
  - ✅ Máximo tamaño respetado (5MB)
  - ✅ Duplicados detectados por hash SHA-256
  - ✅ Ruta se persiste en BD

---

**T.2.4 - Crear Endpoint REST de Subida (8 horas)**

- **Objetivo:** Exponer API REST para subida de documentos

- **Tareas Técnicas:**
  - Crear controller `DocumentoController.java`:
    ```java
    @RestController
    @RequestMapping("/api/documentos")
    @RequiredArgsConstructor
    @Slf4j
    public class DocumentoController {
        
        private final DocumentoService documentoService;
        
        @PostMapping("/subir")
        public ResponseEntity<?> subirDocumento(
            @RequestParam("solicitanteId") Long solicitanteId,
            @RequestParam("tipoDocumento") String tipoDocumento,
            @RequestParam("archivo") MultipartFile archivo
        ) {
            try {
                DocumentoSolicitante documento = 
                    documentoService.cargarDocumento(solicitanteId, tipoDocumento, archivo);
                
                return ResponseEntity.status(HttpStatus.CREATED).body(
                    Map.of(
                        "id", documento.getId(),
                        "mensaje", "Documento subido correctamente",
                        "estado", documento.getEstadoVerificacion()
                    )
                );
            } catch (FileSizeExceededException e) {
                return ResponseEntity.badRequest().body(
                    Map.of("error", "Archivo demasiado grande. Máximo 5MB")
                );
            }
        }
        
        @GetMapping("/{solicitanteId}")
        public ResponseEntity<List<DocumentoDTO>> obtenerDocumentos(
            @PathVariable Long solicitanteId
        ) {
            List<DocumentoSolicitante> documentos = 
                documentoService.obtenerPorSolicitante(solicitanteId);
            return ResponseEntity.ok(mapToDTO(documentos));
        }
        
        @GetMapping("/{id}/verificar")
        public ResponseEntity<?> verificarDocumento(
            @PathVariable Long id,
            @RequestParam String estado,
            @RequestParam(required = false) String comentarios
        ) {
            documentoService.verificarDocumento(id, estado, comentarios);
            return ResponseEntity.ok(Map.of("mensaje", "Documento verificado"));
        }
    }
    ```
  - Crear DTO `DocumentoDTO` con campos públicos necesarios

- **Criterios de Aceptación:**
  - ✅ POST `/api/documentos/subir` retorna 201 CREATED
  - ✅ GET `/api/documentos/{solicitanteId}` lista documentos
  - ✅ Response incluye estado de verificación
  - ✅ Validation errors retornan 400 BAD REQUEST

---

**T.2.5 - Componente Frontend Drag & Drop (16 horas)**

- **Objetivo:** Proporcionar UX moderna para subida de documentos

- **Tareas Técnicas:**
  - Crear archivo `src/main/resources/static/js/document-upload.js`:
    ```javascript
    class DocumentUploadManager {
        constructor(dropZoneSelector, fileInputSelector) {
            this.dropZone = document.querySelector(dropZoneSelector);
            this.fileInput = document.querySelector(fileInputSelector);
            this.initializing();
        }
        
        initializing() {
            // Drag & drop events
            this.dropZone.addEventListener('dragover', this.handleDragOver.bind(this));
            this.dropZone.addEventListener('dragleave', this.handleDragLeave.bind(this));
            this.dropZone.addEventListener('drop', this.handleDrop.bind(this));
            
            // File input change
            this.fileInput.addEventListener('change', this.handleFiles.bind(this));
        }
        
        handleDragOver(e) {
            e.preventDefault();
            e.stopPropagation();
            this.dropZone.classList.add('dragover');
        }
        
        handleDragLeave(e) {
            e.preventDefault();
            this.dropZone.classList.remove('dragover');
        }
        
        handleDrop(e) {
            e.preventDefault();
            this.dropZone.classList.remove('dragover');
            const files = e.dataTransfer.files;
            this.handleFiles({ target: { files } });
        }
        
        async handleFiles(e) {
            const files = e.target.files;
            for (const file of files) {
                await this.uploadFile(file);
            }
        }
        
        async uploadFile(file) {
            const formData = new FormData();
            formData.append('archivo', file);
            formData.append('tipoDocumento', this.getTipoDocumento(file.name));
            
            try {
                const response = await fetch('/api/documentos/subir', {
                    method: 'POST',
                    body: formData
                });
                
                if (!response.ok) throw new Error('Upload failed');
                
                const data = await response.json();
                this.mostrarExito(file.name, data);
                this.actualizarLista();
            } catch (error) {
                this.mostrarError(file.name, error.message);
            }
        }
        
        getTipoDocumento(nombreArchivo) {
            if (nombreArchivo.includes('cedula')) return 'Cédula';
            if (nombreArchivo.includes('servicio')) return 'Servicio_Básico';
            return 'Comprobante_Domicilio';
        }
        
        mostrarExito(nombre, datos) {
            const toast = this.crearToast(nombre + ' subido correctamente', 'success');
            document.body.appendChild(toast);
            setTimeout(() => toast.remove(), 3000);
        }
        
        mostrarError(nombre, error) {
            const toast = this.crearToast(nombre + ': ' + error, 'danger');
            document.body.appendChild(toast);
        }
    }
    
    // Inicializar cuando DOM esté listo
    document.addEventListener('DOMContentLoaded', () => {
        new DocumentUploadManager('#dropZone', '#fileInput');
    });
    ```
  
  - Crear archivo `src/main/resources/templates/solicitantes/subir-documentos.jsp`:
    ```html
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Verificación de Documentos</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            .drop-zone {
                border: 2px dashed #0066cc;
                border-radius: 8px;
                padding: 40px;
                text-align: center;
                cursor: pointer;
                transition: all 0.3s ease;
                background-color: #f8f9fa;
            }
            
            .drop-zone.dragover {
                border-color: #28a745;
                background-color: #e8f5e9;
                box-shadow: 0 0 10px rgba(40, 167, 69, 0.3);
            }
            
            .drop-zone:hover {
                border-color: #0066cc;
                background-color: #e3f2fd;
            }
            
            .document-card {
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 10px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            
            .verification-badge {
                padding: 5px 10px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: bold;
            }
            
            .verification-badge.pending {
                background-color: #ffc107;
                color: #000;
            }
            
            .verification-badge.verified {
                background-color: #28a745;
                color: #fff;
            }
            
            .verification-badge.rejected {
                background-color: #dc3545;
                color: #fff;
            }
        </style>
    </head>
    <body>
        <div class="container mt-5">
            <h2><i class="fas fa-file-upload"></i> Verificación de Documentos</h2>
            
            <!-- Drop Zone -->
            <div class="drop-zone" id="dropZone">
                <i class="fas fa-cloud-upload-alt" style="font-size: 48px; color: #0066cc;"></i>
                <h4 class="mt-3">Arrastra tus documentos aquí</h4>
                <p class="text-muted">o haz clic para seleccionar archivos</p>
                <input type="file" id="fileInput" multiple hidden accept="image/png,image/jpeg,application/pdf">
            </div>
            
            <!-- Document List -->
            <div class="mt-5">
                <h4>Documentos Cargados</h4>
                <div id="documentList"></div>
            </div>
        </div>
        
        <script src="/static/js/document-upload.js"></script>
    </body>
    </html>
    ```

  - Integrar en página de perfil de solicitante

- **Criterios de Aceptación:**
  - ✅ Drag & drop funciona en navegadores modernos
  - ✅ Validación de tipo MIME en cliente
  - ✅ Barra de progreso durante subida
  - ✅ Toast con confirmación de éxito/error
  - ✅ Responsive en móvil
  - ✅ Accesibilidad WCAG 2.1

---

**T.2.6 - Servicio de Visualización de Documentos (8 horas)**

- **Objetivo:** Permitir visualización segura de documentos subidos

- **Tareas Técnicas:**
  - Crear método en `DocumentoService`:
    ```java
    public byte[] descargarDocumento(Long documentoId, Long solicitanteId) 
        throws AccessDeniedException, FileNotFoundException {
        DocumentoSolicitante doc = documentoRepository.findById(documentoId)
            .orElseThrow(() -> new FileNotFoundException("Documento no encontrado"));
        
        // Validar que la descargar pertenece al solicitante actual
        if (!doc.getSolicitante().getId().equals(solicitanteId)) {
            throw new AccessDeniedException("No tienes permiso para descargar este documento");
        }
        
        return Files.readAllBytes(Path.of(doc.getRutaArchivo()));
    }
    
    public Resource visualizarDocumento(Long documentoId) {
        DocumentoSolicitante doc = documentoRepository.findById(documentoId)
            .orElseThrow();
        Path filePath = Path.of(doc.getRutaArchivo());
        return new FileSystemResource(filePath);
    }
    ```
  
  - Crear endpoint GET con seguridad:
    ```java
    @GetMapping("/{id}/descargar")
    public ResponseEntity<Resource> descargarDocumento(
        @PathVariable Long id,
        Authentication authentication // Del usuario autenticado
    ) {
        Long solicitanteId = obtenerSolicitanteIdDelUsuario(authentication);
        Resource resource = documentoService.obtengerRecurso(id, solicitanteId);
        return ResponseEntity.ok()
            .contentType(MediaType.APPLICATION_OCTET_STREAM)
            .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"documento.pdf\"")
            .body(resource);
    }
    ```

- **Criterios de Aceptación:**
  - ✅ Solo propietario puede descargar su documento
  - ✅ Streaming de archivo seguro sin exponer rutas
  - ✅ Logging de descargas para auditoría
  - ✅ Validación de MIME type en respuesta

---

### 📌 US.3 - Generación de Contratos PDF (32 horas)

**Descripción:**  
Como Admin, quiero descargar un contrato PDF autocompletado con los datos del match adoptante-mascota para formalizar legalmente la adopción.

**Valor Comercial:** 32 horas ideales

#### 🔧 Desglose de Tareas Técnicas

**T.3.1 - Diseñar Plantilla Legal HTML/CSS (8 horas)**

- **Objetivo:** Crear plantilla profesional que pueda convertirse a PDF

- **Tareas Técnicas:**
  - Crear archivo `src/main/resources/templates/contratos/contrato-adopcion-template.html`:
    ```html
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <style>
            body { font-family: Arial, sans-serif; margin: 20px; line-height: 1.6; }
            .header { text-align: center; border-bottom: 2px solid #333; padding-bottom: 10px; }
            .section { margin-top: 20px; }
            .section-title { font-weight: bold; text-decoration: underline; margin-bottom: 10px; }
            table { width: 100%; border-collapse: collapse; margin-top: 10px; }
            td, th { border: 1px solid #ddd; padding: 8px; text-align: left; }
            .signature-line { margin-top: 40px; border-top: 1px solid #333; width: 200px; }
            .two-column { display: flex; justify-content: space-between; }
        </style>
    </head>
    <body>
        <div class="header">
            <h1>CONTRATO DE ADOPCIÓN DE MASCOTA</h1>
            <p>Paws & Home - Sistema de Adopciones Responsables</p>
            <p>Fecha: ${fechaGeneracion}</p>
        </div>
        
        <div class="section">
            <div class="section-title">1. PARTES INVOLUCRADAS</div>
            <table>
                <tr>
                    <td><strong>Refugio/Organización:</strong></td>
                    <td>${nombreRefugio}</td>
                </tr>
                <tr>
                    <td><strong>Representante Legal:</strong></td>
                    <td>${representanteLegal}</td>
                </tr>
                <tr>
                    <td><strong>Adoptante:</strong></td>
                    <td>${nombreAdoptante}</td>
                </tr>
                <tr>
                    <td><strong>Cédula Adoptante:</strong></td>
                    <td>${cedulaAdoptante}</td>
                </tr>
            </table>
        </div>
        
        <div class="section">
            <div class="section-title">2. INFORMACIÓN DE LA MASCOTA</div>
            <table>
                <tr>
                    <td><strong>Nombre:</strong></td>
                    <td>${nombreMascota}</td>
                </tr>
                <tr>
                    <td><strong>Tipo:</strong></td>
                    <td>${tipoMascota}</td>
                </tr>
                <tr>
                    <td><strong>Raza:</strong></td>
                    <td>${razaMascota}</td>
                </tr>
                <tr>
                    <td><strong>Edad:</strong></td>
                    <td>${edadMascota} años</td>
                </tr>
            </table>
        </div>
        
        <div class="section">
            <div class="section-title">3. TÉRMINOS Y CONDICIONES</div>
            <p>El adoptante se compromete a:</p>
            <ul>
                <li>Proporcionar un hogar seguro y cuidado humanitario</li>
                <li>Mantener las vacunas al día</li>
                <li>No revender ni transferir la mascota sin consentimiento</li>
                <li>Contactar al refugio en caso de abandono</li>
            </ul>
        </div>
        
        <div class="two-column">
            <div>
                <p><strong>Adoptante</strong></p>
                <div class="signature-line"></div>
                <p>${nombreAdoptante}</p>
                <p>Fecha: ______________</p>
            </div>
            <div>
                <p><strong>Refugio</strong></p>
                <div class="signature-line"></div>
                <p>${representanteLegal}</p>
                <p>Fecha: ______________</p>
            </div>
        </div>
    </body>
    </html>
    ```

  - Crear CSS profesional con branding del proyecto
  - Incluir campos para firmas y fechas

- **Criterios de Aceptación:**
  - ✅ Plantilla es válida HTML5
  - ✅ CSS renderiza correctamente en navegadores
  - ✅ Diseño es profesional y legal
  - ✅ Espacios para firmas manualmente

---

**T.3.2 - Integrar Librería de Renderizado PDF (12 horas)**

- **Objetivo:** Convertir HTML a PDF con librería robusta

- **Tareas Técnicas:**
  - Agregar dependencia Maven en `pom.xml`:
    ```xml
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-thymeleaf</artifactId>
    </dependency>
    <dependency>
        <groupId>org.xhtmlrenderer</groupId>
        <artifactId>flying-saucer-pdf-itext5</artifactId>
        <version>9.3.1</version>
    </dependency>
    ```
  
  - Crear servicio `ContratoService.java`:
    ```java
    @Service
    @RequiredArgsConstructor
    @Slf4j
    public class ContratoService {
        
        private final ThymeleafEngine thymeleafEngine;
        private final TemplateEngine templateEngine;
        
        public byte[] generarContratoPDF(Long adopcionId) throws IOException, DocumentException {
            // Obtener datos de la adopción
            Adopcion adopcion = adopcionRepository.findById(adopcionId)
                .orElseThrow(() -> new ResourceNotFoundException("Adopción no encontrada"));
            
            // Preparar contexto de Thymeleaf
            Context context = new Context();
            context.setVariable("nombreRefugio", "Paws & Home Sanctuary");
            context.setVariable("representanteLegal", "Admin Shelter");
            context.setVariable("nombreAdoptante", adopcion.getSolicitante().getNombre());
            context.setVariable("cedulaAdoptante", adopcion.getSolicitante().getDocumentoIdentidad());
            context.setVariable("nombreMascota", adopcion.getMascota().getNombre());
            context.setVariable("tipoMascota", adopcion.getMascota().getTipo());
            context.setVariable("razaMascota", adopcion.getMascota().getRaza());
            context.setVariable("edadMascota", adopcion.getMascota().getEdad());
            context.setVariable("fechaGeneracion", LocalDateTime.now().format(...));
            
            // Renderizar HTML desde plantilla
            String htmlContent = templateEngine.process("contratos/contrato-adopcion-template", context);
            
            // Convertir HTML a PDF
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            ITextRenderer renderer = new ITextRenderer();
            renderer.setDocumentFromString(htmlContent);
            renderer.layout();
            renderer.createPDF(outputStream);
            
            log.info("Contrato PDF generado para adopción ID: {}", adopcionId);
            return outputStream.toByteArray();
        }
    }
    ```
  
  - Configuración adicional en `application.properties`:
    ```properties
    spring.thymeleaf.mode=HTML
    spring.thymeleaf.cache=false
    ```

- **Criterios de Aceptación:**
  - ✅ PDF se genera sin errores
  - ✅ Datos se interpolan correctamente
  - ✅ PDF es descargable directamente
  - ✅ Todos los caracteres especiales renderean (ñ, acentos)

---

**T.3.3 - Servicio de Mapeo de Datos Adopción-Contrato (8 horas)**

- **Objetivo:** Mapear entidades a DTO para plantilla

- **Tareas Técnicas:**
  - Crear DTO `ContratoDTO`:
    ```java
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public class ContratoDTO {
        private Long adopcionId;
        private String nombreRefugio;
        private String nombreAdoptante;
        private String cedulaAdoptante;
        private String emailAdoptante;
        private String telefonoAdoptante;
        private String nombreMascota;
        private String tipoMascota;
        private String razaMascota;
        private Integer edadMascota;
        private LocalDate fechaGeneracion;
        private String numeroContrato; // Generado automáticamente
    }
    ```
  
  - Crear mapper en `ContratoService`:
    ```java
    private ContratoDTO mapearAdopcionAContrato(Adopcion adopcion) {
        return ContratoDTO.builder()
            .adopcionId(adopcion.getId())
            .nombreAdoptante(adopcion.getSolicitante().getNombre())
            .cedulaAdoptante(adopcion.getSolicitante().getDocumentoIdentidad())
            .nombreMascota(adopcion.getMascota().getNombre())
            .tipoMascota(adopcion.getMascota().getTipo())
            .razaMascota(adopcion.getMascota().getRaza())
            .edadMascota(adopcion.getMascota().getEdad())
            .fechaGeneracion(LocalDate.now())
            .numeroContrato(generarNumeroContrato(adopcion.getId()))
            .build();
    }
    
    private String generarNumeroContrato(Long adopcionId) {
        return "CONTRATO-" + adopcionId + "-" + System.currentTimeMillis();
    }
    ```

- **Criterios de Aceptación:**
  - ✅ DTO contiene todos los campos necesarios
  - ✅ Mapeo es completo sin null pointers
  - ✅ Número de contrato es único

---

**T.3.4 - Botón de Descarga en Frontend (4 horas)**

- **Objetivo:** Permitir descargar contrato PDF desde UI

- **Tareas Técnicas:**
  - Agregar botón en vista de adopción `src/main/resources/templates/adopciones/detalleAdopcion.jsp`:
    ```html
    <button class="btn btn-success" onclick="descargarContrato(${adopcion.id})">
        <i class="fas fa-file-pdf"></i> Descargar Contrato PDF
    </button>
    ```
  
  - Crear método en `AdopcionController`:
    ```java
    @GetMapping("/{id}/contrato/descargar")
    public ResponseEntity<byte[]> descargarContrato(@PathVariable Long id) {
        byte[] pdfContent = contratoService.generarContratoPDF(id);
        
        return ResponseEntity.ok()
            .contentType(MediaType.APPLICATION_PDF)
            .header(HttpHeaders.CONTENT_DISPOSITION, 
                "attachment; filename=\"contrato_adopcion_" + id + ".pdf\"")
            .body(pdfContent);
    }
    ```
  
  - JavaScript para descarga:
    ```javascript
    function descargarContrato(adopcionId) {
        window.location.href = `/adopciones/${adopcionId}/contrato/descargar`;
    }
    ```

- **Criterios de Aceptación:**
  - ✅ Botón aparece en vista de adopción
  - ✅ Click descarga PDF al navegador
  - ✅ Nombre de archivo incluye ID de adopción
  - ✅ MIME type correcto en header

---

### 📌 US.4 - Filtros de Compatibilidad (24 horas)

**Descripción:**  
Como Usuario, quiero filtrar mascotas por compatibilidad (si tengo niños, otros animales, espacio disponible) para encontrar la mascota ideal sin riesgo.

**Valor Comercial:** 24 horas ideales

#### 🔧 Desglose de Tareas Técnicas

**T.4.1 - Agregar Campos de Compatibilidad en BD (4 horas)**

- **Objetivo:** Extender tabla de mascotas con atributos de compatibilidad

- **Tareas Técnicas:**
  - Crear script SQL para agregar columnas a tabla `mascotas`:
    ```sql
    ALTER TABLE mascotas ADD COLUMN (
        compatible_ninos BOOLEAN DEFAULT true,
        compatible_gatos BOOLEAN DEFAULT true,
        compatible_perros BOOLEAN DEFAULT true,
        energía_nivel VARCHAR(20) DEFAULT 'Media', -- Baja, Media, Alta
        tamaño_requerido VARCHAR(20) DEFAULT 'Mediano', -- Pequeño, Mediano, Grande
        requisitos_especiales VARCHAR(500),
        edad_minima_ninos INT DEFAULT 5,
        es_hipoalergenico BOOLEAN DEFAULT false,
        necesita_patio BOOLEAN DEFAULT false
    );
    ```
  
  - Crear índices para búsquedas frecuentes:
    ```sql
    CREATE INDEX idx_compatibilidad ON mascotas(compatible_ninos, compatible_gatos, compatible_perros);
    CREATE INDEX idx_energia ON mascotas(energía_nivel);
    CREATE INDEX idx_tamaño ON mascotas(tamaño_requerido);
    ```
  
  - Crear script de migración: `V3__MascotaCompatibilidad.sql`

- **Criterios de Aceptación:**
  - ✅ Columnas creadas sin errores
  - ✅ Valores default apropiados
  - ✅ Índices optimizan queries

---

**T.4.2 - Extender Entidad Mascota (4 horas)**

- **Objetivo:** Mapear nuevos campos a entidad JPA

- **Tareas Técnicas:**
  - Modificar `Mascota.java`:
    ```java
    @Column(name = "compatible_ninos")
    @Builder.Default
    private Boolean compatibleNinos = true;
    
    @Column(name = "compatible_gatos")
    @Builder.Default
    private Boolean compatibleGatos = true;
    
    @Column(name = "compatible_perros")
    @Builder.Default
    private Boolean compatiblePerros = true;
    
    @Column(name = "energia_nivel")
    @Builder.Default
    private String nivelEnergia = "Media";
    
    @Column(name = "tamaño_requerido")
    @Builder.Default
    private String tamañoRequerido = "Mediano";
    
    @Column(name = "requisitos_especiales")
    @Size(max = 500)
    private String requisitosEspeciales;
    
    @Column(name = "edad_minima_ninos")
    private Integer edadMinimaNinos;
    
    @Column(name = "es_hipoalergenico")
    @Builder.Default
    private Boolean esHipoalergenico = false;
    
    @Column(name = "necesita_patio")
    @Builder.Default
    private Boolean necesitaPatio = false;
    ```

- **Criterios de Aceptación:**
  - ✅ Campos mapean correctamente
  - ✅ Validaciones aplicadas
  - ✅ Builders funcionan

---

**T.4.3 - Endpoint Backend de Filtrado (8 horas)**

- **Objetivo:** Implementar query dinámico basado en criterios de compatibilidad

- **Tareas Técnicas:**
  - Crear método en `MascotaRepository`:
    ```java
    @Query("""
        SELECT m FROM Mascota m WHERE 
        m.estado = 'Disponible'
        AND (:tieneNinos IS NULL OR m.compatibleNinos = :tieneNinos)
        AND (:tieneGatos IS NULL OR m.compatibleGatos = :tieneGatos)
        AND (:tienePerros IS NULL OR m.compatiblePerros = :tienePerros)
        AND (:nivelEnergia IS NULL OR m.nivelEnergia = :nivelEnergia)
        AND (:tamañoPreferido IS NULL OR m.tamañoRequerido = :tamañoPreferido)
        AND (:esHipoalergenico IS NULL OR m.esHipoalergenico = :esHipoalergenico)
        """)
    List<Mascota> filtrarPorCompatibilidad(
        @Param("tieneNinos") Boolean tieneNinos,
        @Param("tieneGatos") Boolean tieneGatos,
        @Param("tienePerros") Boolean tienePerros,
        @Param("nivelEnergia") String nivelEnergia,
        @Param("tamañoPreferido") String tamañoPreferido,
        @Param("esHipoalergenico") Boolean esHipoalergenico
    );
    ```
  
  - Crear método de servicio:
    ```java
    public List<Mascota> filtrarPorCompatibilidad(FiltroCompatibilidadDTO filtro) {
        return mascotaRepository.filtrarPorCompatibilidad(
            filtro.getTieneNinos(),
            filtro.getTieneGatos(),
            filtro.getTienePerros(),
            filtro.getNivelEnergia(),
            filtro.getTamañoPreferido(),
            filtro.getEsHipoalergenico()
        );
    }
    ```
  
  - Crear DTO:
    ```java
    @Data
    @NoArgsConstructor
    public class FiltroCompatibilidadDTO {
        private Boolean tieneNinos;
        private Boolean tieneGatos;
        private Boolean tienePerros;
        private String nivelEnergia;
        private String tamañoPreferido;
        private Boolean esHipoalergenico;
    }
    ```

- **Criterios de Aceptación:**
  - ✅ Query retorna solo mascotas disponibles
  - ✅ Todos los filtros son opcionales
  - ✅ Combinaciones de filtros funcionan
  - ✅ Performance es aceptable (<500ms)

---

**T.4.4 - Endpoint REST (4 horas)**

- **Objetivo:** Exponer API REST para búsqueda con filtros

- **Tareas Técnicas:**
  - Agregar en `MascotaController`:
    ```java
    @GetMapping("/filtrar")
    public ResponseEntity<List<MascotaDTO>> filtrarPorCompatibilidad(
        @RequestParam(required = false) Boolean tieneNinos,
        @RequestParam(required = false) Boolean tieneGatos,
        @RequestParam(required = false) Boolean tienePerros,
        @RequestParam(required = false) String nivelEnergia,
        @RequestParam(required = false) String tamaño,
        @RequestParam(required = false) Boolean hipoalergenico
    ) {
        FiltroCompatibilidadDTO filtro = FiltroCompatibilidadDTO.builder()
            .tieneNinos(tieneNinos)
            .tieneGatos(tieneGatos)
            .tienePerros(tienePerros)
            .nivelEnergia(nivelEnergia)
            .tamañoPreferido(tamaño)
            .esHipoalergenico(hipoalergenico)
            .build();
        
        List<Mascota> mascotas = mascotaService.filtrarPorCompatibilidad(filtro);
        return ResponseEntity.ok(mapToDTO(mascotas));
    }
    ```

- **Criterios de Aceptación:**
  - ✅ GET `/mascotas/filtrar?tieneNinos=true&nivelEnergia=Media` retorna resultados
  - ✅ Parámetros son opcionales
  - ✅ Response es pagination-ready

---

**T.4.5 - Interfaz Web de Filtros (8 horas)**

- **Objetivo:** Crear formulario interactivo con filtros

- **Tareas Técnicas:**
  - Crear/modificar `src/main/resources/templates/mascotas/filtrar.jsp`:
    ```html
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html>
    <head>
        <title>Buscar Mascota Compatible</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-5">
            <h2>🔍 Encuentra tu Mascota Ideal</h2>
            
            <div class="row">
                <!-- Filtros -->
                <div class="col-md-3">
                    <div class="card">
                        <div class="card-body">
                            <h5>Filtros de Compatibilidad</h5>
                            <form id="filtroForm">
                                <div class="mb-3">
                                    <label>¿Tienes niños?</label>
                                    <select class="form-select" name="tieneNinos">
                                        <option value="">Cualquiera</option>
                                        <option value="true">Sí</option>
                                        <option value="false">No</option>
                                    </select>
                                </div>
                                
                                <div class="mb-3">
                                    <label>¿Tienes gatos?</label>
                                    <select class="form-select" name="tieneGatos">
                                        <option value="">Cualquiera</option>
                                        <option value="true">Sí</option>
                                        <option value="false">No</option>
                                    </select>
                                </div>
                                
                                <div class="mb-3">
                                    <label>¿Tienes perros?</label>
                                    <select class="form-select" name="tienePerros">
                                        <option value="">Cualquiera</option>
                                        <option value="true">Sí</option>
                                        <option value="false">No</option>
                                    </select>
                                </div>
                                
                                <div class="mb-3">
                                    <label>Nivel de Energía</label>
                                    <select class="form-select" name="nivelEnergia">
                                        <option value="">Cualquiera</option>
                                        <option value="Baja">Baja</option>
                                        <option value="Media">Media</option>
                                        <option value="Alta">Alta</option>
                                    </select>
                                </div>
                                
                                <div class="mb-3">
                                    <label>Tamaño Preferido</label>
                                    <select class="form-select" name="tamaño">
                                        <option value="">Cualquiera</option>
                                        <option value="Pequeño">Pequeño</option>
                                        <option value="Mediano">Mediano</option>
                                        <option value="Grande">Grande</option>
                                    </select>
                                </div>
                                
                                <div class="mb-3 form-check">
                                    <input class="form-check-input" type="checkbox" name="hipoalergenico">
                                    <label class="form-check-label">Hipoalergénico</label>
                                </div>
                                
                                <button type="submit" class="btn btn-primary w-100">Buscar</button>
                                <button type="reset" class="btn btn-secondary w-100 mt-2">Limpiar</button>
                            </form>
                        </div>
                    </div>
                </div>
                
                <!-- Resultados -->
                <div class="col-md-9">
                    <div id="resultados"></div>
                </div>
            </div>
        </div>
        
        <script>
            document.getElementById('filtroForm').addEventListener('submit', async (e) => {
                e.preventDefault();
                const formData = new FormData(e.target);
                const params = new URLSearchParams(formData);
                const response = await fetch('/mascotas/filtrar?' + params);
                const mascotas = await response.json();
                renderizarResultados(mascotas);
            });
            
            function renderizarResultados(mascotas) {
                const html = mascotas.map(m => `
                    <div class="card mb-3">
                        <div class="row g-0">
                            <div class="col-md-4">
                                <img src="/static/imgs/mascota-${m.id}.jpg" class="img-fluid rounded-start">
                            </div>
                            <div class="col-md-8">
                                <div class="card-body">
                                    <h5 class="card-title">${m.nombre}</h5>
                                    <p>${m.tipo} - ${m.raza}</p>
                                    <button class="btn btn-primary" onclick="solicitarAdopcion(${m.id})">
                                        Solicitar Adopción
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                `).join('');
                document.getElementById('resultados').innerHTML = html;
            }
        </script>
    </body>
    </html>
    ```

- **Criterios de Aceptación:**
  - ✅ Todos los filtros funcionan sin F5
  - ✅ Resultados actualizan dinámicamente
  - ✅ Formulario es responsive
  - ✅ Botón "Limpiar" resetea todos los valores

---

## 🔄 Iteración 2: Engagement & Welfare Tracking (Semanas 3-4)

### 🎯 Objetivo de Valor
**Optimizar el cierre de la adopción y asegurar la supervivencia del proyecto mediante visibilidad, seguimiento y engagement post-adopción.**

### 📋 User Stories

---

### 📌 US.5 - Canal de Contacto WhatsApp (16 horas)

**Descripción:**  
Como Usuario, quiero contactar al refugio vía WhatsApp directamente desde mi solicitud para resolver dudas en tiempo real.

**Valor Comercial:** 16 horas ideales

#### 🔧 Desglose de Tareas Técnicas

**T.5.1 - Agregar Información de Contacto al Refugio (4 horas)**

- **Objetivo:** Centralizar teléfono y datos de contacto

- **Tareas Técnicas:**
  - Crear tabla de configuración:
    ```sql
    CREATE TABLE configuracion_refugio (
        id INT PRIMARY KEY,
        nombre VARCHAR(255),
        telefono_whatsapp VARCHAR(20),
        email_contacto VARCHAR(255),
        sitio_web VARCHAR(255),
        horario_atencion VARCHAR(100),
        zona_horaria VARCHAR(50)
    );
    ```
  
  - Agregar en `application.properties`:
    ```properties
    app.refugio.nombre=Paws & Home Sanctuary
    app.refugio.whatsapp=+34666777888
    app.refugio.email=adopciones@pawshome.com
    app.refugio.horario=Lunes-Viernes 09:00-18:00
    ```
  
  - Crear DTO `RefugioConfigDTO`

- **Criterios de Aceptación:**
  - ✅ Configuración centralizada y accesible
  - ✅ Propiedades loadean desde Spring Config

---

**T.5.2 - Crear Servicio de Generate WhatsApp Link (4 horas)**

- **Objetivo:** Generar URL de WhatsApp Web con mensaje pre-escrito

- **Tareas Técnicas:**
  - Crear servicio `WhatsAppService.java`:
    ```java
    @Service
    @RequiredArgsConstructor
    @Slf4j
    public class WhatsAppService {
        
        @Value("${app.refugio.whatsapp}")
        private String telefonoRefugio;
        
        public String generarLinkWhatsApp(Long solicitudId, String nombreSolicitante) {
            String mensaje = String.format(
                "Hola! Soy %s y tengo una consulta sobre mi solicitud de adopción #%d",
                nombreSolicitante,
                solicitudId
            );
            
            // URL encode del mensaje
            String mensajeEncoded = URLEncoder.encode(mensaje, StandardCharsets.UTF_8);
            
            // Generar URL de WhatsApp Web
            String whatsappUrl = String.format(
                "https://wa.me/%s?text=%s",
                telefonoRefugio.replaceAll("[^0-9]", ""),
                mensajeEncoded
            );
            
            log.debug("Link WhatsApp generado para solicitud: {}", solicitudId);
            return whatsappUrl;
        }
        
        public String generarLinkWhatsAppApp(Long solicitudId, String nombreSolicitante) {
            // Para abrir app de WhatsApp directamente en móvil
            String mensaje = String.format(
                "Hola! Soy %s y tengo una consulta sobre mi solicitud de adopción #%d",
                nombreSolicitante,
                solicitudId
            );
            
            String mensajeEncoded = URLEncoder.encode(mensaje, StandardCharsets.UTF_8);
            return String.format(
                "whatsapp://send?phone=%s&text=%s",
                telefonoRefugio.replaceAll("[^0-9]", ""),
                mensajeEncoded
            );
        }
    }
    ```

- **Criterios de Aceptación:**
  - ✅ URL generada es válida
  - ✅ Mensaje incluye datos de solicitud
  - ✅ Teléfono se valida correctamente

---

**T.5.3 - Endpoint REST de Contacto (4 horas)**

- **Objetivo:** Exponer endpoint GET que retorna link WhatsApp

- **Tareas Técnicas:**
  - Agregar en `SolicitudController`:
    ```java
    @GetMapping("/{id}/contactar-whatsapp")
    public ResponseEntity<Map<String, String>> generarLinkWhatsApp(
        @PathVariable Long id
    ) {
        Solicitud solicitud = solicitudService.obtenerPorId(id)
            .orElseThrow(() -> new ResourceNotFoundException("Solicitud no encontrada"));
        
        String linkWhatsApp = whatsAppService.generarLinkWhatsApp(
            solicitud.getId(),
            solicitud.getSolicitante().getNombre()
        );
        
        return ResponseEntity.ok(Map.of(
            "whatsappLink", linkWhatsApp,
            "mensaje", "Abre este link para contactar al refugio vía WhatsApp"
        ));
    }
    ```

- **Criterios de Aceptación:**
  - ✅ GET `/solicitudes/{id}/contactar-whatsapp` retorna link válido
  - ✅ Link abre WhatsApp Web en escritorio
  - ✅ Link abre app de WhatsApp en móvil

---

**T.5.4 - Botón en Frontend y Integración (4 horas)**

- **Objetivo:** Integrar botón de WhatsApp en vista de solicitud

- **Tareas Técnicas:**
  - Modificar `src/main/resources/templates/solicitudes/detalleSolicitud.jsp`:
    ```html
    <div class="contact-section">
        <h5>Contactar al Refugio</h5>
        <button class="btn btn-success" onclick="abrirWhatsApp(${solicitud.id})">
            <i class="fab fa-whatsapp"></i> Contactar por WhatsApp
        </button>
    </div>
    ```
  
  - JavaScript:
    ```javascript
    async function abrirWhatsApp(solicitudId) {
        const response = await fetch(`/solicitudes/${solicitudId}/contactar-whatsapp`);
        const data = await response.json();
        window.open(data.whatsappLink, '_blank');
    }
    ```

- **Criterios de Aceptación:**
  - ✅ Botón aparece en vista de solicitud
  - ✅ Click abre WhatsApp en nueva pestaña
  - ✅ Mensaje pre-llenado aparece

---

### 📌 US.6 - Dashboard de Métricas Avanzadas (32 horas)

**Descripción:**  
Como Admin, quiero ver métricas clave (tiempo de adopción, tasa de éxito, progreso de adopciones) en un dashboard avanzado para tomar decisiones estratégicas.

**Valor Comercial:** 32 horas ideales

#### 🔧 Desglose de Tareas Técnicas

**T.6.1 - Queries y Aggregations en Base de Datos (12 horas)**

- **Objetivo:** Crear queries optimizadas para métricas

- **Tareas Técnicas:**
  - Crear query para "Tiempo promedio de adopción":
    ```sql
    SELECT 
        AVG(DATEDIFF(a.fecha_adopcion, s.fecha_solicitud)) AS dias_promedio
    FROM adopciones a
    JOIN solicitudes s ON a.solicitud_id = s.id
    WHERE a.estado = 'Completada';
    ```
  
  - Crear query para "Tasa de éxito":
    ```sql
    SELECT 
        COUNT(CASE WHEN a.estado = 'Completada' THEN 1 END) * 100 / COUNT(*) AS tasa_exito
    FROM adopciones a;
    ```
  
  - Crear query para "Mascotas más solicitadas":
    ```sql
    SELECT m.nombre, COUNT(s.id) AS num_solicitudes
    FROM mascotas m
    LEFT JOIN solicitudes s ON m.id = s.mascota_id
    GROUP BY m.id, m.nombre
    ORDER BY num_solicitudes DESC
    LIMIT 10;
    ```
  
  - Crear método en `AdopcionRepository`:
    ```java
    @Query("""
        SELECT AVG(CAST(DATEDIFF(a.fechaAdopcion, a.solicitud.fechaSolicitud) AS DOUBLE))
        FROM Adopcion a
        WHERE a.estado = 'Completada'
        """)
    Double obtenerTiempoPromedioAdopcion();
    
    @Query("""
        SELECT COUNT(a) as total,
               SUM(CASE WHEN a.estado = 'Completada' THEN 1 ELSE 0 END) as exitosas
        FROM Adopcion a
        """)
    Object[] obtenerEstadisticasGlobales();
    
    @Query("""
        SELECT new map(
            m.nombre as nombre,
            COUNT(s) as solicitudes,
            m.id as mascotaId
        )
        FROM Mascota m
        LEFT JOIN m.solicitudes s
        GROUP BY m.id, m.nombre
        ORDER BY COUNT(s) DESC
        """)
    List<Map<String, Object>> obtenerMascotasMasSolicitadas();
    
    @Query("""
        SELECT new map(
            FUNCTION('MONTH', a.fechaAdopcion) as mes,
            COUNT(a) as cantidad
        )
        FROM Adopcion a
        WHERE a.estado = 'Completada'
        GROUP BY FUNCTION('MONTH', a.fechaAdopcion)
        ORDER BY FUNCTION('MONTH', a.fechaAdopcion)
        """)
    List<Map<String, Object>> obtenerAdopcionesPorMes();
    ```

- **Criterios de Aceptación:**
  - ✅ Queries retornan datos correctamente
  - ✅ Performance es acceptable (<1 segundo)
  - ✅ Resultados son agregados correctamente

---

**T.6.2 - Servicio de Cálculo de Métricas (8 horas)**

- **Objetivo:** Centralizar lógica de cálculo de métricas

- **Tareas Técnicas:**
  - Crear clase `MetricasService.java`:
    ```java
    @Service
    @RequiredArgsConstructor
    @Transactional(readOnly = true)
    public class MetricasService {
        
        private final AdopcionRepository adopcionRepository;
        private final SolicitudRepository solicitudRepository;
        private final MascotaRepository mascotaRepository;
        
        public DashboardMetricasDTO obtenerMetricasGlobales() {
            Double tiempoPromedio = adopcionRepository.obtenerTiempoPromedioAdopcion();
            Object[] estadisticas = adopcionRepository.obtenerEstadisticasGlobales();
            Long totalAdopciones = ((Number) estadisticas[0]).longValue();
            Long adoptacionesCompletadas = ((Number) estadisticas[1]).longValue();
            Double tasaExito = totalAdopciones > 0 ? (adoptacionesCompletadas * 100.0) / totalAdopciones : 0;
            
            Long totalSolicitudes = solicitudRepository.count();
            Long totalMascotas = mascotaRepository.count();
            Long mascotasDisponibles = mascotaRepository.countByEstado("Disponible");
            
            return DashboardMetricasDTO.builder()
                .tiempoPromedioAdopcion(tiempoPromedio != null ? tiempoPromedio.intValue() : 0)
                .tasaExito(tasaExito)
                .totalAdopciones(totalAdopciones)
                .totalSolicitudes(totalSolicitudes)
                .totalMascotas(totalMascotas)
                .mascotasDisponibles(mascotasDisponibles)
                .mascotasEnProceso(totalMascotas - mascotasDisponibles)
                .build();
        }
        
        public List<MascotaMasPopularDTO> obtenerMascotasMasPopulares() {
            return adopcionRepository.obtenerMascotasMasSolicitadas()
                .stream()
                .map(map -> new MascotaMasPopularDTO(
                    (String) map.get("nombre"),
                    ((Number) map.get("solicitudes")).longValue()
                ))
                .limit(10)
                .toList();
        }
        
        public List<AdopcionesPorMesDTO> obtenerTendenciaAdopciones() {
            return adopcionRepository.obtenerAdopcionesPorMes()
                .stream()
                .map(map -> new AdopcionesPorMesDTO(
                    ((Number) map.get("mes")).intValue(),
                    ((Number) map.get("cantidad")).longValue()
                ))
                .toList();
        }
    }
    ```
  
  - Crear DTO `DashboardMetricasDTO`:
    ```java
    @Data
    @AllArgsConstructor
    @Builder
    public class DashboardMetricasDTO {
        private Integer tiempoPromedioAdopcion; // en días
        private Double tasaExito; // porcentaje
        private Long totalAdopciones;
        private Long totalSolicitudes;
        private Long totalMascotas;
        private Long mascotasDisponibles;
        private Long mascotasEnProceso;
    }
    ```

- **Criterios de Aceptación:**
  - ✅ Métricas se calculan correctamente
  - ✅ DTO contiene todos los campos necesarios
  - ✅ Valores son números válidos (sin NaN/Infinity)

---

**T.6.3 - Integrar Chart.js/Recharts (12 horas)**

- **Objetivo:** Visualización de datos con gráficos interactivos

- **Tareas Técnicas:**
  - Agregar dependencia Chart.js en `pom.xml` (via WebJars):
    ```xml
    <dependency>
        <groupId>org.webjars</groupId>
        <artifactId>chartjs</artifactId>
        <version>3.9.1</version>
    </dependency>
    ```
  
  - Crear archivo `src/main/resources/static/js/dashboard-charts.js`:
    ```javascript
    // Gráfico de Tendencia de Adopciones (Línea)
    async function renderizarTendenciaAdopciones() {
        const response = await fetch('/api/metricas/tendencia-adopciones');
        const datos = await response.json();
        
        const ctx = document.getElementById('adoptionesChart').getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio'],
                datasets: [{
                    label: 'Adopciones Completadas',
                    data: datos.map(d => d.cantidad),
                    borderColor: '#28a745',
                    backgroundColor: 'rgba(40, 167, 69, 0.1)',
                    tension: 0.3,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    title: {
                        display: true,
                        text: 'Tendencia de Adopciones (últimos 6 meses)'
                    }
                }
            }
        });
    }
    
    // Gráfico de Mascotas Más Populares (Barra)
    async function renderizarMascotasPopulares() {
        const response = await fetch('/api/metricas/mascotas-populares');
        const mascotasTop = await response.json();
        
        const ctx = document.getElementById('popularesMascotasChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: mascotasTop.map(m => m.nombre),
                datasets: [{
                    label: 'Solicitudes de Adopción',
                    data: mascotasTop.map(m => m.solicitudes),
                    backgroundColor: '#007bff'
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    title: {
                        display: true,
                        text: 'Top 10 Mascotas Más Solicitadas'
                    }
                }
            }
        });
    }
    
    // Gráfico de Tasa de Éxito (Dona)
    async function renderizarTasaExito() {
        const response = await fetch('/api/metricas/globales');
        const metricas = await response.json();
        
        const ctx = document.getElementById('tasaExitoChart').getContext('2d');
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Exitosas', 'Pendientes/Rechazadas'],
                datasets: [{
                    data: [metricas.tasaExito, 100 - metricas.tasaExito],
                    backgroundColor: ['#28a745', '#e7e7e7']
                }]
            }
        });
    }
    
    // Inicializar al cargar la página
    document.addEventListener('DOMContentLoaded', () => {
        renderizarTendenciaAdopciones();
        renderizarMascotasPopulares();
        renderizarTasaExito();
    });
    ```
  
  - Crear endpoints en `AdminController`:
    ```java
    @RestController
    @RequestMapping("/api/metricas")
    @RequiredArgsConstructor
    public class MetricasController {
        
        private final MetricasService metricasService;
        
        @GetMapping("/globales")
        public ResponseEntity<DashboardMetricasDTO> obtenerMetricasGlobales() {
            return ResponseEntity.ok(metricasService.obtenerMetricasGlobales());
        }
        
        @GetMapping("/mascotas-populares")
        public ResponseEntity<List<MascotaMasPopularDTO>> obtenerMasPopulares() {
            return ResponseEntity.ok(metricasService.obtenerMascotasMasPopulares());
        }
        
        @GetMapping("/tendencia-adopciones")
        public ResponseEntity<List<AdopcionesPorMesDTO>> obtenerTendencia() {
            return ResponseEntity.ok(metricasService.obtenerTendenciaAdopciones());
        }
    }
    ```

- **Criterios de Aceptación:**
  - ✅ Gráficos se renderizan correctamente
  - ✅ Datos carguen dinámicamente desde API
  - ✅ Gráficos son responsivos
  - ✅ Leyendas y títulos visibles

---

**T.6.4 - Interfaz de Reportes Admin (8 horas)**

- **Objetivo:** Dashboard mejorado con todos los gráficos

- **Tareas Técnicas:**
  - Modificar `src/main/resources/templates/admin/dashboard.jsp`:
    ```html
    <div class="dashboard-container">
        <!-- Métricas Principales -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="metric-card">
                    <div class="card-value">${metricas.tiempoPromedioAdopcion}</div>
                    <div class="card-label">Días promedio de adopción</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="metric-card success">
                    <div class="card-value">${metricas.tasaExito}%</div>
                    <div class="card-label">Tasa de éxito</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="metric-card info">
                    <div class="card-value">${metricas.totalAdopciones}</div>
                    <div class="card-label">Adopciones completadas</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="metric-card warning">
                    <div class="card-value">${metricas.mascotasDisponibles}</div>
                    <div class="card-label">Mascotas disponibles</div>
                </div>
            </div>
        </div>
        
        <!-- Gráficos -->
        <div class="row">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-body">
                        <canvas id="adoptionesChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <canvas id="tasaExitoChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mt-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-body">
                        <canvas id="popularesMascotasChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="/webjars/chartjs/3.9.1/chart.min.js"></script>
    <script src="/static/js/dashboard-charts.js"></script>
    ```

- **Criterios de Aceptación:**
  - ✅ Dashboard carga todas las métricas
  - ✅ Gráficos son interactivos
  - ✅ Responsive en móvil
  - ✅ Actualización automática cada 5 minutos

---

### 📌 US.7 - Seguimiento Post-adopción (40 horas)

**Descripción:**  
Como Adoptante, quiero subir fotos y comentarios de seguimiento durante el primer mes para compartir el progreso con el refugio y recibir consejos expertos.

**Valor Comercial:** 40 horas ideales

#### 🔧 Desglose de Tareas Técnicas

**T.7.1 - Crear Tabla de Seguimiento en BD (4 horas)**

- **Objetivo:** Almacenar registros de seguimiento post-adopción

- **Tareas Técnicas:**
  - Crear tabla `seguimiento_adopcion`:
    ```sql
    CREATE TABLE seguimiento_adopcion (
        id BIGINT PRIMARY KEY AUTO_INCREMENT,
        adopcion_id BIGINT NOT NULL,
        fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        comentario VARCHAR(2000),
        estado_mascota VARCHAR(50), -- Feliz, Adaptándose, Con problemas
        salud_estado VARCHAR(255),
        comportamiento VARCHAR(2000),
        foto_id BIGINT,
        respuesta_admin VARCHAR(2000),
        fecha_respuesta_admin TIMESTAMP,
        FOREIGN KEY (adopcion_id) REFERENCES adopciones(id),
        FOREIGN KEY (foto_id) REFERENCES fotos(id),
        INDEX idx_adopcion (adopcion_id),
        INDEX idx_fecha (fecha_registro)
    );
    ```
  
  - Crear script de migración

- **Criterios de Aceptación:**
  - ✅ Tabla creada con relaciones correctas
  - ✅ Índices optimizan búsquedas

---

**T.7.2 - Crear Entidad y Repositorio (4 horas)**

- **Objetivo:** Mapear tabla a JPA

- **Tareas Técnicas:**
  - Crear entidad `SeguimientoAdopcion`:
    ```java
    @Entity
    @Table(name = "seguimiento_adopcion")
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public class SeguimientoAdopcion {
        @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long id;
        
        @ManyToOne(fetch = FetchType.LAZY)
        @JoinColumn(name = "adopcion_id", nullable = false)
        private Adopcion adopcion;
        
        @Column(name = "fecha_registro")
        private LocalDateTime fechaRegistro;
        
        @Size(max = 2000)
        private String comentario;
        
        @Column(name = "estado_mascota")
        private String estadoMascota;
        
        @Column(name = "salud_estado")
        @Size(max = 255)
        private String saludEstado;
        
        @Column(name = "comportamiento")
        @Size(max = 2000)
        private String comportamiento;
        
        @ManyToOne(fetch = FetchType.LAZY)
        @JoinColumn(name = "foto_id")
        private Foto foto;
        
        @Column(name = "respuesta_admin")
        @Size(max = 2000)
        private String respuestaAdmin;
        
        @Column(name = "fecha_respuesta_admin")
        private LocalDateTime fechaRespuestaAdmin;
        
        @PrePersist
        protected void onCreate() {
            if (fechaRegistro == null) {
                fechaRegistro = LocalDateTime.now();
            }
        }
    }
    ```
  
  - Crear repositorio

- **Criterios de Aceptación:**
  - ✅ Entidad mapea correctamente
  - ✅ Relaciones son lazy-loaded

---

**T.7.3 - Endpoint de Subida de Imágenes Múltiple (12 horas)**

- **Objetivo:** Permitir subida de múltiples fotos por seguimiento

- **Tareas Técnicas:**
  - Crear método en `SeguimientoService`:
    ```java
    @Transactional
    public SeguimientoAdopcion crearSeguimiento(
        Long adopcionId,
        String comentario,
        String estadoMascota,
        String saludEstado,
        String comportamiento,
        List<MultipartFile> fotos
    ) throws IOException {
        Adopcion adopcion = adopcionRepository.findById(adopcionId)
            .orElseThrow(() -> new ResourceNotFoundException("Adopción no encontrada"));
        
        SeguimientoAdopcion seguimiento = SeguimientoAdopcion.builder()
            .adopcion(adopcion)
            .comentario(comentario)
            .estadoMascota(estadoMascota)
            .saludEstado(saludEstado)
            .comportamiento(comportamiento)
            .build();
        
        // Procesar fotos
        if (fotos != null && !fotos.isEmpty()) {
            for (MultipartFile foto : fotos) {
                Foto fotoGuardada = guardarFoto(foto, adopcion.getMascota());
                // Guardar relación
            }
        }
        
        return seguimientoRepository.save(seguimiento);
    }
    
    private Foto guardarFoto(MultipartFile archivo, Mascota mascota) throws IOException {
        String nombreUnico = UUID.randomUUID() + "_" + archivo.getOriginalFilename();
        Path ruta = Path.of(uploadPath, "seguimientos", nombreUnico);
        Files.createDirectories(ruta.getParent());
        Files.write(ruta, archivo.getBytes());
        
        return Foto.builder()
            .mascota(mascota)
            .ruta(ruta.toString())
            .tipo("Seguimiento")
            .build();
    }
    ```
  
  - Crear endpoint REST:
    ```java
    @PostMapping("/{adopcionId}/seguimiento")
    public ResponseEntity<?> crearSeguimiento(
        @PathVariable Long adopcionId,
        @RequestParam String comentario,
        @RequestParam String estadoMascota,
        @RequestParam(required = false) String saludEstado,
        @RequestParam(required = false) String comportamiento,
        @RequestParam("fotos") List<MultipartFile> fotos
    ) {
        SeguimientoAdopcion seguimiento = seguimientoService.crearSeguimiento(
            adopcionId, comentario, estadoMascota, saludEstado, comportamiento, fotos
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(seguimiento);
    }
    ```

- **Criterios de Aceptación:**
  - ✅ Múltiples fotos se guardan correctamente
  - ✅ Datos del seguimiento se persisten
  - ✅ Response incluye resumen

---

**T.7.4 - Vista "Diario de Mascota" (12 horas)**

- **Objetivo:** Mostrar seguimiento cronológico e interactivo

- **Tareas Técnicas:**
  - Crear `src/main/resources/templates/adopciones/diario-mascota.jsp`:
    ```html
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <!DOCTYPE html>
    <html>
    <head>
        <title>Diario de ${mascota.nombre}</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .timeline {
                position: relative;
                padding: 20px 0;
            }
            
            .timeline-item {
                margin-bottom: 30px;
                position: relative;
                padding-left: 40px;
            }
            
            .timeline-item::before {
                content: '';
                position: absolute;
                left: -15px;
                top: 0;
                width: 30px;
                height: 30px;
                background: #28a745;
                border-radius: 50%;
                border: 3px solid #fff;
            }
            
            .timeline-item::after {
                content: '';
                position: absolute;
                left: -5px;
                top: 30px;
                width: 2px;
                height: 100%;
                background: #ccc;
            }
            
            .timeline-item:last-child::after {
                display: none;
            }
            
            .card-seguimiento {
                border-left: 4px solid #28a745;
                padding: 15px;
                background: #f8f9fa;
            }
        </style>
    </head>
    <body>
        <div class="container mt-5">
            <h2>📔 Diario de ${mascota.nombre}</h2>
            <p class="text-muted">Seguimiento desde la adopción</p>
            
            <div class="timeline">
                <c:forEach var="seguimiento" items="${seguimientos}">
                    <div class="timeline-item">
                        <div class="card card-seguimiento">
                            <div class="card-header">
                                <b><fmt:formatDate value="${seguimiento.fechaRegistro}" pattern="dd/MM/yyyy HH:mm"/></b>
                                <span class="badge bg-info">${seguimiento.estadoMascota}</span>
                            </div>
                            <div class="card-body">
                                <p>${seguimiento.comentario}</p>
                                <p><strong>Salud:</strong> ${seguimiento.saludEstado}</p>
                                <p><strong>Comportamiento:</strong> ${seguimiento.comportamiento}</p>
                                
                                <c:if test="${not empty seguimiento.foto}">
                                    <img src="/fotos/${seguimiento.foto.id}" class="img-fluid rounded" style="max-width: 300px;">
                                </c:if>
                                
                                <c:if test="${not empty seguimiento.respuestaAdmin}">
                                    <div class="alert alert-info mt-3">
                                        <strong>Respuesta del Refugio:</strong>
                                        <p>${seguimiento.respuestaAdmin}</p>
                                        <small><fmt:formatDate value="${seguimiento.fechaRespuestaAdmin}" pattern="dd/MM/yyyy HH:mm"/></small>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
            
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#agregarSeguimientoModal">
                <i class="fas fa-plus"></i> Agregar Seguimiento
            </button>
        </div>
        
        <!-- Modal para agregar seguimiento -->
        <div class="modal fade" id="agregarSeguimientoModal">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form id="formSeguimiento" enctype="multipart/form-data">
                        <div class="modal-header">
                            <h5 class="modal-title">Nuevo Seguimiento</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label>¿Cómo está ${mascota.nombre}?</label>
                                <select class="form-select" name="estadoMascota" required>
                                    <option value="Feliz">😊 Feliz</option>
                                    <option value="Adaptándose">🤔 Adaptándose</option>
                                    <option value="Con problemas">😟 Con problemas</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label>Comentario</label>
                                <textarea class="form-control" name="comentario" required></textarea>
                            </div>
                            <div class="mb-3">
                                <label>Estado de Salud</label>
                                <input type="text" class="form-control" name="saludEstado" placeholder="Ej: Energético, Come bien...">
                            </div>
                            <div class="mb-3">
                                <label>Fotos</label>
                                <input type="file" class="form-control" name="fotos" multiple accept="image/*">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                            <button type="submit" class="btn btn-primary">Guardar Seguimiento</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
    </html>
    ```

- **Criterios de Aceptación:**
  - ✅ Timeline renderiza correctamente
  - ✅ Fotos se muestran en cada seguimiento
  - ✅ Modal funciona para agregar nuevo seguimiento
  - ✅ Responsive en móvil

---

**T.7.5 - Alerta Automática a Admin (12 horas)**

- **Objetivo:** Notificar admin cuando hay seguimientos con problemas

- **Tareas Técnicas:**
  - Crear intervalo para verificar seguimientos problemáticos:
    ```java
    @Service
    @RequiredArgsConstructor
    @Slf4j
    public class AlertasService {
        
        private final SeguimientoRepository seguimientoRepository;
        private final EmailService emailService;
        
        @Scheduled(fixedRate = 3600000) // Cada hora
        public void verificarSeguimientosProblematicos() {
            List<SeguimientoAdopcion> problemáticos = seguimientoRepository
                .findByEstadoMascotaAndRespuestaAdminIsNull("Con problemas");
            
            for (SeguimientoAdopcion seg : problemáticos) {
                String asunto = "⚠️ ALERTA: Problema reportado en mascota " + 
                    seg.getAdopcion().getMascota().getNombre();
                
                String cuerpo = "El adoptante " + 
                    seg.getAdopcion().getSolicitante().getNombre() + 
                    " reportó problemas: " + seg.getComentario();
                
                emailService.enviarEmail(
                    "admin@pawshome.com",
                    asunto,
                    cuerpo,
                    true // HTML
                );
                
                log.warn("Alerta enviada para seguimiento problemático ID: {}", seg.getId());
            }
        }
    }
    ```
  
  - Agregar endpoint para responden admin:
    ```java
    @PostMapping("/{id}/responder")
    public ResponseEntity<?> responderSeguimiento(
        @PathVariable Long id,
        @RequestParam String respuesta
    ) {
        SeguimientoAdopcion seguimiento = seguimientoRepository.findById(id)
            .orElseThrow();
        
        seguimiento.setRespuestaAdmin(respuesta);
        seguimiento.setFechaRespuestaAdmin(LocalDateTime.now());
        
        return ResponseEntity.ok(seguimientoRepository.save(seguimiento));
    }
    ```

- **Criterios de Aceptación:**
  - ✅ Alertas se envían vía email
  - ✅ Solo para seguimientos sin respuesta
  - ✅ Admin puede responder

---

### 📌 US.8 - Sección "Finales Felices" (32 horas)

**Descripción:**  
Como Usuario, quiero ver una sección de "Finales Felices" con mascotas ya adoptadas y sus historias para inspirarme y confiar en el proceso.

**Valor Comercial:** 32 horas ideales

#### 🔧 Desglose de Tareas Técnicas

**T.8.1 - Crear Tabla para Historias de Adopción (4 horas)**

- **Objetivo:** Almacenar casos de éxito

- **Tareas Técnicas:**
  - Crear tabla `finales_felices`:
    ```sql
    CREATE TABLE finales_felices (
        id BIGINT PRIMARY KEY AUTO_INCREMENT,
        adopcion_id BIGINT NOT NULL UNIQUE,
        titulo VARCHAR(255) NOT NULL,
        descripcion VARCHAR(2000),
        foto_principal_id BIGINT,
        estado_publicacion VARCHAR(50), -- Borrador, Aprobado, Publicado
        fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        fecha_publicacion TIMESTAMP,
        numero_visualizaciones INT DEFAULT 0,
        destacado BOOLEAN DEFAULT false,
        FOREIGN KEY (adopcion_id) REFERENCES adopciones(id),
        FOREIGN KEY (foto_principal_id) REFERENCES fotos(id),
        INDEX idx_estado (estado_publicacion),
        INDEX idx_fecha_pub (fecha_publicacion)
    );
    ```

- **Criterios de Aceptación:**
  - ✅ Tabla creada con relaciones correctas
  - ✅ Índices optimizan búsquedas

---

**T.8.2 - CRUD Administrativo (12 horas)**

- **Objetivo:** Gestionar historias de adopción

- **Tareas Técnicas:**
  - Crear entidad `FinalFeliz`:
    ```java
    @Entity
    @Table(name = "finales_felices")
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public class FinalFeliz {
        @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long id;
        
        @OneToOne(fetch = FetchType.LAZY)
        @JoinColumn(name = "adopcion_id", nullable = false)
        private Adopcion adopcion;
        
        @NotBlank
        @Size(min = 10, max = 255)
        private String titulo;
        
        @Size(max = 2000)
        private String descripcion;
        
        @ManyToOne(fetch = FetchType.LAZY)
        @JoinColumn(name = "foto_principal_id")
        private Foto fotoPrincipal;
        
        @Column(name = "estado_publicacion")
        @Builder.Default
        private String estadoPublicacion = "Borrador";
        
        @Column(name = "fecha_creacion")
        private LocalDateTime fechaCreacion;
        
        @Column(name = "fecha_publicacion")
        private LocalDateTime fechaPublicacion;
        
        @Column(name = "numero_visualizaciones")
        @Builder.Default
        private Long numeroVisualizaciones = 0L;
        
        @Column(name = "destacado")
        @Builder.Default
        private Boolean destacado = false;
        
        @PrePersist
        protected void onCreate() {
            if (fechaCreacion == null) {
                fechaCreacion = LocalDateTime.now();
            }
        }
    }
    ```
  
  - Crear servicio `FinalFelizService`:
    ```java
    @Service
    @RequiredArgsConstructor
    @Transactional
    public class FinalFelizService {
        
        private final FinalFelizRepository finalFelizRepository;
        private final AdopcionRepository adopcionRepository;
        
        public FinalFeliz crearHistoria(Long adopcionId, String titulo, String descripcion, Long fotoId) {
            Adopcion adopcion = adopcionRepository.findById(adopcionId)
                .orElseThrow(() -> new ResourceNotFoundException("Adopción no encontrada"));
            
            FinalFeliz finalFeliz = FinalFeliz.builder()
                .adopcion(adopcion)
                .titulo(titulo)
                .descripcion(descripcion)
                .estadoPublicacion("Borrador")
                .build();
            
            return finalFelizRepository.save(finalFeliz);
        }
        
        public FinalFeliz publicarHistoria(Long id) {
            FinalFeliz finalFeliz = finalFelizRepository.findById(id)
                .orElseThrow();
            
            finalFeliz.setEstadoPublicacion("Publicado");
            finalFeliz.setFechaPublicacion(LocalDateTime.now());
            
            return finalFelizRepository.save(finalFeliz);
        }
        
        public void incrementarVisualizaciones(Long id) {
            FinalFeliz finalFeliz = finalFelizRepository.findById(id)
                .orElseThrow();
            finalFeliz.setNumeroVisualizaciones(finalFeliz.getNumeroVisualizaciones() + 1);
            finalFelizRepository.save(finalFeliz);
        }
    }
    ```
  
  - Crear controller admin:
    ```java
    @RestController
    @RequestMapping("/api/admin/finales-felices")
    @RequiredArgsConstructor
    public class FinalFelizAdminController {
        
        private final FinalFelizService finalFelizService;
        
        @PostMapping
        public ResponseEntity<?> crearHistoria(@RequestBody CrearFinalFelizDTO dto) {
            FinalFeliz finalFeliz = finalFelizService.crearHistoria(
                dto.getAdopcionId(),
                dto.getTitulo(),
                dto.getDescripcion(),
                dto.getFotoId()
            );
            return ResponseEntity.status(HttpStatus.CREATED).body(finalFeliz);
        }
        
        @PutMapping("/{id}/publicar")
        public ResponseEntity<?> publicarHistoria(@PathVariable Long id) {
            FinalFeliz finalFeliz = finalFelizService.publicarHistoria(id);
            return ResponseEntity.ok(finalFeliz);
        }
        
        @DeleteMapping("/{id}")
        public ResponseEntity<?> eliminarHistoria(@PathVariable Long id) {
            finalFelizService.eliminarHistoria(id);
            return ResponseEntity.noContent().build();
        }
    }
    ```

- **Criterios de Aceptación:**
  - ✅ Admin puede crear, editar, eliminar historias
  - ✅ Estados de publicación se respetan
  - ✅ CRUD completo funciona

---

**T.8.3 - Vista Pública de Finales Felices (12 horas)**

- **Objetivo:** Página pública mostrando historias de adopción

- **Tareas Técnicas:**
  - Crear endpoint público:
    ```java
    @RestController
    @RequestMapping("/api/finales-felices")
    @RequiredArgsConstructor
    public class FinalFelizPublicoController {
        
        private final FinalFelizService finalFelizService;
        
        @GetMapping
        public ResponseEntity<Page<FinalFelizDTO>> obtenerPublicadas(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "12") int size
        ) {
            Pageable pageable = PageRequest.of(page, size, Sort.by("fechaPublicacion").descending());
            Page<FinalFeliz> finales = finalFelizRepository.findByEstadoPublicacion("Publicado", pageable);
            return ResponseEntity.ok(finales.map(FinalFelizDTO::from));
        }
        
        @GetMapping("/destacadas")
        public ResponseEntity<List<FinalFelizDTO>> obtenerDestacadas() {
            List<FinalFeliz> destacadas = finalFelizRepository
                .findByEstadoPublicacionAndDestacadoOrderByFechaPublicacionDesc("Publicado", true);
            return ResponseEntity.ok(destacadas.stream().map(FinalFelizDTO::from).toList());
        }
        
        @GetMapping("/{id}")
        public ResponseEntity<FinalFelizDTO> obtenerHistoria(@PathVariable Long id) {
            FinalFeliz finalFeliz = finalFelizRepository.findById(id)
                .orElseThrow();
            finalFelizService.incrementarVisualizaciones(id);
            return ResponseEntity.ok(FinalFelizDTO.from(finalFeliz));
        }
    }
    ```
  
  - Crear JSP `src/main/resources/templates/finales-felices.jsp`:
    ```html
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Finales Felices - Paws & Home</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            .hero-section {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 60px 20px;
                text-align: center;
            }
            
            .historia-card {
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                height: 100%;
            }
            
            .historia-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            }
            
            .historia-imagen {
                height: 250px;
                object-fit: cover;
                border-radius: 8px 8px 0 0;
            }
            
            .destacada-badge {
                position: absolute;
                top: 10px;
                right: 10px;
                background: #ffc107;
                color: #000;
                padding: 5px 15px;
                border-radius: 20px;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <!-- Hero Section -->
        <div class="hero-section">
            <h1>✨ Finales Felices ✨</h1>
            <p class="lead">Historias inspiradoras de mascotas adoptadas que encontraron su hogar perfecto</p>
        </div>
        
        <div class="container my-5">
            <!-- Destacadas -->
            <div class="mb-5">
                <h3 class="mb-4">🌟 Historias Destacadas</h3>
                <div class="row">
                    <c:forEach var="historia" items="${destacadas}" varStatus="status">
                        <c:if test="${status.count <= 3}">
                            <div class="col-md-4 mb-4">
                                <div class="card historia-card">
                                    <div style="position: relative;">
                                        <img src="/fotos/${historia.fotoPrincipal.id}" class="historia-imagen">
                                        <div class="destacada-badge">⭐ Destacada</div>
                                    </div>
                                    <div class="card-body">
                                        <h5 class="card-title">${historia.titulo}</h5>
                                        <p class="card-text">${historia.descripcion.substring(0, Math.min(100, historia.descripcion.length()))}...</p>
                                        <a href="/finales-felices/${historia.id}" class="btn btn-primary btn-sm">Leer Más</a>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
            
            <!-- Todas las Historias -->
            <div>
                <h3 class="mb-4">📖 Todas las Historias</h3>
                <div class="row" id="historiasContainer"></div>
                <nav>
                    <ul class="pagination justify-content-center" id="paginacion"></ul>
                </nav>
            </div>
        </div>
        
        <script>
            async function cargarHistorias(page = 0) {
                const response = await fetch(`/api/finales-felices?page=${page}&size=12`);
                const data = await response.json();
                
                const html = data.content.map(h => `
                    <div class="col-md-4 mb-4">
                        <div class="card historia-card">
                            <img src="/fotos/${h.fotoPrincipal.id}" class="historia-imagen">
                            <div class="card-body">
                                <h5>${h.titulo}</h5>
                                <p>${h.descripcion.substring(0, 100)}...</p>
                                <a href="/finales-felices/${h.id}" class="btn btn-primary btn-sm">Leer Más</a>
                                <small class="text-muted d-block mt-2">
                                    👁️ ${h.numeroVisualizaciones} visualizaciones
                                </small>
                            </div>
                        </div>
                    </div>
                `).join('');
                
                document.getElementById('historiasContainer').innerHTML = html;
                
                // Paginación
                const paginationHtml = generarPaginacion(data.totalPages, page);
                document.getElementById('paginacion').innerHTML = paginationHtml;
            }
            
            function generarPaginacion(totalPages, currentPage) {
                let html = '';
                for (let i = 0; i < totalPages; i++) {
                    const active = i === currentPage ? 'active' : '';
                    html += `<li class="page-item ${active}"><a class="page-link" href="#" onclick="cargarHistorias(${i})">${i + 1}</a></li>`;
                }
                return html;
            }
            
            document.addEventListener('DOMContentLoaded', () => cargarHistorias());
        </script>
    </body>
    </html>
    ```

- **Criterios de Aceptación:**
  - ✅ Página carga historias paginadas
  - ✅ Destacadas se muestran especialmente
  - ✅ Contador de visualizaciones funciona
  - ✅ Responsive en móvil

---

**T.8.4 - Validar Responsive (4 horas)**

- **Objetivo:** Asegurar funcionalidad en todos los dispositivos

- **Tareas Técnicas:**
  - Pruebas en Chrome DevTools emulando:
    - iPhone 12 Pro
    - iPad Pro
    - Samsung Galaxy S21
    - Desktop 1920x1080
  
  - Validar CSS media queries
  - Optimizar imágenes para diferentes DPI
  - Verificar navegabilidad táctil

- **Criterios de Aceptación:**
  - ✅ Página se adapta a todos los tamaños
  - ✅ Texto legible en móvil
  - ✅ Botones son clickeables (mínimo 48x48px)
  - ✅ Imágenes se escalan correctamente

---

## 📊 Resumen de Horas por Iteración

### Iteración 1: Trust & Legal Foundation

| US | Feature | Horas Estimadas |
|----|---------|-----------------|
| US.1 | Gestión de Estados | 32h |
| US.2 | Documentación | 40h |
| US.3 | Contratos PDF | 32h |
| US.4 | Filtros Compatibilidad | 24h |
| **Total Iter. 1** | | **128h** |

### Iteración 2: Engagement & Welfare Tracking

| US | Feature | Horas Estimadas |
|----|---------|-----------------|
| US.5 | Canal WhatsApp | 16h |
| US.6 | Dashboard Métricas | 32h |
| US.7 | Seguimiento Post-adopción | 40h |
| US.8 | Finales Felices | 32h |
| **Total Iter. 2** | | **120h** |

---

## 🎯 Criterios de Aceptación Globales

- ✅ Todos los endpoints REST tienen documentación Swagger
- ✅ Cobertura de tests unitarios ≥75%
- ✅ Aplicación es responsive (mobile-first)
- ✅ Performance: cargas <2 segundos en conexión 3G
- ✅ Seguridad: HTTPS, validación de entrada, protección CSRF
- ✅ Accesibilidad: WCAG 2.1 AA compliant
- ✅ Base de datos: backups automáticos, migraciones versionadas
- ✅ CI/CD pipeline funcionando en GitHub Actions

---

## 🚀 Próximos Pasos Post-Release 1.0

- [ ] Implementar autenticación con JWT
- [ ] Agregar login social (Google, Facebook)
- [ ] Push notifications
- [ ] Integración con pasarelas de pago (donaciones)
- [ ] App móvil nativa (React Native)
- [ ] Traducción a múltiples idiomas (i18n)
- [ ] Analytics y tracking (Google Analytics)
- [ ] Módulo de voluntarios
- [ ] Sistema de rewards/gamificación

---

**Documento preparado por:** GitHub Copilot  
**Fecha:** Mayo 2026  
**Versión:** 1.0


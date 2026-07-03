# 🧪 Casos de Prueba - Sprints 4 y 5

## 📋 Información General

| Aspecto | Detalle |
|--------|---------|
| **Proyecto** | GR01 - Paws & Home |
| **Sprint 4** | Contratos y contacto con el refugio |
| **Sprint 5** | Bienestar post-adopción, estadísticas y reportes |
| **Historias cubiertas** | SCRUM-19 a SCRUM-26 (HU11 a HU18) |
| **Fecha de elaboración** | 2026-07-02 |
| **Base de verificación** | Código fuente y pruebas unitarias/integración actuales del repositorio (rama `Paws`) |

---

## 🎯 Historias de Usuario cubiertas

### Sprint 4
- **HU11** - Creación de contrato desde solicitud aprobada
- **HU12** - Autocompletado de datos en el contrato
- **HU13** - Descarga del contrato generado
- **HU14** - Contacto con el refugio por WhatsApp

### Sprint 5
- **HU15** - Registro de actualización de bienestar por adoptante
- **HU16** - Consulta de actualizaciones de bienestar por administrador
- **HU17** - Visualización de estadísticas generales del sistema
- **HU18** - Generación de reporte de mascotas registradas

---

## 📌 HU11 - Creación de contrato desde solicitud aprobada

#### **Descripción**
El sistema permite generar el contrato de adopción en PDF a partir de una `Solicitud` que se encuentra en estado **Aprobada**. Endpoint: `GET /solicitudes/{id}/contrato/descargar` (implementado en `SolicitudController`, delega en `ContratoService.generarContratoPDFDesdeSolicitud`).

#### **Pasos de Ejecución**

| # | Paso | Acción | Resultado Esperado |
|---|------|--------|---------------------|
| 1 | Solicitud aprobada existente | `GET /solicitudes/{id}/contrato/descargar` con `id` de una solicitud en estado `Aprobada` | HTTP 200, cuerpo `application/pdf` con contenido no vacío |
| 2 | Solicitud en otro estado | `GET /solicitudes/{id}/contrato/descargar` con solicitud en estado `Pendiente`, `En revisión`, `Rechazada` o `Cancelada` | HTTP 403 Forbidden, cuerpo: "El contrato solo puede descargarse si la solicitud ha sido aprobada" |
| 3 | Solicitud inexistente | `GET /solicitudes/9999/contrato/descargar` | HTTP 404 Not Found |
| 4 | Generación desde una Adopción ya creada | `GET /adopciones/{id}/contrato/descargar` con `id` de adopción existente | HTTP 200, cuerpo `application/pdf` (usa `ContratoService.generarContratoPDF`) |
| 5 | Adopción inexistente | `GET /adopciones/9999/contrato/descargar` | HTTP 404 Not Found |
| 6 | Número de contrato único | Descargar contrato dos veces para la misma solicitud | Cada PDF contiene un número de contrato distinto, formato `CONTRATO-SOL-{solicitudId}-{timestamp}` |
| 7 | Falla interna de generación | Forzar excepción en `ContratoService` (mock) | HTTP 500 Internal Server Error, cuerpo: "Error al generar el contrato: {mensaje}" |

**Criterios de Aceptación**
✅ Solo se genera el contrato si la solicitud está en estado `Aprobada`
✅ Solicitud no aprobada devuelve HTTP 403 con mensaje explicativo
✅ Solicitud inexistente devuelve HTTP 404
✅ El contrato también puede generarse desde una `Adopcion` ya procesada
✅ El número de contrato es único por generación (incluye timestamp)
✅ Errores internos devuelven HTTP 500 sin exponer stack trace al usuario

---

## 📌 HU12 - Autocompletado de datos en el contrato

#### **Descripción**
`AdopcionContratoMapper` completa automáticamente los datos del adoptante, la mascota y el refugio en el `ContratoDTO`, sin intervención manual, tomando la información desde `Solicitud`/`Adopcion`. Cuando una relación falta, se usa un valor por defecto en vez de fallar.

#### **Pasos de Ejecución**

| # | Paso | Acción | Resultado Esperado |
|---|------|--------|---------------------|
| 1 | Mapeo completo desde Solicitud | Invocar `toContratoDTODesdeSolicitud(solicitud)` con solicitante y mascota completos | DTO con `nombreAdoptante`, `cedulaAdoptante`, `emailAdoptante`, `telefonoAdoptante`, `nombreMascota`, `tipoMascota`, `razaMascota`, `edadMascota`, `descripcionMascota`, `colorMascota` autocompletados desde las entidades |
| 2 | Mapeo completo desde Adopción | Invocar `toContratoDTO(adopcion)` con solicitante y mascota completos | Mismos campos autocompletados, más `vacunasMascota` según `adopcion.vacunasAplicadas` |
| 3 | Vacunas aplicadas = true | `adopcion.vacunasAplicadas = true` | `vacunasMascota` = "Vacunas aplicadas y registradas" |
| 4 | Vacunas aplicadas = false/null | `adopcion.vacunasAplicadas = false` o `null` | `vacunasMascota` = "Vacunación pendiente - Se recomienda aplicar dentro de 7 días" |
| 5 | Solicitante nulo | `adopcion.solicitante = null` | `nombreAdoptante` = "Nombre no disponible", `cedulaAdoptante` = "---", `emailAdoptante` = "email@no-disponible.com", `telefonoAdoptante` = "No disponible" (no lanza excepción) |
| 6 | Mascota nula | `adopcion.mascota = null` | `nombreMascota` = "Mascota sin nombre", `tipoMascota` = "Tipo desconocido", `razaMascota` = "Raza desconocida", `edadMascota` = 0, `descripcionMascota` = "Sin descripción", `colorMascota` = "Color no especificado" |
| 7 | Adopción/Solicitud nula | `toContratoDTO(null)` / `toContratoDTODesdeSolicitud(null)` | `IllegalArgumentException`: "La adopción no puede ser nula" / "La solicitud no puede ser nula" |
| 8 | Datos del refugio | Cualquier mapeo | `nombreRefugio` y `representanteLegal` autocompletados desde configuración (`app.refugio.nombre`, `app.refugio.representante`), con valores por defecto "Paws & Home Sanctuary" y "Administración Refugio" |
| 9 | Fecha de generación | Cualquier mapeo | `fechaGeneracion` = fecha actual del sistema, formateada `dd/MM/yyyy` en el PDF |

**Criterios de Aceptación**
✅ Todos los campos del contrato se completan automáticamente sin captura manual
✅ Datos faltantes de solicitante o mascota usan valores por defecto legibles (no `null`, no excepción)
✅ El estado de vacunación se deriva del campo `vacunasAplicadas` de la adopción
✅ Adopción o solicitud nula produce error controlado (`IllegalArgumentException`), no `NullPointerException`
✅ Los datos del refugio provienen de configuración centralizada

---

## 📌 HU13 - Descarga del contrato generado

#### **Descripción**
El PDF del contrato se entrega como archivo adjunto descargable con cabeceras HTTP correctas, tanto desde una solicitud aprobada como desde una adopción.

#### **Pasos de Ejecución**

| # | Paso | Acción | Resultado Esperado |
|---|------|--------|---------------------|
| 1 | Descarga desde solicitud aprobada | `GET /solicitudes/{id}/contrato/descargar` | Header `Content-Type: application/pdf`; `Content-Disposition: attachment; filename="contrato_adopcion_solicitud_{id}.pdf"` |
| 2 | Descarga desde adopción | `GET /adopciones/{id}/contrato/descargar` | Header `Content-Type: application/pdf`; `Content-Disposition: attachment; filename="contrato_adopcion_{id}.pdf"` |
| 3 | Content-Length correcto | Comparar `Content-Length` con el tamaño real del arreglo de bytes devuelto | Coinciden exactamente |
| 4 | Obtener URL de descarga (AJAX) | `GET /adopciones/{id}/contrato/url` con adopción existente | HTTP 200, JSON `{ "url": "/adopciones/{id}/contrato/descargar", "nombreArchivo": "contrato_adopcion_{id}.pdf", "mensaje": "Descarga lista" }` |
| 5 | URL de descarga, adopción inexistente | `GET /adopciones/9999/contrato/url` | HTTP 404 Not Found |
| 6 | PDF generado vacío | Forzar que `ContratoService` devuelva `byte[0]` (mock) | HTTP 500 Internal Server Error, cuerpo: "Error: No se pudo generar el PDF del contrato" |
| 7 | Contenido binario válido | Abrir el PDF descargado con un lector de PDF | El archivo abre correctamente y contiene los datos del contrato (refugio, adoptante, mascota) |

**Criterios de Aceptación**
✅ El PDF se descarga con `Content-Type: application/pdf`
✅ El nombre de archivo sigue el patrón `contrato_adopcion_{id}.pdf` o `contrato_adopcion_solicitud_{id}.pdf`
✅ `Content-Length` refleja el tamaño real del PDF
✅ Existe endpoint auxiliar para obtener la URL de descarga sin disparar la generación del PDF
✅ Un PDF vacío o generación fallida se traduce en HTTP 500 con mensaje claro, nunca en un archivo corrupto

---

## 📌 HU14 - Contacto con el refugio por WhatsApp

#### **Descripción**
`WhatsAppLinkService` construye un enlace `https://wa.me/{numero}?text={mensaje}` con mensaje prellenado, mostrado como botón en el detalle de la solicitud del solicitante (`detalleSolicitud.jsp`), sin requerir API/SDK de WhatsApp.

#### **Pasos de Ejecución**

| # | Paso | Acción | Resultado Esperado |
|---|------|--------|---------------------|
| 1 | Ver detalle de solicitud propia | `GET /solicitudes/{id}` autenticado como el solicitante dueño | Página incluye botón "Contactar por WhatsApp" con `href` = URL `https://wa.me/...` y `target="_blank"` |
| 2 | Número de teléfono limpio | Configurar `app.refugio.whatsapp = "+34 666 777 888"` y generar enlace | URL comienza con `https://wa.me/34666777888?text=` (sin símbolos `+`, espacios ni guiones) |
| 3 | Mensaje con nombre y número de solicitud | `construirUrlContactoSolicitud(42L, "Ana López")` | El mensaje decodificado contiene "Ana López" y "#42" |
| 4 | Nombre de adoptante nulo | `construirUrlContactoSolicitud(1L, null)` | Usa valor por defecto "un adoptante" en el mensaje, no lanza excepción |
| 5 | Codificación de caracteres especiales | Mensaje con espacios y tildes, ej. "¿Cómo estás?" | La URL resultante no contiene espacios sin codificar y conserva el parámetro `text=` |
| 6 | Acceso a solicitud ajena | `GET /solicitudes/{id}` con `id` de una solicitud que no pertenece al solicitante autenticado | Redirige a `/solicitudes/mis-solicitudes` con mensaje de error; no se expone el enlace de WhatsApp de esa solicitud |

**Criterios de Aceptación**
✅ El enlace usa el esquema público `wa.me`, sin credenciales ni SDK de WhatsApp
✅ El número del refugio se normaliza a solo dígitos antes de construir la URL
✅ El mensaje incluye el nombre del adoptante y el número de la solicitud, correctamente codificado en URL
✅ Un nombre de adoptante ausente no rompe la generación del enlace
✅ El enlace solo se muestra al solicitante propietario de la solicitud

---

## 📌 HU15 - Registro de actualización de bienestar por adoptante

#### **Descripción**
Desde el detalle de su adopción (`GET /adopciones/{id}`), el adoptante autenticado registra el estado de bienestar de su mascota mediante `POST /adopciones/{id}/bienestar`, validando que sea el propietario de la adopción (`BienestarService.registrar`).

#### **Pasos de Ejecución**

| # | Paso | Acción | Resultado Esperado |
|---|------|--------|---------------------|
| 1 | Registro exitoso | `POST /adopciones/{id}/bienestar` con sesión de solicitante propietario, `estadoMascota=Feliz`, `comentario="Todo bien"` | HTTP 302 a `/adopciones/{id}` + flash "Actualización de bienestar registrada exitosamente"; se persiste con `fechaRegistro` autogenerada |
| 2 | Opciones válidas de estado | Enviar `estadoMascota` con cada valor del formulario: `Feliz`, `Adaptándose`, `Con problemas` | Los tres valores se guardan correctamente (`@NotBlank`, sin restricción de enum en backend) |
| 3 | Sin sesión activa | `POST /adopciones/{id}/bienestar` sin `solicitanteId` en sesión | HTTP 302 a `/adopciones/{id}` + flash "Debe iniciar sesión para registrar una actualización"; no se invoca `BienestarService` |
| 4 | Solicitante no propietario | `POST /adopciones/{id}/bienestar` con sesión de un solicitante distinto al dueño de la adopción | `AccessDeniedException` capturada → HTTP 302 a `/adopciones/{id}` + flash "No tienes permiso para registrar bienestar en esta adopción"; no se guarda el registro |
| 5 | Adopción inexistente | `POST /adopciones/9999/bienestar` con sesión válida | `IllegalArgumentException` ("Adopción no encontrada: 9999") capturada → HTTP 302 con flash de error, sin persistir |
| 6 | Comentario opcional | `POST /adopciones/{id}/bienestar` sin parámetro `comentario` | Se guarda la actualización con `comentario = null`, sin error |
| 7 | Comentario excede longitud | `comentario` con más de 1000 caracteres | Falla la restricción `@Size(max=1000)` a nivel de entidad al persistir |
| 8 | Visualización en el detalle | `GET /adopciones/{id}` tras registrar una actualización | El modelo incluye `actualizacionesBienestar` con la nueva actualización, ordenada por fecha descendente (más reciente primero) |

**Criterios de Aceptación**
✅ Solo el solicitante autenticado y propietario de la adopción puede registrar bienestar
✅ Falta de sesión y falta de permisos generan mensajes de error distintos y específicos
✅ `estadoMascota` es obligatorio; `comentario` es opcional
✅ Las actualizaciones se listan de la más reciente a la más antigua
✅ Ninguna violación de permisos persiste datos en la base

---

## 📌 HU16 - Consulta de actualizaciones de bienestar por administrador

#### **Descripción**
El administrador visualiza, en `GET /admin/bienestar`, todas las actualizaciones de bienestar registradas por los adoptantes (`BienestarService.listarTodas` → `findAllConDetalle`).

#### **Pasos de Ejecución**

| # | Paso | Acción | Resultado Esperado |
|---|------|--------|---------------------|
| 1 | Listado general | `GET /admin/bienestar` | HTTP 200, vista `admin/bienestar`, modelo con atributo `actualizaciones` conteniendo todas las actualizaciones registradas por cualquier adoptante |
| 2 | Sin actualizaciones registradas | `GET /admin/bienestar` cuando no existe ninguna actualización | HTTP 200, `actualizaciones` es una lista vacía (no null, no error) |
| 3 | Datos con detalle de relación | Verificar contenido de cada actualización listada | Incluye `estadoMascota`, `comentario`, `fechaRegistro` y datos de la adopción/mascota/adoptante asociados (vía `findAllConDetalle`) |
| 4 | Respuesta administrativa opcional | Invocar `BienestarService.responder(id, "Gracias por la actualización")` | Se actualizan `respuestaAdmin` y `fechaRespuestaAdmin` de la actualización correspondiente |
| 5 | Respuesta a actualización inexistente | `responder(9999, "texto")` | `IllegalArgumentException`: "Actualización no encontrada: 9999" |
| 6 | Consulta por adopción específica | `GET /adopciones/{id}` como administrador o dueño | El modelo expone `actualizacionesBienestar` filtradas para esa adopción únicamente |

**Criterios de Aceptación**
✅ El administrador puede ver todas las actualizaciones de bienestar de todos los adoptantes en una sola vista
✅ La ausencia de registros no genera error, se muestra lista vacía
✅ Cada actualización incluye suficiente contexto (mascota/adoptante) para que el administrador la identifique
✅ El administrador puede, opcionalmente, responder a una actualización sin afectar el listado general

---

## 📌 HU17 - Visualización de estadísticas generales del sistema

#### **Descripción**
`GET /admin/estadisticas` presenta un resumen agregando conteos de mascotas (`MascotaService`), solicitudes por estado, adopciones completadas, tasa de aprobación y la mascota más solicitada (`EstadisticasService`).

#### **Pasos de Ejecución**

| # | Paso | Acción | Resultado Esperado |
|---|------|--------|---------------------|
| 1 | Vista de estadísticas | `GET /admin/estadisticas` | HTTP 200, vista `admin/estadisticas`, modelo con `estadisticasGenerales` y `mascotaMasSolicitada` |
| 2 | Conteo de mascotas | Verificar `estadisticasGenerales` | Contiene `total`, `disponibles`, `adoptados`, `en_proceso` provenientes de `MascotaService.obtenerEstadisticas()` |
| 3 | Solicitudes por estado | Con 1 Pendiente, 0 En revisión, 2 Aprobada, 1 Rechazada, 0 Cancelada | `solicitudesPorEstado` = `{Pendiente:1, En revisión:0, Aprobada:2, Rechazada:1, Cancelada:0}`, `totalSolicitudes` = 4 |
| 4 | Tasa de aprobación calculada | Con los datos del paso 3 (2 aprobadas de 4 totales) | `tasaAprobacion` = 50.0 (redondeada a 1 decimal) |
| 5 | Tasa de aprobación sin solicitudes | Sin ninguna solicitud registrada | `tasaAprobacion` = 0.0 (sin división por cero) |
| 6 | Adopciones completadas | Con 2 adopciones completadas | `adopcionesCompletadas` = 2 |
| 7 | Mascota más solicitada presente | Existen solicitudes para varias mascotas | `mascotaMasSolicitada` = la mascota con mayor número de solicitudes (primer resultado de `findMascotasOrdenadasPorNumeroSolicitudes`) |
| 8 | Sin solicitudes registradas | No existe ninguna solicitud en el sistema | `mascotaMasSolicitada` = vacío; la vista muestra el bloque alternativo (sin mascota destacada) sin error |
| 9 | Renderizado en la vista | Revisar `admin/estadisticas.jsp` | Los valores `${estadisticasGenerales.total}`, `.disponibles}`, `.adopcionesCompletadas}`, `.tasaAprobacion}` y `.solicitudesPorEstado}` se muestran sin `null` visible (usan valor por defecto 0) |

**Criterios de Aceptación**
✅ Las estadísticas combinan datos de mascotas, solicitudes y adopciones en una sola consulta
✅ La tasa de aprobación se calcula como (solicitudes aprobadas / total solicitudes) × 100, redondeada a 1 decimal
✅ La tasa de aprobación es 0.0 cuando no hay solicitudes, sin lanzar `ArithmeticException`
✅ La mascota más solicitada se determina por número de solicitudes recibidas
✅ La ausencia de datos (sin mascotas, sin solicitudes) se maneja con valores vacíos/cero, no con errores

---

## 📌 HU18 - Generación de reporte de mascotas registradas

#### **Descripción**
El administrador visualiza (`GET /admin/reporte/mascotas`) y descarga en PDF (`GET /admin/reporte/mascotas/descargar`) el listado completo de mascotas registradas junto con estadísticas resumen (`ReporteService.generarReporteMascotasPDF`).

#### **Pasos de Ejecución**

| # | Paso | Acción | Resultado Esperado |
|---|------|--------|---------------------|
| 1 | Vista previa del reporte | `GET /admin/reporte/mascotas` | HTTP 200, vista `admin/reporteMascotas`, modelo con `mascotas` (listado completo) y `estadisticas` |
| 2 | Descarga del PDF | `GET /admin/reporte/mascotas/descargar` | HTTP 200, `Content-Type: application/pdf`, `Content-Disposition: attachment; filename="reporte_mascotas_{fecha_actual}.pdf"` |
| 3 | Content-Length correcto | Comparar `Content-Length` con el tamaño real del PDF devuelto | Coinciden exactamente |
| 4 | Contenido del reporte | Abrir el PDF descargado | Incluye el listado de todas las mascotas registradas, estadísticas resumen y fecha de generación (`dd/MM/yyyy`) |
| 5 | Sistema sin mascotas registradas | `GET /admin/reporte/mascotas/descargar` cuando no hay mascotas | HTTP 200, PDF generado igualmente (listado vacío, estadísticas en cero), sin error 500 |
| 6 | Nombre de archivo con fecha del día | Descargar el reporte en la fecha actual | El nombre de archivo incluye la fecha en formato `yyyy-MM-dd` (`LocalDate.now()`) |

**Criterios de Aceptación**
✅ El reporte de mascotas se genera en formato PDF descargable
✅ El PDF incluye tanto el listado detallado como estadísticas resumen
✅ El nombre del archivo incluye la fecha de generación
✅ Un sistema sin mascotas registradas no impide generar el reporte (reporte vacío, sin error)
✅ La vista previa en HTML y el PDF descargado usan la misma fuente de datos (`MascotaService`), evitando inconsistencias

---

## ✅ Resumen de Trazabilidad

| Historia | Endpoint(s) principal(es) | Clase de servicio | Cobertura de prueba unitaria existente |
|----------|---------------------------|--------------------|------------------------------------------|
| HU11 | `GET /solicitudes/{id}/contrato/descargar`, `GET /adopciones/{id}/contrato/descargar` | `ContratoService` | `ContratoServiceTest` |
| HU12 | (interno, usado por HU11/HU13) | `AdopcionContratoMapper` | `AdopcionContratoMapperTest` |
| HU13 | `GET /adopciones/{id}/contrato/descargar`, `GET /adopciones/{id}/contrato/url` | `ContratoService`, `AdopcionController` | `ContratoServiceTest`, `AdopcionControllerTest` |
| HU14 | `GET /solicitudes/{id}` (botón WhatsApp) | `WhatsAppLinkService` | `WhatsAppLinkServiceTest` |
| HU15 | `POST /adopciones/{id}/bienestar` | `BienestarService` | `BienestarServiceTest`, `AdopcionControllerTest` |
| HU16 | `GET /admin/bienestar` | `BienestarService` | `BienestarServiceTest`, `AdminControllerTest` |
| HU17 | `GET /admin/estadisticas` | `EstadisticasService` | `EstadisticasServiceTest`, `AdminControllerTest` |
| HU18 | `GET /admin/reporte/mascotas`, `GET /admin/reporte/mascotas/descargar` | `ReporteService` | `ReporteServiceTest`, `AdminControllerTest` |

> Todos los casos de prueba descritos están alineados con el comportamiento verificado en el código fuente actual (controladores, servicios y pruebas unitarias/integración) de la rama `Paws`, por lo que se espera que se cumplan sin requerir cambios adicionales en la implementación.

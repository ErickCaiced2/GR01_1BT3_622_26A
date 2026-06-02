package com.example.gr01_1bt3_622_26a.controller;

import com.example.gr01_1bt3_622_26a.entity.Solicitud;
import com.example.gr01_1bt3_622_26a.entity.Solicitante;
import com.example.gr01_1bt3_622_26a.entity.Mascota;
import com.example.gr01_1bt3_622_26a.service.SolicitudService;
import com.example.gr01_1bt3_622_26a.service.SolicitanteService;
import com.example.gr01_1bt3_622_26a.service.MascotaService;
import com.example.gr01_1bt3_622_26a.service.ContratoService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/solicitudes")
@RequiredArgsConstructor
@Slf4j
public class SolicitudController {
    
    private final SolicitudService solicitudService;
    private final SolicitanteService solicitanteService;
    private final MascotaService mascotaService;
    private final ContratoService contratoService;

    @GetMapping("/formulario")
    public String mostrarFormulario(
            @RequestParam(value = "mascotaId", required = false) Long mascotaId,
            Model model) {

        Mascota mascotaPreSeleccionada = null;

        // Si viene mascotaId en la URL, pre-cargar la mascota
        if (mascotaId != null) {
            Optional<Mascota> mascotaOpt = mascotaService.obtenerPorId(mascotaId);
            if (mascotaOpt.isPresent()) {
                mascotaPreSeleccionada = mascotaOpt.get();
                log.info("Mascota pre-seleccionada: {} (ID: {})", mascotaPreSeleccionada.getNombre(), mascotaId);
            }
        }

        // Crear una nueva solicitud con la mascota pre-seleccionada si es aplicable
        Solicitud solicitud = new Solicitud();
        if (mascotaPreSeleccionada != null) {
            // Inicializar la mascota en la solicitud
            solicitud.setMascota(mascotaPreSeleccionada);
        }

        // Agregar datos al modelo
        if (mascotaPreSeleccionada != null) {
            // Si hay mascota pre-seleccionada, NO incluir lista de mascotas
            model.addAttribute("mascotaPreSeleccionada", mascotaPreSeleccionada);
            model.addAttribute("tieneMascotaPreSeleccionada", true);
        } else {
            // Si no hay pre-selección, mostrar lista de mascotas disponibles
            List<Mascota> mascotas = mascotaService.obtenerDisponibles();
            model.addAttribute("mascotas", mascotas);
            model.addAttribute("tieneMascotaPreSeleccionada", false);
        }

        model.addAttribute("solicitud", solicitud);
        return "solicitudes/formularioSolicitud";
    }
    
    /**
     * TAREA 3: Proteger endpoint POST /solicitudes/crear
     * TAREA 4: Agregar validación con BindingResult
     * TAREA 5: Obtener solicitante desde HttpSession
     *
     * Crea una nueva solicitud de adopción validando todos los campos.
     * El ID del solicitante se obtiene de la sesión del usuario (TAREA 3 - Seguridad)
     * para evitar que alguien envíe solicitudes en nombre de otro usuario.
     *
     * @param solicitud Objeto con datos del formulario, validado con anotaciones.
     * @param bindingResult Captura errores de validación (TAREA 4)
     * @param session Sesión HTTP para obtener solicitar desde usuario autenticado (TAREA 3)
     * @param redirectAttributes Para pasar mensajes de éxito/error
     * @return Vista de redirección con resultado
     */
    @PostMapping("/crear")
    public String crearSolicitud(
            @Valid @ModelAttribute("solicitud") Solicitud solicitud,
            BindingResult bindingResult,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        log.info("Intento de crear solicitud");

        // TAREA 4: Validar errores de validación del formulario
        if (bindingResult.hasErrors()) {
            log.warn("Errores de validación en formulario de solicitud: {}", bindingResult.getAllErrors());
            // El formulario se vuelve a mostrar con los errores
            return "solicitudes/formularioSolicitud";
        }

        // TAREA 3: Obtener solicitante de la sesión (seguridad)
        Long solicitanteId = (Long) session.getAttribute("solicitanteId");

        if (solicitanteId == null) {
            log.warn("Intento de crear solicitud sin sesión de usuario");
            redirectAttributes.addFlashAttribute("error", "Debe iniciar sesión para crear una solicitud");
            return "redirect:/solicitudes/formulario";
        }

        Optional<Solicitante> solicitante = solicitanteService.obtenerPorId(solicitanteId);
        Optional<Mascota> mascota = mascotaService.obtenerPorId(solicitud.getMascota().getId());

        if (solicitante.isPresent() && mascota.isPresent()) {
            solicitud.setSolicitante(solicitante.get());
            solicitud.setMascota(mascota.get());

            try {
                Solicitud savedSolicitud = solicitudService.crearSolicitud(solicitud);
                log.info("Solicitud creada exitosamente: {}", savedSolicitud.getId());
                redirectAttributes.addFlashAttribute("mensaje", "Solicitud creada exitosamente");
                return "redirect:/solicitudes/" + savedSolicitud.getId();
            } catch (Exception e) {
                log.error("Error al crear solicitud", e);
                redirectAttributes.addFlashAttribute("error", "Error al procesar la solicitud");
                return "redirect:/solicitudes/formulario";
            }
        }
        
        log.warn("Solicitante o Mascota no encontrados");
        redirectAttributes.addFlashAttribute("error", "Error al crear la solicitud");
        return "redirect:/solicitudes/formulario";
    }
    
    /**
     * TAREA 1: Listar solicitudes asociadas al solicitante
     *
     * Obtiene todas las solicitudes del usuario autenticado desde la sesión.
     * Implementa el método obtenerSolicitudesDelSolicitante del servicio.
     *
     * @param session Sesión HTTP del usuario autenticado
     * @param model Modelo para pasar datos a la vista
     * @return Vista con lista de solicitudes del solicitante
     */
    @GetMapping("/mis-solicitudes")
    public String listarMisSolicitudes(HttpSession session, Model model) {
        Long solicitanteId = (Long) session.getAttribute("solicitanteId");

        if (solicitanteId == null) {
            log.warn("Intento de acceder a solicitudes sin sesión de usuario");
            return "redirect:/login";
        }

        log.info("Listando solicitudes del solicitante: {}", solicitanteId);
        List<Solicitud> solicitudes = solicitudService.obtenerSolicitudesDelSolicitante(solicitanteId);

        model.addAttribute("solicitudes", solicitudes);
        model.addAttribute("titulo", "Mis Solicitudes");
        return "solicitudes/listaSolicitudes";
    }

    /**
     * TAREA 2: Consultar el detalle de una solicitud específica
     *
     * Obtiene el detalle de una solicitud validando que el solicitante sea el propietario.
     * Implementa el método obtenerDetalleSolicitud del servicio con validación de seguridad.
     *
     * Modificación: Ahora valida que el solicitante sea el propietario de la solicitud
     * antes de mostrar el detalle.
     *
     * @param id ID de la solicitud
     * @param session Sesión HTTP para validar propietario
     * @param model Modelo para pasar datos a la vista
     * @param redirectAttributes Para pasar mensajes de error
     * @return Vista del detalle si es propietario, redirección en otro caso
     */
    @GetMapping("/{id}")
    public String verDetalle(
            @PathVariable Long id,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) {

        Long solicitanteId = (Long) session.getAttribute("solicitanteId");

        if (solicitanteId == null) {
            log.warn("Intento de ver solicitud sin sesión de usuario");
            return "redirect:/login";
        }

        log.info("Consultando detalle de solicitud {} para solicitante {}", id, solicitanteId);

        // TAREA 2: Usar obtenerDetalleSolicitud que valida propietario
        Optional<Solicitud> solicitud = solicitudService.obtenerDetalleSolicitud(id, solicitanteId);

        if (solicitud.isPresent()) {
            model.addAttribute("solicitud", solicitud.get());
            return "solicitudes/detalleSolicitud";
        }

        log.warn("Solicitud {} no encontrada o solicitante {} no es el propietario", id, solicitanteId);
        redirectAttributes.addFlashAttribute("error", "No tienes permiso para ver esta solicitud");
        return "redirect:/solicitudes/mis-solicitudes";
    }
    
    @GetMapping("/pendientes/lista")
    public String listarPendientes(Model model) {
        List<Solicitud> pendientes = solicitudService.obtenerPorEstado("Pendiente");
        model.addAttribute("solicitudes", pendientes);
        model.addAttribute("titulo", "Solicitudes Pendientes");
        return "solicitudes/listaSolicitudes";
    }
    
    @GetMapping("/solicitante/{solicitanteId}")
    public String listarSolicitante(@PathVariable Long solicitanteId, Model model) {
        List<Solicitud> solicitudes = solicitudService.obtenerPorSolicitante(solicitanteId);
        model.addAttribute("solicitudes", solicitudes);
        return "solicitudes/listaSolicitudes";
    }
    
    @PostMapping("/{id}/aprobar")
    public ResponseEntity<?> aprobarSolicitud(@PathVariable Long id,
                                   @RequestParam(required = false) String observaciones) {
        try {
            Solicitud solicitud = solicitudService.aprobarSolicitud(id, observaciones != null ? observaciones : "");
            if (solicitud != null) {
                log.info("Solicitud {} aprobada exitosamente", id);
                Map<String, String> response = new HashMap<>();
                response.put("mensaje", "Solicitud aprobada exitosamente");
                return ResponseEntity.ok(response);
            }
        } catch (Exception e) {
            log.error("Error al aprobar solicitud {}: {}", id, e.getMessage());
            Map<String, String> error = new HashMap<>();
            error.put("error", "Error al aprobar solicitud: " + e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
        Map<String, String> error = new HashMap<>();
        error.put("error", "No se pudo aprobar la solicitud");
        return ResponseEntity.badRequest().body(error);
    }
    
    @PostMapping("/{id}/rechazar")
    public ResponseEntity<?> rechazarSolicitud(@PathVariable Long id,
                                   @RequestParam String razon) {
        try {
            if (razon == null || razon.trim().isEmpty()) {
                log.warn("Intento de rechazar solicitud {} sin razón", id);
                Map<String, String> error = new HashMap<>();
                error.put("error", "Debes proporcionar una razón para rechazar");
                return ResponseEntity.badRequest().body(error);
            }

            Solicitud solicitud = solicitudService.rechazarSolicitud(id, razon);
            if (solicitud != null) {
                log.info("Solicitud {} rechazada exitosamente", id);
                Map<String, String> response = new HashMap<>();
                response.put("mensaje", "Solicitud rechazada exitosamente");
                return ResponseEntity.ok(response);
            }
        } catch (Exception e) {
            log.error("Error al rechazar solicitud {}: {}", id, e.getMessage());
            Map<String, String> error = new HashMap<>();
            error.put("error", "Error al rechazar solicitud: " + e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
        Map<String, String> error = new HashMap<>();
        error.put("error", "No se pudo rechazar la solicitud");
        return ResponseEntity.badRequest().body(error);
    }

    @PostMapping("/{id}/enviar-a-revision")
    public ResponseEntity<?> enviarARevision(@PathVariable Long id,
                                 @RequestParam(required = false) String observaciones) {
        try {
            log.info("Enviando solicitud {} a revisión", id);

            // Obtener la solicitud actual
            Optional<Solicitud> solicitudOpt = solicitudService.obtenerPorId(id);
            if (solicitudOpt.isEmpty()) {
                log.warn("Solicitud {} no encontrada", id);
                Map<String, String> error = new HashMap<>();
                error.put("error", "Solicitud no encontrada");
                return ResponseEntity.badRequest().body(error);
            }

            Solicitud solicitud = solicitudOpt.get();
            solicitud.setEstado("En revisión");
            if (observaciones != null && !observaciones.trim().isEmpty()) {
                solicitud.setObservaciones(observaciones);
            }

            solicitudService.actualizarSolicitud(solicitud);
            log.info("Solicitud {} enviada a revisión exitosamente", id);
            Map<String, String> response = new HashMap<>();
            response.put("mensaje", "Solicitud enviada a revisión exitosamente");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("Error al enviar solicitud {} a revisión: {}", id, e.getMessage());
            Map<String, String> error = new HashMap<>();
            error.put("error", "Error al enviar a revisión: " + e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }

    /**
     * Descarga el contrato PDF de una solicitud aprobada
     *
     * Endpoint: GET /solicitudes/{id}/contrato/descargar
     * Solo permite descargar si la solicitud está Aprobada
     *
     * @param id ID de la solicitud
     * @return PDF del contrato o error 404/403
     */
    @GetMapping("/{id}/contrato/descargar")
    public ResponseEntity<?> descargarContratoSolicitud(@PathVariable Long id) {
        log.info("Solicitud de descarga de contrato para solicitud ID: {}", id);

        try {
            // Verificar que la solicitud existe
            Optional<Solicitud> solicitudOpt = solicitudService.obtenerPorId(id);
            if (solicitudOpt.isEmpty()) {
                log.warn("Intento de descargar contrato para solicitud inexistente: {}", id);
                return ResponseEntity.notFound().build();
            }

            Solicitud solicitud = solicitudOpt.get();

            // Verificar que esté aprobada
            if (!"Aprobada".equals(solicitud.getEstado())) {
                log.warn("Intento de descargar contrato para solicitud no aprobada. ID: {}, Estado: {}",
                    id, solicitud.getEstado());
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body("El contrato solo puede descargarse si la solicitud ha sido aprobada");
            }

            // Para generar el PDF de la solicitud, usamos el método que referencia a una adopción
            // Si no existe adopción, generamos desde la solicitud directamente
            byte[] pdfContent = contratoService.generarContratoPDFDesdeSolicitud(id);

            if (pdfContent == null || pdfContent.length == 0) {
                log.error("PDF generado vacío para solicitud ID: {}", id);
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error: No se pudo generar el PDF del contrato");
            }

            // Construir headers HTTP
            String nombreArchivo = String.format("contrato_adopcion_solicitud_%d.pdf", id);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_PDF);
            headers.setContentDispositionFormData("attachment", nombreArchivo);
            headers.setContentLength(pdfContent.length);

            log.info("Contrato PDF descargado para solicitud ID: {} - Tamaño: {} bytes",
                id, pdfContent.length);

            return ResponseEntity.ok()
                    .headers(headers)
                    .body(pdfContent);

        } catch (RuntimeException e) {
            log.error("Error al descargar contrato para solicitud ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error al generar el contrato: " + e.getMessage());
        }
    }

    /**
     * Obtiene los datos de una solicitud en formato JSON para mostrar en modal
     *
     * Endpoint: GET /solicitudes/{id}/api/detalle
     * @param id ID de la solicitud
     * @return JSON con datos de la solicitud
     */
    @GetMapping("/{id}/api/detalle")
    @ResponseBody
    public ResponseEntity<?> obtenerDetalleSolicitudAPI(@PathVariable Long id) {
        try {
            Optional<Solicitud> solicitudOpt = solicitudService.obtenerPorId(id);
            if (solicitudOpt.isEmpty()) {
                log.warn("Solicitud {} no encontrada", id);
                return ResponseEntity.notFound().build();
            }

            Solicitud solicitud = solicitudOpt.get();
            Map<String, Object> response = new HashMap<>();

            // Datos de la solicitud
            response.put("id", solicitud.getId());
            response.put("estado", solicitud.getEstado());
            response.put("motivo", solicitud.getMotivo());
            response.put("numeroMascotas", solicitud.getNumeroMascotas());
            response.put("tipoVivienda", solicitud.getTipoVivienda());
            response.put("tieneJardin", solicitud.getTieneJardin());
            response.put("fechaSolicitud", solicitud.getFechaSolicitud());

            // Datos del solicitante
            Map<String, Object> solicitanteMap = new HashMap<>();
            if (solicitud.getSolicitante() != null) {
                Solicitante sol = solicitud.getSolicitante();
                solicitanteMap.put("nombre", sol.getNombre());
                solicitanteMap.put("apellido", sol.getApellido());
                solicitanteMap.put("email", sol.getEmail());
                solicitanteMap.put("telefono", sol.getTelefono());
                solicitanteMap.put("tipoDocumento", sol.getTipoDocumento());
                solicitanteMap.put("documentoIdentidad", sol.getDocumentoIdentidad());
                solicitanteMap.put("direccion", sol.getDireccion());
                solicitanteMap.put("ciudad", sol.getCiudad());
            }
            response.put("solicitante", solicitanteMap);

            // Datos de la mascota
            Map<String, Object> mascotaMap = new HashMap<>();
            if (solicitud.getMascota() != null) {
                Mascota mac = solicitud.getMascota();
                mascotaMap.put("nombre", mac.getNombre());
                mascotaMap.put("tipo", mac.getTipo());
                mascotaMap.put("raza", mac.getRaza());
                mascotaMap.put("edad", mac.getEdad());
            }
            response.put("mascota", mascotaMap);

            log.info("Detalle de solicitud {} obtenido exitosamente", id);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("Error al obtener detalle de solicitud {}: {}", id, e.getMessage());
            Map<String, String> error = new HashMap<>();
            error.put("error", "Error al obtener detalle de solicitud");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }
}

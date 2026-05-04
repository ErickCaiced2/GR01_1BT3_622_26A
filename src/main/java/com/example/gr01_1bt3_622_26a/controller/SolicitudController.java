package com.example.gr01_1bt3_622_26a.controller;

import com.example.gr01_1bt3_622_26a.entity.Solicitud;
import com.example.gr01_1bt3_622_26a.entity.Solicitante;
import com.example.gr01_1bt3_622_26a.entity.Mascota;
import com.example.gr01_1bt3_622_26a.service.SolicitudService;
import com.example.gr01_1bt3_622_26a.service.SolicitanteService;
import com.example.gr01_1bt3_622_26a.service.MascotaService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/solicitudes")
@RequiredArgsConstructor
@Slf4j
public class SolicitudController {
    
    private final SolicitudService solicitudService;
    private final SolicitanteService solicitanteService;
    private final MascotaService mascotaService;
    
    @GetMapping("/formulario")
    public String mostrarFormulario(Model model) {
        List<Mascota> mascotas = mascotaService.obtenerDisponibles();
        model.addAttribute("mascotas", mascotas);
        if (!model.containsAttribute("solicitud")) {
            model.addAttribute("solicitud", new Solicitud());
        }
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
    public String aprobarSolicitud(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        Solicitud solicitud = solicitudService.aprobarSolicitud(id);
        if (solicitud != null) {
            redirectAttributes.addFlashAttribute("mensaje", "Solicitud aprobada exitosamente");
        }
        return "redirect:/solicitudes/" + id;
    }
    
    @PostMapping("/{id}/rechazar")
    public String rechazarSolicitud(@PathVariable Long id, @RequestParam String razon, RedirectAttributes redirectAttributes) {
        Solicitud solicitud = solicitudService.rechazarSolicitud(id, razon);
        if (solicitud != null) {
            redirectAttributes.addFlashAttribute("mensaje", "Solicitud rechazada");
        }
        return "redirect:/solicitudes/" + id;
    }
}


package com.example.gr01_1bt3_622_26a.controller;

import com.example.gr01_1bt3_622_26a.entity.Mascota;
import com.example.gr01_1bt3_622_26a.entity.Solicitud;
import com.example.gr01_1bt3_622_26a.service.MascotaService;
import com.example.gr01_1bt3_622_26a.service.SolicitudService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;

/**
 * Controlador para el panel de administracion
 */
@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
@Slf4j
public class AdminController {

    private static final String ESTADO_EN_REVISION = "En revisión";
    private static final List<String> ESTADOS_DISPONIBLES = List.of(
            "Pendiente",
            "En revisión",
            "Aprobada",
            "Rechazada",
            "Cancelada"
    );

    private final MascotaService mascotaService;
    private final SolicitudService solicitudService;

    /**
     * Dashboard principal de administracion
     */
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        log.info("Accediendo al dashboard de administracion");

        Map<String, Long> estadisticas = mascotaService.obtenerEstadisticas();
        List<Solicitud> solicitudesEnRevision = solicitudService.obtenerPorEstado(ESTADO_EN_REVISION);

        model.addAttribute("totalMascotas", estadisticas.get("total"));
        model.addAttribute("mascotasDisponiblesCount", estadisticas.get("disponibles"));
        model.addAttribute("mascotasAdoptadas", estadisticas.get("adoptados"));
        model.addAttribute("mascotasEnProceso", estadisticas.get("en_proceso"));
        model.addAttribute("mascotas", mascotaService.obtenerTodasLasMascotas());
        model.addAttribute("solicitudesPendientes", solicitudesEnRevision.stream().limit(10).toList());
        model.addAttribute("solicitudesPendientesCount", solicitudesEnRevision.size());

        return "admin/dashboard";
    }

    /**
     * Reporte de mascotas
     */
    @GetMapping("/reporte/mascotas")
    public String reporteMascotas(Model model) {
        log.info("Accediendo al reporte de mascotas");

        List<Mascota> mascotas = mascotaService.obtenerTodasLasMascotas();
        Map<String, Long> estadisticas = mascotaService.obtenerEstadisticas();

        model.addAttribute("mascotas", mascotas);
        model.addAttribute("estadisticas", estadisticas);

        return "admin/reporteMascotas";
    }

    @GetMapping("/solicitudes/gestionar")
    public String gestionarEstados(
            @RequestParam(defaultValue = ESTADO_EN_REVISION) String estado,
            @RequestParam(required = false) String fecha,
            @RequestParam(required = false) String solicitante,
            Model model) {

        log.info("Accediendo a gestion de solicitudes con filtros estado={}, fecha={}, solicitante={}",
                estado, fecha, solicitante);

        List<Solicitud> solicitudes = solicitudService.obtenerPorEstado(estado);
        List<Solicitud> filtradas = solicitudes.stream()
                .filter(solicitud -> coincideFecha(solicitud, fecha))
                .filter(solicitud -> coincideSolicitante(solicitud, solicitante))
                .toList();

        model.addAttribute("solicitudes", filtradas);
        model.addAttribute("estadoSeleccionado", estado);
        model.addAttribute("fechaSeleccionada", fecha);
        model.addAttribute("solicitanteSeleccionado", solicitante);
        model.addAttribute("estadosDisponibles", ESTADOS_DISPONIBLES);

        return "solicitudes/gestionar-estados";
    }

    private boolean coincideFecha(Solicitud solicitud, String fecha) {
        if (fecha == null || fecha.isBlank()) {
            return true;
        }

        LocalDateTime fechaSolicitud = solicitud.getFechaSolicitud();
        return fechaSolicitud != null && fechaSolicitud.toLocalDate().toString().equals(fecha.trim());
    }

    private boolean coincideSolicitante(Solicitud solicitud, String solicitante) {
        if (solicitante == null || solicitante.isBlank()) {
            return true;
        }

        String criterio = solicitante.trim().toLowerCase();
        String nombre = solicitud.getSolicitante() != null && solicitud.getSolicitante().getNombre() != null
                ? solicitud.getSolicitante().getNombre().toLowerCase()
                : "";
        String email = solicitud.getSolicitante() != null && solicitud.getSolicitante().getEmail() != null
                ? solicitud.getSolicitante().getEmail().toLowerCase()
                : "";

        return Stream.of(nombre, email)
                .anyMatch(valor -> valor.contains(criterio));
    }
}

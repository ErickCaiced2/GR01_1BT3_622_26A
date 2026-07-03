package com.example.gr01_1bt3_622_26a.controller;

import com.example.gr01_1bt3_622_26a.entity.ActualizacionBienestar;
import com.example.gr01_1bt3_622_26a.entity.DocumentoSolicitante;
import com.example.gr01_1bt3_622_26a.entity.Mascota;
import com.example.gr01_1bt3_622_26a.entity.Solicitud;
import com.example.gr01_1bt3_622_26a.service.BienestarService;
import com.example.gr01_1bt3_622_26a.service.DocumentoService;
import com.example.gr01_1bt3_622_26a.service.EstadisticasService;
import com.example.gr01_1bt3_622_26a.service.MascotaService;
import com.example.gr01_1bt3_622_26a.service.ReporteService;
import com.example.gr01_1bt3_622_26a.service.SolicitudService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collections;
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
    private final DocumentoService documentoService;
    private final BienestarService bienestarService;
    private final EstadisticasService estadisticasService;
    private final ReporteService reporteService;

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
    /**
     * Vista admin para revisar documentos de un solicitante (HU9, HU10)
     */
    @GetMapping("/documentos")
    public String verDocumentosSolicitante(
            @RequestParam(required = false) Long solicitanteId,
            Model model) {

        log.info("Vista admin documentos, solicitanteId={}", solicitanteId);

        model.addAttribute("solicitanteId", solicitanteId);

        List<DocumentoSolicitante> documentos = solicitanteId != null
                ? documentoService.obtenerPorSolicitante(solicitanteId)
                : Collections.emptyList();

        model.addAttribute("documentos", documentos);

        return "admin/documentos";
    }

    /**
     * HU16: Vista admin con todas las actualizaciones de bienestar reportadas
     * por los adoptantes.
     */
    @GetMapping("/bienestar")
    public String bienestar(Model model) {
        log.info("Accediendo a actualizaciones de bienestar");

        List<ActualizacionBienestar> actualizaciones = bienestarService.listarTodas();
        model.addAttribute("actualizaciones", actualizaciones);

        return "admin/bienestar";
    }

    /**
     * HU17: Vista dedicada de estadísticas generales del sistema (mascotas,
     * solicitudes por estado, adopciones y tasa de aprobación).
     */
    @GetMapping("/estadisticas")
    public String estadisticas(Model model) {
        log.info("Accediendo a estadísticas generales del sistema");

        model.addAttribute("estadisticasGenerales", estadisticasService.obtenerEstadisticasGenerales());
        model.addAttribute("mascotaMasSolicitada", estadisticasService.obtenerMascotaMasSolicitada().orElse(null));

        return "admin/estadisticas";
    }

    @GetMapping("/reporte/mascotas")
    public String reporteMascotas(Model model) {
        log.info("Accediendo al reporte de mascotas");

        List<Mascota> mascotas = mascotaService.obtenerTodasLasMascotas();
        Map<String, Long> estadisticas = mascotaService.obtenerEstadisticas();

        model.addAttribute("mascotas", mascotas);
        model.addAttribute("estadisticas", estadisticas);

        return "admin/reporteMascotas";
    }

    /**
     * HU18: Genera y descarga el reporte de mascotas registradas en formato PDF.
     */
    @GetMapping("/reporte/mascotas/descargar")
    public ResponseEntity<byte[]> descargarReporteMascotasPDF() {
        log.info("Solicitud de descarga del reporte de mascotas en PDF");

        byte[] pdfContent = reporteService.generarReporteMascotasPDF();
        String nombreArchivo = "reporte_mascotas_" + LocalDate.now() + ".pdf";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_PDF);
        headers.setContentDispositionFormData("attachment", nombreArchivo);
        headers.setContentLength(pdfContent.length);

        return ResponseEntity.ok().headers(headers).body(pdfContent);
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

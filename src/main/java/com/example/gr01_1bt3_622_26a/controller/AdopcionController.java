package com.example.gr01_1bt3_622_26a.controller;

import com.example.gr01_1bt3_622_26a.entity.Adopcion;
import com.example.gr01_1bt3_622_26a.entity.Solicitud;
import com.example.gr01_1bt3_622_26a.entity.Solicitante;
import com.example.gr01_1bt3_622_26a.entity.Mascota;
import com.example.gr01_1bt3_622_26a.service.AdopcionService;
import com.example.gr01_1bt3_622_26a.service.SolicitudService;
import com.example.gr01_1bt3_622_26a.service.SolicitanteService;
import com.example.gr01_1bt3_622_26a.service.MascotaService;
import com.example.gr01_1bt3_622_26a.service.ContratoService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/adopciones")
@RequiredArgsConstructor
@Slf4j
public class AdopcionController {

    private final AdopcionService adopcionService;
    private final SolicitudService solicitudService;
    private final SolicitanteService solicitanteService;
    private final MascotaService mascotaService;
    private final ContratoService contratoService;

    @PostMapping("/procesar/{solicitudId}")
    public String procesarAdopcion(@PathVariable Long solicitudId, RedirectAttributes redirectAttributes) {
        Optional<Solicitud> solicitud = solicitudService.obtenerPorId(solicitudId);

        if (solicitud.isPresent() && "Aprobada".equals(solicitud.get().getEstado())) {
            Adopcion adopcion = Adopcion.builder()
                    .solicitante(solicitud.get().getSolicitante())
                    .mascota(solicitud.get().getMascota())
                    .solicitud(solicitud.get())
                    .build();

            Adopcion savedAdopcion = adopcionService.crearAdopcion(adopcion);
            redirectAttributes.addFlashAttribute("mensaje", "Adopción procesada exitosamente");
            return "redirect:/adopciones/" + savedAdopcion.getId();
        }

        redirectAttributes.addFlashAttribute("error", "No se puede procesar esta adopción");
        return "redirect:/solicitudes/" + solicitudId;
    }

    @GetMapping("/{id}")
    public String verDetalle(@PathVariable Long id, Model model) {
        Optional<Adopcion> adopcion = adopcionService.obtenerPorId(id);
        if (adopcion.isPresent()) {
            model.addAttribute("adopcion", adopcion.get());
            return "adopciones/detalleAdopcion";
        }
        return "redirect:/";
    }

    @GetMapping("/completadas/lista")
    public String listarCompletadas(Model model) {
        List<Adopcion> completadas = adopcionService.obtenerCompletadas();
        model.addAttribute("adopciones", completadas);
        model.addAttribute("titulo", "Adopciones Completadas");
        return "adopciones/listaAdopciones";
    }

    @GetMapping("/solicitante/{solicitanteId}")
    public String listarSolicitante(@PathVariable Long solicitanteId, Model model) {
        List<Adopcion> adopciones = adopcionService.obtenerAdopcionesCompledasSolicitante(solicitanteId);
        model.addAttribute("adopciones", adopciones);
        return "adopciones/listaAdopciones";
    }

    @PostMapping("/{id}/completar")
    public String completarAdopcion(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        Adopcion adopcion = adopcionService.completarAdopcion(id);
        if (adopcion != null) {
            redirectAttributes.addFlashAttribute("mensaje", "Adopción completada exitosamente");
        }
        return "redirect:/adopciones/" + id;
    }

    @PostMapping("/{id}/actualizar")
    public String actualizarAdopcion(
            @PathVariable Long id,
            @RequestParam(required = false) Boolean contratoFirmado,
            @RequestParam(required = false) Boolean vacunasAplicadas,
            @RequestParam(required = false) Boolean desparasitacion,
            @RequestParam(required = false) Boolean microchipColocado,
            @RequestParam(required = false) String observaciones,
            RedirectAttributes redirectAttributes) {

        Optional<Adopcion> adopcionOpt = adopcionService.obtenerPorId(id);
        if (adopcionOpt.isPresent()) {
            Adopcion adopcion = adopcionOpt.get();

            if (contratoFirmado != null) adopcion.setContratoFirmado(contratoFirmado);
            if (vacunasAplicadas != null) adopcion.setVacunasAplicadas(vacunasAplicadas);
            if (desparasitacion != null) adopcion.setDesparasitacion(desparasitacion);
            if (microchipColocado != null) adopcion.setMicrochipColocado(microchipColocado);
            if (observaciones != null) adopcion.setObservaciones(observaciones);

            adopcionService.actualizarAdopcion(adopcion);
            redirectAttributes.addFlashAttribute("mensaje", "Adopción actualizada exitosamente");
        }

        return "redirect:/adopciones/" + id;
    }

    @GetMapping("/lista")
    public String listarTodas(Model model) {
        List<Adopcion> adopciones = adopcionService.obtenerTodas();
        model.addAttribute("adopciones", adopciones);
        return "adopciones/listaAdopciones";
    }

    /**
     * Genera y descarga el contrato PDF de una adopción
     *
     * Endpoint REST: GET /adopciones/{id}/contrato/descargar
     * Response: PDF binario con headers apropiados
     *
     * @param id ID de la adopción
     * @return ResponseEntity con PDF o error 404
     */
    @GetMapping("/{id}/contrato/descargar")
    public ResponseEntity<?> descargarContratoPDF(@PathVariable Long id) {
        log.info("Solicitud de descarga de contrato para adopción ID: {}", id);

        try {
            // Verificar que la adopción existe
            Optional<Adopcion> adopcionOpt = adopcionService.obtenerPorId(id);
            if (adopcionOpt.isEmpty()) {
                log.warn("Intento de descargar contrato para adopción inexistente: {}", id);
                return ResponseEntity.notFound().build();
            }

            // Generar PDF
            byte[] pdfContent = contratoService.generarContratoPDF(id);

            if (pdfContent == null || pdfContent.length == 0) {
                log.error("PDF generado vacío para adopción ID: {}", id);
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error: No se pudo generar el PDF del contrato");
            }

            // Construir headers HTTP
            String nombreArchivo = String.format("contrato_adopcion_%d.pdf", id);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_PDF);
            headers.setContentDispositionFormData("attachment", nombreArchivo);
            headers.setContentLength(pdfContent.length);

            log.info("Contrato PDF descargado para adopción ID: {} - Tamaño: {} bytes",
                id, pdfContent.length);

            return ResponseEntity.ok()
                    .headers(headers)
                    .body(pdfContent);

        } catch (RuntimeException e) {
            log.error("Error al descargar contrato para adopción ID: {}", id, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error al generar el contrato: " + e.getMessage());
        }
    }

    /**
     * Endpoint REST adicional para obtener la URL de descarga (útil para AJAX)
     *
     * @param id ID de la adopción
     * @return URL de descarga o error
     */
    @GetMapping("/{id}/contrato/url")
    @ResponseBody
    public ResponseEntity<?> obtenerURLContratoDescarga(@PathVariable Long id) {
        log.debug("Solicitud de URL de descarga para adopción ID: {}", id);

        Optional<Adopcion> adopcionOpt = adopcionService.obtenerPorId(id);
        if (adopcionOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        String url = String.format("/adopciones/%d/contrato/descargar", id);
        return ResponseEntity.ok().body(
            java.util.Map.of(
                "url", url,
                "nombreArchivo", String.format("contrato_adopcion_%d.pdf", id),
                "mensaje", "Descarga lista"
            )
        );
    }
}


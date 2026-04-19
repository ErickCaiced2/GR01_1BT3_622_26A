package com.example.gr01_1bt3_622_26a.controller;

import com.example.gr01_1bt3_622_26a.entity.Adopcion;
import com.example.gr01_1bt3_622_26a.entity.Solicitud;
import com.example.gr01_1bt3_622_26a.entity.Solicitante;
import com.example.gr01_1bt3_622_26a.entity.Mascota;
import com.example.gr01_1bt3_622_26a.service.AdopcionService;
import com.example.gr01_1bt3_622_26a.service.SolicitudService;
import com.example.gr01_1bt3_622_26a.service.SolicitanteService;
import com.example.gr01_1bt3_622_26a.service.MascotaService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/adopciones")
@RequiredArgsConstructor
public class AdopcionController {

    private final AdopcionService adopcionService;
    private final SolicitudService solicitudService;
    private final SolicitanteService solicitanteService;
    private final MascotaService mascotaService;

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
}


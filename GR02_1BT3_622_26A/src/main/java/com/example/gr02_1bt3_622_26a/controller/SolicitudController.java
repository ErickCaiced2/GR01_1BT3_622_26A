package com.example.gr02_1bt3_622_26a.controller;

import com.example.gr02_1bt3_622_26a.entity.Solicitud;
import com.example.gr02_1bt3_622_26a.entity.Solicitante;
import com.example.gr02_1bt3_622_26a.entity.Mascota;
import com.example.gr02_1bt3_622_26a.service.SolicitudService;
import com.example.gr02_1bt3_622_26a.service.SolicitanteService;
import com.example.gr02_1bt3_622_26a.service.MascotaService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/solicitudes")
@RequiredArgsConstructor
public class SolicitudController {
    
    private final SolicitudService solicitudService;
    private final SolicitanteService solicitanteService;
    private final MascotaService mascotaService;
    
    @GetMapping("/formulario")
    public String mostrarFormulario(Model model) {
        List<Mascota> mascotas = mascotaService.obtenerDisponibles();
        model.addAttribute("mascotas", mascotas);
        model.addAttribute("solicitud", new Solicitud());
        return "solicitudes/formularioSolicitud";
    }
    
    @PostMapping("/crear")
    public String crearSolicitud(
            @RequestParam Long solicitanteId,
            @RequestParam Long mascotaId,
            @RequestParam String motivo,
            @RequestParam Integer numeroMascotas,
            @RequestParam String tipoVivienda,
            @RequestParam(required = false) Boolean tieneJardin,
            RedirectAttributes redirectAttributes) {
        
        Optional<Solicitante> solicitante = solicitanteService.obtenerPorId(solicitanteId);
        Optional<Mascota> mascota = mascotaService.obtenerPorId(mascotaId);
        
        if (solicitante.isPresent() && mascota.isPresent()) {
            Solicitud solicitud = Solicitud.builder()
                    .solicitante(solicitante.get())
                    .mascota(mascota.get())
                    .motivo(motivo)
                    .numeroMascotas(numeroMascotas)
                    .tipoVivienda(tipoVivienda)
                    .tieneJardin(tieneJardin)
                    .build();
            
            Solicitud savedSolicitud = solicitudService.crearSolicitud(solicitud);
            redirectAttributes.addFlashAttribute("mensaje", "Solicitud creada exitosamente");
            return "redirect:/solicitudes/" + savedSolicitud.getId();
        }
        
        redirectAttributes.addFlashAttribute("error", "Error al crear la solicitud");
        return "redirect:/solicitudes/formulario";
    }
    
    @GetMapping("/{id}")
    public String verDetalle(@PathVariable Long id, Model model) {
        Optional<Solicitud> solicitud = solicitudService.obtenerPorId(id);
        if (solicitud.isPresent()) {
            model.addAttribute("solicitud", solicitud.get());
            return "solicitudes/detalleSolicitud";
        }
        return "redirect:/";
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


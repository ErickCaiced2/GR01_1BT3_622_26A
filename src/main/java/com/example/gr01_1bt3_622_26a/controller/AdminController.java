package com.example.gr01_1bt3_622_26a.controller;

import com.example.gr01_1bt3_622_26a.entity.Mascota;
import com.example.gr01_1bt3_622_26a.service.MascotaService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Map;

/**
 * Controlador para el panel de administración
 */
@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
@Slf4j
public class AdminController {

    private final MascotaService mascotaService;

    /**
     * Dashboard principal de administración
     */
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        log.info("Accediendo al dashboard de administración");

        Map<String, Long> estadisticas = mascotaService.obtenerEstadisticas();
        model.addAttribute("totalMascotas", estadisticas.get("total"));
        model.addAttribute("mascotasDisponiblesCount", estadisticas.get("disponibles"));
        model.addAttribute("mascotasAdoptadas", estadisticas.get("adoptados"));
        model.addAttribute("mascotasEnProceso", estadisticas.get("en_proceso"));
        model.addAttribute("mascotas", mascotaService.obtenerTodasLasMascotas());

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
}


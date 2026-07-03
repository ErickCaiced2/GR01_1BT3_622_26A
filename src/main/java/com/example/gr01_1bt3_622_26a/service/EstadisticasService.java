package com.example.gr01_1bt3_622_26a.service;

import com.example.gr01_1bt3_622_26a.entity.Mascota;
import com.example.gr01_1bt3_622_26a.repository.SolicitudRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * HU17: Servicio de estadísticas generales del sistema.
 * Reutiliza los servicios/repositorios existentes de mascotas, solicitudes y
 * adopciones para agregar métricas sin duplicar lógica de conteo.
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class EstadisticasService {

    private static final List<String> ESTADOS_SOLICITUD = List.of(
            "Pendiente", "En revisión", "Aprobada", "Rechazada", "Cancelada"
    );

    private final MascotaService mascotaService;
    private final SolicitudService solicitudService;
    private final AdopcionService adopcionService;
    private final SolicitudRepository solicitudRepository;

    /**
     * Agrega estadísticas generales del sistema: mascotas, solicitudes por estado
     * y adopciones/tasa de aprobación.
     */
    public Map<String, Object> obtenerEstadisticasGenerales() {
        log.info("Calculando estadísticas generales del sistema");

        Map<String, Object> estadisticas = new LinkedHashMap<>();

        // Estadísticas de mascotas (reutiliza MascotaService.obtenerEstadisticas())
        estadisticas.putAll(mascotaService.obtenerEstadisticas());

        // Solicitudes por estado
        Map<String, Integer> solicitudesPorEstado = new LinkedHashMap<>();
        int totalSolicitudes = 0;
        for (String estado : ESTADOS_SOLICITUD) {
            int cantidad = solicitudService.obtenerPorEstado(estado).size();
            solicitudesPorEstado.put(estado, cantidad);
            totalSolicitudes += cantidad;
        }
        estadisticas.put("solicitudesPorEstado", solicitudesPorEstado);
        estadisticas.put("totalSolicitudes", totalSolicitudes);

        // Adopciones completadas y tasa de aprobación
        int adopcionesCompletadas = adopcionService.obtenerCompletadas().size();
        int solicitudesAprobadas = solicitudesPorEstado.getOrDefault("Aprobada", 0);
        double tasaAprobacion = totalSolicitudes > 0
                ? (solicitudesAprobadas * 100.0) / totalSolicitudes
                : 0.0;

        estadisticas.put("adopcionesCompletadas", adopcionesCompletadas);
        estadisticas.put("tasaAprobacion", Math.round(tasaAprobacion * 10.0) / 10.0);

        return estadisticas;
    }

    /**
     * Mascota con mayor número de solicitudes recibidas, si existe alguna.
     */
    public Optional<Mascota> obtenerMascotaMasSolicitada() {
        List<Mascota> mascotas = solicitudRepository.findMascotasOrdenadasPorNumeroSolicitudes();
        return mascotas.isEmpty() ? Optional.empty() : Optional.of(mascotas.get(0));
    }
}

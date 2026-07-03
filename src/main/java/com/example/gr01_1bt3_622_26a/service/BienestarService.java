package com.example.gr01_1bt3_622_26a.service;

import com.example.gr01_1bt3_622_26a.entity.ActualizacionBienestar;
import com.example.gr01_1bt3_622_26a.entity.Adopcion;
import com.example.gr01_1bt3_622_26a.repository.ActualizacionBienestarRepository;
import com.example.gr01_1bt3_622_26a.repository.AdopcionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.file.AccessDeniedException;
import java.util.List;

/**
 * Servicio de seguimiento de bienestar post-adopción.
 * HU15: el adoptante registra actualizaciones sobre su mascota.
 * HU16: el administrador consulta todas las actualizaciones.
 */
@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class BienestarService {

    private final ActualizacionBienestarRepository actualizacionBienestarRepository;
    private final AdopcionRepository adopcionRepository;

    /**
     * Registra una actualización de bienestar, validando que el solicitante autenticado
     * sea el propietario de la adopción (mismo patrón de seguridad que
     * {@code SolicitudService.obtenerDetalleSolicitud}).
     *
     * @param adopcionId    ID de la adopción sobre la que se registra la actualización
     * @param solicitanteId ID del solicitante autenticado (dueño esperado de la adopción)
     * @param estadoMascota Estado general de la mascota (Feliz, Adaptándose, Con problemas)
     * @param comentario    Comentario libre del adoptante
     * @return la actualización guardada
     * @throws IllegalArgumentException si la adopción no existe
     * @throws AccessDeniedException    si el solicitante no es el propietario de la adopción
     */
    public ActualizacionBienestar registrar(Long adopcionId, Long solicitanteId, String estadoMascota, String comentario)
            throws AccessDeniedException {
        Adopcion adopcion = adopcionRepository.findById(adopcionId)
                .orElseThrow(() -> new IllegalArgumentException("Adopción no encontrada: " + adopcionId));

        if (adopcion.getSolicitante() == null || !adopcion.getSolicitante().getId().equals(solicitanteId)) {
            log.warn("ACCESO DENEGADO: Solicitante {} intentó registrar bienestar en adopción {} que no le pertenece",
                    solicitanteId, adopcionId);
            throw new AccessDeniedException("No tienes permiso para registrar bienestar en esta adopción");
        }

        ActualizacionBienestar actualizacion = ActualizacionBienestar.builder()
                .adopcion(adopcion)
                .estadoMascota(estadoMascota)
                .comentario(comentario)
                .build();

        ActualizacionBienestar guardada = actualizacionBienestarRepository.save(actualizacion);
        log.info("Actualización de bienestar {} registrada para adopción {}", guardada.getId(), adopcionId);
        return guardada;
    }

    @Transactional(readOnly = true)
    public List<ActualizacionBienestar> listarPorAdopcion(Long adopcionId) {
        return actualizacionBienestarRepository.findByAdopcionIdOrderByFechaRegistroDesc(adopcionId);
    }

    @Transactional(readOnly = true)
    public List<ActualizacionBienestar> listarTodas() {
        return actualizacionBienestarRepository.findAllConDetalle();
    }

    /**
     * Permite al administrador responder a una actualización de bienestar (complemento
     * opcional de HU16, ya que la propia HU solo exige la consulta).
     */
    public ActualizacionBienestar responder(Long id, String respuestaAdmin) {
        ActualizacionBienestar actualizacion = actualizacionBienestarRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Actualización no encontrada: " + id));
        actualizacion.setRespuestaAdmin(respuestaAdmin);
        actualizacion.setFechaRespuestaAdmin(java.time.LocalDateTime.now());
        return actualizacionBienestarRepository.save(actualizacion);
    }
}

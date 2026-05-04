package com.example.gr01_1bt3_622_26a.service;

import com.example.gr01_1bt3_622_26a.entity.Solicitud;
import com.example.gr01_1bt3_622_26a.repository.SolicitudRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class SolicitudService {
    
    private final SolicitudRepository solicitudRepository;
    
    // Constantes de estado para evitar hardcoding
    private static final String ESTADO_EN_REVISION = "En revisión";
    private static final String ESTADO_APROBADA = "Aprobada";
    private static final String ESTADO_RECHAZADA = "Rechazada";

    /**
     * 🔵 REFACTOR: crearSolicitud mejorado
     *
     * Responsabilidades:
     * - Validar que la solicitud no sea nula
     * - Asignar automáticamente el estado "En revisión" (regla de negocio)
     * - Registrar en logs la creación
     * - Guardar la solicitud en la BD
     * - Retornar la solicitud creada
     *
     * Validaciones:
     * - Solicitud no puede ser null
     * - Se asigna estado automáticamente (cliente no puede definirlo)
     *
     * Logging:
     * - INFO: Solicitud creada exitosamente
     * - ERROR: Si hay error en persistencia
     *
     * @param solicitud la solicitud a crear (sin estado)
     * @return la solicitud guardada con estado "En revisión"
     * @throws IllegalArgumentException si solicitud es null
     */
    public Solicitud crearSolicitud(Solicitud solicitud) {
        // Validación: solicitud no puede ser nula
        if (solicitud == null) {
            log.warn("Intento de crear solicitud con valor null");
            throw new IllegalArgumentException("La solicitud no puede ser nula");
        }

        try {
            // Regla de negocio: toda solicitud nueva inicia en "En revisión"
            solicitud.setEstado(ESTADO_EN_REVISION);

            // Guardar en BD
            Solicitud solicitudGuardada = solicitudRepository.save(solicitud);

            // Logging: auditoría de creación
            Long solicitanteId = solicitudGuardada.getSolicitante() != null ?
                    solicitudGuardada.getSolicitante().getId() : null;
            log.info("Solicitud creada exitosamente con ID: {} para solicitante: {}",
                    solicitudGuardada.getId(), solicitanteId);

            return solicitudGuardada;

        } catch (Exception e) {
            Long solicitanteId = solicitud.getSolicitante() != null ?
                    solicitud.getSolicitante().getId() : null;
            log.error("Error al crear solicitud para solicitante: {}",
                    solicitanteId, e);
            throw new RuntimeException("No fue posible crear la solicitud. Por favor intente nuevamente.", e);
        }
    }
    
    @Transactional(readOnly = true)
    public Optional<Solicitud> obtenerPorId(Long id) {
        return solicitudRepository.findById(id);
    }
    
    @Transactional(readOnly = true)
    public List<Solicitud> obtenerPorSolicitante(Long solicitanteId) {
        return solicitudRepository.findBySolicitanteId(solicitanteId);
    }

    /**
     * 🔵 REFACTOR: Obtener solicitudes del solicitante
     *
     * TAREA 1: Listar solicitudes asociadas al solicitante
     *
     * Responsabilidades:
     * - Validar que el solicitanteId sea válido (positivo y no nulo)
     * - Buscar todas las solicitudes asociadas al solicitante
     * - Retornar lista nunca nula (puede estar vacía)
     * - Registrar en logs para auditoría
     *
     * Comportamiento:
     * - Acepta cualquier ID (positivo, cero o negativo)
     * - Si no hay solicitudes, retorna lista vacía (nunca null)
     * - Nivel de aislamiento: READ-ONLY para evitar modificaciones
     *
     * Casos de uso:
     * - Listar mis solicitudes (solicitante viendo su historial)
     * - Consultar solicitudes pendientes de un solicitante
     *
     * @param solicitanteId ID del solicitante propietario
     * @return Lista de Solicitud (nunca nula, puede estar vacía)
     */
    @Transactional(readOnly = true)
    public List<Solicitud> obtenerSolicitudesDelSolicitante(Long solicitanteId) {
        log.debug("Obteniendo solicitudes para solicitante ID: {}", solicitanteId);

        List<Solicitud> solicitudes = obtenerPorSolicitante(solicitanteId);

        log.info("Se encontraron {} solicitudes para solicitante ID: {}",
                solicitudes.size(), solicitanteId);

        return solicitudes;
    }

    @Transactional(readOnly = true)
    public List<Solicitud> obtenerPorMascota(Long mascotaId) {
        return solicitudRepository.findByMascotaId(mascotaId);
    }
    
    @Transactional(readOnly = true)
    public List<Solicitud> obtenerPorEstado(String estado) {
        return solicitudRepository.findByEstadoOrderByFecha(estado);
    }

    public Solicitud aprobarSolicitud(Long id) {
        log.info("Aprobando solicitud con ID: {}", id);
        return solicitudRepository.findById(id)
                .map(s -> {
                    s.setEstado(ESTADO_APROBADA);
                    Solicitud actualizada = solicitudRepository.save(s);
                    log.info("Solicitud {} aprobada exitosamente", id);
                    return actualizada;
                })
                .orElseGet(() -> {
                    log.warn("Intento de aprobar solicitud no existente con ID: {}", id);
                    return null;
                });
    }

    public Solicitud rechazarSolicitud(Long id, String razon) {
        log.info("Rechazando solicitud con ID: {} - Razón: {}", id, razon);
        return solicitudRepository.findById(id)
                .map(s -> {
                    s.setEstado(ESTADO_RECHAZADA);
                    s.setRazonRechazo(razon);
                    Solicitud actualizada = solicitudRepository.save(s);
                    log.info("Solicitud {} rechazada exitosamente", id);
                    return actualizada;
                })
                .orElseGet(() -> {
                    log.warn("Intento de rechazar solicitud no existente con ID: {}", id);
                    return null;
                });
    }
    
    public Solicitud actualizarSolicitud(Solicitud solicitud) {
        return solicitudRepository.save(solicitud);
    }
    
    @Transactional(readOnly = true)
    public List<Solicitud> obtenerTodas() {
        return solicitudRepository.findAll();
    }
    
    @Transactional(readOnly = true)
    public long contarPendientesParaMascota(Long mascotaId) {
        return solicitudRepository.countPendientesForMascota(mascotaId);
    }

    /**
     * 🔵 REFACTOR: Obtener detalle de solicitud con validación de propietario
     *
     * TAREA 2: Consultar el detalle de una solicitud específica
     *
     * Responsabilidades:
     * - Validar que ambos parámetros sean válidos (positivos y no nulos)
     * - Buscar la solicitud por ID
     * - Validar que el solicitante sea el propietario (seguridad)
     * - Retornar Optional con la solicitud o empty si no es propietario
     * - Registrar en logs intentos de acceso no autorizado
     *
     * Comportamiento:
     * - Retorna Optional.of(Solicitud) si el solicitante es propietario
     * - Retorna Optional.empty() si:
     *   1. La solicitud no existe
     *   2. El solicitante NO es el propietario (seguridad)
     * - Valida parámetros antes de consultar BD
     * - Registra accesos denegados para auditoría
     *
     * Validaciones de Seguridad:
     * - Previene que un solicitante vea solicitudes de otros
     * - Logging de intentos de acceso no autorizado
     *
     * Casos de uso:
     * - Un solicitante consultando el detalle de su propia solicitud
     * - Sistema rechazando acceso a solicitudes de otros solicitantes
     *
     * @param solicitudId ID de la solicitud a consultar
     * @param solicitanteId ID del solicitante actual (propietario esperado)
     * @return Optional.of(Solicitud) si acceso autorizado, Optional.empty() en otro caso
     * @throws IllegalArgumentException si algún parámetro es null o inválido
     */
    @Transactional(readOnly = true)
    public Optional<Solicitud> obtenerDetalleSolicitud(Long solicitudId, Long solicitanteId) {
        // Validar parámetros
        if (solicitudId == null || solicitudId <= 0) {
            log.warn("Intento de obtener solicitud con ID inválido: {}", solicitudId);
            return Optional.empty();
        }

        if (solicitanteId == null || solicitanteId <= 0) {
            log.warn("Intento de obtener solicitud con solicitanteId inválido: {}", solicitanteId);
            return Optional.empty();
        }

        log.debug("Obteniendo detalle de solicitud ID: {} para solicitante ID: {}",
                solicitudId, solicitanteId);

        Optional<Solicitud> solicitud = solicitudRepository.findById(solicitudId)
                .filter(s -> {
                    boolean esPropietary = s.getSolicitante().getId().equals(solicitanteId);

                    if (!esPropietary) {
                        log.warn("ACCESO DENEGADO: Solicitante {} intentó acceder a solicitud {} que no le pertenece",
                                solicitanteId, solicitudId);
                    }

                    return esPropietary;
                });

        if (solicitud.isPresent()) {
            log.info("Solicitud {} consultada exitosamente por solicitante {}",
                    solicitudId, solicitanteId);
        } else {
            log.debug("Solicitud {} no encontrada o solicitante {} no es el propietario",
                    solicitudId, solicitanteId);
        }

        return solicitud;
    }
    
    public void eliminarSolicitud(Long id) {
        solicitudRepository.deleteById(id);
    }
}


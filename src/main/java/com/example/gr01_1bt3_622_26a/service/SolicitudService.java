package com.example.gr01_1bt3_622_26a.service;

import com.example.gr01_1bt3_622_26a.entity.Solicitud;
import com.example.gr01_1bt3_622_26a.repository.SolicitudRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class SolicitudService {
    
    private final SolicitudRepository solicitudRepository;
    
    public Solicitud crearSolicitud(Solicitud solicitud) {
        return solicitudRepository.save(solicitud);
    }
    
    @Transactional(readOnly = true)
    public Optional<Solicitud> obtenerPorId(Long id) {
        return solicitudRepository.findById(id);
    }
    
    @Transactional(readOnly = true)
    public List<Solicitud> obtenerPorSolicitante(Long solicitanteId) {
        return solicitudRepository.findBySolicitanteId(solicitanteId);
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
        return solicitudRepository.findById(id)
                .map(s -> {
                    s.setEstado("Aprobada");
                    return solicitudRepository.save(s);
                })
                .orElse(null);
    }

    public Solicitud rechazarSolicitud(Long id, String razon) {
        return solicitudRepository.findById(id)
                .map(s -> {
                    s.setEstado("Rechazada");
                    s.setRazonRechazo(razon);
                    return solicitudRepository.save(s);
                })
                .orElse(null);
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
    
    public void eliminarSolicitud(Long id) {
        solicitudRepository.deleteById(id);
    }
}


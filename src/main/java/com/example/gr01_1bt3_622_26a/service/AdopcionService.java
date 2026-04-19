package com.example.gr01_1bt3_622_26a.service;

import com.example.gr01_1bt3_622_26a.entity.Adopcion;
import com.example.gr01_1bt3_622_26a.repository.AdopcionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class AdopcionService {

    private final AdopcionRepository adopcionRepository;

    public Adopcion crearAdopcion(Adopcion adopcion) {
        return adopcionRepository.save(adopcion);
    }

    @Transactional(readOnly = true)
    public Optional<Adopcion> obtenerPorId(Long id) {
        return adopcionRepository.findById(id);
    }

    @Transactional(readOnly = true)
    public Optional<Adopcion> obtenerPorSolicitud(Long solicitudId) {
        return adopcionRepository.findBySolicitudId(solicitudId);
    }

    @Transactional(readOnly = true)
    public List<Adopcion> obtenerPorSolicitante(Long solicitanteId) {
        return adopcionRepository.findBySolicitanteId(solicitanteId);
    }

    @Transactional(readOnly = true)
    public List<Adopcion> obtenerPorMascota(Long mascotaId) {
        return adopcionRepository.findByMascotaId(mascotaId);
    }

    @Transactional(readOnly = true)
    public List<Adopcion> obtenerPorEstado(String estado) {
        return adopcionRepository.findByEstado(estado);
    }

    @Transactional(readOnly = true)
    public List<Adopcion> obtenerCompletadas() {
        return adopcionRepository.findAllCompletadas();
    }

    @Transactional(readOnly = true)
    public List<Adopcion> obtenerAdopcionesCompledasSolicitante(Long solicitanteId) {
        return adopcionRepository.findSolicitanteCompletedAdoptions(solicitanteId);
    }

    @Transactional(readOnly = true)
    public long contarAdopcionesDesde(LocalDate fecha) {
        return adopcionRepository.countAdoptionsAfter(fecha);
    }

    public Adopcion completarAdopcion(Long id) {
        Optional<Adopcion> adopcion = adopcionRepository.findById(id);
        if (adopcion.isPresent()) {
            Adopcion a = adopcion.get();
            a.setEstado("Completada");
            a.setFechaFinalizacion(LocalDate.now());
            return adopcionRepository.save(a);
        }
        return null;
    }

    public Adopcion actualizarAdopcion(Adopcion adopcion) {
        return adopcionRepository.save(adopcion);
    }

    @Transactional(readOnly = true)
    public List<Adopcion> obtenerTodas() {
        return adopcionRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<Adopcion> obtenerPendientesSeguimiento() {
        return adopcionRepository.findAdoptionsPendingFollowUp();
    }

    public void eliminarAdopcion(Long id) {
        adopcionRepository.deleteById(id);
    }
}


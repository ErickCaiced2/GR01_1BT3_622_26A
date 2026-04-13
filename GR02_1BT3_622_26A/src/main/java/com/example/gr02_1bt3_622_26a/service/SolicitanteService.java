package com.example.gr02_1bt3_622_26a.service;

import com.example.gr02_1bt3_622_26a.entity.Solicitante;
import com.example.gr02_1bt3_622_26a.repository.SolicitanteRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class SolicitanteService {

    private final SolicitanteRepository solicitanteRepository;

    public Solicitante crearSolicitante(Solicitante solicitante) {
        return solicitanteRepository.save(solicitante);
    }

    @Transactional(readOnly = true)
    public Optional<Solicitante> obtenerPorId(Long id) {
        return solicitanteRepository.findById(id);
    }

    @Transactional(readOnly = true)
    public Optional<Solicitante> obtenerPorEmail(String email) {
        return solicitanteRepository.findByEmail(email);
    }

    @Transactional(readOnly = true)
    public Optional<Solicitante> obtenerPorDocumento(String documento) {
        return solicitanteRepository.findByDocumentoIdentidad(documento);
    }

    public Solicitante actualizarSolicitante(Solicitante solicitante) {
        return solicitanteRepository.save(solicitante);
    }

    @Transactional(readOnly = true)
    public List<Solicitante> obtenerTodos() {
        return solicitanteRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<Solicitante> obtenerActivos() {
        return solicitanteRepository.findAllActive();
    }

    public void eliminarSolicitante(Long id) {
        solicitanteRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public boolean solicitanteExistePorEmail(String email) {
        return solicitanteRepository.findByEmail(email).isPresent();
    }
}


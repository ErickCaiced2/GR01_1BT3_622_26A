package com.example.gr02_1bt3_622_26a.repository;

import com.example.gr02_1bt3_622_26a.entity.Solicitante;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SolicitanteRepository extends JpaRepository<Solicitante, Long> {
    Optional<Solicitante> findByEmail(String email);
    Optional<Solicitante> findByDocumentoIdentidad(String documentoIdentidad);
    List<Solicitante> findByEstado(String estado);

    @Query("SELECT s FROM Solicitante s WHERE s.estado = 'Activo' ORDER BY s.fechaRegistro DESC")
    List<Solicitante> findAllActive();
}


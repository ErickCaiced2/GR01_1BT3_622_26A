package com.example.gr02_1bt3_622_26a.repository;

import com.example.gr02_1bt3_622_26a.entity.Adopcion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface AdopcionRepository extends JpaRepository<Adopcion, Long> {
    List<Adopcion> findBySolicitanteId(Long solicitanteId);
    List<Adopcion> findByMascotaId(Long mascotaId);
    List<Adopcion> findByEstado(String estado);
    Optional<Adopcion> findBySolicitudId(Long solicitudId);

    @Query("SELECT a FROM Adopcion a WHERE a.estado = 'Completada' ORDER BY a.fechaAdopcion DESC")
    List<Adopcion> findAllCompletadas();

    @Query("SELECT a FROM Adopcion a WHERE a.solicitante.id = :solicitanteId AND a.estado = 'Completada'")
    List<Adopcion> findSolicitanteCompletedAdoptions(@Param("solicitanteId") Long solicitanteId);

    @Query("SELECT COUNT(a) FROM Adopcion a WHERE a.estado = 'Completada' AND a.fechaAdopcion >= :fecha")
    long countAdoptionsAfter(@Param("fecha") LocalDate fecha);

    @Query("SELECT a FROM Adopcion a WHERE a.seguimientoRequerido = true AND a.estado = 'Completada' ORDER BY a.fechaSeguimiento ASC")
    List<Adopcion> findAdoptionsPendingFollowUp();
}


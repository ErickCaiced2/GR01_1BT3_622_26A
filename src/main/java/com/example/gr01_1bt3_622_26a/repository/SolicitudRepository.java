package com.example.gr01_1bt3_622_26a.repository;

import com.example.gr01_1bt3_622_26a.entity.Solicitud;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface SolicitudRepository extends JpaRepository<Solicitud, Long> {

    @Query("SELECT DISTINCT s FROM Solicitud s LEFT JOIN FETCH s.solicitante LEFT JOIN FETCH s.mascota WHERE s.id = :id")
    java.util.Optional<Solicitud> findById(@Param("id") Long id);

    @Query("SELECT DISTINCT s FROM Solicitud s LEFT JOIN FETCH s.solicitante LEFT JOIN FETCH s.mascota WHERE s.solicitante.id = :solicitanteId ORDER BY s.fechaSolicitud DESC")
    List<Solicitud> findBySolicitanteId(@Param("solicitanteId") Long solicitanteId);

    @Query("SELECT DISTINCT s FROM Solicitud s LEFT JOIN FETCH s.mascota LEFT JOIN FETCH s.solicitante WHERE s.mascota.id = :mascotaId ORDER BY s.fechaSolicitud DESC")
    List<Solicitud> findByMascotaId(@Param("mascotaId") Long mascotaId);

    @Query("SELECT DISTINCT s FROM Solicitud s LEFT JOIN FETCH s.solicitante LEFT JOIN FETCH s.mascota WHERE s.estado = :estado ORDER BY s.fechaSolicitud DESC")
    List<Solicitud> findByEstado(@Param("estado") String estado);

    @Query("SELECT DISTINCT s FROM Solicitud s LEFT JOIN FETCH s.solicitante LEFT JOIN FETCH s.mascota WHERE s.estado = :estado ORDER BY s.fechaSolicitud DESC")
    List<Solicitud> findByEstadoOrderByFecha(@Param("estado") String estado);
    
    @Query("SELECT COUNT(s) FROM Solicitud s WHERE s.mascota.id = :mascotaId AND s.estado = 'Pendiente'")
    long countPendientesForMascota(@Param("mascotaId") Long mascotaId);
    
    @Query("SELECT DISTINCT s FROM Solicitud s LEFT JOIN FETCH s.solicitante LEFT JOIN FETCH s.mascota WHERE s.solicitante.id = :solicitanteId AND s.estado = :estado ORDER BY s.fechaSolicitud DESC")
    List<Solicitud> findSolicitanteSolicitudesByEstado(@Param("solicitanteId") Long solicitanteId, @Param("estado") String estado);
}


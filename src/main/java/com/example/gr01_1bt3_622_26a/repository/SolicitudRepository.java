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
    List<Solicitud> findBySolicitanteId(Long solicitanteId);
    List<Solicitud> findByMascotaId(Long mascotaId);
    List<Solicitud> findByEstado(String estado);
    
    @Query("SELECT s FROM Solicitud s WHERE s.estado = :estado ORDER BY s.fechaSolicitud DESC")
    List<Solicitud> findByEstadoOrderByFecha(@Param("estado") String estado);
    
    @Query("SELECT COUNT(s) FROM Solicitud s WHERE s.mascota.id = :mascotaId AND s.estado = 'Pendiente'")
    long countPendientesForMascota(@Param("mascotaId") Long mascotaId);
    
    @Query("SELECT s FROM Solicitud s WHERE s.solicitante.id = :solicitanteId AND s.estado = :estado ORDER BY s.fechaSolicitud DESC")
    List<Solicitud> findSolicitanteSolicitudesByEstado(@Param("solicitanteId") Long solicitanteId, @Param("estado") String estado);
}


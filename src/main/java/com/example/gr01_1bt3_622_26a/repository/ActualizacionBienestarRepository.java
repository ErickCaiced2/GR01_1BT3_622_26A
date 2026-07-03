package com.example.gr01_1bt3_622_26a.repository;

import com.example.gr01_1bt3_622_26a.entity.ActualizacionBienestar;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ActualizacionBienestarRepository extends JpaRepository<ActualizacionBienestar, Long> {

    List<ActualizacionBienestar> findByAdopcionIdOrderByFechaRegistroDesc(Long adopcionId);

    @Query("SELECT DISTINCT a FROM ActualizacionBienestar a " +
            "JOIN FETCH a.adopcion ad " +
            "JOIN FETCH ad.solicitante " +
            "JOIN FETCH ad.mascota " +
            "ORDER BY a.fechaRegistro DESC")
    List<ActualizacionBienestar> findAllConDetalle();
}

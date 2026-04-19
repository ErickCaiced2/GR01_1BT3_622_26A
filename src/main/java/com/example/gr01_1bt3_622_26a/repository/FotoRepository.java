package com.example.gr01_1bt3_622_26a.repository;

import com.example.gr01_1bt3_622_26a.entity.Foto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

/**
 * Repositorio para operaciones CRUD de Foto
 */
@Repository
public interface FotoRepository extends JpaRepository<Foto, Long> {

    /**
     * Buscar fotos por mascota ID
     */
    List<Foto> findByMascotaId(Long mascotaId);

    /**
     * Buscar foto principal de una mascota
     */
    @Query("SELECT f FROM Foto f WHERE f.mascota.id = :mascotaId AND f.esPrincipal = true")
    Optional<Foto> findFotoPrincipal(@Param("mascotaId") Long mascotaId);

    /**
     * Contar fotos de una mascota
     */
    long countByMascotaId(Long mascotaId);
}


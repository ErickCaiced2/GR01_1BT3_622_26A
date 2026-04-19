package com.example.gr01_1bt3_622_26a.repository;

import com.example.gr01_1bt3_622_26a.entity.Mascota;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

/**
 * Repositorio para operaciones CRUD de Mascota
 */
@Repository
public interface MascotaRepository extends JpaRepository<Mascota, Long> {

    /**
     * Buscar mascotas por estado
     */
    List<Mascota> findByEstado(String estado);

    /**
     * Buscar mascotas por tipo
     */
    List<Mascota> findByTipo(String tipo);

    /**
     * Buscar mascotas disponibles
     */
    @Query("SELECT m FROM Mascota m WHERE m.estado = 'Disponible' ORDER BY m.fechaRegistro DESC")
    List<Mascota> findMascotasDisponibles();

    /**
     * Buscar mascotas por nombre (búsqueda LIKE)
     */
    @Query("SELECT m FROM Mascota m WHERE LOWER(m.nombre) LIKE LOWER(CONCAT('%', :nombre, '%'))")
    List<Mascota> buscarPorNombre(@Param("nombre") String nombre);

    /**
     * Buscar mascotas por tipo de género
     */
    List<Mascota> findByGenero(String genero);

    /**
     * Buscar mascotas por raza
     */
    List<Mascota> findByRaza(String raza);

    /**
     * Contar mascotas por estado
     */
    long countByEstado(String estado);
}


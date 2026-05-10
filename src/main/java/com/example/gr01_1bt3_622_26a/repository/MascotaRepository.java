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

    /**
     * Filtrar mascotas por compatibilidad (T.4.3)
     */
    @Query("""
        SELECT m FROM Mascota m WHERE 
        m.estado = 'Disponible'
        AND (:tieneNinos IS NULL OR m.compatibleNinos = :tieneNinos)
        AND (:tieneGatos IS NULL OR m.compatibleGatos = :tieneGatos)
        AND (:tienePerros IS NULL OR m.compatiblePerros = :tienePerros)
        AND (:nivelEnergia IS NULL OR m.nivelEnergia = :nivelEnergia)
        AND (:tamañoPreferido IS NULL OR m.tamañoRequerido = :tamañoPreferido)
        AND (:esHipoalergenico IS NULL OR m.esHipoalergenico = :esHipoalergenico)
        """)
    List<Mascota> filtrarPorCompatibilidad(
        @Param("tieneNinos") Boolean tieneNinos,
        @Param("tieneGatos") Boolean tieneGatos,
        @Param("tienePerros") Boolean tienePerros,
        @Param("nivelEnergia") String nivelEnergia,
        @Param("tamañoPreferido") String tamañoPreferido,
        @Param("esHipoalergenico") Boolean esHipoalergenico
    );
}


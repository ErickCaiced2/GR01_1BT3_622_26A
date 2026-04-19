package com.example.gr01_1bt3_622_26a.service;

import com.example.gr01_1bt3_622_26a.entity.Mascota;
import com.example.gr01_1bt3_622_26a.entity.Foto;
import com.example.gr01_1bt3_622_26a.repository.MascotaRepository;
import com.example.gr01_1bt3_622_26a.repository.FotoRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Servicio para gestionar mascotas
 */
@Service
@Slf4j
@Transactional
public class MascotaService {

    @Autowired
    private MascotaRepository mascotaRepository;

    @Autowired
    private FotoRepository fotoRepository;

    /**
     * Registrar una nueva mascota
     */
    public Mascota registrarMascota(Mascota mascota) {
        log.info("Registrando nueva mascota: {}", mascota.getNombre());
        if (mascota.getFechaRegistro() == null) {
            mascota.setFechaRegistro(LocalDate.now());
        }
        if (mascota.getEstado() == null) {
            mascota.setEstado("Disponible");
        }
        return mascotaRepository.save(mascota);
    }

    /**
     * Obtener todas las mascotas
     */
    public List<Mascota> obtenerTodasLasMascotas() {
        log.info("Obteniendo todas las mascotas");
        return mascotaRepository.findAll();
    }

    /**
     * Obtener mascotas disponibles
     */
    public List<Mascota> obtenerMascotasDisponibles() {
        log.info("Obteniendo mascotas disponibles");
        return mascotaRepository.findMascotasDisponibles();
    }

    /**
     * Obtener mascotas disponibles (alias para compatibilidad)
     */
    public List<Mascota> obtenerDisponibles() {
        return obtenerMascotasDisponibles();
    }

    /**
     * Obtener mascota por ID
     */
    public Optional<Mascota> obtenerMascotaPorId(Long id) {
        log.info("Obteniendo mascota con ID: {}", id);
        return mascotaRepository.findById(id);
    }

    /**
     * Obtener mascota por ID (alias para compatibilidad)
     */
    public Optional<Mascota> obtenerPorId(Long id) {
        return obtenerMascotaPorId(id);
    }

    /**
     * Actualizar mascota
     */
    public Mascota actualizarMascota(Long id, Mascota mascotaActualizada) {
        log.info("Actualizando mascota con ID: {}", id);
        return mascotaRepository.findById(id).map(mascota -> {
            mascota.setNombre(mascotaActualizada.getNombre());
            mascota.setTipo(mascotaActualizada.getTipo());
            mascota.setRaza(mascotaActualizada.getRaza());
            mascota.setEdad(mascotaActualizada.getEdad());
            mascota.setGenero(mascotaActualizada.getGenero());
            mascota.setDescripcion(mascotaActualizada.getDescripcion());
            mascota.setEstado(mascotaActualizada.getEstado());
            mascota.setColor(mascotaActualizada.getColor());
            mascota.setPesoKg(mascotaActualizada.getPesoKg());
            return mascotaRepository.save(mascota);
        }).orElseThrow(() -> new RuntimeException("Mascota no encontrada con ID: " + id));
    }

    /**
     * Eliminar mascota
     */
    public void eliminarMascota(Long id) {
        log.info("Eliminando mascota con ID: {}", id);
        mascotaRepository.deleteById(id);
    }

    /**
     * Buscar mascotas por nombre
     */
    public List<Mascota> buscarPorNombre(String nombre) {
        log.info("Buscando mascotas con nombre: {}", nombre);
        return mascotaRepository.buscarPorNombre(nombre);
    }

    /**
     * Obtener mascotas por tipo
     */
    public List<Mascota> obtenerPorTipo(String tipo) {
        log.info("Obteniendo mascotas de tipo: {}", tipo);
        return mascotaRepository.findByTipo(tipo);
    }

    /**
     * Obtener mascotas por estado
     */
    public List<Mascota> obtenerPorEstado(String estado) {
        log.info("Obteniendo mascotas con estado: {}", estado);
        return mascotaRepository.findByEstado(estado);
    }

    /**
     * Cambiar estado de mascota
     */
    public Mascota cambiarEstado(Long id, String nuevoEstado) {
        log.info("Cambiando estado de mascota {} a {}", id, nuevoEstado);
        return mascotaRepository.findById(id).map(mascota -> {
            mascota.setEstado(nuevoEstado);
            return mascotaRepository.save(mascota);
        }).orElse(null);
    }

    /**
     * Contar mascotas por estado
     */
    public long contarPorEstado(String estado) {
        log.info("Contando mascotas por estado: {}", estado);
        return mascotaRepository.countByEstado(estado);
    }

    /**
     * Agregar foto a mascota
     */
    public Foto agregarFoto(Long mascotaId, Foto foto) {
        log.info("Agregando foto a mascota con ID: {}", mascotaId);
        return mascotaRepository.findById(mascotaId).map(mascota -> {
            foto.setMascota(mascota);
            return fotoRepository.save(foto);
        }).orElse(null);
    }

    /**
     * Obtener fotos de una mascota
     */
    public List<Foto> obtenerFotosDeMascota(Long mascotaId) {
        log.info("Obteniendo fotos de mascota con ID: {}", mascotaId);
        return fotoRepository.findByMascotaId(mascotaId);
    }

    /**
     * Obtener estadísticas generales
     */
    public java.util.Map<String, Long> obtenerEstadisticas() {
        log.info("Obteniendo estadísticas generales");
        java.util.Map<String, Long> stats = new java.util.HashMap<>();
        stats.put("total", mascotaRepository.count());
        stats.put("disponibles", contarPorEstado("Disponible"));
        stats.put("adoptados", contarPorEstado("Adoptado"));
        stats.put("en_proceso", contarPorEstado("En proceso"));
        return stats;
    }
}


package com.example.gr01_1bt3_622_26a.repository;

import com.example.gr01_1bt3_622_26a.entity.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

/**
 * 🔵 REFACTOR: UsuarioRepository MEJORADO
 *
 * Repositorio para la entidad Usuario
 * Proporciona métodos de acceso a datos personalizados
 */
@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

    /**
     * Buscar usuario por email
     */
    Optional<Usuario> findByEmail(String email);

    /**
     * Verificar si existe un usuario con ese email
     */
    boolean existsByEmail(String email);
}


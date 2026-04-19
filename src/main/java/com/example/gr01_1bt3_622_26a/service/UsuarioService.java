package com.example.gr01_1bt3_622_26a.service;

import com.example.gr01_1bt3_622_26a.entity.Usuario;
import com.example.gr01_1bt3_622_26a.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import java.time.LocalDate;

/**
 * 🔵 REFACTOR: UsuarioService MEJORADO
 *
 * Ciclo TDD:
 * 🔴 RED: Test falla (no existe UsuarioService)
 * 🟢 GREEN: Se crea UsuarioService mínimo
 * 🔵 REFACTOR: Se mejora con validaciones, excepciones, logging
 *
 * Responsabilidades:
 * - Registrar nuevos usuarios
 * - Validar datos de entrada
 * - Manejo de excepciones
 * - Logging de eventos
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class UsuarioService {

    private final UsuarioRepository usuarioRepository;

    /**
     * Registrar un nuevo usuario en la base de datos
     *
     * @param email Email del usuario
     * @param password Contraseña
     * @param nombre Nombre completo
     * @return Usuario registrado con ID asignado
     * @throws IllegalArgumentException si email ya existe o datos inválidos
     */
    public Usuario registrarUsuario(String email, String password, String nombre) {
        log.info("🔐 [REGISTRO] Iniciando registro de usuario: {}", email);

        // Validaciones
        validarEmail(email);
        validarPassword(password);
        validarNombre(nombre);

        // Verificar que el email no exista
        if (usuarioRepository.existsByEmail(email)) {
            log.warn("⚠️ [REGISTRO] Email ya registrado: {}", email);
            throw new IllegalArgumentException("El email " + email + " ya está registrado");
        }

        // Crear usuario
        Usuario usuario = Usuario.builder()
                .email(email)
                .password(password) // 🔵 REFACTOR: En producción encriptar con BCrypt
                .nombre(nombre)
                .estado("ACTIVO")
                .fechaCreacion(LocalDate.now())
                .rol(Usuario.RolUsuario.SOLICITANTE)
                .intentosFallidos(0)
                .build();

        // Guardar en BD
        Usuario usuarioGuardado = usuarioRepository.save(usuario);
        log.info("✅ [REGISTRO] Usuario registrado exitosamente: {} (ID: {})", email, usuarioGuardado.getId());

        return usuarioGuardado;
    }

    /**
     * Validar formato de email
     */
    private void validarEmail(String email) {
        if (email == null || email.isBlank()) {
            throw new IllegalArgumentException("El email no puede estar vacío");
        }

        if (!email.contains("@") || !email.contains(".")) {
            throw new IllegalArgumentException("El email debe tener un formato válido");
        }

        if (email.length() > 255) {
            throw new IllegalArgumentException("El email no puede exceder 255 caracteres");
        }

        log.debug("✓ Email válido: {}", email);
    }

    /**
     * Validar contraseña
     */
    private void validarPassword(String password) {
        if (password == null || password.isBlank()) {
            throw new IllegalArgumentException("La contraseña no puede estar vacía");
        }

        if (password.length() < 6) {
            throw new IllegalArgumentException("La contraseña debe tener al menos 6 caracteres");
        }

        if (password.length() > 255) {
            throw new IllegalArgumentException("La contraseña no puede exceder 255 caracteres");
        }

        log.debug("✓ Contraseña válida (longitud: {})", password.length());
    }

    /**
     * Validar nombre
     */
    private void validarNombre(String nombre) {
        if (nombre == null || nombre.isBlank()) {
            throw new IllegalArgumentException("El nombre no puede estar vacío");
        }

        if (nombre.length() < 2) {
            throw new IllegalArgumentException("El nombre debe tener al menos 2 caracteres");
        }

        if (nombre.length() > 100) {
            throw new IllegalArgumentException("El nombre no puede exceder 100 caracteres");
        }

        log.debug("✓ Nombre válido: {}", nombre);
    }

    /**
     * Verificar si un email ya existe
     */
    public boolean existeEmail(String email) {
        return usuarioRepository.existsByEmail(email);
    }

    /**
     * Obtener usuario por email
     */
    public Usuario obtenerPorEmail(String email) {
        return usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("Usuario no encontrado: " + email));
    }

    /**
     * Obtener usuario por ID
     */
    public Usuario obtenerPorId(Long id) {
        return usuarioRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Usuario no encontrado: ID " + id));
    }

    /**
     * Contar total de usuarios
     */
    public long contarUsuarios() {
        return usuarioRepository.count();
    }

    /**
     * Iniciar sesión con email y contraseña
     *
     * @param email Email del usuario
     * @param password Contraseña
     * @return Usuario autenticado
     * @throws IllegalArgumentException si credenciales son inválidas
     */
    public Usuario iniciarSesion(String email, String password) {
        log.info("🔐 [LOGIN] Intento de sesión con email: {}", email);

        // Validaciones de entrada
        validarCredencialesLogin(email, password);

        // Buscar usuario por email
        Usuario usuario = obtenerUsuarioParaLogin(email);

        // Validar credenciales
        validarContraseña(usuario, password);

        // Validar estado del usuario
        validarEstadoUsuario(usuario);

        // Registrar login exitoso
        registrarLoginExitoso(usuario);

        log.info("✅ [LOGIN] Sesión iniciada exitosamente para: {}", email);
        return usuario;
    }

    /**
     * Validar credenciales de entrada para login
     */
    private void validarCredencialesLogin(String email, String password) {
        if (email == null || email.isBlank()) {
            log.warn("⚠️ [LOGIN] Email vacío en intento de login");
            throw new IllegalArgumentException("El email no puede estar vacío");
        }

        if (password == null || password.isBlank()) {
            log.warn("⚠️ [LOGIN] Contraseña vacía en intento de login");
            throw new IllegalArgumentException("La contraseña no puede estar vacía");
        }

        log.debug("✓ Credenciales de entrada válidas");
    }

    /**
     * Obtener usuario para login por email
     */
    private Usuario obtenerUsuarioParaLogin(String email) {
        return usuarioRepository.findByEmail(email)
                .orElseThrow(() -> {
                    log.warn("⚠️ [LOGIN] Usuario no encontrado: {}", email);
                    return new IllegalArgumentException("Usuario no encontrado");
                });
    }

    /**
     * Validar contraseña del usuario
     */
    private void validarContraseña(Usuario usuario, String password) {
        if (!usuario.getPassword().equals(password)) {
            log.warn("⚠️ [LOGIN] Contraseña incorrecta para: {}", usuario.getEmail());

            // Incrementar intentos fallidos
            usuario.incrementarIntentosFallidos();
            usuarioRepository.save(usuario);

            log.warn("⚠️ [LOGIN] Intentos fallidos: {}/3", usuario.getIntentosFallidos());

            throw new IllegalArgumentException("Contraseña incorrecta");
        }

        log.debug("✓ Contraseña válida para: {}", usuario.getEmail());
    }

    /**
     * Validar estado del usuario para login
     */
    private void validarEstadoUsuario(Usuario usuario) {
        if (!usuario.esActivo()) {
            log.warn("⚠️ [LOGIN] Usuario inactivo o bloqueado: {} (Estado: {})",
                    usuario.getEmail(), usuario.getEstado());
            throw new IllegalArgumentException("Usuario inactivo o bloqueado");
        }

        log.debug("✓ Usuario activo: {}", usuario.getEmail());
    }

    /**
     * Registrar login exitoso
     */
    private void registrarLoginExitoso(Usuario usuario) {
        // Resetear intentos fallidos
        usuario.reiniciarIntentosFallidos();

        // Registrar fecha y hora de login
        usuario.registrarUltimoLogin();

        // Guardar cambios
        usuarioRepository.save(usuario);

        log.info("✅ [LOGIN] Login registrado para: {} en: {}",
                usuario.getEmail(), usuario.getFechaUltimoLogin());
    }

    /**
     * Cerrar sesión del usuario
     *
     * @param usuarioId ID del usuario
     * @return true si la sesión se cerró exitosamente
     * @throws IllegalArgumentException si el usuario no existe
     */
    public boolean cerrarSesion(Long usuarioId) {
        log.info("🔐 [LOGOUT] Cerrando sesión para usuario ID: {}", usuarioId);

        // Validar ID
        validarIdUsuario(usuarioId);

        // Obtener usuario
        Usuario usuario = obtenerUsuarioParaLogout(usuarioId);

        // Limpiar sesión
        limpiarSesionUsuario(usuario);

        // Registrar logout
        registrarLogoutExitoso(usuario);

        log.info("✅ [LOGOUT] Sesión cerrada exitosamente para usuario ID: {}", usuarioId);
        return true;
    }

    /**
     * Validar que el ID del usuario sea válido
     */
    private void validarIdUsuario(Long usuarioId) {
        if (usuarioId == null || usuarioId <= 0) {
            log.warn("⚠️ [LOGOUT] ID de usuario inválido: {}", usuarioId);
            throw new IllegalArgumentException("ID de usuario inválido");
        }

        log.debug("✓ ID de usuario válido: {}", usuarioId);
    }

    /**
     * Obtener usuario para logout
     */
    private Usuario obtenerUsuarioParaLogout(Long usuarioId) {
        return usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> {
                    log.warn("⚠️ [LOGOUT] Usuario no encontrado: ID {}", usuarioId);
                    return new IllegalArgumentException("Usuario no encontrado");
                });
    }

    /**
     * Limpiar información de sesión del usuario
     */
    private void limpiarSesionUsuario(Usuario usuario) {
        log.debug("🔄 [LOGOUT] Limpiando sesión para: {}", usuario.getEmail());

        // Limpiar fecha de último login
        usuario.setFechaUltimoLogin(null);

        // Resetear intentos fallidos (opcional, según política)
        usuario.reiniciarIntentosFallidos();

        log.debug("✓ Sesión limpiada para: {}", usuario.getEmail());
    }

    /**
     * Registrar logout exitoso
     */
    private void registrarLogoutExitoso(Usuario usuario) {
        usuarioRepository.save(usuario);

        log.info("✅ [LOGOUT] Sesión cerrada para: {} - Fecha actual: {}",
                usuario.getEmail(), java.time.LocalDateTime.now());
    }
}

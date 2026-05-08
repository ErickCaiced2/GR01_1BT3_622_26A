package com.example.gr01_1bt3_622_26a.controller;

import com.example.gr01_1bt3_622_26a.entity.Usuario;
import com.example.gr01_1bt3_622_26a.entity.Solicitante;
import com.example.gr01_1bt3_622_26a.service.UsuarioService;
import com.example.gr01_1bt3_622_26a.service.SolicitanteService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * 🔐 Controlador de Autenticación y Manejo de Sesiones
 *
 * Responsabilidades:
 * - Mostrar formularios de login (solicitante y admin)
 * - Procesar credenciales de entrada
 * - Crear sesiones del usuario
 * - Cerrar sesiones (logout)
 * - Redirigir según rol
 *
 * Ciclo TDD:
 * 🔴 RED: No existe LoginController
 * 🟢 GREEN: Se crea controlador mínimo
 * 🔵 REFACTOR: Se mejora con validaciones, logging y manejo de sesiones
 */
@Controller
@RequiredArgsConstructor
@Slf4j
public class LoginController {

    private final UsuarioService usuarioService;
    private final SolicitanteService solicitanteService;

    // ========== CONSTANTES DE CONFIGURACIÓN ==========
    private static final int SESSION_TIMEOUT_MINUTES = 30;
    private static final String SESSION_ATTR_USUARIO_ID = "usuarioId";
    private static final String SESSION_ATTR_EMAIL = "email";
    private static final String SESSION_ATTR_NOMBRE = "nombre";
    private static final String SESSION_ATTR_ROL = "rol";
    private static final String SESSION_ATTR_DOCUMENTO = "documentoIdentidad";
    private static final String ROL_ADMIN = "ADMIN";

    // ========== FORMULARIOS DE LOGIN ==========

    /**
     * Mostrar formulario de login para solicitantes
     */
    @GetMapping("/login")
    public String mostrarLoginSolicitante(HttpSession session) {
        log.info("📄 Accediendo a formulario de login de solicitante");

        // Si ya hay sesión activa, redirigir al dashboard
        if (haySessionActiva(session)) {
            String rol = (String) session.getAttribute(SESSION_ATTR_ROL);
            log.info("✓ Usuario ya autenticado con rol: {}", rol);
            return rol != null && rol.equals(ROL_ADMIN)
                    ? "redirect:/admin/dashboard"
                    : "redirect:/solicitudes/mis-solicitudes";
        }

        return "login/loginSolicitante";
    }

    /**
     * Mostrar formulario de login para administradores
     */
    @GetMapping("/login/admin")
    public String mostrarLoginAdmin(HttpSession session) {
        log.info("📄 Accediendo a formulario de login de administrador");

        // Si hay sesión admin, redirigir al dashboard
        if (haySessionActiva(session)) {
            String rol = (String) session.getAttribute(SESSION_ATTR_ROL);
            if (ROL_ADMIN.equals(rol)) {
                log.info("✓ Admin ya autenticado");
                return "redirect:/admin/dashboard";
            }
        }

        return "login/loginAdmin";
    }

    /**
     * Mostrar formulario de acceso público
     */
    @GetMapping("/acceso")
    public String mostrarAcceso() {
        log.info("📄 Accediendo a página de selección de acceso");
        return "login/acceso";
    }

    // ========== PROCESAMIENTO DE LOGIN ==========

    /**
     * Procesar login de solicitante
     *
     * @param email Email del solicitante
     * @param password Contraseña
     * @param session Sesión HTTP para almacenar datos de usuario
     * @param model Modelo para pasar datos a la vista
     * @param redirectAttributes Atributos para redireccionamiento con mensaje flash
     * @return Redirección a dashboard o vuelta al login con error
     */
    @PostMapping("/login/procesar")
    public String procesarLoginSolicitante(
            @RequestParam String email,
            @RequestParam String password,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) {

        log.info("🔐 [LOGIN] Intento de autenticación de solicitante: {}", email);

        try {
            // Validar credenciales
            Usuario usuario = usuarioService.iniciarSesion(email, password);

            // Verificar rol
            if (!usuario.getRol().equals(Usuario.RolUsuario.SOLICITANTE)) {
                log.warn("⚠️ [LOGIN] Usuario con rol incorrecto intentando acceso solicitante: {}", email);
                redirectAttributes.addFlashAttribute("error",
                        "Este usuario no tiene permiso para acceso de solicitante. Use el login de administrador.");
                return "redirect:/acceso";
            }

            // Crear sesión
            crearSesion(session, usuario);

            log.info("✅ [LOGIN] Sesión iniciada para solicitante: {} (ID: {})", email, usuario.getId());
            return "redirect:/";

        } catch (IllegalArgumentException e) {
            log.warn("⚠️ [LOGIN] Error de autenticación para {}: {}", email, e.getMessage());
            redirectAttributes.addFlashAttribute("error", "Email o contraseña incorrectos");
            return "redirect:/login";
        } catch (Exception e) {
            log.error("❌ [LOGIN] Error inesperado durante login: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("error", "Error al procesar login. Intente nuevamente.");
            return "redirect:/login";
        }
    }

    /**
     * Procesar login de administrador
     *
     * @param email Email del administrador
     * @param password Contraseña
     * @param session Sesión HTTP
     * @param redirectAttributes Atributos para mensajes flash
     * @return Redirección a dashboard admin o error
     */
    @PostMapping("/login/admin/procesar")
    public String procesarLoginAdmin(
            @RequestParam String email,
            @RequestParam String password,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        log.info("🔐 [LOGIN] Intento de autenticación de administrador: {}", email);

        try {
            // Validar credenciales
            Usuario usuario = usuarioService.iniciarSesion(email, password);

            // Verificar rol
            if (!usuario.getRol().equals(Usuario.RolUsuario.ADMIN)) {
                log.warn("⚠️ [LOGIN] Usuario con rol incorrecto intentando acceso admin: {}", email);
                redirectAttributes.addFlashAttribute("error",
                        "Este usuario no tiene permisos de administrador. Use el login de solicitante.");
                return "redirect:/acceso";
            }

            // Crear sesión
            crearSesion(session, usuario);

            log.info("✅ [LOGIN] Sesión iniciada para admin: {} (ID: {})", email, usuario.getId());
            return "redirect:/admin/dashboard";

        } catch (IllegalArgumentException e) {
            log.warn("⚠️ [LOGIN] Error de autenticación para admin {}: {}", email, e.getMessage());
            redirectAttributes.addFlashAttribute("error", "Email o contraseña incorrectos");
            return "redirect:/login/admin";
        } catch (Exception e) {
            log.error("❌ [LOGIN] Error inesperado durante login admin: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("error", "Error al procesar login. Intente nuevamente.");
            return "redirect:/login/admin";
        }
    }

    // ========== LOGOUT ==========

    /**
     * Cerrar sesión del usuario
     *
     * @param session Sesión HTTP a invalidar
     * @param redirectAttributes Atributos para mensajes flash
     * @return Redirección a página de inicio
     */
    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        Long usuarioId = (Long) session.getAttribute("usuarioId");

        if (usuarioId != null) {
            try {
                // Invocar servicio de logout en BD
                usuarioService.cerrarSesion(usuarioId);
                log.info("✅ [LOGOUT] Sesión cerrada para usuario ID: {}", usuarioId);
            } catch (Exception e) {
                log.warn("⚠️ [LOGOUT] Error al cerrar sesión en BD para ID {}: {}", usuarioId, e.getMessage());
            }
        }

        // Invalidar sesión HTTP
        session.invalidate();
        log.info("✅ [LOGOUT] Sesión HTTP invalidada");

        redirectAttributes.addFlashAttribute("mensaje", "¡Has cerrado sesión exitosamente!");
        return "redirect:/acceso";
    }

    // ========== MÉTODOS AUXILIARES ==========

    /**
     * 🔵 REFACTOR: Crear sesión HTTP después de autenticación exitosa
     *
     * Mejoras:
     * - Validación de parámetros de entrada
     * - Uso de constantes para atributos de sesión
     * - Logging completo del proceso
     * - Manejo seguro de null para documentoIdentidad
     *
     * @param session Sesión HTTP (no debe ser null)
     * @param usuario Usuario autenticado (no debe ser null)
     * @throws IllegalArgumentException si session o usuario son null
     */
    public void crearSesion(HttpSession session, Usuario usuario) {
        // Validar parámetros de entrada
        validarParametrosSesion(session, usuario);

        try {
            // Configurar tiempo de expiración
            int timeoutSegundos = SESSION_TIMEOUT_MINUTES * 60;
            session.setMaxInactiveInterval(timeoutSegundos);
            log.debug("⏱️ Timeout de sesión configurado: {} minutos", SESSION_TIMEOUT_MINUTES);

            // Guardar datos del usuario
            almacenarAtributosSesion(session, usuario);

            // Log de éxito
            log.info("✅ Sesión creada exitosamente - Usuario: {} (ID: {}) - Timeout: {}min",
                    usuario.getEmail(), usuario.getId(), SESSION_TIMEOUT_MINUTES);

        } catch (Exception e) {
            log.error("❌ Error crítico al crear sesión para usuario {}: {}",
                    usuario.getEmail(), e.getMessage(), e);
            throw new RuntimeException("Error al crear sesión del usuario", e);
        }
    }

    /**
     * 🔵 REFACTOR: Validar que el usuario tenga rol ADMIN
     *
     * Mejoras:
     * - Validación de parámetro null
     * - Validación de estado del usuario
     * - Logging detallado de rechazos
     * - Mensaje de error específico
     *
     * @param usuario Usuario a validar (no debe ser null)
     * @throws IllegalArgumentException si usuario no es ADMIN o es inválido
     */
    public void validarRolAdmin(Usuario usuario) {
        // Validar parámetro
        if (usuario == null) {
            log.warn("⚠️ Intento de validar rol con usuario null");
            throw new IllegalArgumentException("Usuario no puede ser null");
        }

        // Validar que sea ADMIN
        boolean esAdmin = usuario.getRol() != null &&
                          usuario.getRol().equals(Usuario.RolUsuario.ADMIN);

        if (!esAdmin) {
            log.warn("⚠️ [ACCESO DENEGADO] Usuario {} intentó acceso admin - Rol actual: {}",
                    usuario.getEmail() != null ? usuario.getEmail() : "DESCONOCIDO",
                    usuario.getRol());
            throw new IllegalArgumentException("Este usuario no tiene permisos de administrador");
        }

        // Validar estado del usuario
        if (usuario.getEstado() != null && !usuario.esActivo()) {
            log.warn("⚠️ [ACCESO DENEGADO] Usuario admin {} está inactivo - Estado: {}",
                    usuario.getEmail(), usuario.getEstado());
            throw new IllegalArgumentException("Usuario inactivo o bloqueado");
        }

        // Log de éxito
        log.debug("✓ [PERMISO CONCEDIDO] Usuario {} validado como ADMIN", usuario.getEmail());
    }

    /**
     * 🔵 REFACTOR: Verificar si hay sesión HTTP activa
     *
     * @param session Sesión HTTP a verificar
     * @return true si la sesión tiene usuarioId, false en caso contrario
     */
    private boolean haySessionActiva(HttpSession session) {
        return session != null && session.getAttribute(SESSION_ATTR_USUARIO_ID) != null;
    }

    /**
     * 🔵 REFACTOR: Validar parámetros necesarios para crear sesión
     *
     * @param session Sesión HTTP
     * @param usuario Usuario autenticado
     * @throws IllegalArgumentException si algún parámetro es inválido
     */
    private void validarParametrosSesion(HttpSession session, Usuario usuario) {
        if (session == null) {
            log.error("❌ Intento de crear sesión con HttpSession null");
            throw new IllegalArgumentException("Sesión HTTP no puede ser null");
        }

        if (usuario == null) {
            log.error("❌ Intento de crear sesión con Usuario null");
            throw new IllegalArgumentException("Usuario no puede ser null");
        }

        if (usuario.getId() == null || usuario.getId() <= 0) {
            log.error("❌ Usuario con ID inválido: {}", usuario.getId());
            throw new IllegalArgumentException("Usuario debe tener ID válido");
        }

        if (usuario.getEmail() == null || usuario.getEmail().isBlank()) {
            log.error("❌ Usuario sin email válido");
            throw new IllegalArgumentException("Usuario debe tener email válido");
        }

        if (usuario.getRol() == null) {
            log.error("❌ Usuario sin rol asignado");
            throw new IllegalArgumentException("Usuario debe tener rol asignado");
        }
    }

    /**
     * 🔵 REFACTOR: Almacenar atributos del usuario en la sesión HTTP
     *
     * @param session Sesión HTTP
     * @param usuario Usuario autenticado
     */
    private void almacenarAtributosSesion(HttpSession session, Usuario usuario) {
        session.setAttribute(SESSION_ATTR_USUARIO_ID, usuario.getId());
        log.trace("✓ Atributo usuarioId guardado: {}", usuario.getId());

        session.setAttribute(SESSION_ATTR_EMAIL, usuario.getEmail());
        log.trace("✓ Atributo email guardado: {}", usuario.getEmail());

        session.setAttribute(SESSION_ATTR_NOMBRE, usuario.getNombre());
        log.trace("✓ Atributo nombre guardado: {}", usuario.getNombre());

        session.setAttribute(SESSION_ATTR_ROL, usuario.getRol().toString());
        log.trace("✓ Atributo rol guardado: {}", usuario.getRol());

        // Documento de identidad puede ser null, es opcional
        if (usuario.getDocumentoIdentidad() != null && !usuario.getDocumentoIdentidad().isBlank()) {
            session.setAttribute(SESSION_ATTR_DOCUMENTO, usuario.getDocumentoIdentidad());
            log.trace("✓ Atributo documentoIdentidad guardado");
        } else {
            log.debug("ℹ️ Usuario sin documento de identidad registrado");
        }

        // 🆕 Si es SOLICITANTE, obtener y guardar el solicitanteId
        if (usuario.getRol().equals(Usuario.RolUsuario.SOLICITANTE)) {
            var solicitanteOpt = solicitanteService.obtenerPorEmail(usuario.getEmail());
            if (solicitanteOpt.isPresent()) {
                Long solicitanteId = solicitanteOpt.get().getId();
                session.setAttribute("solicitanteId", solicitanteId);
                log.trace("✓ Atributo solicitanteId guardado: {}", solicitanteId);
            } else {
                log.warn("⚠️ Solicitante no encontrado para email: {}", usuario.getEmail());
            }
        }
    }
}

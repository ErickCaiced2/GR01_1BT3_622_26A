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
     * 🆕 FLUJO UNIFICADO: Mostrar formulario único de login
     *
     * El formulario es el mismo para todos los roles.
     * Al ingresar credenciales, el sistema automáticamente:
     * - SOLICITANTE → `/solicitudes/mis-solicitudes`
     * - ADMIN → `/admin/dashboard`
     * - STAFF → `/admin/solicitudes/gestionar`
     */
    @GetMapping("/login")
    public String mostrarLogin(HttpSession session) {
        log.info("📄 Accediendo a formulario de login unificado");

        // Si ya hay sesión activa, redirigir según rol
        if (haySessionActiva(session)) {
            String rol = (String) session.getAttribute(SESSION_ATTR_ROL);
            log.info("✓ Usuario ya autenticado con rol: {}", rol);
            return redirigirSegunRol(rol);
        }

        return "login/login";
    }

    /**
     * @deprecated Redirige a /login (flujo unificado)
     */
    @GetMapping("/login/admin")
    public String mostrarLoginAdmin(HttpSession session) {
        log.warn("⚠️ /login/admin está deprecado, redirigiendo a /login");
        return "redirect:/login";
    }

    /**
     * @deprecated Redirige a /login (flujo unificado)
     */
    @GetMapping("/acceso")
    public String mostrarAcceso() {
        log.warn("⚠️ /acceso está deprecado, redirigiendo a /login");
        return "redirect:/login";
    }

    // ========== PROCESAMIENTO DE LOGIN ==========

    /**
     * 🆕 FLUJO UNIFICADO: Procesar login para TODOS los roles
     *
     * Valida credenciales y redirige automáticamente según el rol del usuario:
     * - SOLICITANTE → `/solicitudes/mis-solicitudes`
     * - ADMIN → `/admin/dashboard`
     * - STAFF → `/admin/solicitudes/gestionar`
     *
     * @param email Email del usuario
     * @param password Contraseña
     * @param session Sesión HTTP para almacenar datos de usuario
     * @param redirectAttributes Atributos para redireccionamiento con mensaje flash
     * @return Redirección a dashboard según rol o vuelta al login con error
     */
    @PostMapping("/login/procesar")
    public String procesarLogin(
            @RequestParam String email,
            @RequestParam String password,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        log.info("🔐 [LOGIN] Intento de autenticación unificado para: {}", email);

        try {
            // Validar credenciales
            Usuario usuario = usuarioService.iniciarSesion(email, password);

            // Crear sesión
            crearSesion(session, usuario);

            // Obtener rol y redirigir automáticamente
            String rol = usuario.getRol().toString();
            String redirectUrl = redirigirSegunRol(rol);

            log.info("✅ [LOGIN] Autenticación exitosa para {} - Rol: {} - Redirigiendo a {}",
                    email, rol, redirectUrl);
            return redirectUrl;

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
     * @deprecated Redirige a /login/procesar (flujo unificado)
     */
    @PostMapping("/login/admin/procesar")
    public String procesarLoginAdmin(
            @RequestParam String email,
            @RequestParam String password,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        log.warn("⚠️ /login/admin/procesar está deprecado, redirigiendo a /login/procesar");
        return procesarLogin(email, password, session, redirectAttributes);
    }

    // ========== LOGOUT ==========

    /**
     * 🆕 Cerrar sesión del usuario (redirige a /login)
     *
     * @param session Sesión HTTP a invalidar
     * @param redirectAttributes Atributos para mensajes flash
     * @return Redirección a página de login
     */
    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        Long usuarioId = (Long) session.getAttribute("usuarioId");
        String email = (String) session.getAttribute("email");

        if (usuarioId != null) {
            try {
                // Invocar servicio de logout en BD
                usuarioService.cerrarSesion(usuarioId);
                log.info("✅ [LOGOUT] Sesión cerrada para usuario ID: {} ({})", usuarioId, email);
            } catch (Exception e) {
                log.warn("⚠️ [LOGOUT] Error al cerrar sesión en BD para ID {}: {}", usuarioId, e.getMessage());
            }
        }

        // Invalidar sesión HTTP
        session.invalidate();
        log.info("✅ [LOGOUT] Sesión HTTP invalidada");

        redirectAttributes.addFlashAttribute("mensaje", "¡Has cerrado sesión exitosamente!");
        return "redirect:/login";
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
     * 🆕 FLUJO UNIFICADO: Redirigir según el rol del usuario
     *
     * Implementa el redirecionamiento automático según rol:
     * - SOLICITANTE → `/solicitudes/mis-solicitudes`
     * - ADMIN → `/admin/dashboard`
     * - STAFF → `/admin/solicitudes/gestionar`
     * - Otro → `/` (inicio)
     *
     * @param rol Rol del usuario (ej: "ADMIN", "SOLICITANTE", "STAFF")
     * @return URL a redirigir
     */
    private String redirigirSegunRol(String rol) {
        if (rol == null) {
            log.warn("⚠️ Rol null, redirigiendo a inicio");
            return "redirect:/";
        }

        return switch (rol) {
            case "ADMIN" -> "redirect:/admin/dashboard";
            case "STAFF" -> "redirect:/admin/solicitudes/gestionar";
            case "SOLICITANTE" -> "redirect:/solicitudes/mis-solicitudes";
            default -> {
                log.warn("⚠️ Rol desconocido: {}, redirigiendo a inicio", rol);
                yield "redirect:/";
            }
        };
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
            if (solicitanteService == null) {
                log.debug("Servicio de solicitantes no disponible; se omite solicitanteId en sesión");
                return;
            }

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

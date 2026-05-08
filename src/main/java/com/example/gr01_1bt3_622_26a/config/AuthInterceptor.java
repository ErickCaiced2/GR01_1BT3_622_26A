package com.example.gr01_1bt3_622_26a.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.util.*;

/**
 * 🔐 Interceptor de Autenticación y Autorización
 *
 * Responsabilidades:
 * - Verificar sesión activa antes de acceder a rutas protegidas
 * - Validar roles de usuario para rutas específicas
 * - Redirigir a login si no hay sesión
 * - Redirigir a acceso denegado si no tiene permisos
 *
 * Rutas Protegidas:
 * - /admin/** → Requiere rol ADMIN
 * - /solicitudes/** → Requiere autenticació (SOLICITANTE)
 * - /solicitantes/** (excepto registro) → Requiere autenticación
 * - /adopciones/** → Puede requerir autenticación según contexto
 */
@Component
@Slf4j
public class AuthInterceptor implements HandlerInterceptor {

    // Rutas que NO requieren autenticación
    private static final Set<String> RUTAS_PUBLICAS = new HashSet<>(Arrays.asList(
            "/",
            "/login",
            "/login/admin",
            "/login/procesar",
            "/login/admin/procesar",
            "/logout",
            "/acceso",
            "/solicitantes/registro",
            "/solicitantes/registrar",
            "/usuarios/registro",
            "/usuarios/crear",
            "/mascotas",
            "/mascotas/disponibles",
            "/mascotas/buscar"
    ));

    // Rutas que requieren rol ADMIN
    private static final Set<String> RUTAS_ADMIN = new HashSet<>(Arrays.asList(
            "/admin"
    ));

    // Rutas que requieren autenticación (cualquier rol)
    private static final Set<String> RUTAS_AUTENTICADAS = new HashSet<>(Arrays.asList(
            "/solicitudes",
            "/adopciones"
    ));

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        String requestURI = request.getRequestURI();

        log.debug("🔍 [AUTH] Verificando acceso a: {}", requestURI);

        // Verificar si es ruta pública
        if (esRutaPublica(requestURI)) {
            log.debug("✓ Ruta pública permitida: {}", requestURI);
            return true;
        }

        // Obtener sesión
        HttpSession session = request.getSession(false);

        // Verificar sesión activa
        if (session == null || session.getAttribute("usuarioId") == null) {
            log.warn("⚠️ [AUTH] Intento de acceso sin sesión a: {}", requestURI);

            // Redirigir según tipo de ruta
            if (requestURI.startsWith("/admin")) {
                response.sendRedirect("/login/admin");
            } else {
                response.sendRedirect("/login");
            }
            return false;
        }

        String rol = (String) session.getAttribute("rol");
        String email = (String) session.getAttribute("email");

        // Verificar rol si es ruta admin
        if (esRutaAdmin(requestURI)) {
            if (!"ADMIN".equals(rol)) {
                log.warn("⚠️ [AUTH] Usuario {} intentó acceso admin sin permisos", email);
                response.sendRedirect("/acceso");
                return false;
            }

            log.info("✅ [AUTH] Acceso admin permitido para: {}", email);
            return true;
        }

        // Verificar si es ruta autenticada
        if (esRutaAutenticada(requestURI)) {
            log.info("✅ [AUTH] Acceso autenticado permitido para {} (rol: {})", email, rol);
            return true;
        }

        // Acceso permitido (otras rutas)
        return true;
    }

    /**
     * Verificar si una ruta es pública (sin necesidad de autenticación)
     */
    private boolean esRutaPublica(String uri) {
        return RUTAS_PUBLICAS.stream()
                .anyMatch(uri::startsWith);
    }

    /**
     * Verificar si una ruta requiere rol ADMIN
     */
    private boolean esRutaAdmin(String uri) {
        return RUTAS_ADMIN.stream()
                .anyMatch(uri::startsWith);
    }

    /**
     * Verificar si una ruta requiere autenticación
     */
    private boolean esRutaAutenticada(String uri) {
        return RUTAS_AUTENTICADAS.stream()
                .anyMatch(uri::startsWith);
    }

    @Override
    public void afterCompletion(HttpServletRequest request,
                                HttpServletResponse response,
                                Object handler,
                                Exception ex) throws Exception {

        if (ex != null) {
            log.error("❌ [AUTH] Error durante procesamiento de request: {}", request.getRequestURI(), ex);
        }
    }
}


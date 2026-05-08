package com.example.gr01_1bt3_622_26a.controller;

import com.example.gr01_1bt3_622_26a.entity.Usuario;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockHttpSession;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 🧪 Tests Unitarios PUROS para LoginController
 *
 * ❌ IMPORTANTE: NO usamos:
 * - @WebMvcTest (no cargamos Spring)
 * - @MockBean (no mockeamos servicios)
 * - MockMvc (no probamos HTTP)
 *
 * ✅ Probamos: Lógica de negocio SIN dependencias
 *
 * Ciclo TDD:
 * 🔴 RED: Tests fallan (método no existe)
 * 🟢 GREEN: Código mínimo para pasar
 * 🔵 REFACTOR: Mejorar sin quebrar tests
 */
class LoginControllerUnitTest {

    private LoginController loginController;
    private Usuario usuarioTest;

    @BeforeEach
    void setUp() {
        loginController = new LoginController(null); // null porque queremos probar SOLO la lógica del controller

        // Usuario de prueba - SIN mocks
        usuarioTest = Usuario.builder()
                .id(1L)
                .email("test@example.com")
                .password("password123")
                .nombre("Juan Test")
                .estado("ACTIVO")
                .rol(Usuario.RolUsuario.SOLICITANTE)
                .intentosFallidos(0)
                .build();
    }

    // ==================== TEST UNITARIO 1 ====================
    /**
     * 🔴 RED: Este test FALLARÁ porque el método crearSesion es private
     * 🟢 GREEN: Hacemos el método public/protected y lo implementamos
     * 🔵 REFACTOR: Mejoramos la lógica
     */
    @Test
    @DisplayName("✅ TEST 1: crearSesion() guarda correctamente datos del usuario en sesión HTTP")
    void testCrearSesion_GuardaTodosLosDatos() {
        // 🔴 RED PHASE: Este test va a fallar inicialmente

        // Arrange - Crear sesión mock (sin Spring)
        HttpSession session = new MockHttpSession();

        // Act - Llamar al método (será private inicialmente, lo hacemos public)
        loginController.crearSesion(session, usuarioTest);

        // Assert - Verificar que los datos se guardaron
        assertNotNull(session.getAttribute("usuarioId"), "usuarioId no debe ser null");
        assertEquals(1L, session.getAttribute("usuarioId"), "usuarioId debe ser 1");

        assertNotNull(session.getAttribute("email"), "email no debe ser null");
        assertEquals("test@example.com", session.getAttribute("email"), "email correcto");

        assertNotNull(session.getAttribute("nombre"), "nombre no debe ser null");
        assertEquals("Juan Test", session.getAttribute("nombre"), "nombre correcto");

        assertNotNull(session.getAttribute("rol"), "rol no debe ser null");
        assertEquals("SOLICITANTE", session.getAttribute("rol"), "rol debe ser SOLICITANTE");

        // documentoIdentidad puede ser null si no fue completado en registro
        // assertEquals("12345678", session.getAttribute("documentoIdentidad"));

        System.out.println("✅ TEST 1 PASSED: Sesión creada con todos los datos requeridos correctamente");
    }

    // ==================== TEST UNITARIO 2 ====================
    /**
     * 🔴 RED: Este test FALLARÁ porque el método no existe
     * 🟢 GREEN: Creamos el método que verifica rol de usuario
     * 🔵 REFACTOR: Mejoramos validaciones
     */
    @Test
    @DisplayName("❌ TEST 2: validarRolUsuario() lanza excepción si usuario no es ADMIN en acceso admin")
    void testValidarRolUsuario_LanzaExcepcionParaSolicitante() {
        // 🔴 RED PHASE: Este test va a fallar

        // Arrange
        Usuario solicitante = Usuario.builder()
                .id(1L)
                .email("solicitante@test.com")
                .password("pass123")
                .nombre("Solicitante")
                .estado("ACTIVO")
                .rol(Usuario.RolUsuario.SOLICITANTE) // ← NO es admin
                .build();

        // Act & Assert - Verificar que lanza excepción
        assertThrows(IllegalArgumentException.class, () -> {
            loginController.validarRolAdmin(solicitante);
        }, "Debe lanzar excepción si usuario no es ADMIN");

        System.out.println("✅ TEST 2 PASSED: Excepción lanzada correctamente para no-admin");
    }

}


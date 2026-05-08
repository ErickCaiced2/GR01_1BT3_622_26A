package com.example.gr01_1bt3_622_26a.config;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 🧪 Tests Unitarios PUROS para AuthInterceptor
 *
 * ❌ NO usamos:
 * - Mocks (MockHttpSession, MockHttpServletRequest)
 * - Spring Framework
 * - Dependencias externas
 *
 * ✅ Probamos: Lógica PURA sin dependencias
 *
 * Ciclo TDD:
 * 🔴 RED: Tests fallan (método no existe)
 * 🟢 GREEN: Código mínimo para pasar
 * 🔵 REFACTOR: Mejorar sin quebrar tests
 */
class AuthInterceptorUnitTest {

    private AuthInterceptor authInterceptor;

    @BeforeEach
    void setUp() {
        // Instancia directa, sin Spring
        authInterceptor = new AuthInterceptor();
    }

    // ==================== TEST UNITARIO 3 ====================
    /**
     * 🔴 RED: Este test FALLARÁ porque el método no existe
     * Lógica pura: validar si un ID de usuario es válido
     */
    @Test
    @DisplayName("✅ TEST 3: isValidUsuarioId() retorna true para IDs válidos (>0)")
    void testIsValidUsuarioId_ReturnsTrueForValidIds() {
        // Arrange
        Long usuarioIdValido1 = 1L;
        Long usuarioIdValido2 = 999L;

        // Act & Assert
        assertTrue(authInterceptor.isValidUsuarioId(usuarioIdValido1),
                "ID 1 debe ser válido");
        assertTrue(authInterceptor.isValidUsuarioId(usuarioIdValido2),
                "ID 999 debe ser válido");

        System.out.println("✅ TEST 3 PASSED: IDs de usuario válidos aceptados");
    }

    // ==================== TEST UNITARIO 4 ====================
    /**
     * 🔴 RED: Este test FALLARÁ porque el método no existe
     * Lógica pura: rechazar IDs inválidos sin mocks
     */
    @Test
    @DisplayName("❌ TEST 4: isValidUsuarioId() retorna false para IDs inválidos (<=0 o null)")
    void testIsValidUsuarioId_ReturnsFalseForInvalidIds() {
        // Arrange
        Long usuarioIdNegativo = -1L;
        Long usuarioIdCero = 0L;
        Long usuarioIdNull = null;

        // Act & Assert
        assertFalse(authInterceptor.isValidUsuarioId(usuarioIdNegativo),
                "ID negativo (-1) debe ser inválido");
        assertFalse(authInterceptor.isValidUsuarioId(usuarioIdCero),
                "ID cero (0) debe ser inválido");
        assertFalse(authInterceptor.isValidUsuarioId(usuarioIdNull),
                "ID null debe ser inválido");

        System.out.println("✅ TEST 4 PASSED: IDs inválidos rechazados correctamente");
    }

    // ==================== TEST UNITARIO 5 (BONUS) ====================
    /**
     * 🔴 RED: Test puro para validación de rol
     * Sin mocks, solo lógica de strings
     */
    @Test
    @DisplayName("🔐 TEST 5: isRolAdmin() retorna true SOLO para 'ADMIN'")
    void testIsRolAdmin_ReturnsTrueOnlyForAdminRole() {
        // Arrange
        String rolAdmin = "ADMIN";
        String rolSolicitante = "SOLICITANTE";
        String rolStaff = "STAFF";
        String rolInvalido = "USUARIO";
        String rolNull = null;

        // Act & Assert
        assertTrue(authInterceptor.isRolAdmin(rolAdmin),
                "Rol 'ADMIN' debe retornar true");
        assertFalse(authInterceptor.isRolAdmin(rolSolicitante),
                "Rol 'SOLICITANTE' debe retornar false");
        assertFalse(authInterceptor.isRolAdmin(rolStaff),
                "Rol 'STAFF' debe retornar false");
        assertFalse(authInterceptor.isRolAdmin(rolInvalido),
                "Rol 'USUARIO' debe retornar false");
        assertFalse(authInterceptor.isRolAdmin(rolNull),
                "Rol null debe retornar false");

        System.out.println("✅ TEST 5 PASSED: Validación de rol ADMIN correcta");
    }
}


package com.example.gr01_1bt3_622_26a.validation;

import com.example.gr01_1bt3_622_26a.entity.Solicitud;
import com.example.gr01_1bt3_622_26a.entity.Solicitante;
import com.example.gr01_1bt3_622_26a.entity.Mascota;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 🧪 Tests Unitarios TDD - Validador de Transiciones de Estado
 *
 * 🔴 RED: Tests fallan porque la clase no existe
 * 🟢 GREEN: Implementar código mínimo para pasar
 * 🔵 REFACTOR: Mejorar y validar edge cases
 */
@DisplayName("Tests - Validador de Transiciones de Estado (T.1.2)")
class SolicitudEstadoValidatorTest {

    private SolicitudEstadoValidator validator;
    private Solicitud solicitud;

    @BeforeEach
    void setUp() {
        validator = new SolicitudEstadoValidator();
        solicitud = Solicitud.builder()
                .id(1L)
                .estado("En revisión")
                .build();
    }

    // ==================== TESTS PARA T.1.2: Validador de Transiciones ====================

    /**
     * 🔴 TEST 1: Transición válida de "En revisión" a "Aprobada"
     *
     * Objetivo: Verificar que transiciones válidas NO lanzan excepción
     *
     * Escenario:
     * - Estado actual: "En revisión"
     * - Estado nuevo: "Aprobada"
     * - Resultado esperado: No lanza excepción ✅
     */
    @Test
    @DisplayName("T.1.2-TEST1: Debería permitir transición válida 'En revisión' → 'Aprobada'")
    void testTransicionValidaEnRevisionAAprobada() {
        // Arrange
        String estadoActual = "En revisión";
        String estadoNuevo = "Aprobada";

        // Act & Assert - No debe lanzar excepción
        assertDoesNotThrow(() -> {
            validator.validarTransicion(estadoActual, estadoNuevo);
        }, "Debería permitir transición de 'En revisión' a 'Aprobada'");
    }

    /**
     * 🔴 TEST 2: Transición inválida de "Aprobada" a "En revisión"
     *
     * Objetivo: Verificar que transiciones inválidas LANZAN excepción
     *
     * Escenario:
     * - Estado actual: "Aprobada"
     * - Estado nuevo: "En revisión"
     * - Resultado esperado: Lanza EstadoInvalidoException ❌
     */
    @Test
    @DisplayName("T.1.2-TEST2: Debería rechazar transición inválida 'Aprobada' → 'En revisión'")
    void testTransicionInvalidaAprobadaAEnRevision() {
        // Arrange
        String estadoActual = "Aprobada";
        String estadoNuevo = "En revisión";

        // Act & Assert - Debe lanzar excepción
        assertThrows(
            EstadoInvalidoException.class,
            () -> validator.validarTransicion(estadoActual, estadoNuevo),
            "Debería lanzar EstadoInvalidoException para transición inválida"
        );
    }
}


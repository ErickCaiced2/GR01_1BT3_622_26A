package com.example.gr01_1bt3_622_26a.entity;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("TAREA 1: Corregir estado inicial de Solicitud")
public class SolicitudTest {

    private Solicitud solicitud;

    @BeforeEach
    void setUp() {
        solicitud = new Solicitud();
    }

    /**
     * 🔴 RED FLAG - Test que falla
     * @PrePersist debe asignar estado "En revisión" cuando la solicitud es nula
     */
    @Test
    @DisplayName("🔴 RED - @PrePersist asigna estado 'En revisión' automáticamente")
    void test_prePersist_asignaEstadoEnRevision() {
        // ARRANGE
        solicitud.setEstado(null);

        // ACT
        solicitud.prePersist();

        // ASSERT
        assertThat(solicitud.getEstado()).isEqualTo("En revisión");
    }
}


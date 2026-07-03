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
     * @PrePersist debe asignar estado "Pendiente" cuando la solicitud es nueva.
     *
     * Nota: el estado inicial fue movido de "En revisión" a "Pendiente" (ver
     * FLUJO_SOLICITUD_ADOPCION.md, sección "Estados Iniciales"); el admin mueve
     * la solicitud a "En revisión" explícitamente vía POST /{id}/enviar-a-revision.
     */
    @Test
    @DisplayName("@PrePersist asigna estado 'Pendiente' automáticamente")
    void test_prePersist_asignaEstadoPendiente() {
        // ARRANGE
        solicitud.setEstado(null);

        // ACT
        solicitud.prePersist();

        // ASSERT
        assertThat(solicitud.getEstado()).isEqualTo("Pendiente");
    }
}


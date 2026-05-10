package com.example.gr01_1bt3_622_26a.entity;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("TDD Tareas 4.1 y 4.2: Campos de Compatibilidad en Entidad y BD")
public class MascotaCompatibilidadTest {

    @Test
    @DisplayName("🔴 RED - La entidad Mascota debe tener los campos de compatibilidad definidos")
    void red_mascotaDebeTenerCamposCompatibilidad() {
        // ARRANGE
        Mascota mascota = new Mascota();

        // ACT
        // Intentamos usar los setters que pide la Tarea 4.1 y 4.2
        mascota.setCompatibleNinos(true);
        mascota.setCompatibleGatos(false);
        mascota.setCompatiblePerros(true);
        mascota.setNivelEnergia("Alta");
        mascota.setTamañoRequerido("Grande");
        mascota.setRequisitosEspeciales("Necesita espacio para correr");
        mascota.setEdadMinimaNinos(10);
        mascota.setEsHipoalergenico(false);
        mascota.setNecesitaPatio(true);

        // ASSERT
        // Verificamos usando los getters
        assertThat(mascota.getCompatibleNinos()).isTrue();
        assertThat(mascota.getCompatibleGatos()).isFalse();
        assertThat(mascota.getCompatiblePerros()).isTrue();
        assertThat(mascota.getNivelEnergia()).isEqualTo("Alta");
        assertThat(mascota.getTamañoRequerido()).isEqualTo("Grande");
        assertThat(mascota.getRequisitosEspeciales()).isEqualTo("Necesita espacio para correr");
        assertThat(mascota.getEdadMinimaNinos()).isEqualTo(10);
        assertThat(mascota.getEsHipoalergenico()).isFalse();
        assertThat(mascota.getNecesitaPatio()).isTrue();
    }
}

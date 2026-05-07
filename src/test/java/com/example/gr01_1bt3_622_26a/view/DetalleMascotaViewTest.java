package com.example.gr01_1bt3_622_26a.view;

import com.example.gr01_1bt3_622_26a.entity.Mascota;
import com.example.gr01_1bt3_622_26a.entity.Foto;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("TAREA 3: Renderizar el detalle de la mascota con manejo de campos opcionales")
public class DetalleMascotaViewTest {

    private DetalleMascotaView view;
    private Mascota mascota;
    private List<Foto> fotos;

    @BeforeEach
    void setUp() {
        view = new DetalleMascotaView();
        fotos = new ArrayList<>();
        
        mascota = new Mascota();
        mascota.setNombre("Buddy");
        mascota.setTipo("Perro");
        mascota.setRaza("Labrador");
        mascota.setEdad(3);
        mascota.setGenero("Macho");
        mascota.setDescripcion("Un perro muy amigable");
    }

    @Test
    @DisplayName("🔴 RED - visualizarDetalleMascota() muestra 'Sin diagnósticos previos' cuando el campo es nulo")
    void red_visualizarDetalleMascota_muestraSinDiagnosticos_cuandoEsNulo() {
        // ARRANGE
        mascota.setDiagnosticosPrevios(null);
        view.cargarDetalleMascota(mascota, fotos);

        // ACT
        String resultado = view.visualizarDetalleMascota();

        // ASSERT
        assertThat(resultado).contains("Sin diagnósticos previos");
        assertThat(resultado).contains("Buddy"); // Verificar que otros campos no se afecten
    }

    @Test
    @DisplayName("🔴 RED - visualizarDetalleMascota() muestra 'Sin diagnósticos previos' cuando el campo está vacío")
    void red_visualizarDetalleMascota_muestraSinDiagnosticos_cuandoEstaVacio() {
        // ARRANGE
        mascota.setDiagnosticosPrevios("");
        view.cargarDetalleMascota(mascota, fotos);

        // ACT
        String resultado = view.visualizarDetalleMascota();

        // ASSERT
        assertThat(resultado).contains("Sin diagnósticos previos");
    }

    @Test
    @DisplayName("🔴 RED - visualizarDetalleMascota() muestra el diagnóstico real cuando existe")
    void red_visualizarDetalleMascota_muestraDiagnosticoReal_cuandoExiste() {
        // ARRANGE
        String diagnostico = "Vacunado contra la rabia";
        mascota.setDiagnosticosPrevios(diagnostico);
        view.cargarDetalleMascota(mascota, fotos);

        // ACT
        String resultado = view.visualizarDetalleMascota();

        // ASSERT
        assertThat(resultado).contains(diagnostico);
        assertThat(resultado).doesNotContain("Sin diagnósticos previos");
    }
}

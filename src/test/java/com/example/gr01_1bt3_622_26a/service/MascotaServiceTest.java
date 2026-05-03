package com.example.gr01_1bt3_622_26a.service;

import com.example.gr01_1bt3_622_26a.entity.Mascota;
import com.example.gr01_1bt3_622_26a.entity.Foto;
import com.example.gr01_1bt3_622_26a.repository.MascotaRepository;
import com.example.gr01_1bt3_622_26a.repository.FotoRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("TAREA 2: Consultar Detalle Completo de Mascota")
public class MascotaServiceTest {

    @Mock
    private MascotaRepository mascotaRepository;

    @Mock
    private FotoRepository fotoRepository;

    @InjectMocks
    private MascotaService mascotaService;

    private static final Long ID_MASCOTA_1 = 1L;
    private static final Long ID_MASCOTA_2 = 2L;
    private Mascota mascota1;
    private Mascota mascota2;

    @BeforeEach
    void configurarDatos() {
        // Mascota 1: Disponible
        mascota1 = new Mascota();
        mascota1.setId(ID_MASCOTA_1);
        mascota1.setNombre("Buddy");
        mascota1.setTipo("Perro");
        mascota1.setRaza("Labrador");
        mascota1.setEstado("Disponible");
        mascota1.setFechaRegistro(LocalDate.now().minusDays(5));
        mascota1.setGenero("Macho");
        mascota1.setDescripcion("Perro amigable y juguetón");
        mascota1.setDiagnosticosPrevios("Vacunado");

        // Mascota 2: Disponible
        mascota2 = new Mascota();
        mascota2.setId(ID_MASCOTA_2);
        mascota2.setNombre("Miau");
        mascota2.setTipo("Gato");
        mascota2.setRaza("Persa");
        mascota2.setEstado("Disponible");
        mascota2.setFechaRegistro(LocalDate.now().minusDays(2));
        mascota2.setGenero("Hembra");
        mascota2.setDescripcion("Gata cariñosa");
        mascota2.setDiagnosticosPrevios(null);
    }

    // ===== TESTS TAREA 1: LISTAR MASCOTAS DISPONIBLES - 🔴 RED FLAG =====

    // ===== TESTS TAREA 2: CONSULTAR DETALLE COMPLETO DE MASCOTA - 🔴 RED FLAG =====

    @Test
    @DisplayName("🔴 RED - obtenerDatosMascota retorna Optional con mascota existente")
    void red_obtenerDatosMascota_conMascotaExistente() {
        // ARRANGE
        when(mascotaRepository.findById(ID_MASCOTA_1))
                .thenReturn(Optional.of(mascota1));

        // ACT
        Optional<Mascota> resultado = mascotaService.obtenerDatosMascota(ID_MASCOTA_1);

        // ASSERT
        assertThat(resultado)
                .isPresent()
                .contains(mascota1);

        assertThat(resultado.get().getId()).isEqualTo(ID_MASCOTA_1);
        assertThat(resultado.get().getNombre()).isEqualTo("Buddy");

        verify(mascotaRepository, times(1))
                .findById(ID_MASCOTA_1);
    }

    @Test
    @DisplayName("🔴 RED - obtenerDatosMascota retorna Optional vacio si no existe")
    void red_obtenerDatosMascota_mascotaNoExiste() {
        // ARRANGE - Escenario 4 de HU: mascota no encontrada
        when(mascotaRepository.findById(999L))
                .thenReturn(Optional.empty());

        // ACT
        Optional<Mascota> resultado = mascotaService.obtenerDatosMascota(999L);

        // ASSERT
        assertThat(resultado)
                .isEmpty();

        verify(mascotaRepository, times(1))
                .findById(999L);
    }

    @Test
    @DisplayName("🔴 RED - obtenerFotosMascota retorna lista con fotos")
    void red_obtenerFotosMascota_conFotos() {
        // ARRANGE
        Foto foto1 = new Foto();
        foto1.setId(1L);
        foto1.setRutaFoto("uploads/foto1.jpg");
        foto1.setMascota(mascota1);

        Foto foto2 = new Foto();
        foto2.setId(2L);
        foto2.setRutaFoto("uploads/foto2.jpg");
        foto2.setMascota(mascota1);

        List<Foto> fotos = Arrays.asList(foto1, foto2);
        when(fotoRepository.findByMascotaId(ID_MASCOTA_1))
                .thenReturn(fotos);

        // ACT
        List<Foto> resultado = mascotaService.obtenerFotosMascota(ID_MASCOTA_1);

        // ASSERT
        assertThat(resultado)
                .isNotNull()
                .hasSize(2)
                .containsExactlyInAnyOrder(foto1, foto2);

        verify(fotoRepository, times(1))
                .findByMascotaId(ID_MASCOTA_1);
    }

    @Test
    @DisplayName("🔴 RED - obtenerFotosMascota retorna lista vacía (nunca null)")
    void red_obtenerFotosMascota_sinFotos() {
        // ARRANGE
        when(fotoRepository.findByMascotaId(ID_MASCOTA_1))
                .thenReturn(Collections.emptyList());

        // ACT
        List<Foto> resultado = mascotaService.obtenerFotosMascota(ID_MASCOTA_1);

        // ASSERT
        assertThat(resultado)
                .isNotNull()
                .isEmpty();

        assertThat(resultado)
                .isInstanceOf(List.class);

        verify(fotoRepository, times(1))
                .findByMascotaId(ID_MASCOTA_1);
    }

    @Test
    @DisplayName("🔴 RED - obtenerFotosMascota retorna lista vacía si el repositorio devuelve null")
    void red_obtenerFotosMascota_retornaListaVacia_siRepositorioDevuelveNull() {
        // ARRANGE
        when(fotoRepository.findByMascotaId(ID_MASCOTA_1))
                .thenReturn(null);

        // ACT
        List<Foto> resultado = mascotaService.obtenerFotosMascota(ID_MASCOTA_1);

        // ASSERT
        assertThat(resultado)
                .isNotNull()
                .isEmpty();

        verify(fotoRepository, times(1))
                .findByMascotaId(ID_MASCOTA_1);
    }

    @Test
    @DisplayName("GREEN - obtenerMascotasRelacionadas retorna solo disponibles del mismo tipo")
    void green_obtenerMascotasRelacionadas_filtraPorTipoEstadoYExclusion() {
        Mascota relacionadaDisponible = new Mascota();
        relacionadaDisponible.setId(3L);
        relacionadaDisponible.setNombre("Rocky");
        relacionadaDisponible.setTipo("Perro");
        relacionadaDisponible.setEstado("Disponible");

        Mascota relacionadaAdoptada = new Mascota();
        relacionadaAdoptada.setId(4L);
        relacionadaAdoptada.setNombre("Max");
        relacionadaAdoptada.setTipo("Perro");
        relacionadaAdoptada.setEstado("Adoptado");

        when(mascotaRepository.findById(ID_MASCOTA_1))
                .thenReturn(Optional.of(mascota1));
        when(mascotaRepository.findByTipo("Perro"))
                .thenReturn(Arrays.asList(mascota1, relacionadaDisponible, relacionadaAdoptada));

        List<Mascota> resultado = mascotaService.obtenerMascotasRelacionadas(ID_MASCOTA_1, 3);

        assertThat(resultado)
                .hasSize(1)
                .containsExactly(relacionadaDisponible);

        verify(mascotaRepository).findById(ID_MASCOTA_1);
        verify(mascotaRepository).findByTipo("Perro");
    }

    @Test
    @DisplayName("GREEN - obtenerMascotasRelacionadas retorna vacia si mascota base no existe")
    void green_obtenerMascotasRelacionadas_retornaVacia_siMascotaBaseNoExiste() {
        when(mascotaRepository.findById(99L))
                .thenReturn(Optional.empty());

        List<Mascota> resultado = mascotaService.obtenerMascotasRelacionadas(99L, 3);

        assertThat(resultado).isEmpty();

        verify(mascotaRepository).findById(99L);
        verify(mascotaRepository, never()).findByTipo(anyString());
    }
}

package com.example.gr01_1bt3_622_26a.controller;

import com.example.gr01_1bt3_622_26a.entity.Foto;
import com.example.gr01_1bt3_622_26a.entity.Mascota;
import com.example.gr01_1bt3_622_26a.service.MascotaService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.flash;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

@ExtendWith(MockitoExtension.class)
@DisplayName("TAREA 2: Consultar y cargar el detalle completo de una mascota")
class MascotaControllerTest {

    private static final Long ID_MASCOTA = 1L;
    private static final String MENSAJE_ERROR = "No fue posible cargar la información de la mascota";

    @Mock
    private MascotaService mascotaService;

    @InjectMocks
    private MascotaController mascotaController;

    private MockMvc mockMvc;
    private Mascota mascota;
    private List<Foto> fotos;
    private List<Mascota> mascotasRelacionadas;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(mascotaController).build();

        mascota = Mascota.builder()
                .id(ID_MASCOTA)
                .nombre("Buddy")
                .tipo("Perro")
                .raza("Labrador")
                .edad(3)
                .genero("Macho")
                .descripcion("Perro amigable y juguetón")
                .diagnosticosPrevios("Vacunado")
                .estado("Disponible")
                .fechaRegistro(LocalDate.now())
                .build();

        Foto foto = Foto.builder()
                .id(10L)
                .rutaFoto("uploads/buddy.jpg")
                .nombreArchivo("buddy.jpg")
                .esPrincipal(true)
                .mascota(mascota)
                .build();

        fotos = List.of(foto);

        Mascota relacionada = Mascota.builder()
                .id(3L)
                .nombre("Rocky")
                .tipo("Perro")
                .raza("Beagle")
                .edad(2)
                .genero("Macho")
                .estado("Disponible")
                .build();

        mascotasRelacionadas = List.of(relacionada);
    }

    @Test
    @DisplayName("🔴 RED - GET /mascotas/detalle/{id} carga mascota, fotos y vista de detalle")
    void red_verDetalleMascota_cargaMascotaFotosYVistaDetalle() throws Exception {
        when(mascotaService.obtenerDatosMascota(ID_MASCOTA)).thenReturn(Optional.of(mascota));
        when(mascotaService.obtenerFotosMascota(ID_MASCOTA)).thenReturn(fotos);
        when(mascotaService.obtenerMascotasRelacionadas(ID_MASCOTA, 3)).thenReturn(mascotasRelacionadas);

        mockMvc.perform(get("/mascotas/detalle/{id}", ID_MASCOTA))
                .andExpect(status().isOk())
                .andExpect(view().name("mascotas/detalleMascota"))
                .andExpect(model().attribute("mascota", mascota))
                .andExpect(model().attribute("fotos", fotos))
                .andExpect(model().attribute("mascotasRelacionadas", mascotasRelacionadas));

        verify(mascotaService).obtenerDatosMascota(ID_MASCOTA);
        verify(mascotaService).obtenerFotosMascota(ID_MASCOTA);
        verify(mascotaService).obtenerMascotasRelacionadas(ID_MASCOTA, 3);
    }

    @Test
    @DisplayName("🔴 RED - GET /mascotas/detalle/{id} redirige a disponibles si la mascota no existe")
    void red_verDetalleMascota_redirigeAListaDisponibles_siMascotaNoExiste() throws Exception {
        when(mascotaService.obtenerDatosMascota(ID_MASCOTA)).thenReturn(Optional.empty());

        mockMvc.perform(get("/mascotas/detalle/{id}", ID_MASCOTA))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/mascotas/disponibles"))
                .andExpect(flash().attribute("error", MENSAJE_ERROR));

        verify(mascotaService).obtenerDatosMascota(ID_MASCOTA);
    }

    @Test
    @DisplayName("🔴 RED - GET /mascotas/detalle/{id} redirige a disponibles si ocurre una excepción")
    void red_verDetalleMascota_redirigeAListaDisponibles_siOcurreExcepcion() throws Exception {
        doThrow(new RuntimeException("fallo inesperado"))
                .when(mascotaService)
                .obtenerDatosMascota(ID_MASCOTA);

        mockMvc.perform(get("/mascotas/detalle/{id}", ID_MASCOTA))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/mascotas/disponibles"))
                .andExpect(flash().attribute("error", MENSAJE_ERROR));

        verify(mascotaService).obtenerDatosMascota(ID_MASCOTA);
    }
}

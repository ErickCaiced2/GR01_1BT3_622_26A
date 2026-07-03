package com.example.gr01_1bt3_622_26a.controller;

import com.example.gr01_1bt3_622_26a.entity.Adopcion;
import com.example.gr01_1bt3_622_26a.service.AdopcionService;
import com.example.gr01_1bt3_622_26a.service.BienestarService;
import com.example.gr01_1bt3_622_26a.service.ContratoService;
import com.example.gr01_1bt3_622_26a.service.MascotaService;
import com.example.gr01_1bt3_622_26a.service.SolicitanteService;
import com.example.gr01_1bt3_622_26a.service.SolicitudService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.nio.file.AccessDeniedException;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("AdopcionController - Tests unitarios (HU15)")
class AdopcionControllerTest {

    @Mock
    private AdopcionService adopcionService;

    @Mock
    private SolicitudService solicitudService;

    @Mock
    private SolicitanteService solicitanteService;

    @Mock
    private MascotaService mascotaService;

    @Mock
    private ContratoService contratoService;

    @Mock
    private BienestarService bienestarService;

    @InjectMocks
    private AdopcionController adopcionController;

    private MockMvc mockMvc;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(adopcionController).build();
    }

    @Test
    @DisplayName("GET /adopciones/{id} expone actualizacionesBienestar en el modelo")
    void verDetalleExponeActualizacionesBienestar() throws Exception {
        Adopcion adopcion = Adopcion.builder().id(1L).build();
        when(adopcionService.obtenerPorId(1L)).thenReturn(Optional.of(adopcion));
        when(bienestarService.listarPorAdopcion(1L)).thenReturn(List.of());

        mockMvc.perform(get("/adopciones/1"))
                .andExpect(status().isOk())
                .andExpect(view().name("adopciones/detalleAdopcion"))
                .andExpect(model().attributeExists("actualizacionesBienestar"));
    }

    @Test
    @DisplayName("POST /adopciones/{id}/bienestar sin sesión redirige con error")
    void registrarBienestarSinSesionRedirigeConError() throws Exception {
        mockMvc.perform(post("/adopciones/1/bienestar")
                        .param("estadoMascota", "Feliz")
                        .param("comentario", "Todo bien"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/adopciones/1"))
                .andExpect(flash().attributeExists("error"));

        verifyNoInteractions(bienestarService);
    }

    @Test
    @DisplayName("POST /adopciones/{id}/bienestar con sesión válida registra la actualización")
    void registrarBienestarConSesionValidaRegistraActualizacion() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("solicitanteId", 5L);

        when(bienestarService.registrar(eq(1L), eq(5L), eq("Feliz"), eq("Todo bien")))
                .thenReturn(null);

        mockMvc.perform(post("/adopciones/1/bienestar")
                        .session(session)
                        .param("estadoMascota", "Feliz")
                        .param("comentario", "Todo bien"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/adopciones/1"))
                .andExpect(flash().attributeExists("mensaje"));

        verify(bienestarService).registrar(1L, 5L, "Feliz", "Todo bien");
    }

    @Test
    @DisplayName("POST /adopciones/{id}/bienestar con solicitante que no es propietario redirige con error")
    void registrarBienestarSinPermisoRedirigeConError() throws Exception {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("solicitanteId", 99L);

        when(bienestarService.registrar(anyLong(), anyLong(), eq("Feliz"), eq("Todo bien")))
                .thenThrow(new AccessDeniedException("No tienes permiso"));

        mockMvc.perform(post("/adopciones/1/bienestar")
                        .session(session)
                        .param("estadoMascota", "Feliz")
                        .param("comentario", "Todo bien"))
                .andExpect(status().is3xxRedirection())
                .andExpect(flash().attributeExists("error"));
    }
}

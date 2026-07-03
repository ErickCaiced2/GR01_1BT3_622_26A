package com.example.gr01_1bt3_622_26a.service;

import com.example.gr01_1bt3_622_26a.entity.ActualizacionBienestar;
import com.example.gr01_1bt3_622_26a.entity.Adopcion;
import com.example.gr01_1bt3_622_26a.entity.Solicitante;
import com.example.gr01_1bt3_622_26a.repository.ActualizacionBienestarRepository;
import com.example.gr01_1bt3_622_26a.repository.AdopcionRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.nio.file.AccessDeniedException;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("BienestarService - Tests unitarios")
class BienestarServiceTest {

    @Mock
    private ActualizacionBienestarRepository actualizacionBienestarRepository;

    @Mock
    private AdopcionRepository adopcionRepository;

    @InjectMocks
    private BienestarService bienestarService;

    @Test
    @DisplayName("registrar guarda la actualización cuando el solicitante es propietario de la adopción")
    void registrarGuardaActualizacionCuandoSolicitanteEsPropietario() throws AccessDeniedException {
        Solicitante solicitante = Solicitante.builder().id(1L).nombre("Ana").build();
        Adopcion adopcion = Adopcion.builder().id(10L).solicitante(solicitante).build();

        when(adopcionRepository.findById(10L)).thenReturn(Optional.of(adopcion));
        when(actualizacionBienestarRepository.save(any(ActualizacionBienestar.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        ActualizacionBienestar resultado = bienestarService.registrar(10L, 1L, "Feliz", "Todo bien");

        assertNotNull(resultado);
        assertEquals("Feliz", resultado.getEstadoMascota());
        assertEquals("Todo bien", resultado.getComentario());

        ArgumentCaptor<ActualizacionBienestar> captor = ArgumentCaptor.forClass(ActualizacionBienestar.class);
        verify(actualizacionBienestarRepository).save(captor.capture());
        assertEquals(adopcion, captor.getValue().getAdopcion());
    }

    @Test
    @DisplayName("registrar lanza AccessDeniedException si el solicitante no es propietario de la adopción")
    void registrarLanzaAccessDeniedSiSolicitanteNoEsPropietario() {
        Solicitante propietario = Solicitante.builder().id(1L).nombre("Ana").build();
        Adopcion adopcion = Adopcion.builder().id(10L).solicitante(propietario).build();

        when(adopcionRepository.findById(10L)).thenReturn(Optional.of(adopcion));

        assertThrows(AccessDeniedException.class,
                () -> bienestarService.registrar(10L, 99L, "Feliz", "Todo bien"));
        verify(actualizacionBienestarRepository, never()).save(any());
    }

    @Test
    @DisplayName("registrar lanza IllegalArgumentException si la adopción no existe")
    void registrarLanzaIllegalArgumentSiAdopcionNoExiste() {
        when(adopcionRepository.findById(99L)).thenReturn(Optional.empty());

        assertThrows(IllegalArgumentException.class,
                () -> bienestarService.registrar(99L, 1L, "Feliz", "Todo bien"));
        verify(actualizacionBienestarRepository, never()).save(any());
    }

    @Test
    @DisplayName("listarPorAdopcion delega en el repositorio")
    void listarPorAdopcionDelegaEnRepositorio() {
        List<ActualizacionBienestar> esperado = List.of(ActualizacionBienestar.builder().id(1L).build());
        when(actualizacionBienestarRepository.findByAdopcionIdOrderByFechaRegistroDesc(10L)).thenReturn(esperado);

        List<ActualizacionBienestar> resultado = bienestarService.listarPorAdopcion(10L);

        assertEquals(esperado, resultado);
    }

    @Test
    @DisplayName("listarTodas delega en el repositorio con detalle")
    void listarTodasDelegaEnRepositorioConDetalle() {
        List<ActualizacionBienestar> esperado = List.of(ActualizacionBienestar.builder().id(1L).build());
        when(actualizacionBienestarRepository.findAllConDetalle()).thenReturn(esperado);

        List<ActualizacionBienestar> resultado = bienestarService.listarTodas();

        assertEquals(esperado, resultado);
    }
}

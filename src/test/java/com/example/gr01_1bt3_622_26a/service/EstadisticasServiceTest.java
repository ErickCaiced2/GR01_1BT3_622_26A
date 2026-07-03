package com.example.gr01_1bt3_622_26a.service;

import com.example.gr01_1bt3_622_26a.entity.Adopcion;
import com.example.gr01_1bt3_622_26a.entity.Mascota;
import com.example.gr01_1bt3_622_26a.entity.Solicitud;
import com.example.gr01_1bt3_622_26a.repository.SolicitudRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("EstadisticasService - Tests unitarios")
class EstadisticasServiceTest {

    @Mock
    private MascotaService mascotaService;

    @Mock
    private SolicitudService solicitudService;

    @Mock
    private AdopcionService adopcionService;

    @Mock
    private SolicitudRepository solicitudRepository;

    @InjectMocks
    private EstadisticasService estadisticasService;

    @Test
    @DisplayName("obtenerEstadisticasGenerales combina conteos de mascotas, solicitudes por estado y adopciones")
    void obtenerEstadisticasGeneralesCombinaTodasLasFuentes() {
        when(mascotaService.obtenerEstadisticas()).thenReturn(Map.of(
                "total", 10L, "disponibles", 6L, "adoptados", 2L, "en_proceso", 2L
        ));
        when(solicitudService.obtenerPorEstado("Pendiente")).thenReturn(List.of(new Solicitud()));
        when(solicitudService.obtenerPorEstado("En revisión")).thenReturn(List.of());
        when(solicitudService.obtenerPorEstado("Aprobada")).thenReturn(List.of(new Solicitud(), new Solicitud()));
        when(solicitudService.obtenerPorEstado("Rechazada")).thenReturn(List.of(new Solicitud()));
        when(solicitudService.obtenerPorEstado("Cancelada")).thenReturn(List.of());
        when(adopcionService.obtenerCompletadas()).thenReturn(List.of(new Adopcion(), new Adopcion()));

        Map<String, Object> resultado = estadisticasService.obtenerEstadisticasGenerales();

        assertEquals(10L, resultado.get("total"));
        assertEquals(4, resultado.get("totalSolicitudes"));
        assertEquals(2, resultado.get("adopcionesCompletadas"));
        assertEquals(50.0, resultado.get("tasaAprobacion"));

        @SuppressWarnings("unchecked")
        Map<String, Integer> porEstado = (Map<String, Integer>) resultado.get("solicitudesPorEstado");
        assertEquals(1, porEstado.get("Pendiente"));
        assertEquals(2, porEstado.get("Aprobada"));
    }

    @Test
    @DisplayName("obtenerEstadisticasGenerales calcula tasa de aprobación 0 cuando no hay solicitudes")
    void obtenerEstadisticasGeneralesTasaCeroSinSolicitudes() {
        when(mascotaService.obtenerEstadisticas()).thenReturn(Map.of(
                "total", 0L, "disponibles", 0L, "adoptados", 0L, "en_proceso", 0L
        ));
        when(solicitudService.obtenerPorEstado(org.mockito.ArgumentMatchers.anyString())).thenReturn(List.of());
        when(adopcionService.obtenerCompletadas()).thenReturn(List.of());

        Map<String, Object> resultado = estadisticasService.obtenerEstadisticasGenerales();

        assertEquals(0.0, resultado.get("tasaAprobacion"));
    }

    @Test
    @DisplayName("obtenerMascotaMasSolicitada retorna la primera mascota de la lista ordenada")
    void obtenerMascotaMasSolicitadaRetornaPrimeraMascota() {
        Mascota top = Mascota.builder().id(1L).nombre("Max").tipo("Perro").build();
        when(solicitudRepository.findMascotasOrdenadasPorNumeroSolicitudes())
                .thenReturn(List.of(top, Mascota.builder().id(2L).nombre("Luna").tipo("Gato").build()));

        Optional<Mascota> resultado = estadisticasService.obtenerMascotaMasSolicitada();

        assertTrue(resultado.isPresent());
        assertEquals("Max", resultado.get().getNombre());
    }

    @Test
    @DisplayName("obtenerMascotaMasSolicitada retorna vacío cuando no hay solicitudes")
    void obtenerMascotaMasSolicitadaRetornaVacioSinSolicitudes() {
        when(solicitudRepository.findMascotasOrdenadasPorNumeroSolicitudes()).thenReturn(List.of());

        Optional<Mascota> resultado = estadisticasService.obtenerMascotaMasSolicitada();

        assertTrue(resultado.isEmpty());
    }
}

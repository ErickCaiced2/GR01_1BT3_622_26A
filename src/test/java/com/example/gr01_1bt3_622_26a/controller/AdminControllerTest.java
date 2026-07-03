package com.example.gr01_1bt3_622_26a.controller;

import com.example.gr01_1bt3_622_26a.entity.ActualizacionBienestar;
import com.example.gr01_1bt3_622_26a.entity.Mascota;
import com.example.gr01_1bt3_622_26a.entity.Solicitante;
import com.example.gr01_1bt3_622_26a.entity.Solicitud;
import com.example.gr01_1bt3_622_26a.service.BienestarService;
import com.example.gr01_1bt3_622_26a.service.EstadisticasService;
import com.example.gr01_1bt3_622_26a.service.MascotaService;
import com.example.gr01_1bt3_622_26a.service.ReporteService;
import com.example.gr01_1bt3_622_26a.service.SolicitudService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

@ExtendWith(MockitoExtension.class)
@DisplayName("AdminController - T.1.4")
class AdminControllerTest {

    @Mock
    private MascotaService mascotaService;

    @Mock
    private SolicitudService solicitudService;

    @Mock
    private BienestarService bienestarService;

    @Mock
    private EstadisticasService estadisticasService;

    @Mock
    private ReporteService reporteService;

    @InjectMocks
    private AdminController adminController;

    private MockMvc mockMvc;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(adminController).build();
    }

    @Test
    @DisplayName("dashboard muestra solicitudes pendientes y limita a 10")
    void dashboardIncluyeSolicitudesPendientesYLimitaADiez() throws Exception {
        when(mascotaService.obtenerEstadisticas()).thenReturn(Map.of(
                "total", 14L,
                "disponibles", 8L,
                "adoptados", 3L,
                "en_proceso", 3L
        ));
        when(mascotaService.obtenerTodasLasMascotas()).thenReturn(List.of());
        when(solicitudService.obtenerPorEstado("En revisión")).thenReturn(List.of(
                solicitudCon("Ana", "ana@example.com", LocalDateTime.of(2026, 5, 8, 10, 0)),
                solicitudCon("Luis", "luis@example.com", LocalDateTime.of(2026, 5, 8, 11, 0)),
                solicitudCon("Marta", "marta@example.com", LocalDateTime.of(2026, 5, 8, 12, 0)),
                solicitudCon("Pedro", "pedro@example.com", LocalDateTime.of(2026, 5, 8, 13, 0)),
                solicitudCon("Sofia", "sofia@example.com", LocalDateTime.of(2026, 5, 8, 14, 0)),
                solicitudCon("Jose", "jose@example.com", LocalDateTime.of(2026, 5, 8, 15, 0)),
                solicitudCon("Paula", "paula@example.com", LocalDateTime.of(2026, 5, 8, 16, 0)),
                solicitudCon("Carlos", "carlos@example.com", LocalDateTime.of(2026, 5, 8, 17, 0)),
                solicitudCon("Maria", "maria@example.com", LocalDateTime.of(2026, 5, 8, 18, 0)),
                solicitudCon("Diego", "diego@example.com", LocalDateTime.of(2026, 5, 8, 19, 0)),
                solicitudCon("Elena", "elena@example.com", LocalDateTime.of(2026, 5, 8, 20, 0))
        ));

        mockMvc.perform(get("/admin/dashboard"))
                .andExpect(status().isOk())
                .andExpect(view().name("admin/dashboard"))
                .andExpect(model().attribute("totalMascotas", 14L))
                .andExpect(model().attribute("mascotasDisponiblesCount", 8L))
                .andExpect(model().attribute("mascotasAdoptadas", 3L))
                .andExpect(model().attribute("mascotasEnProceso", 3L))
                .andExpect(model().attribute("solicitudesPendientesCount", 11))
                .andExpect(model().attribute("solicitudesPendientes", hasSize(10)));
    }

    @Test
    @DisplayName("gestionar estados filtra por fecha y solicitante")
    void gestionarEstadosFiltraPorFechaYSolicitante() throws Exception {
        when(solicitudService.obtenerPorEstado("En revisión")).thenReturn(List.of(
                solicitudCon("Ana Pérez", "ana@example.com", LocalDateTime.of(2026, 5, 8, 9, 0)),
                solicitudCon("Ana Pérez", "ana@example.com", LocalDateTime.of(2026, 5, 7, 9, 0)),
                solicitudCon("Luis Gomez", "luis@example.com", LocalDateTime.of(2026, 5, 8, 12, 0))
        ));

        mockMvc.perform(get("/admin/solicitudes/gestionar")
                        .param("estado", "En revisión")
                        .param("fecha", "2026-05-08")
                        .param("solicitante", "ana"))
                .andExpect(status().isOk())
                .andExpect(view().name("solicitudes/gestionar-estados"))
                .andExpect(model().attribute("estadoSeleccionado", "En revisión"))
                .andExpect(model().attribute("fechaSeleccionada", "2026-05-08"))
                .andExpect(model().attribute("solicitanteSeleccionado", "ana"))
                .andExpect(model().attribute("solicitudes", hasSize(1)));
    }

    @Test
    @DisplayName("HU16: GET /admin/bienestar lista las actualizaciones registradas")
    void bienestarListaActualizacionesRegistradas() throws Exception {
        when(bienestarService.listarTodas()).thenReturn(List.of(
                ActualizacionBienestar.builder().id(1L).estadoMascota("Feliz").build()
        ));

        mockMvc.perform(get("/admin/bienestar"))
                .andExpect(status().isOk())
                .andExpect(view().name("admin/bienestar"))
                .andExpect(model().attribute("actualizaciones", hasSize(1)));
    }

    @Test
    @DisplayName("HU17: GET /admin/estadisticas expone estadisticasGenerales y mascotaMasSolicitada")
    void estadisticasExponeEstadisticasGeneralesYMascotaMasSolicitada() throws Exception {
        when(estadisticasService.obtenerEstadisticasGenerales()).thenReturn(Map.of(
                "total", 10L, "totalSolicitudes", 4, "tasaAprobacion", 50.0
        ));
        when(estadisticasService.obtenerMascotaMasSolicitada()).thenReturn(java.util.Optional.of(
                Mascota.builder().id(1L).nombre("Max").tipo("Perro").build()
        ));

        mockMvc.perform(get("/admin/estadisticas"))
                .andExpect(status().isOk())
                .andExpect(view().name("admin/estadisticas"))
                .andExpect(model().attributeExists("estadisticasGenerales"))
                .andExpect(model().attribute("mascotaMasSolicitada",
                        org.hamcrest.Matchers.hasProperty("nombre", org.hamcrest.Matchers.is("Max"))));
    }

    @Test
    @DisplayName("HU18: GET /admin/reporte/mascotas/descargar retorna un PDF descargable")
    void descargarReporteMascotasPDFRetornaPDFDescargable() throws Exception {
        byte[] pdfFalso = "%PDF-1.4 contenido de prueba".getBytes();
        when(reporteService.generarReporteMascotasPDF()).thenReturn(pdfFalso);

        mockMvc.perform(get("/admin/reporte/mascotas/descargar"))
                .andExpect(status().isOk())
                .andExpect(content().contentType("application/pdf"))
                .andExpect(header().string("Content-Disposition",
                        org.hamcrest.Matchers.containsString("attachment")));
    }

    private Solicitud solicitudCon(String nombre, String email, LocalDateTime fecha) {
        return Solicitud.builder()
                .solicitante(Solicitante.builder()
                        .nombre(nombre)
                        .email(email)
                        .build())
                .mascota(Mascota.builder()
                        .nombre("Luna")
                        .tipo("Perro")
                        .estado("Disponible")
                        .estadoMascota("Disponible")
                        .build())
                .fechaSolicitud(fecha)
                .estado("En revisión")
                .build();
    }
}

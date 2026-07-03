package com.example.gr01_1bt3_622_26a.service;

import com.example.gr01_1bt3_622_26a.entity.Mascota;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;

import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("ReporteService - Tests unitarios")
class ReporteServiceTest {

    @Mock
    private MascotaService mascotaService;

    @Mock
    private TemplateEngine templateEngine;

    @InjectMocks
    private ReporteService reporteService;

    @Test
    @DisplayName("generarReporteMascotasPDF procesa la plantilla de reporte y retorna un PDF no vacío")
    void generarReporteMascotasPDFProcesaPlantillaYRetornaPDF() {
        List<Mascota> mascotas = List.of(
                Mascota.builder().id(1L).nombre("Max").tipo("Perro").genero("Macho").estado("Disponible").build()
        );
        Map<String, Long> estadisticas = Map.of("total", 1L, "disponibles", 1L, "adoptados", 0L, "en_proceso", 0L);

        when(mascotaService.obtenerTodasLasMascotas()).thenReturn(mascotas);
        when(mascotaService.obtenerEstadisticas()).thenReturn(estadisticas);
        when(templateEngine.process(eq("reportes/reporte-mascotas-template"), any(Context.class)))
                .thenReturn("<html><body>Reporte de prueba</body></html>");

        byte[] pdf = reporteService.generarReporteMascotasPDF();

        assertNotNull(pdf);
        assertTrue(pdf.length > 0, "El PDF generado no debe estar vacío");

        ArgumentCaptor<Context> contextCaptor = ArgumentCaptor.forClass(Context.class);
        verify(templateEngine).process(eq("reportes/reporte-mascotas-template"), contextCaptor.capture());
        assertEquals(mascotas, contextCaptor.getValue().getVariable("mascotas"));
        assertEquals(estadisticas, contextCaptor.getValue().getVariable("estadisticas"));
    }
}

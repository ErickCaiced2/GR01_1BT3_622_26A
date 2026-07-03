package com.example.gr01_1bt3_622_26a.service;

import com.example.gr01_1bt3_622_26a.entity.Mascota;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.xhtmlrenderer.pdf.ITextRenderer;

import java.io.ByteArrayOutputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

/**
 * HU18: Servicio de generación de reportes en PDF.
 * Reutiliza el mismo patrón de {@link ContratoService}: renderiza una plantilla
 * Thymeleaf a HTML y la convierte a PDF con Flying Saucer (ITextRenderer).
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class ReporteService {

    private final MascotaService mascotaService;
    private final TemplateEngine templateEngine;

    /**
     * Genera un PDF con el listado completo de mascotas registradas y sus
     * estadísticas de resumen.
     *
     * @return Bytes del archivo PDF generado
     */
    public byte[] generarReporteMascotasPDF() {
        log.info("Generando reporte PDF de mascotas registradas");

        List<Mascota> mascotas = mascotaService.obtenerTodasLasMascotas();
        Map<String, Long> estadisticas = mascotaService.obtenerEstadisticas();

        Context context = new Context();
        context.setVariable("mascotas", mascotas);
        context.setVariable("estadisticas", estadisticas);
        context.setVariable("fechaGeneracion", LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));

        String htmlContent = templateEngine.process("reportes/reporte-mascotas-template", context);

        try {
            byte[] pdfBytes = convertirHTMLaPDF(htmlContent);
            log.info("Reporte PDF de mascotas generado exitosamente - Tamaño: {} bytes", pdfBytes.length);
            return pdfBytes;
        } catch (Exception e) {
            log.error("Error al generar reporte PDF de mascotas", e);
            throw new RuntimeException("Error al generar reporte PDF: " + e.getMessage(), e);
        }
    }

    private byte[] convertirHTMLaPDF(String htmlContent) throws Exception {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        ITextRenderer renderer = new ITextRenderer();
        renderer.setDocumentFromString(htmlContent);
        renderer.layout();
        renderer.createPDF(outputStream);
        return outputStream.toByteArray();
    }
}

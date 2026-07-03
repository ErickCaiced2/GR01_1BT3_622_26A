package com.example.gr01_1bt3_622_26a.service;

import com.example.gr01_1bt3_622_26a.entity.Mascota;
import com.example.gr01_1bt3_622_26a.entity.Solicitante;
import com.example.gr01_1bt3_622_26a.entity.Solicitud;
import com.example.gr01_1bt3_622_26a.repository.MascotaRepository;
import com.example.gr01_1bt3_622_26a.repository.SolicitanteRepository;
import com.example.gr01_1bt3_622_26a.repository.SolicitudRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 🧪 Test de integración con contexto Spring real (sin mocks de Thymeleaf).
 *
 * Estos escenarios existen porque {@link ContratoServiceTest} y
 * {@link ReporteServiceTest} mockean {@code TemplateEngine} y por lo tanto NO
 * detectan errores de cableado real del bean (por ejemplo, un
 * {@code SpringResourceTemplateResolver} construido con {@code new} en vez de
 * como {@code @Bean}, que en producción fallaba con
 * "Application Context cannot be null" al no recibir el ApplicationContext).
 *
 * Al usar @SpringBootTest se levanta el contexto real (incluyendo
 * {@code WebConfig.pdfTemplateEngine}) y se genera un PDF de verdad con
 * Flying Saucer, verificando el flujo completo tal como lo ejecuta un usuario.
 */
@SpringBootTest
@ActiveProfiles("test")
@Transactional
@DisplayName("Generación real de PDFs (contrato y reporte) con contexto Spring completo")
class PdfGeneracionIntegracionTest {

    @Autowired
    private ContratoService contratoService;

    @Autowired
    private ReporteService reporteService;

    @Autowired
    private SolicitudRepository solicitudRepository;

    @Autowired
    private SolicitanteRepository solicitanteRepository;

    @Autowired
    private MascotaRepository mascotaRepository;

    @Test
    @DisplayName("generarContratoPDFDesdeSolicitud produce bytes de PDF reales con la plantilla Thymeleaf")
    void generarContratoPDFDesdeSolicitudProduceBytesRealesDePDF() {
        Solicitante solicitante = solicitanteRepository.save(Solicitante.builder()
                .nombre("Ana")
                .apellido("Gómez")
                .email("ana.integracion@example.com")
                .telefono("0999999999")
                .direccion("Calle Falsa 123")
                .documentoIdentidad("1234567890")
                .build());

        Mascota mascota = mascotaRepository.save(Mascota.builder()
                .nombre("Rocky")
                .tipo("Perro")
                .raza("Mestizo")
                .edad(2)
                .genero("Macho")
                .estado("Disponible")
                .estadoMascota("Disponible")
                .build());

        Solicitud solicitud = solicitudRepository.save(Solicitud.builder()
                .solicitante(solicitante)
                .mascota(mascota)
                .estado("Aprobada")
                .build());

        byte[] pdf = contratoService.generarContratoPDFDesdeSolicitud(solicitud.getId());

        assertNotNull(pdf);
        assertTrue(pdf.length > 0, "El PDF del contrato no debe estar vacío");
        assertPdfValido(pdf);
    }

    @Test
    @DisplayName("ReporteService.generarReporteMascotasPDF produce bytes de PDF reales con la plantilla Thymeleaf")
    void generarReporteMascotasPDFProduceBytesRealesDePDF() {
        mascotaRepository.save(Mascota.builder()
                .nombre("Luna")
                .tipo("Gato")
                .raza("Siamés")
                .edad(1)
                .genero("Hembra")
                .estado("Disponible")
                .estadoMascota("Disponible")
                .build());

        byte[] pdf = reporteService.generarReporteMascotasPDF();

        assertNotNull(pdf);
        assertTrue(pdf.length > 0, "El PDF del reporte no debe estar vacío");
        assertPdfValido(pdf);
    }

    private void assertPdfValido(byte[] pdf) {
        String cabecera = new String(pdf, 0, Math.min(5, pdf.length), java.nio.charset.StandardCharsets.US_ASCII);
        assertEquals("%PDF-", cabecera, "El contenido generado debe ser un PDF válido");
    }
}

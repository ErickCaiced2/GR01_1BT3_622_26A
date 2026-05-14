package com.example.gr01_1bt3_622_26a.service;

import com.example.gr01_1bt3_622_26a.dto.ContratoDTO;
import com.example.gr01_1bt3_622_26a.entity.Adopcion;
import com.example.gr01_1bt3_622_26a.entity.Solicitud;
import com.example.gr01_1bt3_622_26a.repository.AdopcionRepository;
import com.example.gr01_1bt3_622_26a.repository.SolicitudRepository;
import com.example.gr01_1bt3_622_26a.service.mapper.AdopcionContratoMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.xhtmlrenderer.pdf.ITextRenderer;

import java.io.ByteArrayOutputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Optional;

/**
 * 📋 Servicio de Generación de Contratos PDF
 * Responsable de:
 * - Mapear datos de adopción a DTO
 * - Renderizar plantilla HTML con Thymeleaf
 * - Convertir HTML a PDF usando Flying Saucer
 * - Retornar bytes del PDF para descarga
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class ContratoService {

    private final AdopcionRepository adopcionRepository;
    private final SolicitudRepository solicitudRepository;
    private final TemplateEngine templateEngine;
    private final AdopcionContratoMapper adopcionContratoMapper;

    /**
     * Genera un PDF de contrato de adopción a partir de los datos de una adopción
     *
     * @param adopcionId ID de la adopción para la cual generar el contrato
     * @return Bytes del archivo PDF generado
     * @throws RuntimeException si la adopción no existe o hay error en la generación
     */
    public byte[] generarContratoPDF(Long adopcionId) {
        log.info("Iniciando generación de contrato PDF para adopción ID: {}", adopcionId);

        // Obtener datos de la adopción
        Adopcion adopcion = adopcionRepository.findById(adopcionId)
                .orElseThrow(() -> {
                    log.error("Adopción no encontrada con ID: {}", adopcionId);
                    return new RuntimeException("Adopción no encontrada con ID: " + adopcionId);
                });

        try {
            // Mapear entidades a DTO usando el mapper
            ContratoDTO contratoDTO = adopcionContratoMapper.toContratoDTO(adopcion);

            // Preparar contexto de Thymeleaf
            Context context = new Context();
            context.setVariable("numeroContrato", contratoDTO.getNumeroContrato());
            context.setVariable("fechaGeneracion", formatearFecha(contratoDTO.getFechaGeneracion()));
            context.setVariable("nombreRefugio", contratoDTO.getNombreRefugio());
            context.setVariable("representanteLegal", contratoDTO.getRepresentanteLegal());
            context.setVariable("nombreAdoptante", contratoDTO.getNombreAdoptante());
            context.setVariable("cedulaAdoptante", contratoDTO.getCedulaAdoptante());
            context.setVariable("emailAdoptante", contratoDTO.getEmailAdoptante());
            context.setVariable("telefonoAdoptante", contratoDTO.getTelefonoAdoptante());
            context.setVariable("nombreMascota", contratoDTO.getNombreMascota());
            context.setVariable("tipoMascota", contratoDTO.getTipoMascota());
            context.setVariable("razaMascota", contratoDTO.getRazaMascota());
            context.setVariable("edadMascota", contratoDTO.getEdadMascota());
            context.setVariable("descripcionMascota", contratoDTO.getDescripcionMascota());
            context.setVariable("colorMascota", contratoDTO.getColorMascota());
            context.setVariable("vacunasMascota", contratoDTO.getVacunasMascota());

            // Renderizar HTML desde plantilla
            log.debug("Procesando plantilla HTML para contrato");
            String htmlContent = templateEngine.process("contratos/contrato-adopcion-template", context);

            // Convertir HTML a PDF usando ITextRenderer
            log.debug("Convirtiendo HTML a PDF mediante Flying Saucer");
            byte[] pdfBytes = convertirHTMLaPDF(htmlContent);

            log.info("Contrato PDF generado exitosamente para adopción ID: {}", adopcionId);
            return pdfBytes;

        } catch (Exception e) {
            log.error("Error al generar contrato PDF para adopción ID: {}", adopcionId, e);
            throw new RuntimeException("Error al generar contrato PDF: " + e.getMessage(), e);
        }
    }

    /**
     * Genera un PDF de contrato de adopción a partir de los datos de una Solicitud aprobada
     *
     * @param solicitudId ID de la solicitud para la cual generar el contrato
     * @return Bytes del archivo PDF generado
     * @throws RuntimeException si la solicitud no existe o hay error en la generación
     */
    public byte[] generarContratoPDFDesdeSolicitud(Long solicitudId) {
        log.info("Iniciando generación de contrato PDF para solicitud ID: {}", solicitudId);

        // Obtener datos de la solicitud
        Solicitud solicitud = solicitudRepository.findById(solicitudId)
                .orElseThrow(() -> {
                    log.error("Solicitud no encontrada con ID: {}", solicitudId);
                    return new RuntimeException("Solicitud no encontrada con ID: " + solicitudId);
                });

        try {
            // Usar directamente HTML manual (Thymeleaf tiene problemas en transacciones)
            log.debug("Construyendo HTML del contrato manualmente sin Thymeleaf");
            String htmlContent = construirHTMLContratoManual(solicitud);

            log.debug("HTML construido. Tamaño: {} bytes", htmlContent.length());

            // Convertir HTML a PDF usando ITextRenderer
            log.debug("Convirtiendo HTML a PDF mediante Flying Saucer");
            byte[] pdfBytes = convertirHTMLaPDF(htmlContent);

            log.info("Contrato PDF generado exitosamente para solicitud ID: {} - Tamaño: {} bytes",
                solicitudId, pdfBytes.length);
            return pdfBytes;

        } catch (Exception e) {
            log.error("Error al generar contrato PDF para solicitud ID: {}", solicitudId, e);
            throw new RuntimeException("Error al generar contrato PDF: " + e.getMessage(), e);
        }
    }


    /**
     * Construye HTML del contrato manualmente sin usar Thymeleaf
     */
    private String construirHTMLContratoManual(Solicitud solicitud) {
        StringBuilder html = new StringBuilder();
        html.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        html.append("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" ");
        html.append("\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">");
        html.append("<html xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"es\">");
        html.append("<head>");
        html.append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />");
        html.append("<title>CONTRATO DE ADOPCIÓN</title>");
        html.append("<style type=\"text/css\">");
        html.append("body { font-family: Arial, sans-serif; margin: 20px; line-height: 1.6; }");
        html.append("h1 { text-align: center; color: #333; margin-bottom: 10px; }");
        html.append("h2 { color: #555; margin-top: 20px; margin-bottom: 10px; border-bottom: 1px solid #ddd; }");
        html.append("table { width: 100%; border-collapse: collapse; margin-bottom: 15px; }");
        html.append("td { padding: 8px; border: 1px solid #ddd; }");
        html.append(".label { font-weight: bold; background-color: #f0f0f0; width: 30%; }");
        html.append("p { margin: 5px 0; }");
        html.append("ul { margin-left: 20px; }");
        html.append(".footer { margin-top: 30px; border-top: 1px solid #ddd; padding-top: 20px; text-align: center; }");
        html.append("</style>");
        html.append("</head>");
        html.append("<body>");

        html.append("<h1>CONTRATO DE ADOPCIÓN DE MASCOTA</h1>");
        html.append("<p><strong>Número de Contrato:</strong> CONTRATO-SOL-").append(solicitud.getId())
            .append("-").append(System.currentTimeMillis()).append("</p>");
        html.append("<p><strong>Fecha:</strong> ").append(formatearFecha(LocalDate.now())).append("</p>");

        html.append("<h2>DATOS DEL ADOPTANTE</h2>");
        html.append("<table>");
        html.append("<tr><td class=\"label\">Nombre Completo:</td><td>")
            .append(solicitud.getSolicitante().getNombre()).append(" ")
            .append(solicitud.getSolicitante().getApellido()).append("</td></tr>");
        html.append("<tr><td class=\"label\">Cédula/Documento:</td><td>")
            .append(solicitud.getSolicitante().getDocumentoIdentidad()).append("</td></tr>");
        html.append("<tr><td class=\"label\">Email:</td><td>")
            .append(solicitud.getSolicitante().getEmail()).append("</td></tr>");
        html.append("<tr><td class=\"label\">Teléfono:</td><td>")
            .append(solicitud.getSolicitante().getTelefono()).append("</td></tr>");
        html.append("<tr><td class=\"label\">Ciudad:</td><td>")
            .append(solicitud.getSolicitante().getCiudad()).append("</td></tr>");
        html.append("<tr><td class=\"label\">Dirección:</td><td>")
            .append(solicitud.getSolicitante().getDireccion()).append("</td></tr>");
        html.append("</table>");

        html.append("<h2>DATOS DE LA MASCOTA</h2>");
        html.append("<table>");
        html.append("<tr><td class=\"label\">Nombre:</td><td>")
            .append(solicitud.getMascota().getNombre()).append("</td></tr>");
        html.append("<tr><td class=\"label\">Tipo:</td><td>")
            .append(solicitud.getMascota().getTipo()).append("</td></tr>");
        html.append("<tr><td class=\"label\">Raza:</td><td>")
            .append(solicitud.getMascota().getRaza()).append("</td></tr>");
        html.append("<tr><td class=\"label\">Edad:</td><td>")
            .append(solicitud.getMascota().getEdad()).append(" años</td></tr>");
        html.append("<tr><td class=\"label\">Color:</td><td>")
            .append(solicitud.getMascota().getColor()).append("</td></tr>");
        html.append("<tr><td class=\"label\">Descripción:</td><td>")
            .append(solicitud.getMascota().getDescripcion()).append("</td></tr>");
        html.append("</table>");

        html.append("<h2>TÉRMINOS Y CONDICIONES</h2>");
        html.append("<p>El adoptante se compromete a asumir la responsabilidad total del animal adoptado y se obliga a:</p>");
        html.append("<ul>");
        html.append("<li>Proporcionar alimento nutritivo, agua fresca y cuidados veterinarios adecuados.</li>");
        html.append("<li>Mantener un entorno seguro, limpio y cómodo para la mascota.</li>");
        html.append("<li>No abandonar, vender o prestar el animal a terceros sin consentimiento previo del refugio.</li>");
        html.append("<li>No maltratar, abusar o descuidar al animal.</li>");
        html.append("<li>Mantener actualizado el registro de vacunaciones y desparasitaciones.</li>");
        html.append("<li>Informar al refugio de cualquier cambio en la situación del animal.</li>");
        html.append("</ul>");

        html.append("<p><strong>El incumplimiento de estos términos puede resultar en la retirada del animal.</strong></p>");

        html.append("<div class=\"footer\">");
        html.append("<p><strong>Fecha de firma:</strong> ").append(formatearFecha(LocalDate.now())).append("</p>");
        html.append("<br />");
        html.append("<p>_________________________________</p>");
        html.append("<p>Firma del Adoptante</p>");
        html.append("<br /><br />");
        html.append("<p>_________________________________</p>");
        html.append("<p>Firma del Refugio</p>");
        html.append("</div>");

        html.append("</body></html>");

        return html.toString();
    }

    /**
     * Convierte contenido HTML a PDF usando ITextRenderer de Flying Saucer
     *
     * @param htmlContent Contenido HTML a convertir
     * @return Bytes del PDF generado
     * @throws Exception si hay error durante la conversión
     */
    private byte[] convertirHTMLaPDF(String htmlContent) throws Exception {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();

        try {
            ITextRenderer renderer = new ITextRenderer();

            // Configurar opciones de renderizado
            renderer.setDocumentFromString(htmlContent);

            // Realizar layout del documento
            renderer.layout();

            // Generar PDF
            renderer.createPDF(outputStream);

            log.debug("PDF generado correctamente. Tamaño: {} bytes", outputStream.size());
            return outputStream.toByteArray();

        } catch (Exception e) {
            log.error("Error en conversión HTML a PDF", e);
            throw e;
        }
    }

    /**
     * Mapea una entidad Adopcion a ContratoDTO
     * Extrae información de la adopción, solicitante y mascota
     *
     * @param adopcion Entidad de adopción con sus relaciones cargadas
     * @return DTO con datos mappeados para la plantilla de contrato
     * @deprecated Usar {@link AdopcionContratoMapper#toContratoDTO(Adopcion)} en su lugar
     */
    @Deprecated(since = "1.0", forRemoval = true)
    private ContratoDTO mapearAdopcionAContrato(Adopcion adopcion) {
        return adopcionContratoMapper.toContratoDTO(adopcion);
    }

    /**
     * Genera un número de contrato único basado en el ID de adopción
     *
     * @param adopcionId ID de la adopción
     * @return Número de contrato formateado (ej: CONTRATO-1-1715429200000)
     * @deprecated Usar {@link AdopcionContratoMapper} en su lugar
     */
    @Deprecated(since = "1.0", forRemoval = true)
    private String generarNumeroContrato(Long adopcionId) {
        // Formato: CONTRATO-{adopcionId}-{timestamp}
        String numeroContrato = String.format(
                "CONTRATO-%d-%d",
                adopcionId,
                System.currentTimeMillis()
        );
        log.debug("Número de contrato generado: {}", numeroContrato);
        return numeroContrato;
    }

    /**
     * Genera un resumen del estado de vacunación de la mascota
     *
     * @param adopcion Entidad de adopción
     * @return String con resumen de vacunas ("Aplicadas" o "Pendientes")
     * @deprecated Usar {@link AdopcionContratoMapper} en su lugar
     */
    @Deprecated(since = "1.0", forRemoval = true)
    private String generarResumenVacunas(Adopcion adopcion) {
        if (adopcion.getVacunasAplicadas() != null && adopcion.getVacunasAplicadas()) {
            return "Vacunas aplicadas y registradas";
        }
        return "Vacunación pendiente - Se recomienda aplicar dentro de 7 días";
    }

    /**
     * Formatea una fecha LocalDate al formato español (dd/MM/yyyy)
     *
     * @param fecha Fecha a formatear
     * @return String con fecha formateada
     */
    private String formatearFecha(LocalDate fecha) {
        if (fecha == null) {
            return LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        }
        return fecha.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }

    /**
     * Obtiene un contrato previo generado (si existe)
     * Útil para saber si ya se generó un contrato para una adopción
     *
     * @param adopcionId ID de la adopción
     * @return Optional con true si se debe regenerar contrato
     */
    @Transactional
    public Optional<Adopcion> verificarEstadoContrato(Long adopcionId) {
        log.debug("Verificando estado de contrato para adopción ID: {}", adopcionId);
        return adopcionRepository.findById(adopcionId);
    }

    /**
     * Marca que un contrato ha sido firmado (opcional)
     * Actualiza el estado en la base de datos
     *
     * @param adopcionId ID de la adopción
     */
    @Transactional
    public void marcarContratoFirmado(Long adopcionId) {
        log.info("Marcando contrato como firmado para adopción ID: {}", adopcionId);
        adopcionRepository.findById(adopcionId).ifPresent(adopcion -> {
            adopcion.setContratoFirmado(true);
            adopcionRepository.save(adopcion);
            log.info("Contrato marcado como firmado para adopción ID: {}", adopcionId);
        });
    }
}

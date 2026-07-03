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
            // Mapear entidades a DTO usando el mapper
            ContratoDTO contratoDTO = adopcionContratoMapper.toContratoDTODesdeSolicitud(solicitud);

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

            log.info("Contrato PDF generado exitosamente para solicitud ID: {} - Tamaño: {} bytes",
                solicitudId, pdfBytes.length);
            return pdfBytes;

        } catch (Exception e) {
            log.error("Error al generar contrato PDF para solicitud ID: {}", solicitudId, e);
            throw new RuntimeException("Error al generar contrato PDF: " + e.getMessage(), e);
        }
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

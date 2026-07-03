package com.example.gr01_1bt3_622_26a.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.net.URLEncoder;

/**
 * 📞 Servicio para generar enlaces de contacto por WhatsApp hacia el refugio
 * usando el esquema público https://wa.me/ (no requiere API/SDK de WhatsApp).
 */
@Service
@Slf4j
public class WhatsAppLinkService {

    @Value("${app.refugio.whatsapp}")
    private String telefonoRefugio;

    /**
     * Construye una URL de WhatsApp con un mensaje pre-escrito para consultar
     * sobre una solicitud de adopción específica.
     *
     * @param solicitudId     ID de la solicitud sobre la que se consulta
     * @param nombreAdoptante Nombre del solicitante, usado en el mensaje
     * @return URL https://wa.me/{numero}?text={mensaje} lista para abrir en una nueva pestaña
     */
    public String construirUrlContactoSolicitud(Long solicitudId, String nombreAdoptante) {
        String mensaje = String.format(
                "Hola! Soy %s y tengo una consulta sobre mi solicitud de adopción #%d",
                nombreAdoptante != null ? nombreAdoptante : "un adoptante",
                solicitudId
        );
        return construirUrlContacto(mensaje);
    }

    /**
     * Construye una URL de WhatsApp con un mensaje arbitrario.
     *
     * @param mensaje Mensaje a pre-cargar en la conversación
     * @return URL https://wa.me/{numero}?text={mensaje}
     */
    public String construirUrlContacto(String mensaje) {
        String digitos = telefonoRefugio != null ? telefonoRefugio.replaceAll("[^0-9]", "") : "";
        String mensajeCodificado = URLEncoder.encode(mensaje != null ? mensaje : "", StandardCharsets.UTF_8);

        String url = String.format("https://wa.me/%s?text=%s", digitos, mensajeCodificado);
        log.debug("Link de WhatsApp generado: {}", url);
        return url;
    }
}

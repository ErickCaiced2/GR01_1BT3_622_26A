package com.example.gr01_1bt3_622_26a.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("WhatsAppLinkService - Tests unitarios")
class WhatsAppLinkServiceTest {

    private WhatsAppLinkService service;

    @BeforeEach
    void setUp() {
        service = new WhatsAppLinkService();
        ReflectionTestUtils.setField(service, "telefonoRefugio", "+34 666 777 888");
    }

    @Test
    @DisplayName("construirUrlContacto limpia el número a solo dígitos")
    void construirUrlContactoUsaSoloDigitosDelTelefono() {
        String url = service.construirUrlContacto("Hola");

        assertTrue(url.startsWith("https://wa.me/34666777888?text="),
                "La URL debe usar el teléfono sin símbolos: " + url);
    }

    @Test
    @DisplayName("construirUrlContacto codifica el mensaje para URL")
    void construirUrlContactoCodificaMensajeConEspaciosYAcentos() {
        String url = service.construirUrlContacto("Hola! ¿Cómo estás?");

        assertFalse(url.contains(" "), "La URL no debe contener espacios sin codificar");
        assertTrue(url.contains("text="), "La URL debe incluir el parámetro text");
    }

    @Test
    @DisplayName("construirUrlContactoSolicitud arma el mensaje con nombre y número de solicitud")
    void construirUrlContactoSolicitudArmaMensajeConNombreYNumeroSolicitud() {
        String url = service.construirUrlContactoSolicitud(42L, "Ana López");

        assertTrue(url.contains("Ana"), "El mensaje codificado debe incluir el nombre del adoptante");
        assertTrue(url.contains("42"), "El mensaje codificado debe incluir el número de solicitud");
    }

    @Test
    @DisplayName("construirUrlContactoSolicitud usa un valor por defecto si el nombre es nulo")
    void construirUrlContactoSolicitudUsaValorPorDefectoSiNombreEsNulo() {
        String url = service.construirUrlContactoSolicitud(1L, null);

        assertNotNull(url);
        assertTrue(url.startsWith("https://wa.me/34666777888?text="));
    }
}

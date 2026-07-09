package com.example.gr01_1bt3_622_26a.controller;

import com.example.gr01_1bt3_622_26a.entity.DocumentoSolicitante;
import com.example.gr01_1bt3_622_26a.service.DocumentoService;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;

import org.mockito.InjectMocks;
import org.mockito.Mock;

import org.mockito.junit.jupiter.MockitoExtension;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import org.springframework.mock.web.MockMultipartFile;

import java.io.IOException;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.when;

/**
 * 🧪 Test con Mocks — T.2.4
 *
 * Objetivo:
 * Verificar que DocumentController:
 *
 * ✅ Permite subir documentos válidos
 * ✅ Retorna CREATED
 * ✅ Maneja errores correctamente
 * 🔴 RED:
 * FALLA porque DocumentController
 * y subirDocumento() no existen
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("T.2.4 — Endpoint REST subida documentos")
class DocumentControllerTest {

    @Mock
    private DocumentoService documentoService;

    @InjectMocks
    private DocumentController documentController;
    /**
     * TEST con Mockito
     * Escenarios verificados:
     * 1. Subida exitosa de documento
     * 2. Manejo de error por archivo inválido
     * Se utiliza Mockito para simular
     * el comportamiento del servicio.
     */
    @Test
    @DisplayName("TEST 1: Endpoint subida documentos responde correctamente")
    void testSubirDocumento_RespuestaCorrecta() throws IOException {

        // ── Arrange caso exitoso ───────────────────────────────

        MockMultipartFile archivoValido =
                new MockMultipartFile(
                        "archivo",
                        "cedula.pdf",
                        "application/pdf",
                        "pdf".getBytes()
                );

        DocumentoSolicitante documento =
                DocumentoSolicitante.builder()
                        .id(1L)
                        .estadoVerificacion("Pendiente")
                        .build();

        when(documentoService.cargarDocumento(
                anyLong(),
                anyString(),
                any()
        )).thenReturn(documento);

        // ── Act ────────────────────────────────────────────────

        ResponseEntity<?> responseOk =

                documentController.subirDocumento(
                        1L,
                        "Cedula",
                        archivoValido
                );

        // ── Assert ─────────────────────────────────────────────

        assertEquals(
                HttpStatus.CREATED,
                responseOk.getStatusCode()
        );

        // ── Arrange caso error ─────────────────────────────────

        MockMultipartFile archivoGrande =
                new MockMultipartFile(
                        "archivo",
                        "grande.pdf",
                        "application/pdf",
                        new byte[6000000]
                );

        when(documentoService.cargarDocumento(
                anyLong(),
                anyString(),
                any()
        )).thenThrow(
                new IllegalArgumentException(
                        "Archivo demasiado grande"
                )
        );

        // ── Act ────────────────────────────────────────────────

        ResponseEntity<?> responseError =

                documentController.subirDocumento(
                        1L,
                        "Cedula",
                        archivoGrande
                );

        // ── Assert ─────────────────────────────────────────────

        assertEquals(
                HttpStatus.BAD_REQUEST,
                responseError.getStatusCode()
        );

        Map<?, ?> body =
                (Map<?, ?>) responseError.getBody();

        assertEquals(
                "Archivo demasiado grande",
                body.get("error")
        );
    }

    /**
     * HU10 — Endpoint de verificación diferencia el mensaje de
     * confirmación entre Verificado y Rechazado, y traduce las
     * excepciones del servicio a los códigos HTTP correctos.
     */
    @Test
    @DisplayName("TEST 2: verificarDocumento diferencia mensajes y traduce errores a HTTP")
    void testVerificarDocumento_MensajesYCodigosHttp() {

        // ── Verificado ───────────────────────────────────────
        doNothing().when(documentoService).verificarDocumento(1L, "Verificado", null);

        ResponseEntity<?> responseVerificado =
                documentController.verificarDocumento(1L, "Verificado", null);

        assertEquals(HttpStatus.OK, responseVerificado.getStatusCode());
        assertEquals(
                "Documento verificado correctamente",
                ((Map<?, ?>) responseVerificado.getBody()).get("mensaje")
        );

        // ── Rechazado ────────────────────────────────────────
        doNothing().when(documentoService).verificarDocumento(2L, "Rechazado", null);

        ResponseEntity<?> responseRechazado =
                documentController.verificarDocumento(2L, "Rechazado", null);

        assertEquals(HttpStatus.OK, responseRechazado.getStatusCode());
        assertEquals(
                "Documento rechazado correctamente",
                ((Map<?, ?>) responseRechazado.getBody()).get("mensaje")
        );

        // ── Documento inexistente → 404 ───────────────────────
        doThrow(new IllegalArgumentException("Documento no encontrado: 999"))
                .when(documentoService).verificarDocumento(999L, "Verificado", null);

        ResponseEntity<?> responseNotFound =
                documentController.verificarDocumento(999L, "Verificado", null);

        assertEquals(HttpStatus.NOT_FOUND, responseNotFound.getStatusCode());

        // ── Decisión ya registrada → 409 ──────────────────────
        doThrow(new IllegalStateException("El documento #3 ya fue revisado (estado actual: Verificado)"))
                .when(documentoService).verificarDocumento(3L, "Rechazado", null);

        ResponseEntity<?> responseConflict =
                documentController.verificarDocumento(3L, "Rechazado", null);

        assertEquals(HttpStatus.CONFLICT, responseConflict.getStatusCode());
    }
}
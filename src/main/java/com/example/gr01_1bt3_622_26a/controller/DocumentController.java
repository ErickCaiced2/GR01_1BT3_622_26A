package com.example.gr01_1bt3_622_26a.controller;

import com.example.gr01_1bt3_622_26a.dto.DocumentoDTO;
import com.example.gr01_1bt3_622_26a.entity.DocumentoSolicitante;
import com.example.gr01_1bt3_622_26a.service.DocumentoDuplicadoException;
import com.example.gr01_1bt3_622_26a.service.DocumentoService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import org.springframework.web.bind.annotation.*;

import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

import java.util.List;
import java.util.Map;

/**
 * 🌐 Controller — T.2.4
 *
 * Objetivo:
 * Exponer endpoints REST para:
 *
 * ✅ Subida de documentos
 * ✅ Consulta de documentos
 * ✅ Verificación de documentos
 *
 * 🔵 REFACTOR:
 * Implementación alineada al release.md
 * y criterios de aceptación oficiales.
 */
@RestController
@RequestMapping("/api/documentos")
@RequiredArgsConstructor
@Slf4j
public class DocumentController {

    /*
     * Servicio principal de documentos
     */
    private final DocumentoService documentoService;

    /**
     * Endpoint REST para subida de documentos
     *
     * Criterios:
     * ✅ POST retorna 201 CREATED
     * ✅ Incluye estado de verificación
     * ✅ Maneja BAD REQUEST
     */
    @PostMapping("/subir")
    public ResponseEntity<?> subirDocumento(

            @RequestParam("solicitanteId")
            Long solicitanteId,

            @RequestParam("tipoDocumento")
            String tipoDocumento,

            @RequestParam("archivo")
            MultipartFile archivo
    ) {

        try {

            // ── Carga documento ─────────────────────────────

            DocumentoSolicitante documento =

                    documentoService.cargarDocumento(
                            solicitanteId,
                            tipoDocumento,
                            archivo
                    );

            log.info(
                    "Documento cargado correctamente: {}",
                    documento.getId()
            );

            // ── Response exitosa ────────────────────────────

            return ResponseEntity
                    .status(HttpStatus.CREATED)
                    .body(

                            Map.of(

                                    "id",
                                    documento.getId(),

                                    "mensaje",
                                    "Documento subido correctamente",

                                    "estado",
                                    documento.getEstadoVerificacion()
                            )
                    );

        } catch (DocumentoDuplicadoException e) {

            log.warn("Documento duplicado: {}", e.getMessage());

            return ResponseEntity
                    .badRequest()
                    .body(Map.of("error", e.getMessage()));

        } catch (

                IOException |

                IllegalArgumentException e

        ) {

            log.error(
                    "Error subiendo documento",
                    e
            );

            return ResponseEntity
                    .badRequest()
                    .body(

                            Map.of(
                                    "error",
                                    e.getMessage()
                            )
                    );
        }
    }

    /**
     * Obtiene documentos del solicitante
     *
     * Criterio:
     * ✅ GET lista documentos
     */
    @GetMapping("/{solicitanteId}")
    public ResponseEntity<List<DocumentoDTO>>
    obtenerDocumentos(

            @PathVariable
            Long solicitanteId
    ) {

        // ── Obtención documentos ───────────────────────────

        List<DocumentoSolicitante> documentos =

                documentoService
                        .obtenerPorSolicitante(
                                solicitanteId
                        );

        // ── Conversión DTO ─────────────────────────────────

        List<DocumentoDTO> response =

                documentos.stream()

                        .map(documento ->

                                DocumentoDTO.builder()

                                        .id(documento.getId())

                                        .tipoDocumento(
                                                documento.getTipoDocumento()
                                        )

                                        .nombreArchivo(
                                                documento.getNombreArchivo()
                                        )

                                        .estadoVerificacion(
                                                documento.getEstadoVerificacion()
                                        )

                                        .build()
                        )

                        .toList();

        return ResponseEntity.ok(response);
    }

    /**
     * Endpoint verificación documentos
     */
    @GetMapping("/{id}/verificar")
    public ResponseEntity<?> verificarDocumento(

            @PathVariable
            Long id,

            @RequestParam
            String estado,

            @RequestParam(required = false)
            String comentarios
    ) {

        try {

            // ── Verificación documento ─────────────────────────

            documentoService.verificarDocumento(
                    id,
                    estado,
                    comentarios
            );

            log.info(
                    "Documento {} verificado con estado {}",
                    id,
                    estado
            );

            String mensaje = "Rechazado".equals(estado)
                    ? "Documento rechazado correctamente"
                    : "Documento verificado correctamente";

            return ResponseEntity.ok(

                    Map.of(
                            "mensaje",
                            mensaje
                    )
            );

        } catch (IllegalArgumentException e) {

            log.warn("Documento no encontrado para verificar: {}", id);

            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(Map.of("error", e.getMessage()));

        } catch (IllegalStateException e) {

            log.warn("Decisión duplicada sobre documento {}: {}", id, e.getMessage());

            return ResponseEntity
                    .status(HttpStatus.CONFLICT)
                    .body(Map.of("error", e.getMessage()));
        }
    }
}
package com.example.gr01_1bt3_622_26a.service;

/**
 * 🔵 REFACTOR — T.2.3
 * Excepción personalizada para detección de documentos duplicados
 * según especificación del PLANIFICACION_RELEASE_1.0.md
 */
public class DocumentoDuplicadoException extends RuntimeException {

    public DocumentoDuplicadoException(String tipoDocumento, Long solicitanteId) {
        super("Ya existe un documento de tipo '" + tipoDocumento
                + "' para el solicitante ID: " + solicitanteId);
    }
}


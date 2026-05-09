package com.example.gr01_1bt3_622_26a.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 📦 DTO para exposición segura
 * de documentos al frontend.
 *
 * Evita enviar entidad completa.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DocumentoDTO {

    /*
     * ID documento
     */
    private Long id;

    /*
     * Tipo documento
     */
    private String tipoDocumento;

    /*
     * Nombre archivo
     */
    private String nombreArchivo;

    /*
     * Estado verificación
     */
    private String estadoVerificacion;
}
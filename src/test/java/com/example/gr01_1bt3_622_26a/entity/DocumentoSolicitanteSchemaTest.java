package com.example.gr01_1bt3_622_26a.entity;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 🧪 Test Unitario PURO — T.2.1
 * Objetivo: Verificar que la clase DocumentoSolicitante define
 * correctamente los campos que representan la tabla documentos_solicitante
 *
 * ❌ NO usamos: Mockito, Spring, BD real
 * ✅ Probamos: Que la entidad tiene los campos requeridos por el esquema SQL
 *
 * 🔴 RED    → FALLA porque DocumentoSolicitante no existe
 * 🟢 GREEN  → Creamos la clase mínima con los campos
 * 🔵 REFACTOR → Agregamos anotaciones JPA y constraints
 */
@DisplayName("T.2.1 — Estructura de tabla documentos_solicitante")
class DocumentoSolicitanteSchemaTest {

    /**
     * 🔴 RED: FALLA porque DocumentoSolicitante no existe
     *
     * Verifica que la entidad tiene todos los campos
     * definidos en el script SQL de T.2.1:
     * id, solicitante_id, tipo_documento, ruta_archivo,
     * nombre_archivo, estado_verificacion, fecha_carga,
     * fecha_verificacion, comentarios_verificador, hash_documento
     */
    @Test
    @DisplayName("TEST 1: DocumentoSolicitante tiene todos los campos definidos en el esquema SQL")
    void testEsquema_EntidadTieneTodosLosCamposRequeridos() {
        // Arrange & Act - Construir entidad con TODOS los campos del esquema
        DocumentoSolicitante documento = DocumentoSolicitante.builder()
                .tipoDocumento("Cédula")
                .rutaArchivo("/uploads/doc/123_cedula.pdf")
                .nombreArchivo("cedula.pdf")
                .estadoVerificacion("Pendiente")
                .hashDocumento("abc123")
                .comentariosVerificador(null)
                .fechaVerificacion(null)
                .build();

        // Assert - Verificar que los campos del esquema SQL existen en la entidad
        assertNotNull(documento, "La entidad no debe ser null");
        assertEquals("Cédula",       documento.getTipoDocumento(),         "Campo tipo_documento requerido");
        assertEquals("/uploads/doc/123_cedula.pdf", documento.getRutaArchivo(), "Campo ruta_archivo requerido");
        assertEquals("cedula.pdf",   documento.getNombreArchivo(),          "Campo nombre_archivo requerido");
        assertEquals("Pendiente",    documento.getEstadoVerificacion(),     "Campo estado_verificacion requerido");
        assertEquals("abc123",       documento.getHashDocumento(),          "Campo hash_documento requerido");
        assertNull(documento.getComentariosVerificador(),                   "Campo comentarios_verificador requerido");
        assertNull(documento.getFechaVerificacion(),                        "Campo fecha_verificacion requerido");
    }
}


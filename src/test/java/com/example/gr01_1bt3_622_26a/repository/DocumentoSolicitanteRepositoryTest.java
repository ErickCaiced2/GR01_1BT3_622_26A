package com.example.gr01_1bt3_622_26a.repository;

import com.example.gr01_1bt3_622_26a.entity.DocumentoSolicitante;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

/**
 * 🧪 Test con Mocks — T.2.2
 * Objetivo: Verificar que DocumentoSolicitanteRepository
 * expone los query methods definidos en la planificación
 *
 * ✅ Usamos: Mockito (@Mock) para simular el repositorio
 * ❌ NO usamos: BD real, Spring context
 *
 * Query methods requeridos por el MD:
 * - findBySolicitanteIdAndEstadoVerificacion(Long, String) → List
 * - findBySolicitanteIdAndTipoDocumento(Long, String)      → Optional
 *
 * 🔴 RED    → FALLA porque DocumentoSolicitanteRepository no existe
 * 🟢 GREEN  → Creamos la interfaz con los query methods
 * 🔵 REFACTOR → Refinamos con @Query si es necesario
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("T.2.2 — Repositorio DocumentoSolicitanteRepository (query methods)")
class DocumentoSolicitanteRepositoryTest {

    @Mock
    private DocumentoSolicitanteRepository documentoRepository;

    /**
     * 🔴 RED: FALLA porque DocumentoSolicitanteRepository no existe
     *
     * Verifica los dos query methods requeridos por el MD:
     * 1. findBySolicitanteIdAndEstadoVerificacion → retorna lista filtrada por estado
     * 2. findBySolicitanteIdAndTipoDocumento      → retorna Optional (existe / no existe)
     */
    @Test
    @DisplayName("TEST 1: Query methods del repositorio retornan resultados correctos según parámetros")
    void testQueryMethods_RetornanResultadosCorrectos() {
        // ── Arrange ──────────────────────────────────────────────────
        Long solicitanteId = 1L;

        DocumentoSolicitante docCedula = DocumentoSolicitante.builder()
                .id(1L)
                .tipoDocumento("Cédula")
                .rutaArchivo("/uploads/cedula.pdf")
                .nombreArchivo("cedula.pdf")
                .estadoVerificacion("Pendiente")
                .build();

        when(documentoRepository.findBySolicitanteIdAndEstadoVerificacion(solicitanteId, "Pendiente"))
                .thenReturn(List.of(docCedula));

        when(documentoRepository.findBySolicitanteIdAndTipoDocumento(solicitanteId, "Cédula"))
                .thenReturn(Optional.of(docCedula));

        when(documentoRepository.findBySolicitanteIdAndTipoDocumento(99L, "Comprobante_Domicilio"))
                .thenReturn(Optional.empty());

        // ── Act & Assert: query 1 ─────────────────────────────────────
        List<DocumentoSolicitante> porEstado =
                documentoRepository.findBySolicitanteIdAndEstadoVerificacion(solicitanteId, "Pendiente");

        assertNotNull(porEstado, "Lista no debe ser null");
        assertEquals(1, porEstado.size(), "Debe retornar 1 documento pendiente");
        assertEquals("Pendiente", porEstado.getFirst().getEstadoVerificacion(), "Estado incorrecto");

        // ── Act & Assert: query 2 presente ───────────────────────────
        Optional<DocumentoSolicitante> porTipoExiste =
                documentoRepository.findBySolicitanteIdAndTipoDocumento(solicitanteId, "Cédula");

        assertTrue(porTipoExiste.isPresent(), "Debe encontrar el documento existente");
        assertEquals("Cédula", porTipoExiste.get().getTipoDocumento(), "Tipo de documento incorrecto");

        // ── Act & Assert: query 2 vacío ───────────────────────────────
        Optional<DocumentoSolicitante> porTipoVacio =
                documentoRepository.findBySolicitanteIdAndTipoDocumento(99L, "Comprobante_Domicilio");

        assertFalse(porTipoVacio.isPresent(), "Debe retornar Optional vacío para solicitante inexistente");
    }
}

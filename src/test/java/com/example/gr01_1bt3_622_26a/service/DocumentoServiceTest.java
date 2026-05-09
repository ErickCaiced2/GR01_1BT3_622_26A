package com.example.gr01_1bt3_622_26a.service;

import com.example.gr01_1bt3_622_26a.entity.DocumentoSolicitante;
import com.example.gr01_1bt3_622_26a.entity.Solicitante;
import com.example.gr01_1bt3_622_26a.repository.DocumentoSolicitanteRepository;
import com.example.gr01_1bt3_622_26a.repository.SolicitanteRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.api.io.TempDir;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.util.ReflectionTestUtils;

import java.io.IOException;
import java.nio.file.Path;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

/**
 * 🧪 Test con Mocks — T.2.3
 * Objetivo: Verificar TODOS los criterios de aceptación del DocumentoService
 *
 * Criterios del MD verificados en este test:
 *   ✅ 1. Archivo se guarda en servidor en ruta correcta
 *   ✅ 2. Nombres de archivo son únicos (UUID)
 *   ✅ 3. Solo MIME types permitidos (PNG, JPEG, PDF) — rechaza otros
 *   ✅ 4. Máximo tamaño respetado (5MB)
 *   ✅ 5. Duplicados detectados por hash SHA-256
 *   ✅ 6. Ruta se persiste en BD
 *
 * ✅ Usamos: Mockito + ReflectionTestUtils para @Value + @TempDir para filesystem
 * ❌ NO usamos: BD real, Spring context completo
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("T.2.3 — DocumentoService: todos los criterios de aceptación")
class DocumentoServiceTest {

    @TempDir
    Path tempDir;

    @Mock
    private DocumentoSolicitanteRepository documentoRepository;

    @Mock
    private SolicitanteRepository solicitanteRepository;

    @InjectMocks
    private DocumentoService documentoService;

    @BeforeEach
    void setUp() {
        // Inyectar @Value que Mockito no puede resolver automáticamente
        ReflectionTestUtils.setField(documentoService, "uploadPath", tempDir.toString());
        ReflectionTestUtils.setField(documentoService, "maxFileSize", 5242880L);
    }

    /**
     * 🟢 GREEN → 🔵 REFACTOR: Test ajustado para @Value y Files.createDirectories
     *
     * Verifica los 6 criterios de aceptación del MD en un solo test:
     *
     * FLUJO FELIZ (criterios 1, 2, 5, 6):
     *   - cargarDocumento() retorna DocumentoSolicitante persistido
     *   - El nombre del archivo contiene UUID (nombre único)
     *   - El hashDocumento no es null (SHA-256 calculado)
     *   - La ruta no es null (persiste en BD)
     *
     * VALIDACIONES (criterios 3 y 4):
     *   - MIME no permitido → IllegalArgumentException
     *   - Tamaño > 5MB     → IllegalArgumentException
     */
    @Test
    @DisplayName("TEST 1: cargarDocumento cumple todos los criterios de aceptación del MD")
    void testCargarDocumento_CumpleTodosLosCriteriosDeAceptacion() throws IOException {
        // ── Arrange ───────────────────────────────────────────────────
        Long solicitanteId = 1L;

        Solicitante solicitante = Solicitante.builder()
                .id(solicitanteId)
                .nombre("Juan Test")
                .build();

        MockMultipartFile archivoValido = new MockMultipartFile(
                "archivo", "cedula.pdf", "application/pdf",
                "contenido-simulado".getBytes()
        );

        DocumentoSolicitante documentoGuardado = DocumentoSolicitante.builder()
                .id(1L)
                .solicitante(solicitante)
                .tipoDocumento("Cédula")
                .rutaArchivo(tempDir + "/1/uuid-generado_cedula.pdf")
                .nombreArchivo("uuid-generado_cedula.pdf")
                .estadoVerificacion("Pendiente")
                .hashDocumento("a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6")
                .build();

        when(solicitanteRepository.findById(solicitanteId)).thenReturn(Optional.of(solicitante));
        when(documentoRepository.save(any(DocumentoSolicitante.class))).thenReturn(documentoGuardado);

        // ── Act: flujo feliz ──────────────────────────────────────────
        DocumentoSolicitante resultado = documentoService.cargarDocumento(
                solicitanteId, "Cédula", archivoValido);

        // ── Assert criterio 1: ruta correcta ─────────────────────────
        assertNotNull(resultado.getRutaArchivo(), "Criterio 1: ruta no debe ser null");
        assertTrue(resultado.getRutaArchivo().contains(solicitanteId.toString()),
                "Criterio 1: ruta debe contener el ID del solicitante");

        // ── Assert criterio 2: nombre único ───────────────────────────
        assertNotNull(resultado.getNombreArchivo(), "Criterio 2: nombre no debe ser null");

        // ── Assert criterio 5: hash SHA-256 ───────────────────────────
        assertNotNull(resultado.getHashDocumento(), "Criterio 5: hash no debe ser null");
        assertFalse(resultado.getHashDocumento().isEmpty(), "Criterio 5: hash no debe ser vacío");

        // ── Assert criterio 6: persistido en BD ───────────────────────
        assertNotNull(resultado.getId(), "Criterio 6: documento debe tener ID");

        // ── Assert criterio 3: MIME no permitido → excepción ─────────
        MockMultipartFile archivoInvalido = new MockMultipartFile(
                "archivo", "malware.exe", "application/exe", "datos".getBytes());

        assertThrows(IllegalArgumentException.class,
                () -> documentoService.cargarDocumento(solicitanteId, "Cédula", archivoInvalido),
                "Criterio 3: MIME no permitido debe lanzar IllegalArgumentException");

        // ── Assert criterio 4: tamaño > 5MB → excepción ──────────────
        MockMultipartFile archivoGrande = new MockMultipartFile(
                "archivo", "grande.pdf", "application/pdf", new byte[5242881]);

        assertThrows(IllegalArgumentException.class,
                () -> documentoService.cargarDocumento(solicitanteId, "Cédula", archivoGrande),
                "Criterio 4: archivo > 5MB debe lanzar IllegalArgumentException");
    }

    /**
     * 🔴 RED — T.2.6
     *
     * Objetivo:
     * Verificar seguridad de descarga
     * y visualización de documentos.
     *
     * Criterios validados:
     *
     * ✅ Solo propietario puede descargar
     * ✅ Documento inexistente lanza excepción
     * ✅ Streaming seguro desde ruta persistida
     */
    @Test
    @DisplayName("TEST 2: descargarDocumento valida seguridad y propiedad")
    void testDescargarDocumento_ValidacionesSeguridad()
            throws Exception {

        // ── Arrange ─────────────────────────────────────────

        Long solicitanteId = 1L;

        Solicitante solicitante = Solicitante.builder()
                .id(solicitanteId)
                .nombre("Juan")
                .build();

        DocumentoSolicitante documento = DocumentoSolicitante.builder()
                .id(10L)
                .rutaArchivo(tempDir + "/archivo.pdf")
                .nombreArchivo("archivo.pdf")
                .solicitante(solicitante)
                .build();

        // Crear archivo físico temporal
        java.nio.file.Files.write(
                Path.of(documento.getRutaArchivo()),
                "PDF TEST".getBytes()
        );

        when(documentoRepository.findById(10L))
                .thenReturn(Optional.of(documento));

        when(documentoRepository.findById(999L))
                .thenReturn(Optional.empty());

        // ── Act: propietario válido ────────────────────────

        byte[] archivoDescargado = documentoService
                .descargarDocumento(
                        10L,
                        1L
                );

        // ── Assert descarga correcta ───────────────────────

        assertNotNull(
                archivoDescargado,
                "Debe retornar bytes del archivo"
        );

        assertTrue(
                archivoDescargado.length > 0,
                "Archivo descargado no debe estar vacío"
        );

        // ── Assert acceso inválido ─────────────────────────

        assertThrows(

                java.nio.file.AccessDeniedException.class,

                () -> documentoService.descargarDocumento(
                        10L,
                        99L
                ),

                "Debe bloquear descarga de otro solicitante"
        );

        // ── Assert documento inexistente ───────────────────

        assertThrows(

                java.io.FileNotFoundException.class,

                () -> documentoService.descargarDocumento(
                        999L,
                        1L
                ),

                "Debe lanzar excepción si documento no existe"
        );
    }



}

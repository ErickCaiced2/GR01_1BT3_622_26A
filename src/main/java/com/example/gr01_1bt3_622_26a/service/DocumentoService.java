package com.example.gr01_1bt3_622_26a.service;

import com.example.gr01_1bt3_622_26a.entity.DocumentoSolicitante;
import com.example.gr01_1bt3_622_26a.entity.Solicitante;
import com.example.gr01_1bt3_622_26a.repository.DocumentoSolicitanteRepository;
import com.example.gr01_1bt3_622_26a.repository.SolicitanteRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.util.UUID;

/**
 * 🔵 REFACTOR — T.2.3
 * Servicio completo de carga de documentos según PLANIFICACION_RELEASE_1.0.md:
 *
 *   - @Value para configuración externa (ruta y tamaño max)
 *   - @Transactional para garantizar atomicidad
 *   - @Slf4j para trazabilidad
 *   - Detección de duplicados por hash SHA-256
 *   - DocumentoDuplicadoException personalizada
 *   - Creación de directorios si no existen
 */
@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class DocumentoService {

    @Value("${app.upload.document.path:/var/uploads/documentos}")
    private String uploadPath;

    @Value("${app.upload.document.max-size:5242880}")
    private long maxFileSize;

    private final DocumentoSolicitanteRepository documentoRepository;
    private final SolicitanteRepository solicitanteRepository;

    public DocumentoSolicitante cargarDocumento(Long solicitanteId,
                                                String tipoDocumento,
                                                MultipartFile archivo) throws IOException {
        log.info("Iniciando carga de documento tipo '{}' para solicitante ID: {}", tipoDocumento, solicitanteId);

        // Criterio 3: validar MIME type
        if (!isAllowedMimeType(archivo.getContentType())) {
            log.warn("Tipo de archivo no permitido: {}", archivo.getContentType());
            throw new IllegalArgumentException("Tipo de archivo no permitido: " + archivo.getContentType());
        }

        // Criterio 4: validar tamaño
        validarTamanoArchivo(archivo.getSize());

        // Criterio 5: calcular hash y detectar duplicados
        String hash = calcularHash(archivo.getBytes());
        log.debug("Hash SHA-256 calculado: {}", hash);

        // Detectar documento duplicado por tipo para el mismo solicitante
        documentoRepository.findBySolicitanteIdAndTipoDocumento(solicitanteId, tipoDocumento)
                .ifPresent(doc -> { throw new DocumentoDuplicadoException(tipoDocumento, solicitanteId); });

        // Criterio 2: nombre único con UUID
        String nombreUnico = UUID.randomUUID() + "_" + archivo.getOriginalFilename();

        // Criterio 1: ruta con ID del solicitante y crear directorios
        Path rutaCompleta = Path.of(uploadPath, solicitanteId.toString(), nombreUnico);
        Files.createDirectories(rutaCompleta.getParent());

        // Criterio 6: persistir en BD
        Solicitante solicitante = solicitanteRepository.findById(solicitanteId)
                .orElseThrow(() -> new IllegalArgumentException("Solicitante no encontrado: " + solicitanteId));

        DocumentoSolicitante documento = DocumentoSolicitante.builder()
                .solicitante(solicitante)
                .tipoDocumento(tipoDocumento)
                .rutaArchivo(rutaCompleta.toString())
                .nombreArchivo(nombreUnico)
                .hashDocumento(hash)
                .build();

        DocumentoSolicitante guardado = documentoRepository.save(documento);
        log.info("Documento guardado con ID: {} para solicitante ID: {}", guardado.getId(), solicitanteId);
        return guardado;
    }

    public boolean isAllowedMimeType(String contentType) {
        if (contentType == null) return false;
        return contentType.matches("^image/(png|jpeg)$|^application/pdf$");
    }

    public void validarTamanoArchivo(long tamanoBytes) {
        if (tamanoBytes > maxFileSize) {
            throw new IllegalArgumentException(
                "Archivo excede el tamaño máximo permitido de 5MB. Tamaño: " + tamanoBytes + " bytes");
        }
    }

    private String calcularHash(byte[] contenido) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(contenido);
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("Error calculando hash SHA-256", e);
        }
    }
}

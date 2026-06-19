package com.example.gr01_1bt3_622_26a.service;

import com.example.gr01_1bt3_622_26a.entity.DocumentoSolicitante;
import com.example.gr01_1bt3_622_26a.entity.Solicitante;
import com.example.gr01_1bt3_622_26a.repository.DocumentoSolicitanteRepository;
import com.example.gr01_1bt3_622_26a.repository.SolicitanteRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.AccessDeniedException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.util.List;
import java.util.UUID;

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

    // =========================
    // 🔵 CASO: CARGA DOCUMENTO
    // =========================
    public DocumentoSolicitante cargarDocumento(Long solicitanteId,
                                                String tipoDocumento,
                                                MultipartFile archivo) throws IOException {

        validarArchivo(archivo);

        String hash = calcularHash(archivo.getBytes());

        validarDuplicado(solicitanteId, tipoDocumento);

        String nombreUnico = generarNombreUnico(archivo.getOriginalFilename());
        Path ruta = construirRuta(solicitanteId, nombreUnico);

        Solicitante solicitante = obtenerSolicitante(solicitanteId);

        DocumentoSolicitante documento = DocumentoSolicitante.builder()
                .solicitante(solicitante)
                .tipoDocumento(tipoDocumento)
                .rutaArchivo(ruta.toString())
                .nombreArchivo(nombreUnico)
                .hashDocumento(hash)
                .build();

        crearDirectorioSiNoExiste(ruta);

        DocumentoSolicitante guardado = documentoRepository.save(documento);

        log.info("Documento guardado ID={} solicitante={}", guardado.getId(), solicitanteId);

        return guardado;
    }

    // =========================
    // 🔵 CASO: DESCARGA SEGURA
    // =========================
    public byte[] descargarDocumento(Long documentoId, Long solicitanteId)
            throws IOException {

        DocumentoSolicitante documento = obtenerDocumento(documentoId);

        validarPropietario(documento, solicitanteId);

        Path ruta = Path.of(documento.getRutaArchivo());

        log.info("Descarga documento ID={} por solicitante={}", documentoId, solicitanteId);

        return Files.readAllBytes(ruta);
    }

    // =========================
    // 🔵 CASO: VISUALIZACIÓN
    // =========================
    public Resource visualizarDocumento(Long documentoId)
            throws FileNotFoundException {

        DocumentoSolicitante documento = obtenerDocumento(documentoId);

        Path ruta = Path.of(documento.getRutaArchivo());

        return new FileSystemResource(ruta);
    }

    // ======================================================
    // 🔧 MÉTODOS EXTRAÍDOS (REFACTOR CLAVE)
    // ======================================================

    private DocumentoSolicitante obtenerDocumento(Long id) throws FileNotFoundException {
        return documentoRepository.findById(id)
                .orElseThrow(() -> new FileNotFoundException("Documento no encontrado"));
    }

    private Solicitante obtenerSolicitante(Long id) {
        return solicitanteRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Solicitante no encontrado"));
    }

    private void validarPropietario(DocumentoSolicitante doc, Long solicitanteId)
            throws AccessDeniedException {

        if (!doc.getSolicitante().getId().equals(solicitanteId)) {
            log.warn("Acceso denegado doc={} solicitante={}", doc.getId(), solicitanteId);
            throw new AccessDeniedException("No tienes permiso para este documento");
        }
    }

    private void validarArchivo(MultipartFile archivo) {

        if (!isAllowedMimeType(archivo.getContentType())) {
            throw new IllegalArgumentException("MIME no permitido: " + archivo.getContentType());
        }

        if (archivo.getSize() > maxFileSize) {
            throw new IllegalArgumentException("Archivo excede 5MB");
        }
    }

    private void validarDuplicado(Long solicitanteId, String tipoDocumento) {
        documentoRepository.findBySolicitanteIdAndTipoDocumento(solicitanteId, tipoDocumento)
                .ifPresent(d -> {
                    throw new DocumentoDuplicadoException(tipoDocumento, solicitanteId);
                });
    }

    private String generarNombreUnico(String originalName) {
        return UUID.randomUUID() + "_" + originalName;
    }

    private Path construirRuta(Long solicitanteId, String nombre) {
        return Path.of(uploadPath, solicitanteId.toString(), nombre);
    }

    private void crearDirectorioSiNoExiste(Path ruta) throws IOException {
        Files.createDirectories(ruta.getParent());
    }

    // =========================
    // UTILIDADES
    // =========================

    public boolean isAllowedMimeType(String contentType) {
        return contentType != null &&
                (contentType.equals("application/pdf") ||
                        contentType.equals("image/png") ||
                        contentType.equals("image/jpeg"));
    }

    private String calcularHash(byte[] contenido) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(contenido);

            StringBuilder sb = new StringBuilder();
            for (byte b : hash) sb.append(String.format("%02x", b));

            return sb.toString();

        } catch (Exception e) {
            throw new RuntimeException("Error hash SHA-256", e);
        }
    }

    // =========================
    // OTROS MÉTODOS (SIN CAMBIO)
    // =========================

    public List<DocumentoSolicitante> obtenerPorSolicitante(Long solicitanteId) {
        return documentoRepository.findBySolicitanteId(solicitanteId);
    }

    public void verificarDocumento(Long id, String estado, String comentarios) {
        DocumentoSolicitante documento = documentoRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Documento no encontrado: " + id));

        documento.setEstadoVerificacion(estado);
        documentoRepository.save(documento);
    }
}
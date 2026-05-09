package com.example.gr01_1bt3_622_26a.repository;

import com.example.gr01_1bt3_622_26a.entity.DocumentoSolicitante;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * 🔵 REFACTOR — T.2.2
 * Repositorio JPA para DocumentoSolicitante
 *
 * Según PLANIFICACION_RELEASE_1.0.md:
 * - Extiende JpaRepository para operaciones CRUD básicas
 * - Expone query methods derivados para búsquedas frecuentes
 * - Operaciones de lectura marcadas como readOnly para optimización
 */
@Repository
@Transactional(readOnly = true)
public interface DocumentoSolicitanteRepository extends JpaRepository<DocumentoSolicitante, Long> {

    /**
     * Busca documentos de un solicitante filtrados por estado de verificación.
     * Usado para listar documentos pendientes, verificados o rechazados.
     *
     * @param solicitanteId       ID del solicitante
     * @param estadoVerificacion  Estado: "Pendiente", "Verificado", "Rechazado"
     * @return Lista de documentos en el estado indicado
     */
    List<DocumentoSolicitante> findBySolicitanteIdAndEstadoVerificacion(
            Long solicitanteId,
            String estadoVerificacion
    );

    /**
     * Busca un documento específico de un solicitante por tipo.
     * Usado para detectar si ya existe un documento del mismo tipo (evitar duplicados).
     *
     * @param solicitanteId  ID del solicitante
     * @param tipoDocumento  Tipo: "Cédula", "Servicio_Básico", "Comprobante_Domicilio"
     * @return Optional con el documento si existe, vacío si no
     */
    Optional<DocumentoSolicitante> findBySolicitanteIdAndTipoDocumento(
            Long solicitanteId,
            String tipoDocumento
    );

    /**
     * Obtiene todos los documentos
     * pertenecientes a un solicitante.
     *
     * @param solicitanteId ID solicitante
     * @return Lista documentos
     */
    List<DocumentoSolicitante> findBySolicitanteId(
            Long solicitanteId
    );
}

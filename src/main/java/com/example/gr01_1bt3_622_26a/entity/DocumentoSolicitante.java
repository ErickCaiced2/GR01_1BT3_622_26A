package com.example.gr01_1bt3_622_26a.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 🔵 REFACTOR — T.2.1
 * Entidad JPA completa con anotaciones, constraints y relaciones
 * según especificación del PLANIFICACION_RELEASE_1.0.md
 *
 * Tabla: documentos_solicitante
 */
@Entity
@Table(
    name = "documentos_solicitante",
    indexes = {
        @Index(name = "idx_solicitante_tipo",    columnList = "solicitante_id, tipo_documento"),
        @Index(name = "idx_estado_verificacion", columnList = "estado_verificacion")
    }
)
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DocumentoSolicitante {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "solicitante_id", nullable = false)
    private Solicitante solicitante;

    @NotBlank(message = "Tipo de documento requerido")
    @Column(name = "tipo_documento", nullable = false, length = 50)
    private String tipoDocumento;

    @NotBlank(message = "Ruta de archivo requerida")
    @Column(name = "ruta_archivo", nullable = false, length = 500)
    private String rutaArchivo;

    @Size(max = 255)
    @Column(name = "nombre_archivo")
    private String nombreArchivo;

    @Column(name = "estado_verificacion", nullable = false, length = 50)
    @Builder.Default
    private String estadoVerificacion = "Pendiente";

    @Column(name = "fecha_carga")
    private LocalDateTime fechaCarga;

    @Column(name = "fecha_verificacion")
    private LocalDateTime fechaVerificacion;

    @Size(max = 1000)
    @Column(name = "comentarios_verificador", length = 1000)
    private String comentariosVerificador;

    @Column(name = "hash_documento")
    private String hashDocumento;

    @PrePersist
    protected void onCreate() {
        fechaCarga = LocalDateTime.now();
    }
}

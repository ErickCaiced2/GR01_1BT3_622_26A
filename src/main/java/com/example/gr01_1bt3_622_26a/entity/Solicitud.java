package com.example.gr01_1bt3_622_26a.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;
import lombok.extern.slf4j.Slf4j;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "solicitudes")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Slf4j
public class Solicitud {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "solicitante_id", nullable = false)
    private Solicitante solicitante;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "mascota_id", nullable = false)
    private Mascota mascota;
    
    @Column(name = "fecha_solicitud")
    private LocalDateTime fechaSolicitud;
    
    @NotBlank(message = "El estado es requerido")
    @Column(nullable = false)
    private String estado; // Pendiente, Aprobada, Rechazada, Cancelada
    
    @Size(max = 1000, message = "El motivo no debe exceder 1000 caracteres")
    @Column(length = 1000)
    private String motivo; // Razón por la cual solicita la adopción
    
    @Size(max = 500, message = "Las observaciones no deben exceder 500 caracteres")
    @Column(length = 500)
    private String observaciones;
    
    @Column(name = "fecha_respuesta")
    private LocalDateTime fechaRespuesta;
    
    @Column(name = "razon_rechazo")
    private String razonRechazo;
    
    @Column(name = "requiere_visita_hogar")
    @Builder.Default
    private Boolean requiereVisitaHogar = false;
    
    @Column(name = "numero_mascotas")
    private Integer numeroMascotas;
    
    @Column(name = "tipo_vivienda")
    private String tipoVivienda; // Casa, Departamento, etc.
    
    @Column(name = "tiene_jardin")
    private Boolean tieneJardin;
    
    @Column(name = "es_primer_adopcion")
    @Builder.Default
    private Boolean esPrimerAdopcion = true;
    
    /**
     * Hook de JPA invocado antes de persistir la entidad en base de datos.
     *
     * Responsabilidades:
     * 1. Asigna automáticamente la fecha/hora actual si no fue especificada ({@code fechaSolicitud})
     * 2. Establece el estado inicial "En revisión" si el estado es nulo
     *
     * Comportamiento:
     * - {@code fechaSolicitud}: Se asigna {@link LocalDateTime#now()} si es null
     * - {@code estado}: Se asigna "En revisión" si es null (primera instancia sin estado explícito)
     *
     * Auditoría: Se registra cuando una nueva solicitud es registrada en el sistema.
     *
     * @see PrePersist
     */
    @PrePersist
    protected void prePersist() {
        // Asignar fecha actual si no fue especificada
        if (fechaSolicitud == null) {
            fechaSolicitud = LocalDateTime.now();
            log.debug("Fecha de solicitud asignada automáticamente: {}", fechaSolicitud);
        }

        // Asignar estado inicial "En revisión" para nuevas solicitudes
        if (estado == null) {
            estado = "En revisión";
            log.info("Solicitud con estado inicial 'En revisión' registrada");
        }
    }
}


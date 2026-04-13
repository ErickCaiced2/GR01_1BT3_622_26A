package com.example.gr02_1bt3_622_26a.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Entidad que representa una adopción completada
 */
@Entity
@Table(name = "adopciones")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Adopcion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "solicitante_id", nullable = false)
    private Solicitante solicitante;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "mascota_id", nullable = false)
    private Mascota mascota;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "solicitud_id", nullable = false)
    private Solicitud solicitud;

    @Column(name = "fecha_adopcion")
    private LocalDateTime fechaAdopcion;

    @Column(name = "fecha_finalizacion")
    private LocalDate fechaFinalizacion;

    @NotBlank(message = "El estado es requerido")
    @Column(nullable = false)
    private String estado; // En_proceso, Completada, Anulada

    @Column(name = "fecha_visita_hogar")
    private LocalDate fechaVisitaHogar;

    @Column(name = "resultado_visita")
    private String resultadoVisita; // Aprobada, Pendiente, Rechazada

    @Size(max = 500, message = "Las observaciones no deben exceder 500 caracteres")
    @Column(length = 500)
    private String observaciones;

    @Column(name = "numero_acta_adopcion")
    private String numeroActaAdopcion;

    @Column(name = "contrato_firmado")
    @Builder.Default
    private Boolean contratoFirmado = false;

    @Column(name = "vacunas_aplicadas")
    @Builder.Default
    private Boolean vacunasAplicadas = false;

    @Column(name = "desparasitacion")
    @Builder.Default
    private Boolean desparasitacion = false;

    @Column(name = "microchip_colocado")
    @Builder.Default
    private Boolean microchipColocado = false;

    @Column(name = "seguimiento_requerido")
    @Builder.Default
    private Boolean seguimientoRequerido = true;

    @Column(name = "fecha_seguimiento")
    private LocalDate fechaSeguimiento;

    @PrePersist
    protected void onCreate() {
        if (fechaAdopcion == null) {
            fechaAdopcion = LocalDateTime.now();
        }
        if (estado == null) {
            estado = "En_proceso";
        }
    }
}


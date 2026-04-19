package com.example.gr01_1bt3_622_26a.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "solicitudes")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
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
    
    @PrePersist
    protected void onCreate() {
        if (fechaSolicitud == null) {
            fechaSolicitud = LocalDateTime.now();
        }
        if (estado == null) {
            estado = "Pendiente";
        }
    }
}


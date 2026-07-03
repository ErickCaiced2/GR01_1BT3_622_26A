package com.example.gr01_1bt3_622_26a.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;

import java.time.LocalDateTime;

/**
 * Entidad que representa una actualización de bienestar registrada por el
 * adoptante sobre una mascota ya adoptada (HU15) y consultada por el
 * administrador (HU16).
 */
@Entity
@Table(name = "actualizaciones_bienestar")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ActualizacionBienestar {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "adopcion_id", nullable = false)
    private Adopcion adopcion;

    @Column(name = "fecha_registro")
    private LocalDateTime fechaRegistro;

    @NotBlank(message = "El estado de la mascota es requerido")
    @Column(name = "estado_mascota", nullable = false)
    private String estadoMascota; // Feliz, Adaptándose, Con problemas

    @Size(max = 1000, message = "El comentario no debe exceder 1000 caracteres")
    @Column(length = 1000)
    private String comentario;

    @Size(max = 1000, message = "La respuesta no debe exceder 1000 caracteres")
    @Column(name = "respuesta_admin", length = 1000)
    private String respuestaAdmin;

    @Column(name = "fecha_respuesta_admin")
    private LocalDateTime fechaRespuestaAdmin;

    @PrePersist
    protected void onCreate() {
        if (fechaRegistro == null) {
            fechaRegistro = LocalDateTime.now();
        }
    }
}

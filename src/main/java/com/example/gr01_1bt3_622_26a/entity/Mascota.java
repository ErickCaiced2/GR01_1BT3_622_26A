package com.example.gr01_1bt3_622_26a.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;
import java.time.LocalDate;
import java.util.List;

/**
 * Entidad que representa una mascota disponible para adopción
 */
@Entity
@Table(name = "mascotas")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Mascota {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotBlank(message = "El nombre de la mascota es requerido")
    @Size(min = 2, max = 100, message = "El nombre debe tener entre 2 y 100 caracteres")
    @Column(nullable = false)
    private String nombre;
    
    @NotBlank(message = "El tipo de mascota es requerido")
    @Column(nullable = false)
    private String tipo; // Perro, Gato, Conejo, etc.
    
    @Size(max = 50, message = "La raza no debe exceder 50 caracteres")
    private String raza;
    
    @NotNull(message = "La edad es requerida")
    @Min(value = 0, message = "La edad no puede ser negativa")
    @Max(value = 50, message = "La edad no puede exceder 50 años")
    private Integer edad;
    
    @NotBlank(message = "El género es requerido")
    @Column(nullable = false)
    private String genero; // Macho, Hembra
    
    @Size(max = 500, message = "La descripción no debe exceder 500 caracteres")
    @Column(length = 500)
    private String descripcion;
    
    @Column(name = "fecha_registro")
    private LocalDate fechaRegistro;
    
    @NotBlank(message = "El estado es requerido")
    @Column(nullable = false)
    private String estado; // Disponible, Adoptado, En proceso, etc.
    
    @Size(max = 255, message = "El color no debe exceder 255 caracteres")
    private String color;
    
    @Column(name = "peso_kg")
    private Double pesoKg;

    /**
     * Diagnósticos médicos previos de la mascota.
     * Campo opcional: una mascota puede no tener historial médico registrado.
     */
    @Size(max = 500, message = "Los diagnósticos previos no deben exceder 500 caracteres")
    @Column(name = "diagnosticos_previos", length = 500, nullable = true)
    private String diagnosticosPrevios;

    // ...existing code...
    @OneToMany(mappedBy = "mascota", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<Foto> fotos;
    
    @PrePersist
    protected void onCreate() {
        if (fechaRegistro == null) {
            fechaRegistro = LocalDate.now();
        }
        if (estado == null) {
            estado = "Disponible";
        }
    }
}


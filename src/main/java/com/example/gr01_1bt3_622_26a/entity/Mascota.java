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

    /**
     * Estado de mascota para control de adopción (T.1.5)
     *
     * Estados válidos:
     * 🟢 "Disponible" → Mascota lista para ser adoptada
     * 🟡 "En evaluación" → Hay solicitud siendo evaluada
     * 🚫 "Bloqueada para adopción" → Solicitud aprobada, se bloquea para otros solicitantes
     * ✅ "Adoptada" → Adopción completada
     *
     * Transiciones (T.1.5):
     * - Disponible → En evaluación (cuando hay solicitud en revisión)
     * - En evaluación → Bloqueada para adopción (cuando se aprueba solicitud)
     * - Bloqueada para adopción → Adoptada (cuando se completa la adopción)
     * - Cualquier estado → Disponible (cuando se rechaza la solicitud)
     *
     * @see com.example.gr01_1bt3_622_26a.service.MascotaService#bloquearMascota
     */
    @Column(name = "estado_mascota", nullable = false)
    @Builder.Default
    private String estadoMascota = "Disponible";

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

    // Campos de Compatibilidad (T.4.2)
    @Column(name = "compatible_ninos")
    @Builder.Default
    private Boolean compatibleNinos = true;
    
    @Column(name = "compatible_gatos")
    @Builder.Default
    private Boolean compatibleGatos = true;
    
    @Column(name = "compatible_perros")
    @Builder.Default
    private Boolean compatiblePerros = true;
    
    @Column(name = "energia_nivel")
    @Builder.Default
    @Size(max = 20, message = "El nivel de energía no debe exceder 20 caracteres")
    private String nivelEnergia = "Media";
    
    @Column(name = "tamaño_requerido")
    @Builder.Default
    @Size(max = 20, message = "El tamaño no debe exceder 20 caracteres")
    private String tamañoRequerido = "Mediano";
    
    @Column(name = "requisitos_especiales")
    @Size(max = 500, message = "Los requisitos no deben exceder 500 caracteres")
    private String requisitosEspeciales;
    
    @Column(name = "edad_minima_ninos")
    @Min(value = 0, message = "La edad mínima no puede ser negativa")
    private Integer edadMinimaNinos;
    
    @Column(name = "es_hipoalergenico")
    @Builder.Default
    private Boolean esHipoalergenico = false;
    
    @Column(name = "necesita_patio")
    @Builder.Default
    private Boolean necesitaPatio = false;

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

    /**
     * Verifica si la mascota está disponible para adopción.
     */
    public boolean esDisponible() {
        return "Disponible".equalsIgnoreCase(this.estado);
    }
}


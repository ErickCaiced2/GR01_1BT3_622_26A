package com.example.gr02_1bt3_622_26a.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;
import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "solicitantes")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Solicitante {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "El nombre es requerido")
    @Column(nullable = false)
    private String nombre;

    @NotBlank(message = "El apellido es requerido")
    @Column(nullable = false)
    private String apellido;

    @NotBlank(message = "El email es requerido")
    @Email(message = "El email debe ser válido")
    @Column(nullable = false, unique = true)
    private String email;

    @NotBlank(message = "El teléfono es requerido")
    @Column(nullable = false)
    private String telefono;

    @NotBlank(message = "La dirección es requerida")
    @Column(nullable = false)
    private String direccion;

    @Column(name = "ciudad")
    private String ciudad;

    @Column(name = "fecha_registro")
    private LocalDate fechaRegistro;

    @NotNull(message = "El documento de identidad es requerido")
    @Column(name = "documento_identidad", unique = true)
    private String documentoIdentidad;

    @Column(name = "tipo_documento")
    private String tipoDocumento;

    @Column(name = "fecha_nacimiento")
    private LocalDate fechaNacimiento;

    @Column(name = "estado", nullable = false)
    @Builder.Default
    private String estado = "Activo";

    @OneToMany(mappedBy = "solicitante", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<Solicitud> solicitudes;

    @OneToMany(mappedBy = "solicitante", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<Adopcion> adopciones;

    @PrePersist
    protected void onCreate() {
        if (fechaRegistro == null) {
            fechaRegistro = LocalDate.now();
        }
    }
}


package com.example.gr01_1bt3_622_26a.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 🔵 REFACTOR: Entidad Usuario COMPLETA con JPA y Validaciones
 *
 * Ciclo TDD:
 * 🔴 RED: Test falla (Usuario no existe)
 * 🟢 GREEN: Se crea Usuario mínimo
 * 🔵 REFACTOR: Se mejora con validaciones, JPA, campos adicionales
 */
@Entity
@Table(name = "usuarios", uniqueConstraints = {
        @UniqueConstraint(columnNames = "email"),
        @UniqueConstraint(columnNames = "documento_identidad")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "El email es requerido")
    @Email(message = "El email debe ser válido")
    @Column(nullable = false, unique = true)
    private String email;

    @NotBlank(message = "La contraseña es requerida")
    @Size(min = 6, message = "La contraseña debe tener al menos 6 caracteres")
    @Column(nullable = false)
    private String password;

    @NotBlank(message = "El nombre es requerido")
    @Size(min = 2, max = 100, message = "El nombre debe tener entre 2 y 100 caracteres")
    @Column(nullable = false)
    private String nombre;

    @Column(nullable = false)
    @Builder.Default
    private String estado = "ACTIVO"; // ACTIVO, INACTIVO, BLOQUEADO

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private RolUsuario rol = RolUsuario.SOLICITANTE;

    @Column(name = "documento_identidad", unique = true)
    private String documentoIdentidad;

    @Column(name = "fecha_creacion")
    private LocalDate fechaCreacion;

    @Column(name = "fecha_ultimo_login")
    private LocalDateTime fechaUltimoLogin;

    @Column(name = "token_recuperacion")
    private String tokenRecuperacion;

    @Column(name = "fecha_expiracion_token")
    private LocalDate fechaExpiracionToken;

    @Column(name = "intentos_fallidos", columnDefinition = "int default 0")
    @Builder.Default
    private Integer intentosFallidos = 0;

    @PrePersist
    protected void onCreate() {
        if (fechaCreacion == null) {
            fechaCreacion = LocalDate.now();
        }
        if (estado == null) {
            estado = "ACTIVO";
        }
        if (rol == null) {
            rol = RolUsuario.SOLICITANTE;
        }
    }

    /**
     * Enumeración de roles disponibles en el sistema
     */
    public enum RolUsuario {
        ADMIN("Administrador"),
        SOLICITANTE("Solicitante de Adopción"),
        STAFF("Personal del Sistema");

        private final String descripcion;

        RolUsuario(String descripcion) {
            this.descripcion = descripcion;
        }

        public String getDescripcion() {
            return descripcion;
        }
    }

    /**
     * Métodos de negocio para validación
     */
    public boolean esActivo() {
        return "ACTIVO".equals(this.estado);
    }

    public boolean estaAlimentado() {
        return intentosFallidos < 3;
    }

    public void incrementarIntentosFallidos() {
        this.intentosFallidos++;
        if (this.intentosFallidos >= 3) {
            this.estado = "BLOQUEADO";
        }
    }

    public void reiniciarIntentosFallidos() {
        this.intentosFallidos = 0;
    }

    public void registrarUltimoLogin() {
        this.fechaUltimoLogin = LocalDateTime.now();
        this.reiniciarIntentosFallidos();
    }
}


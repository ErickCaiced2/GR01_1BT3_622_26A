package com.example.gr01_1bt3_622_26a.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

/**
 * 📦 DTO para datos de contrato de adopción
 * Mapea información de Adopción, Solicitante y Mascota
 * para ser usada en plantilla de contrato
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ContratoDTO {

    /**
     * ID de la adopción
     */
    private Long adopcionId;

    /**
     * Nombre del refugio/organización
     */
    private String nombreRefugio;

    /**
     * Representante legal del refugio
     */
    private String representanteLegal;

    /**
     * Nombre completo del adoptante
     */
    private String nombreAdoptante;

    /**
     * Cédula/Documento de identidad del adoptante
     */
    private String cedulaAdoptante;

    /**
     * Email del adoptante
     */
    private String emailAdoptante;

    /**
     * Teléfono del adoptante
     */
    private String telefonoAdoptante;

    /**
     * Nombre de la mascota adoptada
     */
    private String nombreMascota;

    /**
     * Tipo de animal (Perro, Gato, etc)
     */
    private String tipoMascota;

    /**
     * Raza de la mascota
     */
    private String razaMascota;

    /**
     * Edad aproximada de la mascota en años
     */
    private Integer edadMascota;

    /**
     * Descripción física de la mascota
     */
    private String descripcionMascota;

    /**
     * Color de la mascota
     */
    private String colorMascota;

    /**
     * Historial de vacunas
     */
    private String vacunasMascota;

    /**
     * Fecha de generación del contrato
     */
    private LocalDate fechaGeneracion;

    /**
     * Número de contrato generado automáticamente
     */
    private String numeroContrato;
}



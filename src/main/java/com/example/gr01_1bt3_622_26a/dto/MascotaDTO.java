package com.example.gr01_1bt3_622_26a.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MascotaDTO {
    private Long id;
    private String nombre;
    private String tipo;
    private String raza;
    private Integer edad;
    private String genero;
    private String estado;
    private String nivelEnergia;
    private String tamañoRequerido;
    private Boolean compatibleNinos;
    private Boolean compatibleGatos;
    private Boolean compatiblePerros;
    private Boolean esHipoalergenico;
}


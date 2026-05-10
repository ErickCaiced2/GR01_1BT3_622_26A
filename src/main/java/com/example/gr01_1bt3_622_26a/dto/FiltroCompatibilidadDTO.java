package com.example.gr01_1bt3_622_26a.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FiltroCompatibilidadDTO {
    private Boolean tieneNinos;
    private Boolean tieneGatos;
    private Boolean tienePerros;
    private String nivelEnergia;
    private String tamañoPreferido;
    private Boolean esHipoalergenico;
}

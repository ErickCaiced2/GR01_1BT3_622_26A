package com.example.gr01_1bt3_622_26a.controller;

import com.example.gr01_1bt3_622_26a.dto.FiltroCompatibilidadDTO;
import com.example.gr01_1bt3_622_26a.dto.MascotaDTO;
import com.example.gr01_1bt3_622_26a.entity.Mascota;
import com.example.gr01_1bt3_622_26a.service.MascotaService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * T.4.4 - API REST para búsqueda de mascotas por compatibilidad
 */
@RestController
@RequestMapping("/mascotas")
@Slf4j
public class MascotaRestController {

    @Autowired
    private MascotaService mascotaService;

    /**
     * T.4.4 - Filtrar mascotas por compatibilidad con el hogar del solicitante.
     *
     * Todos los parámetros son opcionales; si se omiten, no aplican como filtro.
     *
     * @param tieneNinos     true si el hogar tiene niños
     * @param tieneGatos     true si el hogar tiene gatos
     * @param tienePerros    true si el hogar tiene perros
     * @param nivelEnergia   Baja | Media | Alta
     * @param tamaño         Pequeño | Mediano | Grande
     * @param hipoalergenico true si se requiere mascota hipoalergénica
     * @return lista de mascotas compatibles como DTO (pagination-ready)
     */
    @GetMapping("/filtrar")
    public ResponseEntity<List<MascotaDTO>> filtrarPorCompatibilidad(
            @RequestParam(required = false) Boolean tieneNinos,
            @RequestParam(required = false) Boolean tieneGatos,
            @RequestParam(required = false) Boolean tienePerros,
            @RequestParam(required = false) String nivelEnergia,
            @RequestParam(required = false) String tamaño,
            @RequestParam(required = false) Boolean hipoalergenico) {

        log.info("REST GET /mascotas/filtrar - tieneNinos={}, nivelEnergia={}, tamaño={}",
                tieneNinos, nivelEnergia, tamaño);

        FiltroCompatibilidadDTO filtro = FiltroCompatibilidadDTO.builder()
                .tieneNinos(tieneNinos)
                .tieneGatos(tieneGatos)
                .tienePerros(tienePerros)
                .nivelEnergia(nivelEnergia)
                .tamañoPreferido(tamaño)
                .esHipoalergenico(hipoalergenico)
                .build();

        List<Mascota> mascotas = mascotaService.filtrarPorCompatibilidad(filtro);
        return ResponseEntity.ok(mapToDTO(mascotas));
    }

    /**
     * Convierte lista de entidades Mascota a lista de MascotaDTO.
     */
    private List<MascotaDTO> mapToDTO(List<Mascota> mascotas) {
        return mascotas.stream().map(m -> MascotaDTO.builder()
                .id(m.getId())
                .nombre(m.getNombre())
                .tipo(m.getTipo())
                .raza(m.getRaza())
                .edad(m.getEdad())
                .genero(m.getGenero())
                .estado(m.getEstado())
                .nivelEnergia(m.getNivelEnergia())
                .tamañoRequerido(m.getTamañoRequerido())
                .compatibleNinos(m.getCompatibleNinos())
                .compatibleGatos(m.getCompatibleGatos())
                .compatiblePerros(m.getCompatiblePerros())
                .esHipoalergenico(m.getEsHipoalergenico())
                .build()).toList();
    }
}


package com.example.gr01_1bt3_622_26a.service.mapper;

import com.example.gr01_1bt3_622_26a.dto.ContratoDTO;
import com.example.gr01_1bt3_622_26a.entity.Adopcion;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.time.LocalDate;

/**
 * 🔄 Mapper para convertir entidad Adopcion a ContratoDTO
 *
 * Patrón Mapper: Responsabilidad única de mapear datos entre capas
 * - Entrada: Entidad JPA Adopcion (con relaciones Solicitante, Mascota)
 * - Salida: DTO ContratoDTO (datos listos para plantilla)
 *
 * Beneficios:
 * - Separación de responsabilidades
 * - Fácil de testear
 * - Reutilizable en múltiples servicios
 * - Mapeos complejos centralizados
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class AdopcionContratoMapper {

    @Value("${app.refugio.nombre:Paws & Home Sanctuary}")
    private String nombreRefugio;

    @Value("${app.refugio.representante:Administración Refugio}")
    private String representanteLegal;

    /**
     * Convierte una Adopcion a ContratoDTO
     *
     * @param adopcion Entidad Adopcion con sus relaciones cargadas
     * @return ContratoDTO con todos los campos mapeados
     * @throws NullPointerException si adopcion o sus relaciones son null
     */
    public ContratoDTO toContratoDTO(Adopcion adopcion) {
        if (adopcion == null) {
            log.warn("Intento de mapear adopcion null");
            throw new IllegalArgumentException("La adopción no puede ser nula");
        }

        log.debug("Mapeando Adopcion ID: {} a ContratoDTO", adopcion.getId());

        try {
            ContratoDTO dto = ContratoDTO.builder()
                    // Datos de Adopción
                    .adopcionId(adopcion.getId())

                    // Datos del Refugio
                    .nombreRefugio(nombreRefugio)
                    .representanteLegal(representanteLegal)

                    // Datos del Solicitante
                    .nombreAdoptante(mapearNombreSolicitante(adopcion))
                    .cedulaAdoptante(mapearCedulaSolicitante(adopcion))
                    .emailAdoptante(mapearEmailSolicitante(adopcion))
                    .telefonoAdoptante(mapearTelefonoSolicitante(adopcion))

                    // Datos de la Mascota
                    .nombreMascota(mapearNombreMascota(adopcion))
                    .tipoMascota(mapearTipoMascota(adopcion))
                    .razaMascota(mapearRazaMascota(adopcion))
                    .edadMascota(mapearEdadMascota(adopcion))
                    .descripcionMascota(mapearDescripcionMascota(adopcion))
                    .colorMascota(mapearColorMascota(adopcion))

                    // Datos de Vacunas
                    .vacunasMascota(generarResumenVacunas(adopcion))

                    // Datos generados
                    .fechaGeneracion(LocalDate.now())
                    .numeroContrato(generarNumeroContrato(adopcion.getId()))

                    .build();

            log.debug("Mapeo exitoso para Adopcion ID: {}", adopcion.getId());
            return dto;

        } catch (NullPointerException e) {
            log.error("Error en mapeo: relación nula en Adopcion ID: {}", adopcion.getId(), e);
            throw new IllegalArgumentException("La adopción debe tener asociadas un solicitante y una mascota", e);
        }
    }

    /**
     * Mapea el nombre del solicitante
     */
    private String mapearNombreSolicitante(Adopcion adopcion) {
        return adopcion.getSolicitante() != null ? adopcion.getSolicitante().getNombre() : "Nombre no disponible";
    }

    /**
     * Mapea la cédula del solicitante
     */
    private String mapearCedulaSolicitante(Adopcion adopcion) {
        return adopcion.getSolicitante() != null ? adopcion.getSolicitante().getDocumentoIdentidad() : "---";
    }

    /**
     * Mapea el email del solicitante
     */
    private String mapearEmailSolicitante(Adopcion adopcion) {
        return adopcion.getSolicitante() != null ? adopcion.getSolicitante().getEmail() : "email@no-disponible.com";
    }

    /**
     * Mapea el teléfono del solicitante
     */
    private String mapearTelefonoSolicitante(Adopcion adopcion) {
        return adopcion.getSolicitante() != null ? adopcion.getSolicitante().getTelefono() : "No disponible";
    }

    /**
     * Mapea el nombre de la mascota
     */
    private String mapearNombreMascota(Adopcion adopcion) {
        return adopcion.getMascota() != null ? adopcion.getMascota().getNombre() : "Mascota sin nombre";
    }

    /**
     * Mapea el tipo de mascota
     */
    private String mapearTipoMascota(Adopcion adopcion) {
        return adopcion.getMascota() != null ? adopcion.getMascota().getTipo() : "Tipo desconocido";
    }

    /**
     * Mapea la raza de la mascota
     */
    private String mapearRazaMascota(Adopcion adopcion) {
        return adopcion.getMascota() != null ? adopcion.getMascota().getRaza() : "Raza desconocida";
    }

    /**
     * Mapea la edad de la mascota
     */
    private Integer mapearEdadMascota(Adopcion adopcion) {
        return adopcion.getMascota() != null ? adopcion.getMascota().getEdad() : 0;
    }

    /**
     * Mapea la descripción de la mascota
     */
    private String mapearDescripcionMascota(Adopcion adopcion) {
        return adopcion.getMascota() != null ? adopcion.getMascota().getDescripcion() : "Sin descripción";
    }

    /**
     * Mapea el color de la mascota
     */
    private String mapearColorMascota(Adopcion adopcion) {
        return adopcion.getMascota() != null ? adopcion.getMascota().getColor() : "Color no especificado";
    }

    /**
     * Genera un resumen textual del estado de vacunación
     * Utiliza información de la adopción para crear un mensaje descriptivo
     *
     * @param adopcion Entidad de adopción
     * @return String con estado de vacunación
     */
    private String generarResumenVacunas(Adopcion adopcion) {
        if (adopcion.getVacunasAplicadas() != null && adopcion.getVacunasAplicadas()) {
            return "Vacunas aplicadas y registradas";
        }
        return "Vacunación pendiente - Se recomienda aplicar dentro de 7 días";
    }

    /**
     * Genera un número único de contrato basado en ID de adopción y timestamp
     * Formato: CONTRATO-{adopcionId}-{timestamp}
     *
     * Ventajas:
     * - Único por adopción y timestamp
     * - Ordenable cronológicamente
     * - Contiene ID de referencia
     *
     * @param adopcionId ID de la adopción
     * @return Número de contrato formateado
     */
    private String generarNumeroContrato(Long adopcionId) {
        String numeroContrato = String.format(
                "CONTRATO-%d-%d",
                adopcionId,
                System.currentTimeMillis()
        );
        log.debug("Número de contrato generado: {}", numeroContrato);
        return numeroContrato;
    }
}


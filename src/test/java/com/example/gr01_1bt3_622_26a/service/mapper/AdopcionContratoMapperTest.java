package com.example.gr01_1bt3_622_26a.service.mapper;

import com.example.gr01_1bt3_622_26a.dto.ContratoDTO;
import com.example.gr01_1bt3_622_26a.entity.Adopcion;
import com.example.gr01_1bt3_622_26a.entity.Mascota;
import com.example.gr01_1bt3_622_26a.entity.Solicitante;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 🧪 Tests unitarios para AdopcionContratoMapper
 *
 * Valida:
 * - Mapeo completo de Adopcion → ContratoDTO
 * - Manejo de valores nulos
 * - Generación de número de contrato
 * - Resumen de vacunas
 */
@DisplayName("AdopcionContratoMapper - Tests unitarios")
class AdopcionContratoMapperTest {

    private AdopcionContratoMapper mapper;

    @BeforeEach
    void setUp() {
        mapper = new AdopcionContratoMapper();
        // Establecer valores de configuración
        ReflectionTestUtils.setField(mapper, "nombreRefugio", "Paws & Home Sanctuary");
        ReflectionTestUtils.setField(mapper, "representanteLegal", "Admin Test");
    }

    /**
     * Test: Mapeo exitoso de Adopcion completa
     */
    @Test
    @DisplayName("Debe mapear Adopcion completa a ContratoDTO correctamente")
    void testMapeoAdopcionCompleta() {
        // Given
        Adopcion adopcion = crearAdopcionCompleta();

        // When
        ContratoDTO dto = mapper.toContratoDTO(adopcion);

        // Then
        assertNotNull(dto, "ContratoDTO no debe ser nulo");
        assertEquals(1L, dto.getAdopcionId(), "ID de adopción debe coincidir");
        assertEquals("Juan Pérez", dto.getNombreAdoptante(), "Nombre adoptante debe coincidir");
        assertEquals("123456789", dto.getCedulaAdoptante(), "Cédula debe coincidir");
        assertEquals("Max", dto.getNombreMascota(), "Nombre mascota debe coincidir");
        assertEquals("Perro", dto.getTipoMascota(), "Tipo debe ser Perro");
        assertEquals("Labrador", dto.getRazaMascota(), "Raza debe ser Labrador");
        assertEquals(3, dto.getEdadMascota(), "Edad debe ser 3");
        assertEquals("Paws & Home Sanctuary", dto.getNombreRefugio(), "Nombre refugio debe coincidir");
        assertEquals("Admin Test", dto.getRepresentanteLegal(), "Representante debe coincidir");
    }

    /**
     * Test: Número de contrato debe ser único y contener ID
     */
    @Test
    @DisplayName("Número de contrato debe ser único y contener ID de adopción")
    void testNumeroContratoUnico() {
        // Given
        Adopcion adopcion1 = crearAdopcionCompleta();
        Adopcion adopcion2 = crearAdopcionCompleta();
        adopcion2.setId(2L);

        // When
        ContratoDTO dto1 = mapper.toContratoDTO(adopcion1);
        ContratoDTO dto2 = mapper.toContratoDTO(adopcion2);

        // Then
        assertNotNull(dto1.getNumeroContrato(), "Número contrato 1 no debe ser nulo");
        assertNotNull(dto2.getNumeroContrato(), "Número contrato 2 no debe ser nulo");
        assertNotEquals(dto1.getNumeroContrato(), dto2.getNumeroContrato(),
            "Números de contrato deben ser diferentes");
        assertTrue(dto1.getNumeroContrato().contains("CONTRATO-1-"),
            "Número debe contener ID de adopción");
        assertTrue(dto2.getNumeroContrato().contains("CONTRATO-2-"),
            "Número debe contener ID de adopción");
    }

    /**
     * Test: Mapeo con Adopcion nula debe lanzar excepción
     */
    @Test
    @DisplayName("Debe lanzar excepción cuando Adopcion es nula")
    void testAdopcionNulaLanzaExcepcion() {
        // When & Then
        assertThrows(IllegalArgumentException.class,
            () -> mapper.toContratoDTO(null),
            "Debe lanzar IllegalArgumentException para Adopcion nula");
    }

    /**
     * Test: Resumen de vacunas aplicadas
     */
    @Test
    @DisplayName("Debe mostrar 'Vacunas aplicadas' cuando vacunasAplicadas es true")
    void testResumenVacunasAplicadas() {
        // Given
        Adopcion adopcion = crearAdopcionCompleta();
        adopcion.setVacunasAplicadas(true);

        // When
        ContratoDTO dto = mapper.toContratoDTO(adopcion);

        // Then
        assertEquals("Vacunas aplicadas y registradas", dto.getVacunasMascota(),
            "Debe indicar que las vacunas están aplicadas");
    }

    /**
     * Test: Resumen de vacunas pendientes
     */
    @Test
    @DisplayName("Debe mostrar vacunación pendiente cuando vacunasAplicadas es false")
    void testResumenVacunasPendientes() {
        // Given
        Adopcion adopcion = crearAdopcionCompleta();
        adopcion.setVacunasAplicadas(false);

        // When
        ContratoDTO dto = mapper.toContratoDTO(adopcion);

        // Then
        assertTrue(dto.getVacunasMascota().contains("Vacunación pendiente"),
            "Debe indicar que las vacunas están pendientes");
    }

    /**
     * Test: Fecha de generación debe ser hoy
     */
    @Test
    @DisplayName("Fecha de generación debe ser la fecha actual")
    void testFechaGeneracionActual() {
        // Given
        Adopcion adopcion = crearAdopcionCompleta();
        LocalDate hoy = LocalDate.now();

        // When
        ContratoDTO dto = mapper.toContratoDTO(adopcion);

        // Then
        assertEquals(hoy, dto.getFechaGeneracion(),
            "Fecha de generación debe ser hoy");
    }

    /**
     * Test: Todos los campos del DTO están poblados
     */
    @Test
    @DisplayName("Todos los campos del ContratoDTO deben estar poblados")
    void testTodosCamposPoblados() {
        // Given
        Adopcion adopcion = crearAdopcionCompleta();

        // When
        ContratoDTO dto = mapper.toContratoDTO(adopcion);

        // Then
        assertNotNull(dto.getAdopcionId());
        assertNotNull(dto.getNombreRefugio());
        assertNotNull(dto.getRepresentanteLegal());
        assertNotNull(dto.getNombreAdoptante());
        assertNotNull(dto.getCedulaAdoptante());
        assertNotNull(dto.getEmailAdoptante());
        assertNotNull(dto.getTelefonoAdoptante());
        assertNotNull(dto.getNombreMascota());
        assertNotNull(dto.getTipoMascota());
        assertNotNull(dto.getRazaMascota());
        assertNotNull(dto.getEdadMascota());
        assertNotNull(dto.getDescripcionMascota());
        assertNotNull(dto.getColorMascota());
        assertNotNull(dto.getVacunasMascota());
        assertNotNull(dto.getFechaGeneracion());
        assertNotNull(dto.getNumeroContrato());
    }

    /**
     * Helper: Crea una Adopcion completa para testing
     */
    private Adopcion crearAdopcionCompleta() {
        Solicitante solicitante = Solicitante.builder()
                .id(1L)
                .nombre("Juan Pérez")
                .documentoIdentidad("123456789")
                .email("juan@example.com")
                .telefono("555-1234")
                .build();

        Mascota mascota = Mascota.builder()
                .id(1L)
                .nombre("Max")
                .tipo("Perro")
                .raza("Labrador")
                .edad(3)
                .descripcion("Perro muy amigable")
                .color("Café")
                .build();

        return Adopcion.builder()
                .id(1L)
                .solicitante(solicitante)
                .mascota(mascota)
                .vacunasAplicadas(true)
                .build();
    }
}


package com.example.gr01_1bt3_622_26a.controller;

import com.example.gr01_1bt3_622_26a.entity.Solicitud;
import com.example.gr01_1bt3_622_26a.entity.Mascota;
import com.example.gr01_1bt3_622_26a.entity.Solicitante;
import com.example.gr01_1bt3_622_26a.repository.SolicitudRepository;
import com.example.gr01_1bt3_622_26a.repository.SolicitanteRepository;
import com.example.gr01_1bt3_622_26a.repository.MascotaRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * 🧪 Tests de Integración REALES - SolicitudController (T.1.3)
 *
 * 🔴 RED: Tests FALLAN porque endpoints no existen
 * 🟢 GREEN: Implementar endpoints mínimos
 * 🔵 REFACTOR: Mejorar con validaciones y respuestas
 *
 * SIN MOCKITO - BD en memoria H2
 * - @SpringBootTest carga contexto completo
 * - BD real (H2) para pruebas
 * - Tests de integración reales
 *
 * Paso a paso TDD:
 * 1. Ejecutar tests → FALLOS (404 endpoints no existen)
 * 2. Implementar métodos en controlador → VERDES
 * 3. Refactorizar y mejorar código
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
@DisplayName("Tests Integración - Endpoints de Estados (T.1.3)")
class SolicitudControllerUnitTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private SolicitudRepository solicitudRepository;

    @Autowired
    private SolicitanteRepository solicitanteRepository;

    @Autowired
    private MascotaRepository mascotaRepository;

    private Solicitud solicitud;
    private Long solicitudId;

    @BeforeEach
    void setUp() {
        // Crear solicitante real en BD
        Solicitante solicitante = Solicitante.builder()
                .nombre("Juan Pérez")
                .apellido("García")
                .email("juan@example.com")
                .telefonoContacto("3001234567")
                .documentoIdentidad("1234567890")
                .build();
        Solicitante solicitanteGuardado = solicitanteRepository.save(solicitante);

        // Crear mascota real en BD
        Mascota mascota = Mascota.builder()
                .nombre("Luna")
                .raza("Labrador")
                .edad(3)
                .genero("Hembra")
                .estadoMascota("Disponible")
                .build();
        Mascota mascotaGuardada = mascotaRepository.save(mascota);

        // Crear solicitud real en BD
        solicitud = Solicitud.builder()
                .solicitante(solicitanteGuardado)
                .mascota(mascotaGuardada)
                .estado("En revisión")
                .motivo("Quiero adoptar")
                .tipoVivienda("Casa")
                .esPrimerAdopcion(true)
                .build();
        Solicitud solicitudGuardada = solicitudRepository.save(solicitud);
        solicitudId = solicitudGuardada.getId();
    }

    // ==================== TEST 1: Aprobar Solicitud ====================

    /**
     * 🔴 TEST 1: Endpoint POST /solicitudes/{id}/aprobar debe retornar 200
     *
     * Objetivo: Verificar que el endpoint aprobar existe y funciona
     *
     * RED FLAG:
     * - Endpoint no existe → 404
     * - Método no implementado → Error de compilación
     *
     * Paso TDD:
     * 1. ROJO: Ejecutar, ve error 404
     * 2. VERDE: Crear método en controlador
     * 3. REFACTOR: Mejorar respuesta
     */
    @Test
    @DisplayName("T.1.3-TEST1: POST /solicitudes/{id}/aprobar retorna 200 con estado Aprobada")
    void testAprobarSolicitudViaEndpoint() throws Exception {
        // Act & Assert: Ejecutar POST y verificar respuesta
        mockMvc.perform(
                post("/solicitudes/" + solicitudId + "/aprobar")
                        .contentType(MediaType.APPLICATION_JSON)
                        .param("observaciones", "Aprobado. Mascota lista para entregar")
        )
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.estado").value("Aprobada"))
        .andExpect(jsonPath("$.id").value(solicitudId))
        .andExpect(jsonPath("$.fechaRespuesta").isNotEmpty());
    }

    // ==================== TEST 2: Rechazar sin Razón ====================

    /**
     * 🔴 TEST 2: Endpoint POST /solicitudes/{id}/rechazar sin razón retorna 400
     *
     * Objetivo: Verificar validación de parámetro obligatorio
     *
     * RED FLAG:
     * - Endpoint no existe → 404
     * - No valida parámetro "razon" → Should fail validation
     *
     * Paso TDD:
     * 1. ROJO: Ejecutar sin parámetro razon
     * 2. VERDE: Implementar validación en controlador
     * 3. REFACTOR: Mensajes de error detallados
     */
    @Test
    @DisplayName("T.1.3-TEST2: POST /solicitudes/{id}/rechazar sin razon retorna 400")
    void testRechazarSinRazonRetorna400() throws Exception {
        // Act & Assert: Ejecutar POST sin parámetro razon (obligatorio)
        mockMvc.perform(
                post("/solicitudes/" + solicitudId + "/rechazar")
                        .contentType(MediaType.APPLICATION_JSON)
        )
        .andExpect(status().isBadRequest());
    }
}



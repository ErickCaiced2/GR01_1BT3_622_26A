package com.example.gr01_1bt3_622_26a.service;

import com.example.gr01_1bt3_622_26a.entity.Solicitud;
import com.example.gr01_1bt3_622_26a.entity.Solicitante;
import com.example.gr01_1bt3_622_26a.repository.SolicitudRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

/**
 * TDD - CICLOS COMPLETADOS
 *
 * TEST 5: ✅ Aprobar Solicitud (COMPLETADO: RED → GREEN → REFACTOR)
 *
 * Caso de Uso: Aprobación de solicitud de adopción
 * Descripción: Cambiar el estado de una solicitud existente a "Aprobada" y guardarla
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("TDD: Ciclo Completo - Aprobar Solicitud (RED → GREEN → REFACTOR)")
public class SolicitudServiceTest {
    @Mock
    private SolicitudRepository solicitudRepository;

    @InjectMocks
    private SolicitudService solicitudService;

    /**
     * Datos de prueba que se reutilizan en cada test
     */
    private Solicitud solicitudPrueba;
    private static final Long ID_SOLICITUD_EXISTENTE = 1L;

    /**
     * Se ejecuta ANTES de cada test
     * Inicializa los datos que usaremos en los tests
     */
    @BeforeEach
    void configurarDatos() {
        // Crear una solicitud con estado "Pendiente"
        solicitudPrueba = new Solicitud();
        solicitudPrueba.setId(ID_SOLICITUD_EXISTENTE);
        solicitudPrueba.setEstado("Pendiente");
        solicitudPrueba.setFechaSolicitud(LocalDateTime.now());
    }

    /**
     * 🔴 RED: Aprobar Solicitud
     *
     * Este test FALLA porque:
     * - La lógica aún no está implementada correctamente
     * - El estado de la solicitud no cambia a "Aprobada"
     * - El método no cumple el comportamiento esperado
     */
    @Test
    @DisplayName("🔴 RED - Debe cambiar el estado de 'Pendiente' a 'Aprobada'")
    void red_debeAprobarSolicitudCambiandoEstadoAAprobada() {
        // ARRANGE (Preparar)
        // Configurar el mock para devolver la solicitud cuando se llame a findById
        when(solicitudRepository.findById(ID_SOLICITUD_EXISTENTE))
                .thenReturn(Optional.of(solicitudPrueba));
        // También configurar el mock para devolver la solicitud modificada al guardar
        when(solicitudRepository.save(any(Solicitud.class)))
                .thenReturn(solicitudPrueba);

        //ACT (Actuar): Llamar al método que queremos probar
        Solicitud resultado = solicitudService.aprobarSolicitud(ID_SOLICITUD_EXISTENTE);

        // ASSERT (Verificar): El test fallaría aquí si el método no estuviera implementado correctamente
        assertThat(resultado)
                .as("La solicitud no debe ser nula")
                .isNotNull();

        assertThat(resultado.getEstado())
                .as("El estado debe cambiar a 'Aprobada'")
                .isEqualTo("Aprobada");
    }

    /**
     * 🟢 GREEN: Aprobar Solicitud
     *
     * Este test PASA porque:
     * - Se implementa la lógica mínima del método
     * - El estado cambia correctamente a "Aprobada"
     * - El comportamiento esperado se cumple
     */
    @Test
    @DisplayName("🟢 GREEN - El método aprueba correctamente la solicitud")
    void green_aprobacionExitosaDeSolicitud() {
        // ARRANGE (Preparar)
        when(solicitudRepository.findById(ID_SOLICITUD_EXISTENTE))
                .thenReturn(Optional.of(solicitudPrueba));

        when(solicitudRepository.save(any(Solicitud.class)))
                .thenReturn(solicitudPrueba);

        // ACT (Actuar)
        Solicitud resultado = solicitudService.aprobarSolicitud(ID_SOLICITUD_EXISTENTE);

        // ASSERT (Verificar)
        // ✅ EN LA FASE GREEN, estas aserciones PASAN
        assertThat(resultado).isNotNull();
        assertThat(resultado.getEstado()).isEqualTo("Aprobada");
    }

    /**
     * 🔵 REFACTOR: Aprobar Solicitud
     *
     * En esta fase se mejora el código sin cambiar su comportamiento:
     * - Se optimiza la claridad y organización del test
     * - Se agregan más validaciones (verify)
     * - Se mejora la mantenibilidad del código
     */

    @Test
    @DisplayName("🔵 REFACTOR - Aprobación con verificación de interacciones")
    void refactor_debeAprobarSolicitudYGuardarEnBD() {

        // ARRANGE: Preparar datos y comportamiento del mock
        Long idSolicitud = 1L;
        Solicitud solicitudPendiente = crearSolicitudPendiente(idSolicitud);

        when(solicitudRepository.findById(idSolicitud))
                .thenReturn(Optional.of(solicitudPendiente));
        when(solicitudRepository.save(any(Solicitud.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        // ACT: Ejecutar el método a probar
        Solicitud solicitudAprobada = solicitudService.aprobarSolicitud(idSolicitud);

        // ASSERT: Verificar resultados e interacciones
        assertThat(solicitudAprobada).isNotNull();
        assertThat(solicitudAprobada.getEstado()).isEqualTo("Aprobada");
        assertThat(solicitudAprobada.getId()).isEqualTo(idSolicitud);

        verify(solicitudRepository).findById(idSolicitud);
        verify(solicitudRepository).save(solicitudPendiente);
        verifyNoMoreInteractions(solicitudRepository);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MÉTODOS AUXILIARES (Helper Methods)
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Crea una solicitud con estado "Pendiente" para uso en tests
     * Reduce la duplicación de código (DRY: Don't Repeat Yourself)
     *
     * @param id el ID de la solicitud
     * @return una Solicitud con estado Pendiente
     */
    private Solicitud crearSolicitudPendiente(Long id) {
        Solicitud solicitud = new Solicitud();
        solicitud.setId(id);
        solicitud.setEstado("Pendiente");
        solicitud.setFechaSolicitud(LocalDateTime.now());
        return solicitud;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // TAREA 2: Mover asignación del estado al Service
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * 🔴 RED: Crear Solicitud con estado "En revisión"
     *
     * Este test FALLA porque:
     * - El método crearSolicitud() NO asigna automáticamente el estado
     * - La solicitud se guarda sin estado definido
     * - Se espera que el Service maneje la regla de negocio
     */
    @Test
    @DisplayName("🔴 RED - crearSolicitud debe asignar estado 'En revisión' automáticamente")
    void red_crearSolicitudDebeAsignarEstadoEnRevision() {
        // ARRANGE: Preparar una solicitud sin estado
        Solicitud solicitudSinEstado = new Solicitud();
        solicitudSinEstado.setId(1L);
        solicitudSinEstado.setFechaSolicitud(LocalDateTime.now());
        // ⚠️ NO establecemos estado - debería hacerlo el Service

        when(solicitudRepository.save(any(Solicitud.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        // ACT: Crear la solicitud a través del Service
        Solicitud resultado = solicitudService.crearSolicitud(solicitudSinEstado);

        // ASSERT: Verificar que el estado fue asignado a "En revisión"
        assertThat(resultado)
                .as("La solicitud no debe ser nula")
                .isNotNull();

        assertThat(resultado.getEstado())
                .as("El estado debe ser 'En revisión' después de crear la solicitud")
                .isEqualTo("En revisión");

        // Verificar que se guardó en la BD
        verify(solicitudRepository).save(any(Solicitud.class));
    }

    /**
     * 🟢 GREEN: Crear Solicitud con estado "En revisión"
     *
     * Este test PASA porque:
     * - El método crearSolicitud() asigna explícitamente el estado
     * - La solicitud se guarda con estado "En revisión"
     * - El comportamiento esperado se cumple
     */
    @Test
    @DisplayName("🟢 GREEN - crearSolicitud asigna estado correctamente")
    void green_crearSolicitudAsignaEstadoEnRevision() {
        // ARRANGE: Preparar una solicitud sin estado
        Solicitud solicitudNueva = new Solicitud();
        solicitudNueva.setId(1L);
        solicitudNueva.setFechaSolicitud(LocalDateTime.now());

        when(solicitudRepository.save(any(Solicitud.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        // ACT: Crear la solicitud
        Solicitud resultado = solicitudService.crearSolicitud(solicitudNueva);

        // ASSERT: Verificar que tiene el estado correcto
        assertThat(resultado).isNotNull();
        assertThat(resultado.getEstado()).isEqualTo("En revisión");
    }

    /**
     * 🔵 REFACTOR: Crear Solicitud con estado "En revisión"
     *
     * En esta fase se mejora el código sin cambiar su comportamiento:
     * - Se optimiza la claridad del test
     * - Se agregan más validaciones (verify)
     * - Se verifica que el estado se estableció ANTES de guardar
     * - Se mejora la mantenibilidad del código
     */
    @Test
    @DisplayName("🔵 REFACTOR - crearSolicitud con verificación de interacciones")
    void refactor_crearSolicitudDebeAsignarEstadoYGuardar() {
        // ARRANGE: Preparar una solicitud incompleta
        Solicitud solicitudIncompleta = new Solicitud();
        solicitudIncompleta.setId(100L);
        solicitudIncompleta.setFechaSolicitud(LocalDateTime.now());
        // ⚠️ Estado no definido - DEBE ser asignado por el Service

        when(solicitudRepository.save(any(Solicitud.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        // ACT: Crear la solicitud a través del Service
        Solicitud resultado = solicitudService.crearSolicitud(solicitudIncompleta);

        // ASSERT: Verificaciones completas del comportamiento
        assertThat(resultado)
                .as("La solicitud retornada no debe ser nula")
                .isNotNull();

        assertThat(resultado.getId())
                .as("El ID debe ser el mismo que se pasó")
                .isEqualTo(100L);

        assertThat(resultado.getEstado())
                .as("El estado debe ser 'En revisión' como regla de negocio")
                .isEqualTo("En revisión");

        assertThat(resultado.getFechaSolicitud())
                .as("La fecha de solicitud debe ser la proporcionada")
                .isNotNull();

        // Verificar que el repository.save fue llamado exactamente una vez
        verify(solicitudRepository, times(1)).save(any(Solicitud.class));
        // Verificar que no hay más interacciones no esperadas
        verifyNoMoreInteractions(solicitudRepository);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // TAREA 1: Listar solicitudes asociadas al solicitante (CON MOCKS)
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * 🔴 RED: Obtener solicitudes del solicitante
     *
     * Este test FALLA porque:
     * - El método obtenerSolicitudesDelSolicitante() NO existe aún
     * - El repository.findBySolicitanteId() no ha sido invocado
     * - No hay implementación del servicio
     */
    @Test
    @DisplayName("🔴 RED - obtenerSolicitudesDelSolicitante debe devolver lista no nula")
    void red_obtenerSolicitudesDelSolicitante() {
        // ARRANGE: Preparar datos
        Long solicitanteId = 1L;
        List<Solicitud> solicitudesEsperadas = Arrays.asList(
                crearSolicitud(1L, solicitanteId, "Pendiente"),
                crearSolicitud(2L, solicitanteId, "Aprobada")
        );

        when(solicitudRepository.findBySolicitanteId(solicitanteId))
                .thenReturn(solicitudesEsperadas);

        // ACT: Llamar al método (FALLARÁ porque no existe)
        List<Solicitud> resultado = solicitudService.obtenerSolicitudesDelSolicitante(solicitanteId);

        // ASSERT: Verificar resultado
        assertThat(resultado)
                .as("La lista no debe ser nula")
                .isNotNull()
                .hasSize(2)
                .containsExactlyElementsOf(solicitudesEsperadas);

        verify(solicitudRepository).findBySolicitanteId(solicitanteId);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // TAREA 2: Consultar detalle de una solicitud específica (PARAMETRIZADO)
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * 🔴 RED: Obtener detalle de solicitud con validación de solicitante
     *
     * Este test FALLA porque:
     * - El método obtenerDetalleSolicitud(Long, Long) NO existe
     * - No valida que el solicitante sea el propietario de la solicitud
     */
    @Test
    @DisplayName("🔴 RED - obtenerDetalleSolicitud debe retornar Optional con la solicitud correcta")
    void red_obtenerDetalleSolicitud() {
        // ARRANGE
        Long solicitudId = 1L;
        Long solicitanteId = 1L;
        Solicitud solicitud = crearSolicitud(solicitudId, solicitanteId, "Pendiente");

        when(solicitudRepository.findById(solicitudId))
                .thenReturn(Optional.of(solicitud));

        // ACT
        Optional<Solicitud> resultado = solicitudService.obtenerDetalleSolicitud(solicitudId, solicitanteId);

        // ASSERT
        assertThat(resultado)
                .isPresent()
                .get()
                .extracting("id", "estado")
                .containsExactly(solicitudId, "Pendiente");
    }

    /**
     * 🔴 RED: Obtener detalle de solicitud - Solicitante NO coincide
     *
     * Este test FALLA porque:
     * - El método no valida que el solicitante sea el propietario
     */
    @Test
    @DisplayName("🔴 RED - obtenerDetalleSolicitud retorna empty si solicitante no coincide")
    void red_obtenerDetalleSolicitudSolicitanteNoCoincide() {
        // ARRANGE
        Long solicitudId = 1L;
        Long solicitanteId = 1L;
        Long solicitanteDistinto = 999L;
        Solicitud solicitud = crearSolicitud(solicitudId, solicitanteId, "Pendiente");

        when(solicitudRepository.findById(solicitudId))
                .thenReturn(Optional.of(solicitud));

        // ACT
        Optional<Solicitud> resultado = solicitudService.obtenerDetalleSolicitud(
                solicitudId,
                solicitanteDistinto  // Diferente solicitante
        );

        // ASSERT
        assertThat(resultado)
                .as("Debe retornar empty si el solicitante no es el propietario")
                .isEmpty();
    }

    /**
     * 🔴 RED: Obtener detalle de solicitud - NO existe
     *
     * Este test FALLA porque:
     * - El método no valida que la solicitud exista
     */
    @Test
    @DisplayName("🔴 RED - obtenerDetalleSolicitud retorna empty si solicitud no existe")
    void red_obtenerDetalleSolicitudNoExiste() {
        // ARRANGE
        Long solicitudId = 999L;
        Long solicitanteId = 1L;

        when(solicitudRepository.findById(solicitudId))
                .thenReturn(Optional.empty());

        // ACT
        Optional<Solicitud> resultado = solicitudService.obtenerDetalleSolicitud(solicitudId, solicitanteId);

        // ASSERT
        assertThat(resultado)
                .as("Debe retornar empty si la solicitud no existe")
                .isEmpty();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MÉTODOS AUXILIARES (Helper Methods)
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Crea una solicitud con datos específicos para pruebas
     */
    private Solicitud crearSolicitud(Long solicitudId, Long solicitanteId, String estado) {
        Solicitud solicitud = new Solicitud();
        solicitud.setId(solicitudId);
        solicitud.setEstado(estado);
        solicitud.setFechaSolicitud(LocalDateTime.now());

        Solicitante solicitante = new Solicitante();
        solicitante.setId(solicitanteId);
        solicitud.setSolicitante(solicitante);

        return solicitud;
    }
}

package com.example.gr01_1bt3_622_26a.validation;

import lombok.extern.slf4j.Slf4j;
import java.util.*;

/**
 * 🔵 Validador de Transiciones de Estado para Solicitudes (REFACTORIZADO)
 *
 * Implementa máquina de estados usando Map para mayor escalabilidad y mantenibilidad.
 *
 * Transiciones válidas:
 * - En revisión → Aprobada ✅
 * - En revisión → Rechazada ✅
 * - Aprobada → Cancelada ✅
 * - Rechazada → Cancelada ✅
 *
 * @author Sistema de Adopciones
 * @version 2.0
 */
@Slf4j
public class SolicitudEstadoValidator {

    /**
     * Mapa que define todas las transiciones válidas
     * Estructura: {estadoActual -> Set<estadosValidos>}
     *
     * Ventajas:
     * - Más fácil de mantener y extender
     * - Separación clara de transiciones válidas
     * - Mejor rendimiento que múltiples if-else
     */
    private static final Map<String, Set<String>> TRANSICIONES_VALIDAS = Map.ofEntries(
            Map.entry("En revisión", Set.of("Aprobada", "Rechazada")),
            Map.entry("Aprobada", Set.of("Cancelada")),
            Map.entry("Rechazada", Set.of("Cancelada"))
    );

    /**
     * Estados válidos del sistema
     */
    private static final Set<String> ESTADOS_VALIDOS = Set.of(
            "En revisión",
            "Aprobada",
            "Rechazada",
            "Cancelada"
    );

    /**
     * Valida si una transición de estado es permitida
     *
     * @param estadoActual Estado actual de la solicitud (no puede ser null)
     * @param estadoNuevo Estado al que se quiere transicionar (no puede ser null)
     * @throws IllegalArgumentException si los estados son null o inválidos
     * @throws EstadoInvalidoException si la transición no es válida
     */
    public void validarTransicion(String estadoActual, String estadoNuevo) {
        // ✅ Validar parámetros de entrada
        validarParametrosEntrada(estadoActual, estadoNuevo);

        log.debug("🔍 Validando transición: '{}' → '{}'", estadoActual, estadoNuevo);

        // ✅ Verificar si la transición es válida
        if (!esTransicionValida(estadoActual, estadoNuevo)) {
            String mensaje = String.format(
                    "❌ Transición no permitida: '%s' → '%s'. Transiciones válidas desde '%s': %s",
                    estadoActual, estadoNuevo, estadoActual,
                    TRANSICIONES_VALIDAS.getOrDefault(estadoActual, Set.of())
            );
            log.warn(mensaje);
            throw new EstadoInvalidoException(mensaje);
        }

        log.info("✅ Transición válida: '{}' → '{}'", estadoActual, estadoNuevo);
    }

    /**
     * Valida los parámetros de entrada
     *
     * @param estadoActual Estado actual
     * @param estadoNuevo Estado nuevo
     * @throws IllegalArgumentException si los parámetros son inválidos
     */
    private void validarParametrosEntrada(String estadoActual, String estadoNuevo) {
        if (estadoActual == null || estadoActual.isBlank()) {
            log.error("❌ Estado actual no puede ser null o vacío");
            throw new IllegalArgumentException("Estado actual no puede ser null o vacío");
        }

        if (estadoNuevo == null || estadoNuevo.isBlank()) {
            log.error("❌ Estado nuevo no puede ser null o vacío");
            throw new IllegalArgumentException("Estado nuevo no puede ser null o vacío");
        }

        if (!ESTADOS_VALIDOS.contains(estadoActual)) {
            log.error("❌ Estado actual inválido: '{}'", estadoActual);
            throw new IllegalArgumentException("Estado actual inválido: '" + estadoActual + "'");
        }

        if (!ESTADOS_VALIDOS.contains(estadoNuevo)) {
            log.error("❌ Estado nuevo inválido: '{}'", estadoNuevo);
            throw new IllegalArgumentException("Estado nuevo inválido: '" + estadoNuevo + "'");
        }
    }

    /**
     * Determina si una transición de estado es válida
     *
     * Algoritmo:
     * 1. Obtener el conjunto de estados válidos desde el mapa
     * 2. Verificar si el estado nuevo está en el conjunto
     *
     * @param estadoActual Estado actual
     * @param estadoNuevo Estado nuevo
     * @return true si la transición es válida, false en caso contrario
     */
    private boolean esTransicionValida(String estadoActual, String estadoNuevo) {
        Set<String> estadosValidos = TRANSICIONES_VALIDAS.get(estadoActual);

        // Si no existe estado actual en el mapa, la transición es inválida
        if (estadosValidos == null) {
            log.debug("⚠️ Estado actual '{}' no tiene transiciones definidas", estadoActual);
            return false;
        }

        boolean esValida = estadosValidos.contains(estadoNuevo);

        if (esValida) {
            log.debug("✓ Transición '{}' → '{}' es válida", estadoActual, estadoNuevo);
        } else {
            log.debug("✗ Transición '{}' → '{}' no es válida", estadoActual, estadoNuevo);
        }

        return esValida;
    }

    /**
     * Obtiene las transiciones válidas desde un estado
     *
     * Útil para UI/validación del lado del cliente
     *
     * @param estado Estado actual
     * @return Set con los estados a los que se puede transicionar
     */
    public Set<String> obtenerTransicionesValidas(String estado) {
        log.debug("📋 Obteniendo transiciones válidas para estado: '{}'", estado);
        return TRANSICIONES_VALIDAS.getOrDefault(estado, Collections.emptySet());
    }

    /**
     * Obtiene todos los estados válidos del sistema
     *
     * @return Set con todos los estados válidos
     */
    public Set<String> obtenerEstadosValidos() {
        return Collections.unmodifiableSet(ESTADOS_VALIDOS);
    }
}


package com.example.gr01_1bt3_622_26a.validation;

import lombok.extern.slf4j.Slf4j;

/**
 * 🔵 Excepción Personalizada para Transiciones de Estado Inválidas (REFACTORIZADA)
 *
 * Se lanza cuando se intenta hacer una transición de estado no permitida.
 *
 * Características:
 * - Hereda de RuntimeException (unchecked exception)
 * - Registro automático de errores con logging
 * - Información contextual enriquecida
 * - Serializable para persistencia
 *
 * Ejemplo de uso:
 * ```java
 * throw new EstadoInvalidoException("No se puede transicionar de 'Aprobada' a 'En revisión'");
 * ```
 *
 * @author Sistema de Adopciones
 * @version 2.0
 * @since 1.0
 */
@Slf4j
public class EstadoInvalidoException extends RuntimeException {

    /**
     * Serial Version UID para serialización
     */
    private static final long serialVersionUID = 1L;

    /**
     * Tipo de error para categorización
     */
    private final String tipoError = "ESTADO_INVALIDO";

    /**
     * Timestamp del momento en que ocurrió la excepción
     */
    private final long timestamp = System.currentTimeMillis();

    /**
     * Constructor básico
     *
     * @param message Mensaje de error descriptivo (no puede ser null)
     * @throws IllegalArgumentException si el mensaje es null
     */
    public EstadoInvalidoException(String message) {
        super(message);

        // ✅ Validar parámetro
        if (message == null || message.isBlank()) {
            throw new IllegalArgumentException("El mensaje de error no puede ser null o vacío");
        }

        // ✅ Registrar error
        log.error("🔴 EstadoInvalidoException: {}", message);
    }

    /**
     * Constructor con causa raíz (para encadenamiento de excepciones)
     *
     * @param message Mensaje de error descriptivo
     * @param cause Excepción que causó este error
     * @throws IllegalArgumentException si el mensaje es null
     */
    public EstadoInvalidoException(String message, Throwable cause) {
        super(message, cause);

        // ✅ Validar parámetro
        if (message == null || message.isBlank()) {
            throw new IllegalArgumentException("El mensaje de error no puede ser null o vacío");
        }

        // ✅ Registrar error con causa
        log.error("🔴 EstadoInvalidoException: {} [Causa: {}]",
                message,
                cause != null ? cause.getMessage() : "Sin causa");
    }

    /**
     * Obtiene el tipo de error
     *
     * @return Código de tipo de error
     */
    public String getTipoError() {
        return tipoError;
    }

    /**
     * Obtiene el timestamp de cuando ocurrió la excepción
     *
     * @return Timestamp en milisegundos
     */
    public long getTimestamp() {
        return timestamp;
    }

    /**
     * Obtiene una representación detallada de la excepción
     *
     * @return String con información completa del error
     */
    @Override
    public String toString() {
        return String.format(
                "EstadoInvalidoException{" +
                "tipo='%s', " +
                "mensaje='%s', " +
                "timestamp=%d, " +
                "causa=%s" +
                "}",
                tipoError,
                getMessage(),
                timestamp,
                getCause() != null ? getCause().getClass().getSimpleName() : "null"
        );
    }

    /**
     * Crea una instancia con mensaje formateado
     *
     * Útil para mensajes dinámicos con parámetros
     *
     * @param template Plantilla del mensaje (compatible con String.format)
     * @param args Argumentos para la plantilla
     * @return Nueva instancia de EstadoInvalidoException
     *
     * Ejemplo:
     * ```java
     * throw EstadoInvalidoException.de("No se puede transicionar de '%s' a '%s'",
     *                                   estadoActual, estadoNuevo);
     * ```
     */
    public static EstadoInvalidoException de(String template, Object... args) {
        String mensaje = String.format(template, args);
        log.debug("⚠️ Creando EstadoInvalidoException con plantilla: {}", template);
        return new EstadoInvalidoException(mensaje);
    }
}



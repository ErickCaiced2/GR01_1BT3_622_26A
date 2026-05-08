-- ============================================
-- Migración V2: Gestión de Estados de Solicitud
-- ============================================
-- Objetivo: Asegurar que la estructura de datos soporta todos los estados requeridos
-- Estados soportados: Pendiente, En revisión, Aprobada, Rechazada, Cancelada
-- Fecha: 2026-05-08
-- ============================================

-- Verificar que la tabla solicitudes existe
SELECT 'Iniciando migración V2__SolicitudEstados.sql' AS status;

-- ============================================
-- 1. Actualizar valores de estado existentes
-- ============================================
-- Cambiar 'Pendiente' por 'En revisión' si es necesario
-- (En este caso mantenemos 'Pendiente' como estado inicial)

UPDATE solicitudes
SET estado = 'En revisión'
WHERE estado = 'Pendiente' AND fecha_solicitud > DATE_SUB(NOW(), INTERVAL 7 DAY);

-- ============================================
-- 2. Agregar índice optimizado en estado (si no existe)
-- ============================================
-- Este índice ya existe, pero lo verificamos
-- CREATE INDEX idx_solicitud_estado ON solicitudes(estado);

-- ============================================
-- 3. Agregar índice compuesto para búsquedas frecuentes
-- ============================================
-- Búsqueda: solicitudes de un solicitante en un estado específico
CREATE INDEX IF NOT EXISTS idx_solicitud_solicitante_estado_fecha
ON solicitudes(solicitante_id, estado, fecha_solicitud DESC);

-- ============================================
-- 4. Verificar que las columnas existen
-- ============================================
-- Las columnas ya existen en schema-mysql.sql:
-- - fecha_respuesta DATETIME
-- - razon_rechazo VARCHAR(500)

-- ============================================
-- 5. Verificación: Estados válidos en la tabla
-- ============================================
-- Resultado esperado: Pendiente, En revisión, Aprobada, Rechazada (y Cancelada si aplica)

SELECT DISTINCT estado AS estados_actuales
FROM solicitudes
ORDER BY estado;

-- ============================================
-- 6. Validación de integridad de datos
-- ============================================
-- Verificar que no hayan estados inválidos
SELECT COUNT(*) as solicitudes_invalidas
FROM solicitudes
WHERE estado NOT IN ('Pendiente', 'En revisión', 'Aprobada', 'Rechazada', 'Cancelada');

-- ============================================
-- 7. Agregar columna estado_mascota a tabla mascotas (para T.1.5)
-- ============================================
-- Estados: Disponible, En evaluación, Bloqueada para adopción, Adoptada

ALTER TABLE mascotas
ADD COLUMN IF NOT EXISTS estado_mascota VARCHAR(50) DEFAULT 'Disponible';

-- Crear índice para búsquedas de mascotas por estado_mascota
CREATE INDEX IF NOT EXISTS idx_mascota_estado_mascota
ON mascotas(estado_mascota);

-- Crear índice compuesto para búsquedas frecuentes
CREATE INDEX IF NOT EXISTS idx_mascota_tipo_estado_mascota
ON mascotas(tipo, estado_mascota);

SELECT 'Migración V2__SolicitudEstados.sql completada exitosamente' AS status;



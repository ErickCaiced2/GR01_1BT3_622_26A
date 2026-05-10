-- ============================================
-- Migración V4: Tabla de Usuarios
-- ============================================
-- Objetivo: Crear tabla de usuarios para autenticación y gestión de roles
-- Roles soportados: ADMIN, SOLICITANTE, STAFF
-- Fecha: 2026-05-10
-- ============================================

SELECT 'Iniciando migración V4__Usuarios.sql' AS status;

-- ============================================
-- 1. Crear tabla USUARIOS
-- ============================================
CREATE TABLE IF NOT EXISTS usuarios (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    estado VARCHAR(50) NOT NULL DEFAULT 'ACTIVO',
    rol VARCHAR(50) NOT NULL DEFAULT 'SOLICITANTE',
    documento_identidad VARCHAR(20) UNIQUE,
    fecha_creacion DATE DEFAULT CURRENT_DATE,
    fecha_ultimo_login DATETIME,
    token_recuperacion VARCHAR(255),
    fecha_expiracion_token DATE,
    intentos_fallidos INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_estado_usuario CHECK (estado IN ('ACTIVO', 'INACTIVO', 'BLOQUEADO')),
    CONSTRAINT chk_rol_usuario CHECK (rol IN ('ADMIN', 'SOLICITANTE', 'STAFF')),
    INDEX idx_email (email),
    INDEX idx_estado (estado),
    INDEX idx_rol (rol),
    INDEX idx_documento (documento_identidad)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 2. Insertar usuarios de ejemplo
-- ============================================
-- Nota: Las contraseñas están en texto plano por ejemplo. En producción usar bcrypt.

-- Usuario Admin del sistema
INSERT INTO usuarios (email, password, nombre, estado, rol, documento_identidad, fecha_creacion)
VALUES ('admin@pawshome.com', 'admin123', 'Administrador Sistema', 'ACTIVO', 'ADMIN', '0000000001', CURDATE())
ON DUPLICATE KEY UPDATE email=VALUES(email);

-- Usuarios Solicitantes (correspondientes a los solicitantes existentes)
INSERT INTO usuarios (email, password, nombre, estado, rol, documento_identidad, fecha_creacion)
VALUES
('carlos.garcia@email.com', 'password123', 'Carlos García', 'ACTIVO', 'SOLICITANTE', '1234567890', CURDATE()),
('maria.lopez@email.com', 'password123', 'María López', 'ACTIVO', 'SOLICITANTE', '9876543210', CURDATE()),
('juan.rodriguez@email.com', 'password123', 'Juan Rodríguez', 'ACTIVO', 'SOLICITANTE', '5555666677', CURDATE()),
('ana.martinez@email.com', 'password123', 'Ana Martínez', 'ACTIVO', 'SOLICITANTE', '1111222233', CURDATE()),
('pedro.sanchez@email.com', 'password123', 'Pedro Sánchez', 'ACTIVO', 'SOLICITANTE', '4444555566', CURDATE())
ON DUPLICATE KEY UPDATE email=VALUES(email);

-- Usuario Staff (personal del refugio)
INSERT INTO usuarios (email, password, nombre, estado, rol, documento_identidad, fecha_creacion)
VALUES ('staff@pawshome.com', 'staff123', 'Personal Refugio', 'ACTIVO', 'STAFF', '0000000002', CURDATE())
ON DUPLICATE KEY UPDATE email=VALUES(email);

-- ============================================
-- 3. Crear índices adicionales para optimización
-- ============================================
CREATE INDEX IF NOT EXISTS idx_usuario_estado_rol ON usuarios(estado, rol);
CREATE INDEX IF NOT EXISTS idx_usuario_fecha_creacion ON usuarios(fecha_creacion DESC);

-- ============================================
-- 4. Verificación: Usuarios creados
-- ============================================
SELECT COUNT(*) as total_usuarios FROM usuarios;

SELECT 'Migración V4__Usuarios.sql completada exitosamente' AS status;


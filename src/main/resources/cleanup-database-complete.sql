-- ============================================
-- SCRIPT DE LIMPIEZA COMPLETO Y CORRECTO
-- ============================================
-- Ejecutar esto cuando Jenkins falla en la BD

SET FOREIGN_KEY_CHECKS = 0;

-- Eliminar todas las tablas
DROP TABLE IF EXISTS flyway_schema_history;
DROP TABLE IF EXISTS documentos_solicitante;
DROP TABLE IF EXISTS adopciones;
DROP TABLE IF EXISTS solicitudes;
DROP TABLE IF EXISTS fotos;
DROP TABLE IF EXISTS solicitantes;
DROP TABLE IF EXISTS mascotas;
DROP TABLE IF EXISTS usuarios;

SET FOREIGN_KEY_CHECKS = 1;

-- ✅ Crear tabla mascotas (sin dependencias)
CREATE TABLE IF NOT EXISTS mascotas (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    raza VARCHAR(50),
    edad INT NOT NULL CHECK (edad >= 0 AND edad <= 50),
    genero VARCHAR(10) NOT NULL,
    color VARCHAR(100),
    peso_kg DECIMAL(5, 2),
    descripcion VARCHAR(500),
    fecha_registro DATE DEFAULT (CURDATE()),
    estado VARCHAR(50) DEFAULT 'Disponible',
    estado_mascota VARCHAR(50) DEFAULT 'Disponible',
    compatible_ninos BOOLEAN DEFAULT true,
    compatible_gatos BOOLEAN DEFAULT true,
    compatible_perros BOOLEAN DEFAULT true,
    energia_nivel VARCHAR(20) DEFAULT 'Media',
    tamano_requerido VARCHAR(20) DEFAULT 'Mediano',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_estado (estado),
    INDEX idx_tipo (tipo),
    INDEX idx_genero (genero)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ✅ Crear tabla usuarios ANTES de solicitantes
CREATE TABLE IF NOT EXISTS usuarios (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    estado VARCHAR(50) NOT NULL DEFAULT 'ACTIVO',
    rol VARCHAR(50) NOT NULL DEFAULT 'SOLICITANTE',
    documento_identidad VARCHAR(20) UNIQUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_estado (estado),
    INDEX idx_rol (rol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ✅ Crear tabla solicitantes DESPUÉS de usuarios
CREATE TABLE IF NOT EXISTS solicitantes (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    ciudad VARCHAR(100),
    documento_identidad VARCHAR(20) UNIQUE,
    tipo_documento VARCHAR(20),
    fecha_nacimiento DATE,
    fecha_registro DATE,
    estado VARCHAR(50) NOT NULL DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_estado (estado),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- INSERTAR DATOS DE EJEMPLO (EN ORDEN CORRECTO)
-- ============================================

-- 1️⃣ Insertar USUARIOS primero
INSERT INTO usuarios (email, password, nombre, estado, rol, documento_identidad)
VALUES
('admin@pawshome.com', 'admin123', 'Administrador Sistema', 'ACTIVO', 'ADMIN', '0000000001'),
('carlos.garcia@email.com', 'password123', 'Carlos García', 'ACTIVO', 'SOLICITANTE', '1234567890'),
('maria.lopez@email.com', 'password123', 'María López', 'ACTIVO', 'SOLICITANTE', '9876543210'),
('juan.rodriguez@email.com', 'password123', 'Juan Rodríguez', 'ACTIVO', 'SOLICITANTE', '5555666677'),
('ana.martinez@email.com', 'password123', 'Ana Martínez', 'ACTIVO', 'SOLICITANTE', '1111222233'),
('pedro.sanchez@email.com', 'password123', 'Pedro Sánchez', 'ACTIVO', 'SOLICITANTE', '4444555566'),
('staff@pawshome.com', 'staff123', 'Personal Refugio', 'ACTIVO', 'STAFF', '0000000002');

-- 2️⃣ Insertar SOLICITANTES (emails DEBEN coincidir con usuarios)
INSERT IGNORE INTO solicitantes (nombre, apellido, email, telefono, direccion, ciudad, documento_identidad, tipo_documento, fecha_nacimiento, estado)
VALUES
('Carlos', 'García', 'carlos.garcia@email.com', '3001234567', 'Calle 10 #45-67', 'Bogotá', '1234567890', 'CC', '1985-03-15', 'Activo'),
('María', 'López', 'maria.lopez@email.com', '3107654321', 'Carrera 5 #78-90', 'Medellín', '9876543210', 'CC', '1990-07-22', 'Activo'),
('Juan', 'Rodríguez', 'juan.rodriguez@email.com', '3152468135', 'Avenida Central #123', 'Cali', '5555666677', 'CC', '1980-11-10', 'Activo'),
('Ana', 'Martínez', 'ana.martinez@email.com', '3013579246', 'Calle 1 #1-1', 'Barranquilla', '1111222233', 'CC', '1992-01-05', 'Activo'),
('Pedro', 'Sánchez', 'pedro.sanchez@email.com', '3009876543', 'Carrera 20 #50-100', 'Bogotá', '4444555566', 'CC', '1988-06-18', 'Activo');

-- 3️⃣ Insertar MASCOTAS
INSERT IGNORE INTO mascotas (nombre, tipo, raza, edad, genero, color, peso_kg, descripcion, estado, estado_mascota)
VALUES
('Firulais', 'Perro', 'Labrador', 3, 'Macho', 'Dorado', 32.5, 'Perro sociable y cariñoso', 'Disponible', 'Disponible'),
('Miau', 'Gato', 'Persa', 2, 'Hembra', 'Blanco', 4.2, 'Gata elegante y tranquila', 'Disponible', 'Disponible'),
('Boxer', 'Perro', 'Boxer', 5, 'Macho', 'Atigrado', 28.0, 'Perro energético', 'Disponible', 'Disponible'),
('Luna', 'Gato', 'Siamés', 1, 'Hembra', 'Blanco y Marrón', 3.5, 'Gatita juguetona', 'Disponible', 'Disponible'),
('Max', 'Perro', 'Pastor Alemán', 4, 'Macho', 'Negro y Marrón', 35.0, 'Perro leal y obediente', 'Disponible', 'Disponible');

-- ============================================
-- VERIFICAR DATOS INSERTADOS
-- ============================================
SELECT 'Base de Datos limpiada e inicializada exitosamente' AS status;
SELECT COUNT(*) as total_usuarios FROM usuarios;
SELECT COUNT(*) as total_solicitantes FROM solicitantes;
SELECT COUNT(*) as total_mascotas FROM mascotas;


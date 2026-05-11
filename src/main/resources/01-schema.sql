-- ============================================
-- PARTE 1: ESTRUCTURA DE BASE DE DATOS
-- Sistema Integral de Adopción de Mascotas
-- Ejecutado automáticamente por Jenkins
-- ============================================

USE adopciones_db;

-- ============================================
-- CREAR TABLAS PRINCIPALES
-- ============================================

CREATE TABLE IF NOT EXISTS mascotas (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    raza VARCHAR(50),
    edad INT NOT NULL CHECK (edad >= 0 AND edad <= 50),
    genero VARCHAR(10) NOT NULL,
    color VARCHAR(255),
    peso_kg DECIMAL(5, 2),
    descripcion VARCHAR(500),
    fecha_registro DATE,
    estado VARCHAR(50) NOT NULL DEFAULT 'Disponible',
    estado_mascota VARCHAR(50) DEFAULT 'Disponible',
    compatible_ninos BOOLEAN DEFAULT true,
    compatible_gatos BOOLEAN DEFAULT true,
    compatible_perros BOOLEAN DEFAULT true,
    energia_nivel VARCHAR(20) DEFAULT 'Media',
    tamano_requerido VARCHAR(20) DEFAULT 'Mediano',
    requisitos_especiales VARCHAR(500),
    edad_minima_ninos INT DEFAULT 5,
    es_hipoalergenico BOOLEAN DEFAULT false,
    necesita_patio BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_estado (estado),
    INDEX idx_tipo (tipo),
    INDEX idx_genero (genero),
    INDEX idx_mascota_estado_mascota (estado_mascota),
    INDEX idx_mascota_tipo_estado_mascota (tipo, estado_mascota),
    INDEX idx_compatibilidad (compatible_ninos, compatible_gatos, compatible_perros),
    INDEX idx_energia (energia_nivel),
    INDEX idx_tamano (tamano_requerido)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS fotos (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    mascota_id BIGINT NOT NULL,
    ruta_foto VARCHAR(255) NOT NULL,
    nombre_archivo VARCHAR(255),
    descripcion VARCHAR(255),
    es_principal BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (mascota_id) REFERENCES mascotas(id) ON DELETE CASCADE,
    INDEX idx_mascota (mascota_id),
    INDEX idx_principal (es_principal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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

CREATE TABLE IF NOT EXISTS usuarios (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    estado VARCHAR(50) NOT NULL DEFAULT 'ACTIVO',
    rol VARCHAR(50) NOT NULL DEFAULT 'SOLICITANTE',
    documento_identidad VARCHAR(20) UNIQUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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
    INDEX idx_documento (documento_identidad),
    INDEX idx_usuario_estado_rol (estado, rol),
    INDEX idx_usuario_fecha_creacion (fecha_creacion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS solicitudes (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    solicitante_id BIGINT NOT NULL,
    mascota_id BIGINT NOT NULL,
    fecha_solicitud DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(50) NOT NULL DEFAULT 'Pendiente',
    motivo VARCHAR(1000),
    observaciones VARCHAR(500),
    fecha_respuesta DATETIME,
    razon_rechazo VARCHAR(500),
    requiere_visita_hogar BOOLEAN DEFAULT FALSE,
    numero_mascotas INT,
    tipo_vivienda VARCHAR(100),
    tiene_jardin BOOLEAN,
    es_primer_adopcion BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (solicitante_id) REFERENCES solicitantes(id) ON DELETE CASCADE,
    FOREIGN KEY (mascota_id) REFERENCES mascotas(id) ON DELETE CASCADE,
    INDEX idx_solicitante (solicitante_id),
    INDEX idx_mascota (mascota_id),
    INDEX idx_estado (estado),
    INDEX idx_fecha (fecha_solicitud),
    INDEX idx_solicitud_solicitante_estado (solicitante_id, estado),
    INDEX idx_solicitud_solicitante_estado_fecha (solicitante_id, estado, fecha_solicitud)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS adopciones (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    solicitante_id BIGINT NOT NULL,
    mascota_id BIGINT NOT NULL,
    solicitud_id BIGINT NOT NULL,
    fecha_adopcion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_finalizacion DATE,
    estado VARCHAR(50) NOT NULL DEFAULT 'En_proceso',
    fecha_visita_hogar DATE,
    resultado_visita VARCHAR(50),
    observaciones VARCHAR(500),
    numero_acta_adopcion VARCHAR(100),
    contrato_firmado BOOLEAN DEFAULT FALSE,
    vacunas_aplicadas BOOLEAN DEFAULT FALSE,
    desparasitacion BOOLEAN DEFAULT FALSE,
    microchip_colocado BOOLEAN DEFAULT FALSE,
    seguimiento_requerido BOOLEAN DEFAULT TRUE,
    fecha_seguimiento DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (solicitante_id) REFERENCES solicitantes(id) ON DELETE CASCADE,
    FOREIGN KEY (mascota_id) REFERENCES mascotas(id) ON DELETE CASCADE,
    FOREIGN KEY (solicitud_id) REFERENCES solicitudes(id) ON DELETE CASCADE,
    INDEX idx_solicitante (solicitante_id),
    INDEX idx_mascota (mascota_id),
    INDEX idx_estado (estado),
    INDEX idx_fecha (fecha_adopcion),
    INDEX idx_adopcion_mascota_estado (mascota_id, estado),
    INDEX idx_adopcion_fecha_rango (fecha_adopcion, estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS documentos_solicitante (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    solicitante_id BIGINT NOT NULL,
    tipo_documento VARCHAR(100) NOT NULL,
    ruta_archivo VARCHAR(255) NOT NULL,
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (solicitante_id) REFERENCES solicitantes(id) ON DELETE CASCADE,
    INDEX idx_solicitante (solicitante_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- FINAL: Base de Datos Lista
-- ============================================
SELECT CONCAT('✅ Estructura creada - Tablas: ', COUNT(*)) as status
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'adopciones_db';


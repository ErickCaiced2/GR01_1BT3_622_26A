-- ============================================
-- Script Completo Base de Datos
-- Sistema de Adopciones
-- ============================================

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS sistema_adopciones;
USE sistema_adopciones;

-- ============================================
-- Tabla MASCOTAS
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
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_estado (estado),
    INDEX idx_tipo (tipo),
    INDEX idx_genero (genero)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Tabla FOTOS
-- ============================================
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

-- ============================================
-- Tabla SOLICITANTES
-- ============================================
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
-- Tabla SOLICITUDES
-- ============================================
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
    INDEX idx_fecha (fecha_solicitud)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Tabla ADOPCIONES
-- ============================================
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
    INDEX idx_fecha (fecha_adopcion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- DATOS DE EJEMPLO
-- ============================================

-- Insertar mascotas
INSERT INTO mascotas (nombre, tipo, raza, edad, genero, color, peso_kg, descripcion, estado) VALUES
('Buddy', 'Perro', 'Golden Retriever', 3, 'Macho', 'Dorado', 32.5, 'Perro muy sociable y cariñoso, perfecto para familias con niños. Le encanta jugar y es muy inteligente.', 'Disponible'),
('Luna', 'Gato', 'Persa', 2, 'Hembra', 'Blanco', 4.2, 'Gata elegante y tranquila. Ama las caricias y es muy independiente. Ideal para apartamentos.', 'Disponible'),
('Max', 'Perro', 'Pastor Alemán', 5, 'Macho', 'Negro y Marrón', 35.0, 'Perro obediente y leal. Requiere actividad física regular. Excelente como mascota de familia.', 'Disponible'),
('Mimi', 'Gato', 'Siamés', 1, 'Hembra', 'Blanco y Marrón', 3.5, 'Gatita juguetona y curiosa. Muy vocal y expresiva. Le encanta interactuar con sus dueños.', 'Disponible'),
('Charlie', 'Perro', 'Bulldog Francés', 4, 'Macho', 'Atigrado', 13.0, 'Pequeño pero con mucha personalidad. Cariñoso y divertido. Perfecto para espacios pequeños.', 'Disponible'),
('Bella', 'Perro', 'Labrador Retriever', 6, 'Hembra', 'Negro', 32.0, 'Perra tranquila y afectuosa. Adora a los niños. Excelente temperamento.', 'En proceso'),
('Tiger', 'Gato', 'Atigrado', 3, 'Macho', 'Naranja y Negro', 5.0, 'Gato activo y cazador. Muy ágil. Necesita espacio para moverse.', 'Disponible'),
('Daisy', 'Conejo', 'Orejas Caídas', 2, 'Hembra', 'Blanco', 2.0, 'Coneja dulce y sociable. Se lleva bien con otros animales.', 'Disponible'),
('Oscar', 'Perro', 'Cocker Spaniel', 4, 'Macho', 'Marrón', 28.0, 'Perro energético y amigable. Adora el agua. Requiere ejercicio regular.', 'Disponible'),
('Whiskers', 'Gato', 'Mestizo', 7, 'Macho', 'Gris', 4.8, 'Gato adulto, tranquilo y cariñoso. Perfecto para jubilados o personas sedentarias.', 'Adoptado');

-- Insertar solicitantes de ejemplo
INSERT INTO solicitantes (nombre, apellido, email, telefono, direccion, ciudad, documento_identidad, tipo_documento, fecha_nacimiento, estado) VALUES
('Carlos', 'García', 'carlos.garcia@email.com', '3001234567', 'Calle 10 #45-67', 'Bogotá', '1234567890', 'CC', '1985-03-15', 'Activo'),
('María', 'López', 'maria.lopez@email.com', '3107654321', 'Carrera 5 #78-90', 'Medellín', '9876543210', 'CC', '1990-07-22', 'Activo'),
('Juan', 'Rodríguez', 'juan.rodriguez@email.com', '3152468135', 'Avenida Central #123', 'Cali', '5555666677', 'CC', '1980-11-10', 'Activo'),
('Ana', 'Martínez', 'ana.martinez@email.com', '3013579246', 'Calle 1 #1-1', 'Barranquilla', '1111222233', 'CC', '1992-01-05', 'Activo'),
('Pedro', 'Sánchez', 'pedro.sanchez@email.com', '3009876543', 'Carrera 20 #50-100', 'Bogotá', '4444555566', 'CC', '1988-06-18', 'Activo');

-- Insertar solicitudes de ejemplo
INSERT INTO solicitudes (solicitante_id, mascota_id, estado, motivo, numero_mascotas, tipo_vivienda, tiene_jardin, requiere_visita_hogar) VALUES
(1, 1, 'Pendiente', 'Quiero un compañero leal para mi familia', 0, 'Casa', TRUE, FALSE),
(2, 2, 'Aprobada', 'Me encanta los gatos, tengo experiencia con ellos', 1, 'Apartamento', FALSE, FALSE),
(3, 3, 'Pendiente', 'Necesito un perro que me acompañe en mis salidas', 2, 'Casa', TRUE, TRUE),
(4, 4, 'Rechazada', 'Primera vez adoptando', 1, 'Apartamento', FALSE, FALSE),
(5, 5, 'Aprobada', 'Tengo espacio en mi casa para un perro pequeño', 0, 'Casa', TRUE, FALSE);

-- Insertar adopciones de ejemplo
INSERT INTO adopciones (solicitante_id, mascota_id, solicitud_id, estado, resultado_visita, contrato_firmado, vacunas_aplicadas, desparasitacion, microchip_colocado) VALUES
(2, 2, 2, 'Completada', 'Aprobada', TRUE, TRUE, TRUE, TRUE),
(5, 5, 5, 'En_proceso', 'Aprobada', FALSE, FALSE, FALSE, FALSE);

-- ============================================
-- Índices adicionales para optimización
-- ============================================
CREATE INDEX idx_solicitud_solicitante_estado ON solicitudes(solicitante_id, estado);
CREATE INDEX idx_adopcion_mascota_estado ON adopciones(mascota_id, estado);
CREATE INDEX idx_adopcion_fecha_rango ON adopciones(fecha_adopcion, estado);

-- ============================================
-- Consultas útiles para verificación
-- ============================================
-- SELECT * FROM mascotas;
-- SELECT * FROM solicitantes;
-- SELECT * FROM solicitudes;
-- SELECT * FROM adopciones;
-- SELECT COUNT(*) as total_mascotas FROM mascotas;
-- SELECT COUNT(*) as solicitudes_pendientes FROM solicitudes WHERE estado = 'Pendiente';
-- SELECT COUNT(*) as adopciones_completadas FROM adopciones WHERE estado = 'Completada';



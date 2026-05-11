-- ============================================
-- INICIALIZACIÓN COMPLETA - BASE DE DATOS
-- Sistema Integral de Adopción de Mascotas
-- Todos los scripts consolidados en uno
-- Orden: Schema + Datos + Migrations V2, V3, V4
-- ============================================

USE adopciones_db;

-- ============================================
-- PARTE 1: CREAR TABLAS PRINCIPALES (schema-mysql.sql)
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
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_estado (estado),
    INDEX idx_tipo (tipo),
    INDEX idx_genero (genero),
    INDEX idx_mascota_estado_mascota (estado_mascota),
    INDEX idx_mascota_tipo_estado_mascota (tipo, estado_mascota)
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
-- PARTE 2: INSERTAR DATOS DE EJEMPLO (init-database.sql)
-- ============================================

INSERT INTO mascotas (nombre, tipo, raza, edad, genero, color, peso_kg, descripcion, estado, estado_mascota) VALUES
('Buddy', 'Perro', 'Golden Retriever', 3, 'Macho', 'Dorado', 32.5, 'Perro muy sociable y cariñoso, perfecto para familias con niños. Le encanta jugar y es muy inteligente.', 'Disponible', 'Disponible'),
('Luna', 'Gato', 'Persa', 2, 'Hembra', 'Blanco', 4.2, 'Gata elegante y tranquila. Ama las caricias y es muy independiente. Ideal para apartamentos.', 'Disponible', 'Disponible'),
('Max', 'Perro', 'Pastor Alemán', 5, 'Macho', 'Negro y Marrón', 35.0, 'Perro obediente y leal. Requiere actividad física regular. Excelente como mascota de familia.', 'Disponible', 'Disponible'),
('Mimi', 'Gato', 'Siamés', 1, 'Hembra', 'Blanco y Marrón', 3.5, 'Gatita juguetona y curiosa. Muy vocal y expresiva. Le encanta interactuar con sus dueños.', 'Disponible', 'Disponible'),
('Charlie', 'Perro', 'Bulldog Francés', 4, 'Macho', 'Atigrado', 13.0, 'Pequeño pero con mucha personalidad. Cariñoso y divertido. Perfecto para espacios pequeños.', 'Disponible', 'Disponible'),
('Bella', 'Perro', 'Labrador Retriever', 6, 'Hembra', 'Negro', 32.0, 'Perra tranquila y afectuosa. Adora a los niños. Excelente temperamento.', 'En proceso', 'Disponible'),
('Tiger', 'Gato', 'Atigrado', 3, 'Macho', 'Naranja y Negro', 5.0, 'Gato activo y cazador. Muy ágil. Necesita espacio para moverse.', 'Disponible', 'Disponible'),
('Daisy', 'Conejo', 'Orejas Caídas', 2, 'Hembra', 'Blanco', 2.0, 'Coneja dulce y sociable. Se lleva bien con otros animales.', 'Disponible', 'Disponible'),
('Oscar', 'Perro', 'Cocker Spaniel', 4, 'Macho', 'Marrón', 28.0, 'Perro energético y amigable. Adora el agua. Requiere ejercicio regular.', 'Disponible', 'Disponible'),
('Whiskers', 'Gato', 'Mestizo', 7, 'Macho', 'Gris', 4.8, 'Gato adulto, tranquilo y cariñoso. Perfecto para jubilados o personas sedentarias.', 'Adoptado', 'Disponible');

-- ⚠️ IMPORTANTE: Crear solicitantes DESPUÉS de usuarios
-- Los emails deben coincidir exactamente con la tabla usuarios
INSERT IGNORE INTO solicitantes (nombre, apellido, email, telefono, direccion, ciudad, documento_identidad, tipo_documento, fecha_nacimiento, estado) VALUES
('Carlos', 'García', 'carlos.garcia@email.com', '3001234567', 'Calle 10 #45-67', 'Bogotá', '1234567890', 'CC', '1985-03-15', 'Activo'),
('María', 'López', 'maria.lopez@email.com', '3107654321', 'Carrera 5 #78-90', 'Medellín', '9876543210', 'CC', '1990-07-22', 'Activo'),
('Juan', 'Rodríguez', 'juan.rodriguez@email.com', '3152468135', 'Avenida Central #123', 'Cali', '5555666677', 'CC', '1980-11-10', 'Activo'),
('Ana', 'Martínez', 'ana.martinez@email.com', '3013579246', 'Calle 1 #1-1', 'Barranquilla', '1111222233', 'CC', '1992-01-05', 'Activo'),
('Pedro', 'Sánchez', 'pedro.sanchez@email.com', '3009876543', 'Carrera 20 #50-100', 'Bogotá', '4444555566', 'CC', '1988-06-18', 'Activo');

INSERT INTO solicitudes (solicitante_id, mascota_id, estado, motivo, numero_mascotas, tipo_vivienda, tiene_jardin, requiere_visita_hogar) VALUES
(1, 1, 'Pendiente', 'Quiero un compañero leal para mi familia', 0, 'Casa', TRUE, FALSE),
(2, 2, 'Aprobada', 'Me encanta los gatos, tengo experiencia con ellos', 1, 'Apartamento', FALSE, FALSE),
(3, 3, 'Pendiente', 'Necesito un perro que me acompañe en mis salidas', 2, 'Casa', TRUE, TRUE),
(4, 4, 'Rechazada', 'Primera vez adoptando', 1, 'Apartamento', FALSE, FALSE),
(5, 5, 'Aprobada', 'Tengo espacio en mi casa para un perro pequeño', 0, 'Casa', TRUE, FALSE);

INSERT INTO adopciones (solicitante_id, mascota_id, solicitud_id, estado, resultado_visita, contrato_firmado, vacunas_aplicadas, desparasitacion, microchip_colocado) VALUES
(2, 2, 2, 'Completada', 'Aprobada', TRUE, TRUE, TRUE, TRUE),
(5, 5, 5, 'En_proceso', 'Aprobada', FALSE, FALSE, FALSE, FALSE);

CREATE INDEX idx_solicitud_solicitante_estado ON solicitudes(solicitante_id, estado);
CREATE INDEX idx_adopcion_mascota_estado ON adopciones(mascota_id, estado);
CREATE INDEX idx_adopcion_fecha_rango ON adopciones(fecha_adopcion, estado);

-- ============================================
-- PARTE 3: MIGRACIONES (V2, V3, V4)
-- ============================================

-- V2: Estados de Solicitud y campos adicionales
UPDATE solicitudes
SET estado = 'En revisión'
WHERE estado = 'Pendiente' AND fecha_solicitud > DATE_SUB(NOW(), INTERVAL 7 DAY);

CREATE INDEX idx_solicitud_solicitante_estado_fecha
ON solicitudes(solicitante_id, estado, fecha_solicitud);

-- estado_mascota ya fue agregado durante la creación de la tabla mascotas

-- V3: Compatibilidad de Mascotas
ALTER TABLE mascotas ADD COLUMN compatible_ninos BOOLEAN DEFAULT true;
ALTER TABLE mascotas ADD COLUMN compatible_gatos BOOLEAN DEFAULT true;
ALTER TABLE mascotas ADD COLUMN compatible_perros BOOLEAN DEFAULT true;
ALTER TABLE mascotas ADD COLUMN energia_nivel VARCHAR(20) DEFAULT 'Media';
ALTER TABLE mascotas ADD COLUMN tamano_requerido VARCHAR(20) DEFAULT 'Mediano';
ALTER TABLE mascotas ADD COLUMN requisitos_especiales VARCHAR(500);
ALTER TABLE mascotas ADD COLUMN edad_minima_ninos INT DEFAULT 5;
ALTER TABLE mascotas ADD COLUMN es_hipoalergenico BOOLEAN DEFAULT false;
ALTER TABLE mascotas ADD COLUMN necesita_patio BOOLEAN DEFAULT false;

CREATE INDEX idx_compatibilidad ON mascotas(compatible_ninos, compatible_gatos, compatible_perros);
CREATE INDEX idx_energia ON mascotas(energia_nivel);
CREATE INDEX idx_tamano ON mascotas(tamano_requerido);

-- V4: Tabla de Usuarios
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
    INDEX idx_documento (documento_identidad)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO usuarios (email, password, nombre, estado, rol, documento_identidad)
VALUES ('admin@pawshome.com', 'admin123', 'Administrador Sistema', 'ACTIVO', 'ADMIN', '0000000001')
ON DUPLICATE KEY UPDATE email=VALUES(email);

INSERT INTO usuarios (email, password, nombre, estado, rol, documento_identidad)
VALUES
('carlos.garcia@email.com', 'password123', 'Carlos García', 'ACTIVO', 'SOLICITANTE', '1234567890'),
('maria.lopez@email.com', 'password123', 'María López', 'ACTIVO', 'SOLICITANTE', '9876543210'),
('juan.rodriguez@email.com', 'password123', 'Juan Rodríguez', 'ACTIVO', 'SOLICITANTE', '5555666677'),
('ana.martinez@email.com', 'password123', 'Ana Martínez', 'ACTIVO', 'SOLICITANTE', '1111222233'),
('pedro.sanchez@email.com', 'password123', 'Pedro Sánchez', 'ACTIVO', 'SOLICITANTE', '4444555566')
ON DUPLICATE KEY UPDATE email=VALUES(email);

INSERT INTO usuarios (email, password, nombre, estado, rol, documento_identidad)
VALUES ('staff@pawshome.com', 'staff123', 'Personal Refugio', 'ACTIVO', 'STAFF', '0000000002')
ON DUPLICATE KEY UPDATE email=VALUES(email);

CREATE INDEX idx_usuario_estado_rol ON usuarios(estado, rol);
CREATE INDEX idx_usuario_fecha_creacion ON usuarios(fecha_creacion);

-- ============================================
-- FINAL: Verificación
-- ============================================
SELECT COUNT(*) as total_mascotas FROM mascotas;
SELECT COUNT(*) as total_usuarios FROM usuarios;
SELECT COUNT(*) as total_solicitantes FROM solicitantes;
SELECT COUNT(*) as total_adopciones FROM adopciones;


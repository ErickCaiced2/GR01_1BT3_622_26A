-- ============================================
-- Script de inicialización de Base de Datos
-- Sistema de Adopciones
-- ============================================

-- Crear tabla de Mascotas
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
    fecha_registro DATE DEFAULT CURDATE(),
    estado VARCHAR(50) DEFAULT 'Disponible',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_estado (estado),
    INDEX idx_tipo (tipo),
    INDEX idx_genero (genero)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Crear tabla de Fotos
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
-- Datos de ejemplo
-- ============================================

-- Insertar mascotas de ejemplo
INSERT INTO mascotas (nombre, tipo, raza, edad, genero, color, peso_kg, descripcion, estado) VALUES
('Buddy', 'Perro', 'Golden Retriever', 3, 'Macho', 'Dorado', 32.5,
'Perro muy sociable y cariñoso, perfecto para familias con niños. Le encanta jugar y es muy inteligente.',
'Disponible'),

('Luna', 'Gato', 'Persa', 2, 'Hembra', 'Blanco', 4.2,
'Gata elegante y tranquila. Ama las caricias y es muy independiente. Ideal para apartamentos.',
'Disponible'),

('Max', 'Perro', 'Pastor Alemán', 5, 'Macho', 'Negro y Marrón', 35.0,
'Perro obediente y leal. Requiere actividad física regular. Excelente como mascota de familia.',
'Disponible'),

('Mimi', 'Gato', 'Siamés', 1, 'Hembra', 'Blanco y Marrón', 3.5,
'Gatita juguetona y curiosa. Muy vocal y expresiva. Le encanta interactuar con sus dueños.',
'Disponible'),

('Charlie', 'Perro', 'Bulldog Francés', 4, 'Macho', 'Atigrado', 13.0,
'Pequeño pero con mucha personalidad. Cariñoso y divertido. Perfecto para espacios pequeños.',
'Disponible'),

('Bella', 'Perro', 'Labrador Retriever', 6, 'Hembra', 'Negro', 32.0,
'Perra tranquila y afectuosa. Adora a los niños. Excelente temperamento.',
'En proceso'),

('Tiger', 'Gato', 'Atigrado', 3, 'Macho', 'Naranja y Negro', 5.0,
'Gato activo y cazador. Muy ágil. Necesita espacio para moverse.',
'Disponible'),

('Daisy', 'Conejo', 'Orejas Caídas', 2, 'Hembra', 'Blanco', 2.0,
'Coneja dulce y sociable. Se lleva bien con otros animales.',
'Disponible'),

('Oscar', 'Perro', 'Cocker Spaniel', 4, 'Macho', 'Marrón', 28.0,
'Perro energético y amigable. Adora el agua. Requiere ejercicio regular.',
'Disponible'),

('Whiskers', 'Gato', 'Mestizo', 7, 'Macho', 'Gris', 4.8,
'Gato adulto, tranquilo y cariñoso. Perfecto para jubilados o personas sedentarias.',
'Adoptado');

-- ============================================
-- Consultas útiles para verificación
-- ============================================

-- Ver todas las mascotas
-- SELECT * FROM mascotas;

-- Ver mascotas disponibles
-- SELECT * FROM mascotas WHERE estado = 'Disponible' ORDER BY fecha_registro DESC;

-- Ver mascotas por tipo
-- SELECT * FROM mascotas WHERE tipo = 'Perro' ORDER BY nombre;

-- Contar mascotas por estado
-- SELECT estado, COUNT(*) as total FROM mascotas GROUP BY estado;

-- Mascotas más nuevas
-- SELECT nombre, tipo, fecha_registro FROM mascotas ORDER BY fecha_registro DESC LIMIT 5;


-- ============================================
-- PARTE 2: DATOS DE EJEMPLO
-- Sistema Integral de Adopción de Mascotas
-- Ejecutar MANUALMENTE después de 01-schema.sql
-- ============================================

USE adopciones_db;

-- ============================================
-- CREAR USUARIOS (PRIMERO - necesario antes de solicitantes)
-- ============================================

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

-- ============================================
-- INSERTAR MASCOTAS
-- ============================================

INSERT INTO mascotas (nombre, tipo, raza, edad, genero, color, peso_kg, descripcion, estado, estado_mascota, compatible_ninos, compatible_gatos, compatible_perros, energia_nivel) VALUES
('Buddy', 'Perro', 'Golden Retriever', 3, 'Macho', 'Dorado', 32.5, 'Perro muy sociable y cariñoso, perfecto para familias con niños. Le encanta jugar y es muy inteligente.', 'Disponible', 'Disponible', true, true, true, 'Media'),
('Luna', 'Gato', 'Persa', 2, 'Hembra', 'Blanco', 4.2, 'Gata elegante y tranquila. Ama las caricias y es muy independiente. Ideal para apartamentos.', 'Disponible', 'Disponible', true, true, false, 'Baja'),
('Max', 'Perro', 'Pastor Alemán', 5, 'Macho', 'Negro y Marrón', 35.0, 'Perro obediente y leal. Requiere actividad física regular. Excelente como mascota de familia.', 'Disponible', 'Disponible', false, false, true, 'Alta'),
('Mimi', 'Gato', 'Siamés', 1, 'Hembra', 'Blanco y Marrón', 3.5, 'Gatita juguetona y curiosa. Muy vocal y expresiva. Le encanta interactuar con sus dueños.', 'Disponible', 'Disponible', true, true, false, 'Media'),
('Charlie', 'Perro', 'Bulldog Francés', 4, 'Macho', 'Atigrado', 13.0, 'Pequeño pero con mucha personalidad. Cariñoso y divertido. Perfecto para espacios pequeños.', 'Disponible', 'Disponible', true, true, true, 'Baja'),
('Bella', 'Perro', 'Labrador Retriever', 6, 'Hembra', 'Negro', 32.0, 'Perra tranquila y afectuosa. Adora a los niños. Excelente temperamento.', 'En proceso', 'Disponible', true, true, true, 'Media'),
('Tiger', 'Gato', 'Atigrado', 3, 'Macho', 'Naranja y Negro', 5.0, 'Gato activo y cazador. Muy ágil. Necesita espacio para moverse.', 'Disponible', 'Disponible', false, true, false, 'Alta'),
('Daisy', 'Conejo', 'Orejas Caídas', 2, 'Hembra', 'Blanco', 2.0, 'Coneja dulce y sociable. Se lleva bien con otros animales.', 'Disponible', 'Disponible', true, true, true, 'Media'),
('Oscar', 'Perro', 'Cocker Spaniel', 4, 'Macho', 'Marrón', 28.0, 'Perro energético y amigable. Adora el agua. Requiere ejercicio regular.', 'Disponible', 'Disponible', true, false, true, 'Alta'),
('Whiskers', 'Gato', 'Mestizo', 7, 'Macho', 'Gris', 4.8, 'Gato adulto, tranquilo y cariñoso. Perfecto para jubilados o personas sedentarias.', 'Adoptado', 'Disponible', true, true, false, 'Baja');

-- ============================================
-- INSERTAR SOLICITANTES
-- ============================================

INSERT IGNORE INTO solicitantes (nombre, apellido, email, telefono, direccion, ciudad, documento_identidad, tipo_documento, fecha_nacimiento, estado) VALUES
('Carlos', 'García', 'carlos.garcia@email.com', '3001234567', 'Calle 10 #45-67', 'Bogotá', '1234567890', 'CC', '1985-03-15', 'Activo'),
('María', 'López', 'maria.lopez@email.com', '3107654321', 'Carrera 5 #78-90', 'Medellín', '9876543210', 'CC', '1990-07-22', 'Activo'),
('Juan', 'Rodríguez', 'juan.rodriguez@email.com', '3152468135', 'Avenida Central #123', 'Cali', '5555666677', 'CC', '1980-11-10', 'Activo'),
('Ana', 'Martínez', 'ana.martinez@email.com', '3013579246', 'Calle 1 #1-1', 'Barranquilla', '1111222233', 'CC', '1992-01-05', 'Activo'),
('Pedro', 'Sánchez', 'pedro.sanchez@email.com', '3009876543', 'Carrera 20 #50-100', 'Bogotá', '4444555566', 'CC', '1988-06-18', 'Activo');

-- ============================================
-- INSERTAR SOLICITUDES
-- ============================================

INSERT INTO solicitudes (solicitante_id, mascota_id, estado, motivo, numero_mascotas, tipo_vivienda, tiene_jardin, requiere_visita_hogar) VALUES
(1, 1, 'Pendiente', 'Quiero un compañero leal para mi familia', 0, 'Casa', TRUE, FALSE),
(2, 2, 'Aprobada', 'Me encanta los gatos, tengo experiencia con ellos', 1, 'Apartamento', FALSE, FALSE),
(3, 3, 'Pendiente', 'Necesito un perro que me acompañe en mis salidas', 2, 'Casa', TRUE, TRUE),
(4, 4, 'Rechazada', 'Primera vez adoptando', 1, 'Apartamento', FALSE, FALSE),
(5, 5, 'Aprobada', 'Tengo espacio en mi casa para un perro pequeño', 0, 'Casa', TRUE, FALSE);

-- ============================================
-- INSERTAR ADOPCIONES
-- ============================================

INSERT INTO adopciones (solicitante_id, mascota_id, solicitud_id, estado, resultado_visita, contrato_firmado, vacunas_aplicadas, desparasitacion, microchip_colocado) VALUES
(2, 2, 2, 'Completada', 'Aprobada', TRUE, TRUE, TRUE, TRUE),
(5, 5, 5, 'En_proceso', 'Aprobada', FALSE, FALSE, FALSE, FALSE);

-- ============================================
-- RESUMEN FINAL
-- ============================================

SELECT
    (SELECT COUNT(*) FROM usuarios) as total_usuarios,
    (SELECT COUNT(*) FROM mascotas) as total_mascotas,
    (SELECT COUNT(*) FROM solicitantes) as total_solicitantes,
    (SELECT COUNT(*) FROM solicitudes) as total_solicitudes,
    (SELECT COUNT(*) FROM adopciones) as total_adopciones;


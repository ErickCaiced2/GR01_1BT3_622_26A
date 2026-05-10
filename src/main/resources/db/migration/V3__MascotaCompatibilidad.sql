-- T.4.1 - Agregar Campos de Compatibilidad en BD
ALTER TABLE mascotas ADD COLUMN compatible_ninos BOOLEAN DEFAULT true;
ALTER TABLE mascotas ADD COLUMN compatible_gatos BOOLEAN DEFAULT true;
ALTER TABLE mascotas ADD COLUMN compatible_perros BOOLEAN DEFAULT true;
ALTER TABLE mascotas ADD COLUMN energia_nivel VARCHAR(20) DEFAULT 'Media';
ALTER TABLE mascotas ADD COLUMN tamaño_requerido VARCHAR(20) DEFAULT 'Mediano';
ALTER TABLE mascotas ADD COLUMN requisitos_especiales VARCHAR(500);
ALTER TABLE mascotas ADD COLUMN edad_minima_ninos INT DEFAULT 5;
ALTER TABLE mascotas ADD COLUMN es_hipoalergenico BOOLEAN DEFAULT false;
ALTER TABLE mascotas ADD COLUMN necesita_patio BOOLEAN DEFAULT false;

CREATE INDEX idx_compatibilidad ON mascotas(compatible_ninos, compatible_gatos, compatible_perros);
CREATE INDEX idx_energia ON mascotas(energia_nivel);
CREATE INDEX idx_tamaño ON mascotas(tamaño_requerido);

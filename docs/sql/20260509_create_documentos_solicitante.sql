-- T.2.1: Migracion tabla documentos_solicitante
-- Fecha: 2026-05-09
-- noinspection SqlNoDataSourceInspection
-- noinspection SqlDialectInspection

CREATE TABLE documentos_solicitante (
    id                      BIGINT PRIMARY KEY AUTO_INCREMENT,
    solicitante_id          BIGINT NOT NULL,
    tipo_documento          VARCHAR(50) NOT NULL,
    ruta_archivo            VARCHAR(500) NOT NULL,
    nombre_archivo          VARCHAR(255) NOT NULL,
    estado_verificacion     VARCHAR(50) DEFAULT 'Pendiente',
    fecha_carga             TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_verificacion      TIMESTAMP,
    comentarios_verificador VARCHAR(1000),
    hash_documento          VARCHAR(255),
    FOREIGN KEY (solicitante_id) REFERENCES solicitantes(id)
);

CREATE INDEX idx_solicitante_tipo ON documentos_solicitante (solicitante_id, tipo_documento);
CREATE INDEX idx_estado_verificacion ON documentos_solicitante (estado_verificacion);

-- Script SQL para crear la base de datos del sistema de grupos
CREATE DATABASE IF NOT EXISTS sistema_peti;
USE sistema_peti;

-- Tabla de usuarios
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE
);

-- Tabla de grupos
CREATE TABLE grupos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(10) NOT NULL UNIQUE,
    limite_usuarios INT NOT NULL DEFAULT 10,
    admin_id INT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (admin_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Tabla de relación miembros-grupos
CREATE TABLE miembros_grupo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    grupo_id INT NOT NULL,
    rol ENUM('admin', 'miembro') DEFAULT 'miembro',
    fecha_union TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (grupo_id) REFERENCES grupos(id) ON DELETE CASCADE,
    UNIQUE KEY unique_usuario_grupo (usuario_id, grupo_id)
);

-- Índices para mejorar el rendimiento
CREATE INDEX idx_usuarios_username ON usuarios(username);
CREATE INDEX idx_grupos_codigo ON grupos(codigo);
CREATE INDEX idx_miembros_usuario ON miembros_grupo(usuario_id);
CREATE INDEX idx_miembros_grupo ON miembros_grupo(grupo_id);

-- Insertar algunos usuarios de prueba
INSERT INTO usuarios (username, password, email) VALUES
('admin', '123', 'admin@test.com'),
('usuario1', 'pass1', 'usuario1@test.com'),
('usuario2', 'pass2', 'usuario2@test.com'),
('test', 'test', 'test@test.com'),
('demo', 'demo', 'demo@test.com');

-- Crear un grupo de ejemplo
INSERT INTO grupos (nombre, codigo, limite_usuarios, admin_id) VALUES
('Grupo Demo', 'ABC123', 5, 1);

-- Agregar el admin al grupo
INSERT INTO miembros_grupo (usuario_id, grupo_id, rol) VALUES
(1, 1, 'admin');

-- Vistas útiles para consultas
CREATE VIEW vista_grupos_completa AS
SELECT
    g.id as grupo_id,
    g.nombre as grupo_nombre,
    g.codigo as grupo_codigo,
    g.limite_usuarios,
    g.fecha_creacion,
    u.username as admin_username,
    COUNT(mg.usuario_id) as total_miembros
FROM grupos g
JOIN usuarios u ON g.admin_id = u.id
LEFT JOIN miembros_grupo mg ON g.id = mg.grupo_id
WHERE g.activo = TRUE
GROUP BY g.id, g.nombre, g.codigo, g.limite_usuarios, g.fecha_creacion, u.username;

CREATE VIEW vista_miembros_grupo AS
SELECT
    mg.id,
    u.username,
    g.nombre as grupo_nombre,
    g.codigo as grupo_codigo,
    mg.rol,
    mg.fecha_union
FROM miembros_grupo mg
JOIN usuarios u ON mg.usuario_id = u.id
JOIN grupos g ON mg.grupo_id = g.id
WHERE g.activo = TRUE AND u.activo = TRUE;

-- Procedimientos almacenados útiles
DELIMITER //

-- Procedimiento para crear un grupo
CREATE PROCEDURE CrearGrupo(
    IN p_nombre VARCHAR(100),
    IN p_codigo VARCHAR(10),
    IN p_limite INT,
    IN p_admin_id INT
)
BEGIN
    DECLARE grupo_id INT;
    
    -- Insertar el grupo
    INSERT INTO grupos (nombre, codigo, limite_usuarios, admin_id)
    VALUES (p_nombre, p_codigo, p_limite, p_admin_id);
    
    SET grupo_id = LAST_INSERT_ID();
    
    -- Agregar el admin como miembro
    INSERT INTO miembros_grupo (usuario_id, grupo_id, rol)
    VALUES (p_admin_id, grupo_id, 'admin');
    
    SELECT grupo_id as id;
END //

-- Procedimiento para unirse a un grupo
CREATE PROCEDURE UnirseGrupo(
    IN p_usuario_id INT,
    IN p_codigo VARCHAR(10)
)
BEGIN
    DECLARE grupo_id INT;
    DECLARE limite INT;
    DECLARE total_miembros INT;
    DECLARE ya_miembro INT DEFAULT 0;
    
    -- Buscar el grupo por código
    SELECT id, limite_usuarios INTO grupo_id, limite
    FROM grupos
    WHERE codigo = p_codigo AND activo = TRUE;
    
    IF grupo_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Grupo no encontrado';
    END IF;
    
    -- Verificar si ya es miembro
    SELECT COUNT(*) INTO ya_miembro
    FROM miembros_grupo
    WHERE usuario_id = p_usuario_id AND grupo_id = grupo_id;
    
    IF ya_miembro > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya es miembro del grupo';
    END IF;
    
    -- Contar miembros actuales
    SELECT COUNT(*) INTO total_miembros
    FROM miembros_grupo
    WHERE grupo_id = grupo_id;
    
    IF total_miembros >= limite THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Grupo lleno';
    END IF;
    
    -- Agregar al usuario al grupo
    INSERT INTO miembros_grupo (usuario_id, grupo_id, rol)
    VALUES (p_usuario_id, grupo_id, 'miembro');
    
    SELECT 'Unido exitosamente' as mensaje;
END //

DELIMITER ;

SHOW TABLES;
DESCRIBE usuarios;
DESCRIBE grupos;
DESCRIBE miembros_grupo;
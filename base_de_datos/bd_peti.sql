-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         10.4.32-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para sistema_peti
CREATE DATABASE IF NOT EXISTS `sistema_peti` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `sistema_peti`;

-- Volcando estructura para procedimiento sistema_peti.CrearGrupo
DELIMITER //
CREATE PROCEDURE `CrearGrupo`(
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
END//
DELIMITER ;

-- Volcando estructura para tabla sistema_peti.grupos
CREATE TABLE IF NOT EXISTS `grupos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `codigo` varchar(10) NOT NULL,
  `limite_usuarios` int(11) NOT NULL DEFAULT 10,
  `admin_id` int(11) NOT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `activo` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`),
  KEY `admin_id` (`admin_id`),
  KEY `idx_grupos_codigo` (`codigo`),
  CONSTRAINT `grupos_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla sistema_peti.grupos: ~2 rows (aproximadamente)
INSERT INTO `grupos` (`id`, `nombre`, `codigo`, `limite_usuarios`, `admin_id`, `fecha_creacion`, `activo`) VALUES
	(5, 'dsad', 'VARCVZ', 5, 8, '2025-09-17 04:59:45', 1),
	(6, 'patito', 'JC11DD', 5, 8, '2025-09-17 04:59:57', 1);

-- Volcando estructura para tabla sistema_peti.miembros_grupo
CREATE TABLE IF NOT EXISTS `miembros_grupo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) NOT NULL,
  `grupo_id` int(11) NOT NULL,
  `rol` enum('admin','miembro') DEFAULT 'miembro',
  `fecha_union` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_usuario_grupo` (`usuario_id`,`grupo_id`),
  KEY `idx_miembros_usuario` (`usuario_id`),
  KEY `idx_miembros_grupo` (`grupo_id`),
  CONSTRAINT `miembros_grupo_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  CONSTRAINT `miembros_grupo_ibfk_2` FOREIGN KEY (`grupo_id`) REFERENCES `grupos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla sistema_peti.miembros_grupo: ~1 rows (aproximadamente)
INSERT INTO `miembros_grupo` (`id`, `usuario_id`, `grupo_id`, `rol`, `fecha_union`) VALUES
	(9, 8, 6, 'admin', '2025-09-17 04:59:57'),
	(10, 9, 6, 'miembro', '2025-09-17 05:09:33');

-- Volcando estructura para procedimiento sistema_peti.UnirseGrupo
DELIMITER //
CREATE PROCEDURE `UnirseGrupo`(
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
END//
DELIMITER ;

-- Volcando estructura para tabla sistema_peti.usuarios
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  `activo` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `idx_usuarios_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla sistema_peti.usuarios: ~9 rows (aproximadamente)
INSERT INTO `usuarios` (`id`, `username`, `password`, `email`, `fecha_registro`, `activo`) VALUES
	(1, 'admin', '123', 'admin@test.com', '2025-09-16 04:40:11', 1),
	(2, 'usuario1', 'pass1', 'usuario1@test.com', '2025-09-16 04:40:11', 1),
	(3, 'usuario2', 'pass2', 'usuario2@test.com', '2025-09-16 04:40:11', 1),
	(4, 'test', 'test', 'test@test.com', '2025-09-16 04:40:11', 1),
	(5, 'demo', 'demo', 'demo@test.com', '2025-09-16 04:40:11', 1),
	(6, 'gaaaaa', '12320', 'diego@upt.pe', '2025-09-16 05:06:54', 1),
	(7, 'xddd', '123', 'usuario@ejemplo.com', '2025-09-16 05:09:38', 1),
	(8, 'diego', '123', 'diecastillom@upt.pe', '2025-09-17 04:52:51', 1),
	(9, 'carlos', '123', 'dc2022073895@virtual.upt.pe', '2025-09-17 04:53:21', 1);

-- Volcando estructura para vista sistema_peti.vista_grupos_completa
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `vista_grupos_completa` (
	`grupo_id` INT(11) NOT NULL,
	`grupo_nombre` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_general_ci',
	`grupo_codigo` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_general_ci',
	`limite_usuarios` INT(11) NOT NULL,
	`fecha_creacion` TIMESTAMP NOT NULL,
	`admin_username` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_general_ci',
	`total_miembros` BIGINT(21) NOT NULL
) ENGINE=MyISAM;

-- Volcando estructura para vista sistema_peti.vista_miembros_grupo
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `vista_miembros_grupo` (
	`id` INT(11) NOT NULL,
	`username` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_general_ci',
	`grupo_nombre` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_general_ci',
	`grupo_codigo` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_general_ci',
	`rol` ENUM('admin','miembro') NULL COLLATE 'utf8mb4_general_ci',
	`fecha_union` TIMESTAMP NOT NULL
) ENGINE=MyISAM;

-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `vista_grupos_completa`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vista_grupos_completa` AS SELECT 
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
GROUP BY g.id, g.nombre, g.codigo, g.limite_usuarios, g.fecha_creacion, u.username ;

-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `vista_miembros_grupo`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vista_miembros_grupo` AS SELECT 
    mg.id,
    u.username,
    g.nombre as grupo_nombre,
    g.codigo as grupo_codigo,
    mg.rol,
    mg.fecha_union
FROM miembros_grupo mg
JOIN usuarios u ON mg.usuario_id = u.id
JOIN grupos g ON mg.grupo_id = g.id
WHERE g.activo = TRUE AND u.activo = TRUE ;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;

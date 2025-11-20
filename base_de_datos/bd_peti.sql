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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla sistema_peti.grupos: ~5 rows (aproximadamente)
INSERT INTO `grupos` (`id`, `nombre`, `codigo`, `limite_usuarios`, `admin_id`, `fecha_creacion`, `activo`) VALUES
	(5, 'dsad', 'VARCVZ', 5, 8, '2025-09-17 04:59:45', 1),
	(6, 'patito', 'JC11DD', 5, 8, '2025-09-17 04:59:57', 1),
	(7, 'gatitos', '08MMLW', 5, 10, '2025-09-29 14:15:11', 1),
	(8, 'JC11DD', 'UWYG41', 5, 11, '2025-10-06 04:18:18', 1),
	(9, 'los galacticos', '46DUXR', 5, 11, '2025-10-06 04:20:08', 1),
	(10, 'los gays', '3A7CKO', 5, 12, '2025-10-06 04:46:08', 1);

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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla sistema_peti.miembros_grupo: ~6 rows (aproximadamente)
INSERT INTO `miembros_grupo` (`id`, `usuario_id`, `grupo_id`, `rol`, `fecha_union`) VALUES
	(9, 8, 6, 'admin', '2025-09-17 04:59:57'),
	(15, 11, 9, 'admin', '2025-10-06 04:20:08'),
	(16, 10, 9, 'miembro', '2025-10-06 04:20:31'),
	(17, 9, 9, 'miembro', '2025-10-06 04:22:01'),
	(18, 12, 10, 'admin', '2025-10-06 04:46:08'),
	(19, 11, 10, 'miembro', '2025-10-06 04:48:46'),
	(20, 8, 7, 'miembro', '2025-10-09 03:56:23'),
	(21, 10, 7, 'miembro', '2025-10-15 03:45:53');

-- Volcando estructura para tabla sistema_peti.peti_datos
CREATE TABLE IF NOT EXISTS `peti_datos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `grupo_id` int(11) NOT NULL,
  `seccion` varchar(50) NOT NULL,
  `campo` varchar(100) NOT NULL,
  `valor` text DEFAULT NULL,
  `usuario_modificacion` int(11) DEFAULT NULL,
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `version` int(11) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_grupo_seccion_campo` (`grupo_id`,`seccion`,`campo`),
  KEY `idx_peti_grupo` (`grupo_id`),
  KEY `idx_peti_seccion` (`seccion`),
  KEY `idx_peti_usuario` (`usuario_modificacion`),
  CONSTRAINT `peti_datos_ibfk_1` FOREIGN KEY (`grupo_id`) REFERENCES `grupos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `peti_datos_ibfk_2` FOREIGN KEY (`usuario_modificacion`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3054 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla sistema_peti.peti_datos: ~56 rows (aproximadamente)
INSERT INTO `peti_datos` (`id`, `grupo_id`, `seccion`, `campo`, `valor`, `usuario_modificacion`, `fecha_modificacion`, `version`) VALUES
	(2788, 7, 'bcg', 'nombres_productos', '{"nombre_producto1":"Producto 1","nombre_producto2":"Producto 2","nombre_producto3":"Producto 3","nombre_producto4":"Producto 4","nombre_producto5":"Producto 5"}', 8, '2025-11-20 04:42:56', 2),
	(2789, 7, 'bcg', 'periodos', '{"periodo1":"2012 - 2013","periodo2":"2013 - 2014","periodo3":"2014 - 2015","periodo4":"2015 - 2016","periodo5":"2016 - 2017","anio1":"2012","anio2":"2013","anio3":"2014","anio4":"2015","anio5":"2016","anio6":"2017"}', 8, '2025-11-20 04:42:56', 2),
	(2790, 7, 'bcg', 'ventas', '{"producto1":"0","producto2":"0","producto3":"0","producto4":"0","producto5":"0"}', 8, '2025-11-20 04:42:57', 2),
	(2791, 7, 'bcg', 'tcm', '{"tcm1_1":"0","tcm1_2":"0","tcm1_3":"0","tcm1_4":"0","tcm1_5":"0","tcm2_1":"0","tcm2_2":"0","tcm2_3":"0","tcm2_4":"0","tcm2_5":"0","tcm3_1":"0","tcm3_2":"0","tcm3_3":"0","tcm3_4":"0","tcm3_5":"0","tcm4_1":"0","tcm4_2":"0","tcm4_3":"0","tcm4_4":"0","tcm4_5":"0","tcm5_1":"0","tcm5_2":"0","tcm5_3":"0","tcm5_4":"0","tcm5_5":"0"}', 8, '2025-11-20 04:42:57', 2),
	(2792, 7, 'bcg', 'competidores', '{"comp1_1":"0","comp2_1":"0","comp3_1":"0","comp4_1":"0","comp5_1":"0","comp1_2":"0","comp2_2":"0","comp3_2":"0","comp4_2":"0","comp5_2":"0","comp1_3":"0","comp2_3":"0","comp3_3":"0","comp4_3":"0","comp5_3":"0","comp1_4":"0","comp2_4":"0","comp3_4":"0","comp4_4":"0","comp5_4":"0","comp1_5":"0","comp2_5":"0","comp3_5":"0","comp4_5":"0","comp5_5":"0","comp1_6":"0","comp2_6":"0","comp3_6":"0","comp4_6":"0","comp5_6":"0","comp1_7":"0","comp2_7":"0","comp3_7":"0","comp4_7":"0","comp5_7":"0","comp1_8":"0","comp2_8":"0","comp3_8":"0","comp4_8":"0","comp5_8":"0","comp1_9":"0","comp2_9":"0","comp3_9":"0","comp4_9":"0","comp5_9":"0"}', 8, '2025-11-20 04:42:57', 2),
	(2793, 7, 'bcg', 'prm', '{"prm1":"0.000000","prm2":"0.000000","prm3":"0.000000","prm4":"0.000000","prm5":"0.000000"}', 8, '2025-11-20 04:42:57', 2),
	(2794, 7, 'bcg', 'demanda', '{"demanda_2012_1":"0","demanda_2012_2":"0","demanda_2012_3":"0","demanda_2012_4":"0","demanda_2012_5":"0","demanda_2013_1":"0","demanda_2013_2":"0","demanda_2013_3":"0","demanda_2013_4":"0","demanda_2013_5":"0","demanda_2014_1":"0","demanda_2014_2":"0","demanda_2014_3":"0","demanda_2014_4":"0","demanda_2014_5":"0","demanda_2015_1":"0","demanda_2015_2":"0","demanda_2015_3":"0","demanda_2015_4":"0","demanda_2015_5":"0","demanda_2016_1":"0","demanda_2016_2":"0","demanda_2016_3":"0","demanda_2016_4":"0","demanda_2016_5":"0","demanda_2017_1":"0","demanda_2017_2":"0","demanda_2017_3":"0","demanda_2017_4":"0","demanda_2017_5":"0"}', 8, '2025-11-20 04:42:57', 2),
	(2795, 7, 'bcg', 'fortaleza3', 'fuertes', 8, '2025-11-20 04:42:57', 2),
	(2796, 7, 'bcg', 'fortaleza4', 'demasiados fuertes', 8, '2025-11-20 04:42:57', 2),
	(2797, 7, 'bcg', 'debilidad3', 'debiles', 8, '2025-11-20 04:42:57', 2),
	(2798, 7, 'bcg', 'debilidad4', 'demasiado debiles', 8, '2025-11-20 04:42:57', 2),
	(2799, 7, 'cadena_valor', 'fortaleza1', 'somos fuerts', 8, '2025-11-20 04:42:21', 3),
	(2800, 7, 'cadena_valor', 'fortaleza2', 'seremos fuertes', 8, '2025-11-20 04:42:21', 3),
	(2801, 7, 'cadena_valor', 'debilidad1', 'somos debiles', 8, '2025-11-20 04:42:21', 3),
	(2802, 7, 'cadena_valor', 'debilidad2', 'seremos debiles', 8, '2025-11-20 04:42:21', 3),
	(2803, 7, 'porter_analisis', 'oportunidad_1', 'TENGO OPORTUNIDAD', 8, '2025-11-20 04:43:19', 3),
	(2804, 7, 'porter_analisis', 'oportunidad_2', 'TENGO OPORTUNIDAD', 8, '2025-11-20 04:43:19', 3),
	(2805, 7, 'porter_analisis', 'amenaza_1', 'TENGO AMENAZA', 8, '2025-11-20 04:43:19', 3),
	(2806, 7, 'porter_analisis', 'amenaza_2', 'TENGO AMENAZA', 8, '2025-11-20 04:43:19', 3),
	(2807, 7, 'pest_analisis', 'pregunta1', '4', 8, '2025-11-20 04:43:59', 3),
	(2808, 7, 'pest_analisis', 'pregunta2', '3', 8, '2025-11-20 04:43:59', 3),
	(2809, 7, 'pest_analisis', 'pregunta3', '3', 8, '2025-11-20 04:43:59', 3),
	(2810, 7, 'pest_analisis', 'pregunta4', '4', 8, '2025-11-20 04:43:59', 3),
	(2811, 7, 'pest_analisis', 'pregunta5', '4', 8, '2025-11-20 04:43:59', 3),
	(2812, 7, 'pest_analisis', 'pregunta6', '4', 8, '2025-11-20 04:43:59', 3),
	(2813, 7, 'pest_analisis', 'pregunta7', '0', 8, '2025-11-20 04:43:59', 3),
	(2814, 7, 'pest_analisis', 'pregunta8', '0', 8, '2025-11-20 04:43:59', 3),
	(2815, 7, 'pest_analisis', 'pregunta9', '0', 8, '2025-11-20 04:43:59', 3),
	(2816, 7, 'pest_analisis', 'pregunta10', '0', 8, '2025-11-20 04:43:59', 3),
	(2817, 7, 'pest_analisis', 'pregunta11', '0', 8, '2025-11-20 04:43:59', 3),
	(2818, 7, 'pest_analisis', 'pregunta12', '0', 8, '2025-11-20 04:43:59', 3),
	(2819, 7, 'pest_analisis', 'pregunta13', '0', 8, '2025-11-20 04:43:59', 3),
	(2820, 7, 'pest_analisis', 'pregunta14', '0', 8, '2025-11-20 04:43:59', 3),
	(2821, 7, 'pest_analisis', 'pregunta15', '0', 8, '2025-11-20 04:43:59', 3),
	(2822, 7, 'pest_analisis', 'pregunta16', '0', 8, '2025-11-20 04:43:59', 3),
	(2823, 7, 'pest_analisis', 'pregunta17', '4', 8, '2025-11-20 04:43:59', 3),
	(2824, 7, 'pest_analisis', 'pregunta18', '4', 8, '2025-11-20 04:43:59', 3),
	(2825, 7, 'pest_analisis', 'pregunta19', '4', 8, '2025-11-20 04:43:59', 3),
	(2826, 7, 'pest_analisis', 'pregunta20', '4', 8, '2025-11-20 04:43:59', 3),
	(2827, 7, 'pest_analisis', 'pregunta21', '4', 8, '2025-11-20 04:43:59', 3),
	(2828, 7, 'pest_analisis', 'pregunta22', '4', 8, '2025-11-20 04:43:59', 3),
	(2829, 7, 'pest_analisis', 'pregunta23', '4', 8, '2025-11-20 04:43:59', 3),
	(2830, 7, 'pest_analisis', 'pregunta24', '4', 8, '2025-11-20 04:43:59', 3),
	(2831, 7, 'pest_analisis', 'pregunta25', '4', 8, '2025-11-20 04:43:59', 3),
	(2832, 7, 'pest_analisis', 'impacto_sociales', 'SI', 8, '2025-11-20 04:43:59', 3),
	(2833, 7, 'pest_analisis', 'impacto_politicos', 'SI', 8, '2025-11-20 04:43:59', 3),
	(2834, 7, 'pest_analisis', 'impacto_tecnologicos', 'SI', 8, '2025-11-20 04:43:59', 3),
	(2835, 7, 'pest_analisis', 'impacto_medioambiental', 'SI', 8, '2025-11-20 04:43:59', 3),
	(2836, 7, 'pest_analisis', 'oportunidad3', 'la mejor oportunidad', 8, '2025-11-20 04:43:59', 3),
	(2837, 7, 'pest_analisis', 'oportunidad4', 'la mejorcita de mejorcita', 8, '2025-11-20 04:43:59', 3),
	(2838, 7, 'pest_analisis', 'amenaza3', 'la peor oportunidad', 8, '2025-11-20 04:43:59', 3),
	(2839, 7, 'pest_analisis', 'amenaza4', 'la peor de la peores', 8, '2025-11-20 04:43:59', 3),
	(2840, 7, 'identificacion_estrategia', 'puntuaciones_fo', '{"fo_0_0":"0","fo_0_1":"0","fo_0_2":"02","fo_0_3":"0","fo_1_0":"0","fo_1_1":"0","fo_1_2":"02","fo_1_3":"0","fo_2_0":"0","fo_2_1":"0","fo_2_2":"02","fo_2_3":"0","fo_3_0":"0","fo_3_1":"0","fo_3_2":"02","fo_3_3":"0"}', 8, '2025-11-16 23:53:51', 3),
	(2841, 7, 'identificacion_estrategia', 'puntuaciones_fa', '{"fa_0_0":"0","fa_0_1":"4","fa_0_2":"0","fa_0_3":"0","fa_1_0":"0","fa_1_1":"03","fa_1_2":"0","fa_1_3":"0","fa_2_0":"0","fa_2_1":"03","fa_2_2":"0","fa_2_3":"0","fa_3_0":"0","fa_3_1":"03","fa_3_2":"0","fa_3_3":"0"}', 8, '2025-11-16 23:53:51', 3),
	(2842, 7, 'identificacion_estrategia', 'puntuaciones_do', '{"do_0_0":"0","do_0_1":"02","do_0_2":"0","do_0_3":"0","do_1_0":"0","do_1_1":"4","do_1_2":"0","do_1_3":"0","do_2_0":"0","do_2_1":"4","do_2_2":"0","do_2_3":"0","do_3_0":"0","do_3_1":"03","do_3_2":"0","do_3_3":"0"}', 8, '2025-11-16 23:53:51', 3),
	(2843, 7, 'identificacion_estrategia', 'puntuaciones_da', '{"da_0_0":"0","da_0_1":"03","da_0_2":"0","da_0_3":"0","da_1_0":"0","da_1_1":"4","da_1_2":"0","da_1_3":"0","da_2_0":"0","da_2_1":"02","da_2_2":"0","da_2_3":"0","da_3_0":"0","da_3_1":"03","da_3_2":"0","da_3_3":"0"}', 8, '2025-11-16 23:53:51', 3),
	(2852, 7, 'empresa', 'nombre', 'los rufianes', 8, '2025-11-20 04:39:27', 2),
	(2853, 7, 'empresa', 'sector', 'TecnologÃ­a', 8, '2025-11-20 04:39:27', 2),
	(2854, 7, 'empresa', 'ubicacion', 'gaa', 8, '2025-11-20 04:39:27', 2),
	(2855, 7, 'empresa', 'descripcion', 'a', 8, '2025-11-20 04:39:27', 2),
	(2856, 7, 'vision', 'declaracion', 'la vision de los gatos', 8, '2025-11-20 04:40:57', 2),
	(2857, 7, 'objetivos', 'objetivo_general', 'gato', 8, '2025-11-20 04:41:28', 2),
	(2859, 7, 'porter_analisis', 'sustitutivos_disponibilidad', '5', 8, '2025-11-20 04:43:19', 2),
	(2901, 7, 'mision', 'declaracion', 'la mision de los gatos', 8, '2025-11-20 04:40:57', 2),
	(2904, 7, 'valores', 'lista', 'gatos\r\nperros\r\npatitos', 8, '2025-11-20 04:41:09', 1),
	(2906, 7, 'objetivos', 'objetivo1', 'gato1', 8, '2025-11-20 04:41:28', 1),
	(2907, 7, 'objetivos', 'objetivo2', 'gato2', 8, '2025-11-20 04:41:28', 1),
	(2908, 7, 'objetivos', 'objetivo3', 'gato3', 8, '2025-11-20 04:41:28', 1),
	(2909, 7, 'objetivos', 'objetivo4', 'gato4', 8, '2025-11-20 04:41:28', 1),
	(2910, 7, 'cadena_valor', 'afirmacion_1', '2', 8, '2025-11-20 04:42:21', 2),
	(2911, 7, 'cadena_valor', 'afirmacion_2', '2', 8, '2025-11-20 04:42:21', 2),
	(2912, 7, 'cadena_valor', 'afirmacion_3', '2', 8, '2025-11-20 04:42:21', 2),
	(2913, 7, 'cadena_valor', 'afirmacion_4', '2', 8, '2025-11-20 04:42:21', 2),
	(2914, 7, 'cadena_valor', 'afirmacion_5', '4', 8, '2025-11-20 04:42:21', 2),
	(2915, 7, 'cadena_valor', 'afirmacion_6', '4', 8, '2025-11-20 04:42:21', 2),
	(2916, 7, 'cadena_valor', 'afirmacion_7', '4', 8, '2025-11-20 04:42:21', 2),
	(2917, 7, 'cadena_valor', 'afirmacion_8', '4', 8, '2025-11-20 04:42:21', 2),
	(2918, 7, 'cadena_valor', 'afirmacion_9', '4', 8, '2025-11-20 04:42:21', 2),
	(2919, 7, 'cadena_valor', 'afirmacion_10', '4', 8, '2025-11-20 04:42:21', 2),
	(2920, 7, 'cadena_valor', 'afirmacion_11', '4', 8, '2025-11-20 04:42:21', 2),
	(2921, 7, 'cadena_valor', 'afirmacion_12', '4', 8, '2025-11-20 04:42:21', 2),
	(2922, 7, 'cadena_valor', 'afirmacion_13', '4', 8, '2025-11-20 04:42:21', 2),
	(2923, 7, 'cadena_valor', 'afirmacion_14', '4', 8, '2025-11-20 04:42:21', 2),
	(2924, 7, 'cadena_valor', 'afirmacion_15', '4', 8, '2025-11-20 04:42:21', 2),
	(2925, 7, 'cadena_valor', 'afirmacion_16', '4', 8, '2025-11-20 04:42:21', 2),
	(2926, 7, 'cadena_valor', 'afirmacion_17', '4', 8, '2025-11-20 04:42:21', 2),
	(2927, 7, 'cadena_valor', 'afirmacion_18', '4', 8, '2025-11-20 04:42:21', 2),
	(2928, 7, 'cadena_valor', 'afirmacion_19', '4', 8, '2025-11-20 04:42:21', 2),
	(2929, 7, 'cadena_valor', 'afirmacion_20', '4', 8, '2025-11-20 04:42:21', 2),
	(2930, 7, 'cadena_valor', 'afirmacion_21', '4', 8, '2025-11-20 04:42:21', 2),
	(2931, 7, 'cadena_valor', 'afirmacion_22', '4', 8, '2025-11-20 04:42:21', 2),
	(2932, 7, 'cadena_valor', 'afirmacion_23', '4', 8, '2025-11-20 04:42:21', 2),
	(2933, 7, 'cadena_valor', 'afirmacion_24', '4', 8, '2025-11-20 04:42:21', 2),
	(2934, 7, 'cadena_valor', 'afirmacion_25', '4', 8, '2025-11-20 04:42:21', 2),
	(2979, 7, 'porter_analisis', 'rivalidad_crecimiento', '5', 8, '2025-11-20 04:43:19', 1),
	(2980, 7, 'porter_analisis', 'rivalidad_competidores', '5', 8, '2025-11-20 04:43:19', 1),
	(2981, 7, 'porter_analisis', 'rivalidad_capacidad', '5', 8, '2025-11-20 04:43:19', 1),
	(2982, 7, 'porter_analisis', 'rivalidad_rentabilidad', '5', 8, '2025-11-20 04:43:19', 1),
	(2983, 7, 'porter_analisis', 'rivalidad_diferenciacion', '5', 8, '2025-11-20 04:43:19', 1),
	(2984, 7, 'porter_analisis', 'rivalidad_barreras', '5', 8, '2025-11-20 04:43:19', 1),
	(2985, 7, 'porter_analisis', 'barreras_economia', '5', 8, '2025-11-20 04:43:19', 1),
	(2986, 7, 'porter_analisis', 'barreras_capital', '5', 8, '2025-11-20 04:43:19', 1),
	(2987, 7, 'porter_analisis', 'barreras_tecnologia', '5', 8, '2025-11-20 04:43:19', 1),
	(2988, 7, 'porter_analisis', 'barreras_reglamentos', '5', 8, '2025-11-20 04:43:19', 1),
	(2989, 7, 'porter_analisis', 'barreras_tramites', '5', 8, '2025-11-20 04:43:19', 1),
	(2990, 7, 'porter_analisis', 'barreras_reaccion', '5', 8, '2025-11-20 04:43:19', 1),
	(2991, 7, 'porter_analisis', 'clientes_numero', '5', 8, '2025-11-20 04:43:19', 1),
	(2992, 7, 'porter_analisis', 'clientes_integracion', '5', 8, '2025-11-20 04:43:19', 1),
	(2993, 7, 'porter_analisis', 'clientes_rentabilidad', '5', 8, '2025-11-20 04:43:19', 1),
	(2994, 7, 'porter_analisis', 'clientes_coste', '5', 8, '2025-11-20 04:43:19', 1),
	(3033, 7, 'matriz_came', 'acciones_corregir', '{"accion_1":"gaaaaaaaaaaa","accion_2":"gaaaaaaaaaaa","accion_3":"gaaaaaaaaaaa","accion_4":"gaaaaaaaaaaa"}', 8, '2025-11-20 04:44:35', 1),
	(3034, 7, 'matriz_came', 'acciones_afrontar', '{"accion_5":"gaaaaaaaaaaa","accion_6":"gaaaaaaaaaaa","accion_7":"gaaaaaaaaaaa","accion_8":"gaaaaaaaaaaa"}', 8, '2025-11-20 04:44:35', 1),
	(3035, 7, 'matriz_came', 'acciones_mantener', '{"accion_9":"gaaaaaaaaaaa","accion_10":"gaaaaaaaaaaa","accion_11":"gaaaaaaaaaaa","accion_12":"gaaaaaaaaaaa"}', 8, '2025-11-20 04:44:35', 1),
	(3036, 7, 'matriz_came', 'acciones_explotar', '{"accion_13":"gaaaaaaaaaaa","accion_14":"gaaaaaaaaaaa","accion_15":"gaaaaaaaaaaa","accion_16":"gaaaaaaaaaaa"}', 8, '2025-11-20 04:44:35', 1),
	(3037, 7, 'resumen_ejecutivo', 'unidades_estrategicas', 'asdasdsadasdasdasd', 8, '2025-11-20 05:52:03', 5),
	(3038, 7, 'resumen_ejecutivo', 'estrategia_identificada', 'sadsadasdasdasdasd', 8, '2025-11-20 05:52:03', 5),
	(3039, 7, 'resumen_ejecutivo', 'conclusiones', 'asdsadsadasdasdasdasdsad', 8, '2025-11-20 05:52:03', 5),
	(3052, 6, 'empresa', 'nombre', 'xdddd', 8, '2025-11-20 05:53:02', 1),
	(3053, 6, 'mision', 'declaracion', 'asdsadasdad', 8, '2025-11-20 05:53:16', 1);

-- Volcando estructura para tabla sistema_peti.peti_historial
CREATE TABLE IF NOT EXISTS `peti_historial` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `grupo_id` int(11) NOT NULL,
  `seccion` varchar(50) NOT NULL,
  `campo` varchar(100) NOT NULL,
  `valor_anterior` text DEFAULT NULL,
  `valor_nuevo` text DEFAULT NULL,
  `usuario_id` int(11) NOT NULL,
  `fecha_cambio` timestamp NOT NULL DEFAULT current_timestamp(),
  `accion` enum('crear','modificar','eliminar') NOT NULL DEFAULT 'modificar',
  PRIMARY KEY (`id`),
  KEY `idx_historial_grupo` (`grupo_id`),
  KEY `idx_historial_usuario` (`usuario_id`),
  KEY `idx_historial_fecha` (`fecha_cambio`),
  CONSTRAINT `peti_historial_ibfk_1` FOREIGN KEY (`grupo_id`) REFERENCES `grupos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `peti_historial_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla sistema_peti.peti_historial: ~8 rows (aproximadamente)
INSERT INTO `peti_historial` (`id`, `grupo_id`, `seccion`, `campo`, `valor_anterior`, `valor_nuevo`, `usuario_id`, `fecha_cambio`, `accion`) VALUES
	(2895, 7, 'identificacion_estrategia', 'puntuaciones_fo', '{"fo_0_0":"0","fo_0_1":"0","fo_0_2":"02","fo_0_3":"0","fo_1_0":"0","fo_1_1":"0","fo_1_2":"02","fo_1_3":"0","fo_2_0":"0","fo_2_1":"0","fo_2_2":"02","fo_2_3":"0","fo_3_0":"0","fo_3_1":"0","fo_3_2":"02","fo_3_3":"0"}', '{"fo_0_0":"0","fo_0_1":"0","fo_0_2":"02","fo_0_3":"0","fo_1_0":"0","fo_1_1":"0","fo_1_2":"02","fo_1_3":"0","fo_2_0":"0","fo_2_1":"0","fo_2_2":"02","fo_2_3":"0","fo_3_0":"0","fo_3_1":"0","fo_3_2":"02","fo_3_3":"0"}', 8, '2025-11-16 23:53:51', 'modificar'),
	(2896, 7, 'identificacion_estrategia', 'puntuaciones_fa', '{"fa_0_0":"0","fa_0_1":"4","fa_0_2":"0","fa_0_3":"0","fa_1_0":"0","fa_1_1":"03","fa_1_2":"0","fa_1_3":"0","fa_2_0":"0","fa_2_1":"03","fa_2_2":"0","fa_2_3":"0","fa_3_0":"0","fa_3_1":"03","fa_3_2":"0","fa_3_3":"0"}', '{"fa_0_0":"0","fa_0_1":"4","fa_0_2":"0","fa_0_3":"0","fa_1_0":"0","fa_1_1":"03","fa_1_2":"0","fa_1_3":"0","fa_2_0":"0","fa_2_1":"03","fa_2_2":"0","fa_2_3":"0","fa_3_0":"0","fa_3_1":"03","fa_3_2":"0","fa_3_3":"0"}', 8, '2025-11-16 23:53:51', 'modificar'),
	(2897, 7, 'identificacion_estrategia', 'puntuaciones_do', '{"do_0_0":"0","do_0_1":"02","do_0_2":"0","do_0_3":"0","do_1_0":"0","do_1_1":"4","do_1_2":"0","do_1_3":"0","do_2_0":"0","do_2_1":"4","do_2_2":"0","do_2_3":"0","do_3_0":"0","do_3_1":"03","do_3_2":"0","do_3_3":"0"}', '{"do_0_0":"0","do_0_1":"02","do_0_2":"0","do_0_3":"0","do_1_0":"0","do_1_1":"4","do_1_2":"0","do_1_3":"0","do_2_0":"0","do_2_1":"4","do_2_2":"0","do_2_3":"0","do_3_0":"0","do_3_1":"03","do_3_2":"0","do_3_3":"0"}', 8, '2025-11-16 23:53:51', 'modificar'),
	(2898, 7, 'identificacion_estrategia', 'puntuaciones_da', '{"da_0_0":"0","da_0_1":"03","da_0_2":"0","da_0_3":"0","da_1_0":"0","da_1_1":"4","da_1_2":"0","da_1_3":"0","da_2_0":"0","da_2_1":"02","da_2_2":"0","da_2_3":"0","da_3_0":"0","da_3_1":"03","da_3_2":"0","da_3_3":"0"}', '{"da_0_0":"0","da_0_1":"03","da_0_2":"0","da_0_3":"0","da_1_0":"0","da_1_1":"4","da_1_2":"0","da_1_3":"0","da_2_0":"0","da_2_1":"02","da_2_2":"0","da_2_3":"0","da_3_0":"0","da_3_1":"03","da_3_2":"0","da_3_3":"0"}', 8, '2025-11-16 23:53:51', 'modificar'),
	(2899, 7, 'empresa', 'nombre', 'los gays mas gays', 'los gays mas gays', 8, '2025-11-17 00:07:08', 'modificar'),
	(2900, 7, 'empresa', 'sector', 'Servicios', 'Servicios', 8, '2025-11-17 00:07:08', 'modificar'),
	(2901, 7, 'empresa', 'ubicacion', 'sadad', 'sadad', 8, '2025-11-17 00:07:08', 'modificar'),
	(2902, 7, 'empresa', 'descripcion', 'DASDA', 'DASDA', 8, '2025-11-17 00:07:08', 'modificar'),
	(2903, 7, 'vision', 'declaracion', 'XDDD', 'XDDD', 8, '2025-11-17 00:07:23', 'modificar'),
	(2904, 7, 'objetivos', 'objetivo_general', 'xd', 'xd', 8, '2025-11-20 04:13:36', 'modificar'),
	(2905, 7, 'objetivos', 'objetivo1', 'xd', 'xd', 8, '2025-11-20 04:13:36', 'modificar'),
	(2906, 7, 'porter_analisis', 'sustitutivos_disponibilidad', '5', '5', 8, '2025-11-20 04:25:16', 'modificar'),
	(2907, 7, 'porter_analisis', 'oportunidad_1', 'TENGO OPORTUNIDAD', 'TENGO OPORTUNIDAD', 8, '2025-11-20 04:25:16', 'modificar'),
	(2908, 7, 'porter_analisis', 'oportunidad_2', 'TENGO OPORTUNIDAD', 'TENGO OPORTUNIDAD', 8, '2025-11-20 04:25:16', 'modificar'),
	(2909, 7, 'porter_analisis', 'amenaza_1', 'TENGO AMENAZA', 'TENGO AMENAZA', 8, '2025-11-20 04:25:16', 'modificar'),
	(2910, 7, 'porter_analisis', 'amenaza_2', 'TENGO AMENAZA', 'TENGO AMENAZA', 8, '2025-11-20 04:25:16', 'modificar'),
	(2911, 7, 'pest_analisis', 'pregunta1', '4', '4', 8, '2025-11-20 04:26:34', 'modificar'),
	(2912, 7, 'pest_analisis', 'pregunta2', '3', '3', 8, '2025-11-20 04:26:34', 'modificar'),
	(2913, 7, 'pest_analisis', 'pregunta3', '3', '3', 8, '2025-11-20 04:26:34', 'modificar'),
	(2914, 7, 'pest_analisis', 'pregunta4', '4', '4', 8, '2025-11-20 04:26:34', 'modificar'),
	(2915, 7, 'pest_analisis', 'pregunta5', '4', '4', 8, '2025-11-20 04:26:34', 'modificar'),
	(2916, 7, 'pest_analisis', 'pregunta6', '4', '4', 8, '2025-11-20 04:26:34', 'modificar'),
	(2917, 7, 'pest_analisis', 'pregunta7', '0', '0', 8, '2025-11-20 04:26:34', 'modificar'),
	(2918, 7, 'pest_analisis', 'pregunta8', '0', '0', 8, '2025-11-20 04:26:34', 'modificar'),
	(2919, 7, 'pest_analisis', 'pregunta9', '0', '0', 8, '2025-11-20 04:26:34', 'modificar'),
	(2920, 7, 'pest_analisis', 'pregunta10', '0', '0', 8, '2025-11-20 04:26:34', 'modificar'),
	(2921, 7, 'pest_analisis', 'pregunta11', '0', '0', 8, '2025-11-20 04:26:34', 'modificar'),
	(2922, 7, 'pest_analisis', 'pregunta12', '0', '0', 8, '2025-11-20 04:26:34', 'modificar'),
	(2923, 7, 'pest_analisis', 'pregunta13', '0', '0', 8, '2025-11-20 04:26:34', 'modificar'),
	(2924, 7, 'pest_analisis', 'pregunta14', '0', '0', 8, '2025-11-20 04:26:34', 'modificar'),
	(2925, 7, 'pest_analisis', 'pregunta15', '0', '0', 8, '2025-11-20 04:26:34', 'modificar'),
	(2926, 7, 'pest_analisis', 'pregunta16', '0', '0', 8, '2025-11-20 04:26:34', 'modificar'),
	(2927, 7, 'pest_analisis', 'pregunta17', '4', '4', 8, '2025-11-20 04:26:34', 'modificar'),
	(2928, 7, 'pest_analisis', 'pregunta18', '4', '4', 8, '2025-11-20 04:26:34', 'modificar'),
	(2929, 7, 'pest_analisis', 'pregunta19', '4', '4', 8, '2025-11-20 04:26:34', 'modificar'),
	(2930, 7, 'pest_analisis', 'pregunta20', '4', '4', 8, '2025-11-20 04:26:34', 'modificar'),
	(2931, 7, 'pest_analisis', 'pregunta21', '4', '4', 8, '2025-11-20 04:26:34', 'modificar'),
	(2932, 7, 'pest_analisis', 'pregunta22', '4', '4', 8, '2025-11-20 04:26:34', 'modificar'),
	(2933, 7, 'pest_analisis', 'pregunta23', '4', '4', 8, '2025-11-20 04:26:34', 'modificar'),
	(2934, 7, 'pest_analisis', 'pregunta24', '4', '4', 8, '2025-11-20 04:26:34', 'modificar'),
	(2935, 7, 'pest_analisis', 'pregunta25', '4', '4', 8, '2025-11-20 04:26:34', 'modificar'),
	(2936, 7, 'pest_analisis', 'impacto_sociales', 'SI', 'SI', 8, '2025-11-20 04:26:34', 'modificar'),
	(2937, 7, 'pest_analisis', 'impacto_politicos', 'SI', 'SI', 8, '2025-11-20 04:26:34', 'modificar'),
	(2938, 7, 'pest_analisis', 'impacto_tecnologicos', 'SI', 'SI', 8, '2025-11-20 04:26:34', 'modificar'),
	(2939, 7, 'pest_analisis', 'impacto_medioambiental', 'SI', 'SI', 8, '2025-11-20 04:26:34', 'modificar'),
	(2940, 7, 'pest_analisis', 'oportunidad3', 'df', 'df', 8, '2025-11-20 04:26:34', 'modificar'),
	(2941, 7, 'pest_analisis', 'oportunidad4', 'fd', 'fd', 8, '2025-11-20 04:26:34', 'modificar'),
	(2942, 7, 'pest_analisis', 'amenaza3', 'fd', 'fd', 8, '2025-11-20 04:26:34', 'modificar'),
	(2943, 7, 'pest_analisis', 'amenaza4', 'df', 'df', 8, '2025-11-20 04:26:34', 'modificar'),
	(2944, 7, 'empresa', 'nombre', 'los rufianes', 'los rufianes', 8, '2025-11-20 04:39:27', 'modificar'),
	(2945, 7, 'empresa', 'sector', 'TecnologÃ­a', 'TecnologÃ­a', 8, '2025-11-20 04:39:27', 'modificar'),
	(2946, 7, 'empresa', 'ubicacion', 'gaa', 'gaa', 8, '2025-11-20 04:39:27', 'modificar'),
	(2947, 7, 'empresa', 'descripcion', 'a', 'a', 8, '2025-11-20 04:39:27', 'modificar'),
	(2948, 7, 'mision', 'declaracion', 'la mision de los gatos', 'la mision de los gatos', 8, '2025-11-20 04:40:48', 'modificar'),
	(2949, 7, 'mision', 'declaracion', 'la mision de los gatos', 'la mision de los gatos', 8, '2025-11-20 04:40:57', 'modificar'),
	(2950, 7, 'vision', 'declaracion', 'la vision de los gatos', 'la vision de los gatos', 8, '2025-11-20 04:40:57', 'modificar'),
	(2951, 7, 'valores', 'lista', 'gatos\r\nperros\r\npatitos', 'gatos\r\nperros\r\npatitos', 8, '2025-11-20 04:41:09', 'modificar'),
	(2952, 7, 'objetivos', 'objetivo1', NULL, NULL, 8, '2025-11-20 04:41:28', 'eliminar'),
	(2953, 7, 'objetivos', 'objetivo_general', 'gato', 'gato', 8, '2025-11-20 04:41:28', 'modificar'),
	(2954, 7, 'objetivos', 'objetivo1', 'gato1', 'gato1', 8, '2025-11-20 04:41:28', 'modificar'),
	(2955, 7, 'objetivos', 'objetivo2', 'gato2', 'gato2', 8, '2025-11-20 04:41:28', 'modificar'),
	(2956, 7, 'objetivos', 'objetivo3', 'gato3', 'gato3', 8, '2025-11-20 04:41:28', 'modificar'),
	(2957, 7, 'objetivos', 'objetivo4', 'gato4', 'gato4', 8, '2025-11-20 04:41:28', 'modificar'),
	(2958, 7, 'cadena_valor', 'afirmacion_1', '2', '2', 8, '2025-11-20 04:42:12', 'modificar'),
	(2959, 7, 'cadena_valor', 'afirmacion_2', '2', '2', 8, '2025-11-20 04:42:12', 'modificar'),
	(2960, 7, 'cadena_valor', 'afirmacion_3', '2', '2', 8, '2025-11-20 04:42:12', 'modificar'),
	(2961, 7, 'cadena_valor', 'afirmacion_4', '2', '2', 8, '2025-11-20 04:42:12', 'modificar'),
	(2962, 7, 'cadena_valor', 'afirmacion_5', '4', '4', 8, '2025-11-20 04:42:12', 'modificar'),
	(2963, 7, 'cadena_valor', 'afirmacion_6', '4', '4', 8, '2025-11-20 04:42:12', 'modificar'),
	(2964, 7, 'cadena_valor', 'afirmacion_7', '4', '4', 8, '2025-11-20 04:42:12', 'modificar'),
	(2965, 7, 'cadena_valor', 'afirmacion_8', '4', '4', 8, '2025-11-20 04:42:12', 'modificar'),
	(2966, 7, 'cadena_valor', 'afirmacion_9', '4', '4', 8, '2025-11-20 04:42:12', 'modificar'),
	(2967, 7, 'cadena_valor', 'afirmacion_10', '4', '4', 8, '2025-11-20 04:42:12', 'modificar'),
	(2968, 7, 'cadena_valor', 'afirmacion_11', '4', '4', 8, '2025-11-20 04:42:12', 'modificar'),
	(2969, 7, 'cadena_valor', 'afirmacion_12', '4', '4', 8, '2025-11-20 04:42:12', 'modificar'),
	(2970, 7, 'cadena_valor', 'afirmacion_13', '4', '4', 8, '2025-11-20 04:42:12', 'modificar'),
	(2971, 7, 'cadena_valor', 'afirmacion_14', '4', '4', 8, '2025-11-20 04:42:12', 'modificar'),
	(2972, 7, 'cadena_valor', 'afirmacion_15', '4', '4', 8, '2025-11-20 04:42:12', 'modificar'),
	(2973, 7, 'cadena_valor', 'afirmacion_16', '4', '4', 8, '2025-11-20 04:42:12', 'modificar'),
	(2974, 7, 'cadena_valor', 'afirmacion_17', '4', '4', 8, '2025-11-20 04:42:12', 'modificar'),
	(2975, 7, 'cadena_valor', 'afirmacion_18', '4', '4', 8, '2025-11-20 04:42:12', 'modificar'),
	(2976, 7, 'cadena_valor', 'afirmacion_19', '4', '4', 8, '2025-11-20 04:42:12', 'modificar'),
	(2977, 7, 'cadena_valor', 'afirmacion_20', '4', '4', 8, '2025-11-20 04:42:12', 'modificar'),
	(2978, 7, 'cadena_valor', 'afirmacion_21', '4', '4', 8, '2025-11-20 04:42:12', 'modificar'),
	(2979, 7, 'cadena_valor', 'afirmacion_22', '4', '4', 8, '2025-11-20 04:42:12', 'modificar'),
	(2980, 7, 'cadena_valor', 'afirmacion_23', '4', '4', 8, '2025-11-20 04:42:12', 'modificar'),
	(2981, 7, 'cadena_valor', 'afirmacion_24', '4', '4', 8, '2025-11-20 04:42:12', 'modificar'),
	(2982, 7, 'cadena_valor', 'afirmacion_25', '4', '4', 8, '2025-11-20 04:42:12', 'modificar'),
	(2983, 7, 'cadena_valor', 'fortaleza1', 'somos fuerts', 'somos fuerts', 8, '2025-11-20 04:42:12', 'modificar'),
	(2984, 7, 'cadena_valor', 'fortaleza2', 'seremos fuertes', 'seremos fuertes', 8, '2025-11-20 04:42:12', 'modificar'),
	(2985, 7, 'cadena_valor', 'debilidad1', 'somos debiles', 'somos debiles', 8, '2025-11-20 04:42:12', 'modificar'),
	(2986, 7, 'cadena_valor', 'debilidad2', 'xd', 'xd', 8, '2025-11-20 04:42:12', 'modificar'),
	(2987, 7, 'cadena_valor', 'afirmacion_1', '2', '2', 8, '2025-11-20 04:42:21', 'modificar'),
	(2988, 7, 'cadena_valor', 'afirmacion_2', '2', '2', 8, '2025-11-20 04:42:21', 'modificar'),
	(2989, 7, 'cadena_valor', 'afirmacion_3', '2', '2', 8, '2025-11-20 04:42:21', 'modificar'),
	(2990, 7, 'cadena_valor', 'afirmacion_4', '2', '2', 8, '2025-11-20 04:42:21', 'modificar'),
	(2991, 7, 'cadena_valor', 'afirmacion_5', '4', '4', 8, '2025-11-20 04:42:21', 'modificar'),
	(2992, 7, 'cadena_valor', 'afirmacion_6', '4', '4', 8, '2025-11-20 04:42:21', 'modificar'),
	(2993, 7, 'cadena_valor', 'afirmacion_7', '4', '4', 8, '2025-11-20 04:42:21', 'modificar'),
	(2994, 7, 'cadena_valor', 'afirmacion_8', '4', '4', 8, '2025-11-20 04:42:21', 'modificar'),
	(2995, 7, 'cadena_valor', 'afirmacion_9', '4', '4', 8, '2025-11-20 04:42:21', 'modificar'),
	(2996, 7, 'cadena_valor', 'afirmacion_10', '4', '4', 8, '2025-11-20 04:42:21', 'modificar'),
	(2997, 7, 'cadena_valor', 'afirmacion_11', '4', '4', 8, '2025-11-20 04:42:21', 'modificar'),
	(2998, 7, 'cadena_valor', 'afirmacion_12', '4', '4', 8, '2025-11-20 04:42:21', 'modificar'),
	(2999, 7, 'cadena_valor', 'afirmacion_13', '4', '4', 8, '2025-11-20 04:42:21', 'modificar'),
	(3000, 7, 'cadena_valor', 'afirmacion_14', '4', '4', 8, '2025-11-20 04:42:21', 'modificar'),
	(3001, 7, 'cadena_valor', 'afirmacion_15', '4', '4', 8, '2025-11-20 04:42:21', 'modificar'),
	(3002, 7, 'cadena_valor', 'afirmacion_16', '4', '4', 8, '2025-11-20 04:42:21', 'modificar'),
	(3003, 7, 'cadena_valor', 'afirmacion_17', '4', '4', 8, '2025-11-20 04:42:21', 'modificar'),
	(3004, 7, 'cadena_valor', 'afirmacion_18', '4', '4', 8, '2025-11-20 04:42:21', 'modificar'),
	(3005, 7, 'cadena_valor', 'afirmacion_19', '4', '4', 8, '2025-11-20 04:42:21', 'modificar'),
	(3006, 7, 'cadena_valor', 'afirmacion_20', '4', '4', 8, '2025-11-20 04:42:21', 'modificar'),
	(3007, 7, 'cadena_valor', 'afirmacion_21', '4', '4', 8, '2025-11-20 04:42:21', 'modificar'),
	(3008, 7, 'cadena_valor', 'afirmacion_22', '4', '4', 8, '2025-11-20 04:42:21', 'modificar'),
	(3009, 7, 'cadena_valor', 'afirmacion_23', '4', '4', 8, '2025-11-20 04:42:21', 'modificar'),
	(3010, 7, 'cadena_valor', 'afirmacion_24', '4', '4', 8, '2025-11-20 04:42:21', 'modificar'),
	(3011, 7, 'cadena_valor', 'afirmacion_25', '4', '4', 8, '2025-11-20 04:42:21', 'modificar'),
	(3012, 7, 'cadena_valor', 'fortaleza1', 'somos fuerts', 'somos fuerts', 8, '2025-11-20 04:42:21', 'modificar'),
	(3013, 7, 'cadena_valor', 'fortaleza2', 'seremos fuertes', 'seremos fuertes', 8, '2025-11-20 04:42:21', 'modificar'),
	(3014, 7, 'cadena_valor', 'debilidad1', 'somos debiles', 'somos debiles', 8, '2025-11-20 04:42:21', 'modificar'),
	(3015, 7, 'cadena_valor', 'debilidad2', 'seremos debiles', 'seremos debiles', 8, '2025-11-20 04:42:21', 'modificar'),
	(3016, 7, 'bcg', 'nombres_productos', '{"nombre_producto1":"Producto 1","nombre_producto2":"Producto 2","nombre_producto3":"Producto 3","nombre_producto4":"Producto 4","nombre_producto5":"Producto 5"}', '{"nombre_producto1":"Producto 1","nombre_producto2":"Producto 2","nombre_producto3":"Producto 3","nombre_producto4":"Producto 4","nombre_producto5":"Producto 5"}', 8, '2025-11-20 04:42:56', 'modificar'),
	(3017, 7, 'bcg', 'periodos', '{"periodo1":"2012 - 2013","periodo2":"2013 - 2014","periodo3":"2014 - 2015","periodo4":"2015 - 2016","periodo5":"2016 - 2017","anio1":"2012","anio2":"2013","anio3":"2014","anio4":"2015","anio5":"2016","anio6":"2017"}', '{"periodo1":"2012 - 2013","periodo2":"2013 - 2014","periodo3":"2014 - 2015","periodo4":"2015 - 2016","periodo5":"2016 - 2017","anio1":"2012","anio2":"2013","anio3":"2014","anio4":"2015","anio5":"2016","anio6":"2017"}', 8, '2025-11-20 04:42:56', 'modificar'),
	(3018, 7, 'bcg', 'ventas', '{"producto1":"0","producto2":"0","producto3":"0","producto4":"0","producto5":"0"}', '{"producto1":"0","producto2":"0","producto3":"0","producto4":"0","producto5":"0"}', 8, '2025-11-20 04:42:57', 'modificar'),
	(3019, 7, 'bcg', 'tcm', '{"tcm1_1":"0","tcm1_2":"0","tcm1_3":"0","tcm1_4":"0","tcm1_5":"0","tcm2_1":"0","tcm2_2":"0","tcm2_3":"0","tcm2_4":"0","tcm2_5":"0","tcm3_1":"0","tcm3_2":"0","tcm3_3":"0","tcm3_4":"0","tcm3_5":"0","tcm4_1":"0","tcm4_2":"0","tcm4_3":"0","tcm4_4":"0","tcm4_5":"0","tcm5_1":"0","tcm5_2":"0","tcm5_3":"0","tcm5_4":"0","tcm5_5":"0"}', '{"tcm1_1":"0","tcm1_2":"0","tcm1_3":"0","tcm1_4":"0","tcm1_5":"0","tcm2_1":"0","tcm2_2":"0","tcm2_3":"0","tcm2_4":"0","tcm2_5":"0","tcm3_1":"0","tcm3_2":"0","tcm3_3":"0","tcm3_4":"0","tcm3_5":"0","tcm4_1":"0","tcm4_2":"0","tcm4_3":"0","tcm4_4":"0","tcm4_5":"0","tcm5_1":"0","tcm5_2":"0","tcm5_3":"0","tcm5_4":"0","tcm5_5":"0"}', 8, '2025-11-20 04:42:57', 'modificar'),
	(3020, 7, 'bcg', 'competidores', '{"comp1_1":"0","comp2_1":"0","comp3_1":"0","comp4_1":"0","comp5_1":"0","comp1_2":"0","comp2_2":"0","comp3_2":"0","comp4_2":"0","comp5_2":"0","comp1_3":"0","comp2_3":"0","comp3_3":"0","comp4_3":"0","comp5_3":"0","comp1_4":"0","comp2_4":"0","comp3_4":"0","comp4_4":"0","comp5_4":"0","comp1_5":"0","comp2_5":"0","comp3_5":"0","comp4_5":"0","comp5_5":"0","comp1_6":"0","comp2_6":"0","comp3_6":"0","comp4_6":"0","comp5_6":"0","comp1_7":"0","comp2_7":"0","comp3_7":"0","comp4_7":"0","comp5_7":"0","comp1_8":"0","comp2_8":"0","comp3_8":"0","comp4_8":"0","comp5_8":"0","comp1_9":"0","comp2_9":"0","comp3_9":"0","comp4_9":"0","comp5_9":"0"}', '{"comp1_1":"0","comp2_1":"0","comp3_1":"0","comp4_1":"0","comp5_1":"0","comp1_2":"0","comp2_2":"0","comp3_2":"0","comp4_2":"0","comp5_2":"0","comp1_3":"0","comp2_3":"0","comp3_3":"0","comp4_3":"0","comp5_3":"0","comp1_4":"0","comp2_4":"0","comp3_4":"0","comp4_4":"0","comp5_4":"0","comp1_5":"0","comp2_5":"0","comp3_5":"0","comp4_5":"0","comp5_5":"0","comp1_6":"0","comp2_6":"0","comp3_6":"0","comp4_6":"0","comp5_6":"0","comp1_7":"0","comp2_7":"0","comp3_7":"0","comp4_7":"0","comp5_7":"0","comp1_8":"0","comp2_8":"0","comp3_8":"0","comp4_8":"0","comp5_8":"0","comp1_9":"0","comp2_9":"0","comp3_9":"0","comp4_9":"0","comp5_9":"0"}', 8, '2025-11-20 04:42:57', 'modificar'),
	(3021, 7, 'bcg', 'prm', '{"prm1":"0.000000","prm2":"0.000000","prm3":"0.000000","prm4":"0.000000","prm5":"0.000000"}', '{"prm1":"0.000000","prm2":"0.000000","prm3":"0.000000","prm4":"0.000000","prm5":"0.000000"}', 8, '2025-11-20 04:42:57', 'modificar'),
	(3022, 7, 'bcg', 'demanda', '{"demanda_2012_1":"0","demanda_2012_2":"0","demanda_2012_3":"0","demanda_2012_4":"0","demanda_2012_5":"0","demanda_2013_1":"0","demanda_2013_2":"0","demanda_2013_3":"0","demanda_2013_4":"0","demanda_2013_5":"0","demanda_2014_1":"0","demanda_2014_2":"0","demanda_2014_3":"0","demanda_2014_4":"0","demanda_2014_5":"0","demanda_2015_1":"0","demanda_2015_2":"0","demanda_2015_3":"0","demanda_2015_4":"0","demanda_2015_5":"0","demanda_2016_1":"0","demanda_2016_2":"0","demanda_2016_3":"0","demanda_2016_4":"0","demanda_2016_5":"0","demanda_2017_1":"0","demanda_2017_2":"0","demanda_2017_3":"0","demanda_2017_4":"0","demanda_2017_5":"0"}', '{"demanda_2012_1":"0","demanda_2012_2":"0","demanda_2012_3":"0","demanda_2012_4":"0","demanda_2012_5":"0","demanda_2013_1":"0","demanda_2013_2":"0","demanda_2013_3":"0","demanda_2013_4":"0","demanda_2013_5":"0","demanda_2014_1":"0","demanda_2014_2":"0","demanda_2014_3":"0","demanda_2014_4":"0","demanda_2014_5":"0","demanda_2015_1":"0","demanda_2015_2":"0","demanda_2015_3":"0","demanda_2015_4":"0","demanda_2015_5":"0","demanda_2016_1":"0","demanda_2016_2":"0","demanda_2016_3":"0","demanda_2016_4":"0","demanda_2016_5":"0","demanda_2017_1":"0","demanda_2017_2":"0","demanda_2017_3":"0","demanda_2017_4":"0","demanda_2017_5":"0"}', 8, '2025-11-20 04:42:57', 'modificar'),
	(3023, 7, 'bcg', 'fortaleza3', 'fuertes', 'fuertes', 8, '2025-11-20 04:42:57', 'modificar'),
	(3024, 7, 'bcg', 'fortaleza4', 'demasiados fuertes', 'demasiados fuertes', 8, '2025-11-20 04:42:57', 'modificar'),
	(3025, 7, 'bcg', 'debilidad3', 'debiles', 'debiles', 8, '2025-11-20 04:42:57', 'modificar'),
	(3026, 7, 'bcg', 'debilidad4', 'demasiado debiles', 'demasiado debiles', 8, '2025-11-20 04:42:57', 'modificar'),
	(3027, 7, 'porter_analisis', 'rivalidad_crecimiento', '5', '5', 8, '2025-11-20 04:43:19', 'modificar'),
	(3028, 7, 'porter_analisis', 'rivalidad_competidores', '5', '5', 8, '2025-11-20 04:43:19', 'modificar'),
	(3029, 7, 'porter_analisis', 'rivalidad_capacidad', '5', '5', 8, '2025-11-20 04:43:19', 'modificar'),
	(3030, 7, 'porter_analisis', 'rivalidad_rentabilidad', '5', '5', 8, '2025-11-20 04:43:19', 'modificar'),
	(3031, 7, 'porter_analisis', 'rivalidad_diferenciacion', '5', '5', 8, '2025-11-20 04:43:19', 'modificar'),
	(3032, 7, 'porter_analisis', 'rivalidad_barreras', '5', '5', 8, '2025-11-20 04:43:19', 'modificar'),
	(3033, 7, 'porter_analisis', 'barreras_economia', '5', '5', 8, '2025-11-20 04:43:19', 'modificar'),
	(3034, 7, 'porter_analisis', 'barreras_capital', '5', '5', 8, '2025-11-20 04:43:19', 'modificar'),
	(3035, 7, 'porter_analisis', 'barreras_tecnologia', '5', '5', 8, '2025-11-20 04:43:19', 'modificar'),
	(3036, 7, 'porter_analisis', 'barreras_reglamentos', '5', '5', 8, '2025-11-20 04:43:19', 'modificar'),
	(3037, 7, 'porter_analisis', 'barreras_tramites', '5', '5', 8, '2025-11-20 04:43:19', 'modificar'),
	(3038, 7, 'porter_analisis', 'barreras_reaccion', '5', '5', 8, '2025-11-20 04:43:19', 'modificar'),
	(3039, 7, 'porter_analisis', 'clientes_numero', '5', '5', 8, '2025-11-20 04:43:19', 'modificar'),
	(3040, 7, 'porter_analisis', 'clientes_integracion', '5', '5', 8, '2025-11-20 04:43:19', 'modificar'),
	(3041, 7, 'porter_analisis', 'clientes_rentabilidad', '5', '5', 8, '2025-11-20 04:43:19', 'modificar'),
	(3042, 7, 'porter_analisis', 'clientes_coste', '5', '5', 8, '2025-11-20 04:43:19', 'modificar'),
	(3043, 7, 'porter_analisis', 'sustitutivos_disponibilidad', '5', '5', 8, '2025-11-20 04:43:19', 'modificar'),
	(3044, 7, 'porter_analisis', 'oportunidad_1', 'TENGO OPORTUNIDAD', 'TENGO OPORTUNIDAD', 8, '2025-11-20 04:43:19', 'modificar'),
	(3045, 7, 'porter_analisis', 'oportunidad_2', 'TENGO OPORTUNIDAD', 'TENGO OPORTUNIDAD', 8, '2025-11-20 04:43:19', 'modificar'),
	(3046, 7, 'porter_analisis', 'amenaza_1', 'TENGO AMENAZA', 'TENGO AMENAZA', 8, '2025-11-20 04:43:19', 'modificar'),
	(3047, 7, 'porter_analisis', 'amenaza_2', 'TENGO AMENAZA', 'TENGO AMENAZA', 8, '2025-11-20 04:43:19', 'modificar'),
	(3048, 7, 'pest_analisis', 'pregunta1', '4', '4', 8, '2025-11-20 04:43:59', 'modificar'),
	(3049, 7, 'pest_analisis', 'pregunta2', '3', '3', 8, '2025-11-20 04:43:59', 'modificar'),
	(3050, 7, 'pest_analisis', 'pregunta3', '3', '3', 8, '2025-11-20 04:43:59', 'modificar'),
	(3051, 7, 'pest_analisis', 'pregunta4', '4', '4', 8, '2025-11-20 04:43:59', 'modificar'),
	(3052, 7, 'pest_analisis', 'pregunta5', '4', '4', 8, '2025-11-20 04:43:59', 'modificar'),
	(3053, 7, 'pest_analisis', 'pregunta6', '4', '4', 8, '2025-11-20 04:43:59', 'modificar'),
	(3054, 7, 'pest_analisis', 'pregunta7', '0', '0', 8, '2025-11-20 04:43:59', 'modificar'),
	(3055, 7, 'pest_analisis', 'pregunta8', '0', '0', 8, '2025-11-20 04:43:59', 'modificar'),
	(3056, 7, 'pest_analisis', 'pregunta9', '0', '0', 8, '2025-11-20 04:43:59', 'modificar'),
	(3057, 7, 'pest_analisis', 'pregunta10', '0', '0', 8, '2025-11-20 04:43:59', 'modificar'),
	(3058, 7, 'pest_analisis', 'pregunta11', '0', '0', 8, '2025-11-20 04:43:59', 'modificar'),
	(3059, 7, 'pest_analisis', 'pregunta12', '0', '0', 8, '2025-11-20 04:43:59', 'modificar'),
	(3060, 7, 'pest_analisis', 'pregunta13', '0', '0', 8, '2025-11-20 04:43:59', 'modificar'),
	(3061, 7, 'pest_analisis', 'pregunta14', '0', '0', 8, '2025-11-20 04:43:59', 'modificar'),
	(3062, 7, 'pest_analisis', 'pregunta15', '0', '0', 8, '2025-11-20 04:43:59', 'modificar'),
	(3063, 7, 'pest_analisis', 'pregunta16', '0', '0', 8, '2025-11-20 04:43:59', 'modificar'),
	(3064, 7, 'pest_analisis', 'pregunta17', '4', '4', 8, '2025-11-20 04:43:59', 'modificar'),
	(3065, 7, 'pest_analisis', 'pregunta18', '4', '4', 8, '2025-11-20 04:43:59', 'modificar'),
	(3066, 7, 'pest_analisis', 'pregunta19', '4', '4', 8, '2025-11-20 04:43:59', 'modificar'),
	(3067, 7, 'pest_analisis', 'pregunta20', '4', '4', 8, '2025-11-20 04:43:59', 'modificar'),
	(3068, 7, 'pest_analisis', 'pregunta21', '4', '4', 8, '2025-11-20 04:43:59', 'modificar'),
	(3069, 7, 'pest_analisis', 'pregunta22', '4', '4', 8, '2025-11-20 04:43:59', 'modificar'),
	(3070, 7, 'pest_analisis', 'pregunta23', '4', '4', 8, '2025-11-20 04:43:59', 'modificar'),
	(3071, 7, 'pest_analisis', 'pregunta24', '4', '4', 8, '2025-11-20 04:43:59', 'modificar'),
	(3072, 7, 'pest_analisis', 'pregunta25', '4', '4', 8, '2025-11-20 04:43:59', 'modificar'),
	(3073, 7, 'pest_analisis', 'impacto_sociales', 'SI', 'SI', 8, '2025-11-20 04:43:59', 'modificar'),
	(3074, 7, 'pest_analisis', 'impacto_politicos', 'SI', 'SI', 8, '2025-11-20 04:43:59', 'modificar'),
	(3075, 7, 'pest_analisis', 'impacto_tecnologicos', 'SI', 'SI', 8, '2025-11-20 04:43:59', 'modificar'),
	(3076, 7, 'pest_analisis', 'impacto_medioambiental', 'SI', 'SI', 8, '2025-11-20 04:43:59', 'modificar'),
	(3077, 7, 'pest_analisis', 'oportunidad3', 'la mejor oportunidad', 'la mejor oportunidad', 8, '2025-11-20 04:43:59', 'modificar'),
	(3078, 7, 'pest_analisis', 'oportunidad4', 'la mejorcita de mejorcita', 'la mejorcita de mejorcita', 8, '2025-11-20 04:43:59', 'modificar'),
	(3079, 7, 'pest_analisis', 'amenaza3', 'la peor oportunidad', 'la peor oportunidad', 8, '2025-11-20 04:43:59', 'modificar'),
	(3080, 7, 'pest_analisis', 'amenaza4', 'la peor de la peores', 'la peor de la peores', 8, '2025-11-20 04:43:59', 'modificar'),
	(3081, 7, 'matriz_came', 'acciones_corregir', '{"accion_1":"gaaaaaaaaaaa","accion_2":"gaaaaaaaaaaa","accion_3":"gaaaaaaaaaaa","accion_4":"gaaaaaaaaaaa"}', '{"accion_1":"gaaaaaaaaaaa","accion_2":"gaaaaaaaaaaa","accion_3":"gaaaaaaaaaaa","accion_4":"gaaaaaaaaaaa"}', 8, '2025-11-20 04:44:35', 'modificar'),
	(3082, 7, 'matriz_came', 'acciones_afrontar', '{"accion_5":"gaaaaaaaaaaa","accion_6":"gaaaaaaaaaaa","accion_7":"gaaaaaaaaaaa","accion_8":"gaaaaaaaaaaa"}', '{"accion_5":"gaaaaaaaaaaa","accion_6":"gaaaaaaaaaaa","accion_7":"gaaaaaaaaaaa","accion_8":"gaaaaaaaaaaa"}', 8, '2025-11-20 04:44:35', 'modificar'),
	(3083, 7, 'matriz_came', 'acciones_mantener', '{"accion_9":"gaaaaaaaaaaa","accion_10":"gaaaaaaaaaaa","accion_11":"gaaaaaaaaaaa","accion_12":"gaaaaaaaaaaa"}', '{"accion_9":"gaaaaaaaaaaa","accion_10":"gaaaaaaaaaaa","accion_11":"gaaaaaaaaaaa","accion_12":"gaaaaaaaaaaa"}', 8, '2025-11-20 04:44:35', 'modificar'),
	(3084, 7, 'matriz_came', 'acciones_explotar', '{"accion_13":"gaaaaaaaaaaa","accion_14":"gaaaaaaaaaaa","accion_15":"gaaaaaaaaaaa","accion_16":"gaaaaaaaaaaa"}', '{"accion_13":"gaaaaaaaaaaa","accion_14":"gaaaaaaaaaaa","accion_15":"gaaaaaaaaaaa","accion_16":"gaaaaaaaaaaa"}', 8, '2025-11-20 04:44:35', 'modificar'),
	(3085, 7, 'resumen_ejecutivo', 'unidades_estrategicas', 'asdasdsadasdasdasd', 'asdasdsadasdasdasd', 8, '2025-11-20 05:21:58', 'modificar'),
	(3086, 7, 'resumen_ejecutivo', 'estrategia_identificada', 'sadsadasdasdasdasd', 'sadsadasdasdasdasd', 8, '2025-11-20 05:21:58', 'modificar'),
	(3087, 7, 'resumen_ejecutivo', 'conclusiones', 'asdsadsadasdasdasdasdsad', 'asdsadsadasdasdasdasdsad', 8, '2025-11-20 05:21:58', 'modificar'),
	(3088, 7, 'resumen_ejecutivo', 'unidades_estrategicas', 'asdasdsadasdasdasd', 'asdasdsadasdasdasd', 8, '2025-11-20 05:41:40', 'modificar'),
	(3089, 7, 'resumen_ejecutivo', 'estrategia_identificada', 'sadsadasdasdasdasd', 'sadsadasdasdasdasd', 8, '2025-11-20 05:41:40', 'modificar'),
	(3090, 7, 'resumen_ejecutivo', 'conclusiones', 'asdsadsadasdasdasdasdsad', 'asdsadsadasdasdasdasdsad', 8, '2025-11-20 05:41:40', 'modificar'),
	(3091, 7, 'resumen_ejecutivo', 'unidades_estrategicas', 'asdasdsadasdasdasd', 'asdasdsadasdasdasd', 8, '2025-11-20 05:43:39', 'modificar'),
	(3092, 7, 'resumen_ejecutivo', 'estrategia_identificada', 'sadsadasdasdasdasd', 'sadsadasdasdasdasd', 8, '2025-11-20 05:43:39', 'modificar'),
	(3093, 7, 'resumen_ejecutivo', 'conclusiones', 'asdsadsadasdasdasdasdsad', 'asdsadsadasdasdasdasdsad', 8, '2025-11-20 05:43:39', 'modificar'),
	(3094, 7, 'resumen_ejecutivo', 'unidades_estrategicas', 'asdasdsadasdasdasd', 'asdasdsadasdasdasd', 8, '2025-11-20 05:45:51', 'modificar'),
	(3095, 7, 'resumen_ejecutivo', 'estrategia_identificada', 'sadsadasdasdasdasd', 'sadsadasdasdasdasd', 8, '2025-11-20 05:45:51', 'modificar'),
	(3096, 7, 'resumen_ejecutivo', 'conclusiones', 'asdsadsadasdasdasdasdsad', 'asdsadsadasdasdasdasdsad', 8, '2025-11-20 05:45:51', 'modificar'),
	(3097, 7, 'resumen_ejecutivo', 'unidades_estrategicas', 'asdasdsadasdasdasd', 'asdasdsadasdasdasd', 8, '2025-11-20 05:52:03', 'modificar'),
	(3098, 7, 'resumen_ejecutivo', 'estrategia_identificada', 'sadsadasdasdasdasd', 'sadsadasdasdasdasd', 8, '2025-11-20 05:52:03', 'modificar'),
	(3099, 7, 'resumen_ejecutivo', 'conclusiones', 'asdsadsadasdasdasdasdsad', 'asdsadsadasdasdasdasdsad', 8, '2025-11-20 05:52:03', 'modificar'),
	(3100, 6, 'empresa', 'nombre', 'xdddd', 'xdddd', 8, '2025-11-20 05:53:02', 'modificar'),
	(3101, 6, 'mision', 'declaracion', 'asdsadasdad', 'asdsadasdad', 8, '2025-11-20 05:53:16', 'modificar');

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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla sistema_peti.usuarios: ~5 rows (aproximadamente)
INSERT INTO `usuarios` (`id`, `username`, `password`, `email`, `fecha_registro`, `activo`) VALUES
	(8, 'diego', '123', 'diecastillom@upt.pe', '2025-09-17 04:52:51', 1),
	(9, 'carlos', '123', 'dc2022073895@virtual.upt.pe', '2025-09-17 04:53:21', 1),
	(10, 'juan', '123', 'ac@upt.pe', '2025-09-29 14:14:34', 1),
	(11, 'mario', '123', 'ma@upt.pe', '2025-09-29 14:14:52', 1),
	(12, 'andy', '123', 'andy@sistema.local', '2025-10-06 04:45:54', 1),
	(13, 'walter', '123', 'wa@upt.pe', '2025-10-17 03:58:01', 1);

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

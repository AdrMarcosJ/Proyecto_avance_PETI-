-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `PETI`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `login_python`
--

CREATE TABLE `login_python` (
  `id` int(11) NOT NULL,
  `tipo_user` int(11) DEFAULT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellido` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` text DEFAULT NULL,
  `sexo` varchar(20) DEFAULT NULL,
  `pais` varchar(50) DEFAULT NULL,
  `create_at` varchar(100) DEFAULT NULL,
  `te_gusta_la_programacion` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `login_python`
--

INSERT INTO `login_python` (`id`, `tipo_user`, `nombre`, `apellido`, `email`, `password`, `sexo`, `pais`, `create_at`, `te_gusta_la_programacion`) VALUES
(2, 1, 'Oscar', 'Jimenez', 'oscar@gmail.com', 'sha256$8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'Masculino', 'Perú', '2024-5-11', 'Si'),
(3, 2, 'Vanessa', 'Gutierrez', 'vanessa@gmail.com', 'sha256$8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'Femenino', 'Perú', '2024-5-11', 'Si');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `login_python`
--
ALTER TABLE `login_python`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `login_python`
--
ALTER TABLE `login_python`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

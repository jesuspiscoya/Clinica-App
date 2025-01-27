-- phpMyAdmin SQL Dump
-- version 5.1.4
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 27-01-2025 a las 15:53:58
-- Versión del servidor: 8.0.39-30
-- Versión de PHP: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `db8irwm2igbtxe`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`sdeo6wimghifp`@`localhost` PROCEDURE `ActualizarPassword` (IN `codigo` INT, IN `pass` VARCHAR(50))   BEGIN
UPDATE personal SET password = pass
WHERE cod_personal = codigo;
END$$

CREATE DEFINER=`sdeo6wimghifp`@`localhost` PROCEDURE `BuscarPaciente` (IN `dni` VARCHAR(8))   BEGIN
SELECT pa.cod_paciente, pa.nhc, pe.nombres, pe.ape_paterno, pe.ape_materno, DATE_FORMAT(pe.fec_nacimiento, '%d-%m-%Y') AS fec_nacimiento, pe.sexo, pe.est_civil, pa.tip_sangre, pa.don_organos
FROM paciente pa
INNER JOIN persona pe
ON pa.cod_persona = pe.cod_persona
WHERE pe.dni = dni;
END$$

CREATE DEFINER=`sdeo6wimghifp`@`localhost` PROCEDURE `BuscarTriaje` (IN `cod_triajes` INT)   BEGIN
SELECT * FROM triaje WHERE cod_triaje = cod_triajes;
END$$

CREATE DEFINER=`sdeo6wimghifp`@`localhost` PROCEDURE `ListarAtencionesPendientes` (IN `cod_medico` INT)   BEGIN
SET @cod_especialidad = (SELECT cod_especialidad FROM personal WHERE cod_personal = cod_medico);
SELECT a.cod_atencion, a.cod_paciente, e.nom_especialidad, a.cod_triaje, pe.dni, pe.nombres, pe.ape_paterno, pe.ape_materno, a.fec_registro
FROM atencion a
INNER JOIN paciente pa
INNER JOIN especialidad e
INNER JOIN persona pe
ON a.cod_paciente = pa.cod_paciente AND a.cod_especialidad = e.cod_especialidad AND pa.cod_persona = pe.cod_persona
WHERE a.estado = 1 AND e.cod_especialidad = @cod_especialidad
ORDER BY a.fec_registro;
END$$

CREATE DEFINER=`sdeo6wimghifp`@`localhost` PROCEDURE `ListarEspecialidad` ()   BEGIN
SELECT * FROM especialidad;
END$$

CREATE DEFINER=`sdeo6wimghifp`@`localhost` PROCEDURE `ListarHistorialAtenciones` (IN `cod_medicos` INT)   BEGIN
SELECT a.cod_atencion, a.cod_paciente, a.cod_triaje, pe.dni, pe.nombres, pe.ape_paterno, pe.ape_materno, a.fec_modificacion, a.sintomas, a.diagnostico, a.tratamiento, a.observaciones, a.examenes
FROM atencion a
INNER JOIN paciente pa
INNER JOIN persona pe
ON a.cod_paciente = pa.cod_paciente AND pa.cod_persona = pe.cod_persona
WHERE a.cod_medico = cod_medicos AND a.estado = 2
ORDER BY a.fec_modificacion DESC;
END$$

CREATE DEFINER=`sdeo6wimghifp`@`localhost` PROCEDURE `ListarTriajePendiente` ()   BEGIN
SELECT a.cod_atencion, pa.cod_paciente, a.cod_enfermera, pa.nhc, pe.dni, pe.nombres, pe.ape_paterno, pe.ape_materno, a.fec_registro
FROM atencion a
INNER JOIN paciente pa
INNER JOIN persona pe
ON a.cod_paciente = pa.cod_paciente AND pa.cod_persona = pe.cod_persona
WHERE a.estado = 0;
END$$

CREATE DEFINER=`sdeo6wimghifp`@`localhost` PROCEDURE `LoginPersonal` (IN `user` VARCHAR(20), IN `pass` VARCHAR(50))   BEGIN
SELECT e.cod_personal, s.nom_especialidad, e.tipo_personal, p.nombres, p.ape_paterno, p.ape_materno, p.fec_nacimiento, e.correo, p.telefono, p.direccion
FROM personal e
LEFT JOIN persona p ON e.cod_persona = p.cod_persona
LEFT JOIN especialidad s ON e.cod_especialidad = s.cod_especialidad
WHERE e.usuario = user AND e.password = pass;
END$$

CREATE DEFINER=`sdeo6wimghifp`@`localhost` PROCEDURE `ModificarAtencion` (IN `codigo` INT, IN `cod_medicos` INT, IN `sintomass` VARCHAR(200), IN `diagnosticos` VARCHAR(200), IN `tratamientos` VARCHAR(200), IN `observacioness` VARCHAR(200), IN `exameness` VARCHAR(200))   BEGIN
UPDATE atencion SET cod_medico = cod_medicos, sintomas = sintomass, diagnostico = diagnosticos, tratamiento = tratamientos, observaciones = observacioness, examenes = exameness, estado = 2, fec_modificacion = NOW()
WHERE cod_atencion = codigo;
END$$

CREATE DEFINER=`sdeo6wimghifp`@`localhost` PROCEDURE `RegistrarAtencion` (IN `cod_paciente` INT, IN `cod_especialidad` INT, IN `cod_enfermera` INT)   BEGIN
INSERT INTO atencion (cod_paciente, cod_especialidad, cod_enfermera) VALUES(cod_paciente, cod_especialidad, cod_enfermera);
END$$

CREATE DEFINER=`sdeo6wimghifp`@`localhost` PROCEDURE `RegistrarEnfermera` (IN `nombre` VARCHAR(50), IN `paterno` VARCHAR(50), IN `materno` VARCHAR(50), IN `dni` VARCHAR(8), IN `telefono` VARCHAR(9), IN `nacimiento` DATE, IN `sexo` VARCHAR(9), IN `civil` VARCHAR(10), IN `departamento` VARCHAR(50), IN `provincia` VARCHAR(50), IN `distrito` VARCHAR(50), IN `direccion` VARCHAR(100), IN `colegiatura` INT, IN `correo` VARCHAR(100), IN `user` VARCHAR(20), IN `pass` VARCHAR(50))   BEGIN
INSERT INTO persona VALUES(null, nombre, paterno, materno, dni, telefono, nacimiento, sexo, civil, departamento, provincia, distrito, direccion, null);
SET @cod_per = (SELECT cod_persona FROM persona ORDER BY cod_persona DESC LIMIT 1);
INSERT INTO personal VALUES(null, @cod_per, 2, null, colegiatura, correo, user, SHA(pass));
END$$

CREATE DEFINER=`sdeo6wimghifp`@`localhost` PROCEDURE `RegistrarMedico` (IN `nombre` VARCHAR(50), IN `paterno` VARCHAR(50), IN `materno` VARCHAR(50), IN `dni` VARCHAR(8), IN `telefono` VARCHAR(9), IN `nacimiento` DATE, IN `sexo` VARCHAR(9), IN `civil` VARCHAR(10), IN `departamento` VARCHAR(50), IN `provincia` VARCHAR(50), IN `distrito` VARCHAR(50), IN `direccion` VARCHAR(100), IN `cod_especialidad` INT, IN `colegiatura` INT, IN `correo` VARCHAR(100), IN `user` VARCHAR(20), IN `pass` VARCHAR(50))   BEGIN
INSERT INTO persona VALUES(null, nombre, paterno, materno, dni, telefono, nacimiento, sexo, civil, departamento, provincia, distrito, direccion, null);
SET @cod_per = (SELECT cod_persona FROM persona ORDER BY cod_persona DESC LIMIT 1);
INSERT INTO medico VALUES(null, @cod_per, 1, cod_especialidad, colegiatura, correo, user, SHA(pass));
END$$

CREATE DEFINER=`sdeo6wimghifp`@`localhost` PROCEDURE `RegistrarPaciente` (IN `nombre` VARCHAR(50), IN `paterno` VARCHAR(50), IN `materno` VARCHAR(50), IN `dni` VARCHAR(8), IN `telefono` VARCHAR(9), IN `nacimiento` DATE, IN `sexo` VARCHAR(9), IN `civil` VARCHAR(10), IN `departamento` VARCHAR(50), IN `provincia` VARCHAR(50), IN `distrito` VARCHAR(50), IN `direccion` VARCHAR(100), IN `nhc` INT, IN `sangre` VARCHAR(3), IN `organos` VARCHAR(2))   BEGIN
INSERT INTO persona (nombres, ape_paterno, ape_materno, dni, telefono, fec_nacimiento, sexo, est_civil, departamento, provincia, distrito, direccion) VALUES(nombre, paterno, materno, dni, telefono, nacimiento, sexo, civil, departamento, provincia, distrito, direccion);
SET @cod_per = (SELECT cod_persona FROM persona ORDER BY cod_persona DESC LIMIT 1);
INSERT INTO paciente VALUES(null, nhc, @cod_per, sangre, organos);
END$$

CREATE DEFINER=`sdeo6wimghifp`@`localhost` PROCEDURE `RegistrarTriaje` (IN `cod_atencions` INT, IN `cod_enfermera` INT, IN `cod_pacientes` INT, IN `peso` VARCHAR(6), IN `talla` VARCHAR(4), IN `temperatura` VARCHAR(4), IN `presion` VARCHAR(6))   BEGIN
INSERT INTO triaje (cod_enfermera, cod_paciente, peso, talla, temperatura, presion) VALUES(cod_enfermera, cod_pacientes, peso, talla, temperatura, presion);
SET @cod_triaje = (SELECT cod_triaje FROM triaje WHERE cod_paciente = cod_pacientes ORDER BY cod_triaje DESC LIMIT 1);
UPDATE atencion SET cod_triaje = @cod_triaje, estado = 1 WHERE cod_atencion = cod_atencions;
END$$

CREATE DEFINER=`sdeo6wimghifp`@`localhost` PROCEDURE `VerificarTriaje` (IN `cod_pacientes` INT)   SELECT a.cod_enfermera, pa.cod_paciente, pa.nhc, pe.dni, pe.nombres, pe.ape_paterno, pe.ape_materno, a.fec_registro, a.estado
FROM atencion a
INNER JOIN paciente pa
INNER JOIN persona pe
ON a.cod_paciente = pa.cod_paciente AND pa.cod_persona = pe.cod_persona
WHERE estado = 0 AND pa.cod_paciente = cod_pacientes$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `atencion`
--

CREATE TABLE `atencion` (
  `cod_atencion` int NOT NULL,
  `cod_paciente` int NOT NULL,
  `cod_especialidad` int NOT NULL,
  `cod_enfermera` int NOT NULL,
  `cod_triaje` int DEFAULT NULL,
  `cod_medico` int DEFAULT NULL,
  `sintomas` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `diagnostico` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tratamiento` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `observaciones` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `examenes` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT '0',
  `fec_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fec_modificacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `especialidad`
--

CREATE TABLE `especialidad` (
  `cod_especialidad` int NOT NULL,
  `nom_especialidad` varchar(50) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `especialidad`
--

INSERT INTO `especialidad` (`cod_especialidad`, `nom_especialidad`) VALUES
(1000, 'Neurología'),
(1001, 'Dermatología'),
(1002, 'Otorrinolaringología'),
(1003, 'Odontología'),
(1004, 'Medicina General'),
(1005, 'Obstetricia'),
(1006, 'Oftalmología'),
(1007, 'Nutrición'),
(1008, 'Traumatología'),
(1009, 'Psicología');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paciente`
--

CREATE TABLE `paciente` (
  `cod_paciente` int NOT NULL,
  `nhc` int NOT NULL,
  `cod_persona` int NOT NULL,
  `tip_sangre` varchar(3) COLLATE utf8mb4_general_ci NOT NULL,
  `don_organos` varchar(2) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `persona`
--

CREATE TABLE `persona` (
  `cod_persona` int NOT NULL,
  `nombres` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `ape_paterno` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `ape_materno` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `dni` varchar(8) COLLATE utf8mb4_general_ci NOT NULL,
  `telefono` varchar(9) COLLATE utf8mb4_general_ci NOT NULL,
  `fec_nacimiento` date NOT NULL,
  `sexo` varchar(9) COLLATE utf8mb4_general_ci NOT NULL,
  `est_civil` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `departamento` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `provincia` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `distrito` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `direccion` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `fec_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personal`
--

CREATE TABLE `personal` (
  `cod_personal` int NOT NULL,
  `cod_persona` int NOT NULL,
  `tipo_personal` int NOT NULL,
  `cod_especialidad` int DEFAULT NULL,
  `num_colegiatura` int NOT NULL,
  `correo` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `usuario` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(50) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `triaje`
--

CREATE TABLE `triaje` (
  `cod_triaje` int NOT NULL,
  `cod_enfermera` int NOT NULL,
  `cod_paciente` int NOT NULL,
  `peso` float NOT NULL,
  `talla` int NOT NULL,
  `temperatura` float NOT NULL,
  `presion` varchar(6) COLLATE utf8mb4_general_ci NOT NULL,
  `fec_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `atencion`
--
ALTER TABLE `atencion`
  ADD PRIMARY KEY (`cod_atencion`),
  ADD KEY `cod_paciente` (`cod_paciente`),
  ADD KEY `cod_especialidad` (`cod_especialidad`),
  ADD KEY `cod_enfermera` (`cod_enfermera`),
  ADD KEY `cod_triaje` (`cod_triaje`),
  ADD KEY `cod_medico` (`cod_medico`);

--
-- Indices de la tabla `especialidad`
--
ALTER TABLE `especialidad`
  ADD PRIMARY KEY (`cod_especialidad`);

--
-- Indices de la tabla `paciente`
--
ALTER TABLE `paciente`
  ADD PRIMARY KEY (`cod_paciente`),
  ADD KEY `cod_persona` (`cod_persona`);

--
-- Indices de la tabla `persona`
--
ALTER TABLE `persona`
  ADD PRIMARY KEY (`cod_persona`);

--
-- Indices de la tabla `personal`
--
ALTER TABLE `personal`
  ADD PRIMARY KEY (`cod_personal`),
  ADD KEY `cod_persona` (`cod_persona`),
  ADD KEY `cod_especialidad` (`cod_especialidad`);

--
-- Indices de la tabla `triaje`
--
ALTER TABLE `triaje`
  ADD PRIMARY KEY (`cod_triaje`),
  ADD KEY `cod_enfermera` (`cod_enfermera`),
  ADD KEY `cod_paciente` (`cod_paciente`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `atencion`
--
ALTER TABLE `atencion`
  MODIFY `cod_atencion` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `especialidad`
--
ALTER TABLE `especialidad`
  MODIFY `cod_especialidad` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `paciente`
--
ALTER TABLE `paciente`
  MODIFY `cod_paciente` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `persona`
--
ALTER TABLE `persona`
  MODIFY `cod_persona` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `personal`
--
ALTER TABLE `personal`
  MODIFY `cod_personal` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `triaje`
--
ALTER TABLE `triaje`
  MODIFY `cod_triaje` int NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `atencion`
--
ALTER TABLE `atencion`
  ADD CONSTRAINT `atencion_ibfk_1` FOREIGN KEY (`cod_paciente`) REFERENCES `paciente` (`cod_paciente`),
  ADD CONSTRAINT `atencion_ibfk_3` FOREIGN KEY (`cod_especialidad`) REFERENCES `especialidad` (`cod_especialidad`),
  ADD CONSTRAINT `atencion_ibfk_4` FOREIGN KEY (`cod_enfermera`) REFERENCES `personal` (`cod_personal`),
  ADD CONSTRAINT `atencion_ibfk_5` FOREIGN KEY (`cod_triaje`) REFERENCES `triaje` (`cod_triaje`),
  ADD CONSTRAINT `atencion_ibfk_6` FOREIGN KEY (`cod_medico`) REFERENCES `personal` (`cod_personal`);

--
-- Filtros para la tabla `paciente`
--
ALTER TABLE `paciente`
  ADD CONSTRAINT `paciente_ibfk_1` FOREIGN KEY (`cod_persona`) REFERENCES `persona` (`cod_persona`);

--
-- Filtros para la tabla `personal`
--
ALTER TABLE `personal`
  ADD CONSTRAINT `personal_ibfk_1` FOREIGN KEY (`cod_persona`) REFERENCES `persona` (`cod_persona`),
  ADD CONSTRAINT `personal_ibfk_2` FOREIGN KEY (`cod_especialidad`) REFERENCES `especialidad` (`cod_especialidad`);

--
-- Filtros para la tabla `triaje`
--
ALTER TABLE `triaje`
  ADD CONSTRAINT `triaje_ibfk_1` FOREIGN KEY (`cod_enfermera`) REFERENCES `personal` (`cod_personal`),
  ADD CONSTRAINT `triaje_ibfk_2` FOREIGN KEY (`cod_paciente`) REFERENCES `paciente` (`cod_paciente`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

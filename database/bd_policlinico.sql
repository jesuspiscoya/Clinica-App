-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 07-05-2023 a las 00:04:32
-- Versión del servidor: 10.4.27-MariaDB
-- Versión de PHP: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bd_policlinico`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `BuscarPaciente` (IN `dni` VARCHAR(8))   BEGIN
SELECT pa.cod_paciente, pa.nhc, pe.nombres, pe.ape_paterno, pe.ape_materno, DATE_FORMAT(pe.fec_nacimiento, '%d-%m-%Y') AS fec_nacimiento, pe.sexo, pe.est_civil, pa.tip_sangre, pa.don_organos
FROM paciente pa
INNER JOIN persona pe
ON pa.cod_persona = pe.cod_persona
WHERE pe.dni = dni;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BuscarTriaje` (IN `cod_pacientes` INT)   BEGIN
SELECT * FROM triaje WHERE cod_paciente = cod_pacientes ORDER BY fec_registro DESC LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListarAtencionesPendientes` ()   BEGIN
SELECT pa.cod_paciente, pe.dni, pe.nombres, pe.ape_paterno, pe.ape_materno, a.fec_registro, a.estado
FROM atencion a
INNER JOIN paciente pa
INNER JOIN persona pe
ON a.cod_paciente = pa.cod_paciente AND pa.cod_persona = pe.cod_persona
WHERE a.estado = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListarEspecialidad` ()   BEGIN
SELECT * FROM especialidad;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListarTriajePendiente` ()   BEGIN
SELECT a.cod_enfermera, pa.cod_paciente, pa.nhc, pe.dni, pe.nombres, pe.ape_paterno, pe.ape_materno, a.fec_registro, a.estado
FROM atencion a
INNER JOIN paciente pa
INNER JOIN persona pe
ON a.cod_paciente = pa.cod_paciente AND pa.cod_persona = pe.cod_persona
WHERE a.estado = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `LoginEnfermera` (IN `user` VARCHAR(20), IN `pass` VARCHAR(50))   BEGIN
SELECT e.cod_enfermera, p.nombres, p.ape_paterno, p.ape_materno
FROM enfermera e
INNER JOIN persona p
ON e.cod_persona = p.cod_persona
WHERE e.usuario = user AND e.password = pass;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `LoginMedico` (IN `user` VARCHAR(20), IN `pass` VARCHAR(50))   BEGIN
SELECT m.cod_medico, e.nom_especialidad, p.nombres, p.ape_paterno, p.ape_materno
FROM medico m
INNER JOIN persona p
INNER JOIN especialidad e
ON m.cod_persona = p.cod_persona AND m.cod_especialidad = e.cod_especialidad
WHERE m.usuario = user AND m.password = pass;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistrarAtencion` (IN `cod_paciente` INT, IN `cod_especialidad` INT, IN `cod_enfermera` INT)   BEGIN
INSERT INTO atencion VALUES(null, cod_paciente, cod_especialidad, cod_enfermera, 0, null);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistrarEnfermera` (IN `nombre` VARCHAR(50), IN `paterno` VARCHAR(50), IN `materno` VARCHAR(50), IN `dni` VARCHAR(8), IN `telefono` VARCHAR(9), IN `nacimiento` DATE, IN `sexo` VARCHAR(9), IN `civil` VARCHAR(10), IN `departamento` VARCHAR(50), IN `provincia` VARCHAR(50), IN `distrito` VARCHAR(50), IN `direccion` VARCHAR(100), IN `colegiatura` INT, IN `correo` VARCHAR(100), IN `user` VARCHAR(20), IN `pass` VARCHAR(50))   BEGIN
INSERT INTO persona VALUES(null, nombre, paterno, materno, dni, telefono, nacimiento, sexo, civil, departamento, provincia, distrito, direccion, null);
INSERT INTO enfermera VALUES(null, (SELECT cod_persona FROM persona ORDER BY cod_persona DESC LIMIT 1), colegiatura, correo, user, SHA(pass));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistrarMedico` (IN `nombre` VARCHAR(50), IN `paterno` VARCHAR(50), IN `materno` VARCHAR(50), IN `dni` VARCHAR(8), IN `telefono` VARCHAR(9), IN `nacimiento` DATE, IN `sexo` VARCHAR(9), IN `civil` VARCHAR(10), IN `departamento` VARCHAR(50), IN `provincia` VARCHAR(50), IN `distrito` VARCHAR(50), IN `direccion` VARCHAR(100), IN `cod_especialidad` INT, IN `colegiatura` INT, IN `correo` VARCHAR(100), IN `user` VARCHAR(20), IN `pass` VARCHAR(50))   BEGIN
INSERT INTO persona VALUES(null, nombre, paterno, materno, dni, telefono, nacimiento, sexo, civil, departamento, provincia, distrito, direccion, null);
SET @cod_per = (SELECT cod_persona FROM persona ORDER BY cod_persona DESC LIMIT 1);
INSERT INTO medico VALUES(null, @cod_per, cod_especialidad, colegiatura, correo, user, SHA(pass));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistrarPaciente` (IN `nombre` VARCHAR(50), IN `paterno` VARCHAR(50), IN `materno` VARCHAR(50), IN `dni` VARCHAR(8), IN `telefono` VARCHAR(9), IN `nacimiento` DATE, IN `sexo` VARCHAR(9), IN `civil` VARCHAR(10), IN `departamento` VARCHAR(50), IN `provincia` VARCHAR(50), IN `distrito` VARCHAR(50), IN `direccion` VARCHAR(100), IN `nhc` INT, IN `sangre` VARCHAR(3), IN `organos` VARCHAR(2))   BEGIN
INSERT INTO persona VALUES(null, nombre, paterno, materno, dni, telefono, nacimiento, sexo, civil, departamento, provincia, distrito, direccion, null);
INSERT INTO paciente VALUES(null, nhc, (SELECT cod_persona FROM persona ORDER BY cod_persona DESC LIMIT 1), sangre, organos);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistrarTriaje` (IN `cod_enfermera` INT, IN `cod_pacientes` INT, IN `peso` VARCHAR(6), IN `talla` VARCHAR(4), IN `temperatura` VARCHAR(4), IN `presion` VARCHAR(6))   BEGIN
INSERT INTO triaje VALUES(null, cod_enfermera, cod_pacientes, peso, talla, temperatura, presion, null);
UPDATE atencion SET estado = 1 WHERE cod_paciente = cod_pacientes;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `VerificarTriaje` (IN `cod_pacientes` INT)   SELECT a.cod_enfermera, pa.cod_paciente, pa.nhc, pe.dni, pe.nombres, pe.ape_paterno, pe.ape_materno, a.fec_registro, a.estado
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
  `cod_atencion` int(11) NOT NULL,
  `cod_paciente` int(11) NOT NULL,
  `cod_especialidad` int(11) NOT NULL,
  `cod_enfermera` int(11) NOT NULL,
  `estado` tinyint(1) NOT NULL,
  `fec_registro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `atencion`
--

INSERT INTO `atencion` (`cod_atencion`, `cod_paciente`, `cod_especialidad`, `cod_enfermera`, `estado`, `fec_registro`) VALUES
(1, 1000, 1001, 1000, 1, '2023-05-03 07:12:19'),
(3, 1002, 1000, 1000, 1, '2023-05-03 07:25:22'),
(9, 1000, 1000, 1001, 0, '2023-05-06 05:52:48'),
(10, 1002, 1000, 1001, 0, '2023-05-06 05:53:11');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `enfermera`
--

CREATE TABLE `enfermera` (
  `cod_enfermera` int(11) NOT NULL,
  `cod_persona` int(11) NOT NULL,
  `num_colegiatura` int(11) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `usuario` varchar(20) NOT NULL,
  `password` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `enfermera`
--

INSERT INTO `enfermera` (`cod_enfermera`, `cod_persona`, `num_colegiatura`, `correo`, `usuario`, `password`) VALUES
(1000, 1003, 123456, 'jesus@gmail.com', 'jesus', '8d5004c9c74259ab775f63f7131da077814a7636'),
(1001, 1004, 123456, 'maria@gmail.com', 'maria', 'e21fc56c1a272b630e0d1439079d0598cf8b8329');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `especialidad`
--

CREATE TABLE `especialidad` (
  `cod_especialidad` int(11) NOT NULL,
  `nom_especialidad` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `especialidad`
--

INSERT INTO `especialidad` (`cod_especialidad`, `nom_especialidad`) VALUES
(1000, 'Neurología'),
(1001, 'Dermatología'),
(1002, 'Otorrinolaringología');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historia_clinica`
--

CREATE TABLE `historia_clinica` (
  `nhc` int(11) NOT NULL,
  `alergias` varchar(100) NOT NULL,
  `antecedentes` varchar(100) NOT NULL,
  `diagnostico` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `medico`
--

CREATE TABLE `medico` (
  `cod_medico` int(11) NOT NULL,
  `cod_persona` int(11) NOT NULL,
  `cod_especialidad` int(11) NOT NULL,
  `num_colegiatura` int(11) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `usuario` varchar(20) NOT NULL,
  `password` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `medico`
--

INSERT INTO `medico` (`cod_medico`, `cod_persona`, `cod_especialidad`, `num_colegiatura`, `correo`, `usuario`, `password`) VALUES
(1000, 1008, 1001, 123456, 'oscar@gmail.com', 'oscar', '2dff4fc90e2973f54d62e257480de234bc59e2c4');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paciente`
--

CREATE TABLE `paciente` (
  `cod_paciente` int(11) NOT NULL,
  `nhc` int(11) NOT NULL,
  `cod_persona` int(11) NOT NULL,
  `tip_sangre` varchar(3) NOT NULL,
  `don_organos` varchar(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `paciente`
--

INSERT INTO `paciente` (`cod_paciente`, `nhc`, `cod_persona`, `tip_sangre`, `don_organos`) VALUES
(1000, 10054, 1005, 'O+', 'Sí'),
(1001, 10055, 1006, 'AB+', 'No'),
(1002, 0, 1007, 'AB+', 'No');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `persona`
--

CREATE TABLE `persona` (
  `cod_persona` int(11) NOT NULL,
  `nombres` varchar(50) NOT NULL,
  `ape_paterno` varchar(50) NOT NULL,
  `ape_materno` varchar(50) NOT NULL,
  `dni` varchar(8) NOT NULL,
  `telefono` varchar(9) NOT NULL,
  `fec_nacimiento` date NOT NULL,
  `sexo` varchar(9) NOT NULL,
  `est_civil` varchar(10) NOT NULL,
  `departamento` varchar(50) NOT NULL,
  `provincia` varchar(50) NOT NULL,
  `distrito` varchar(50) NOT NULL,
  `direccion` varchar(100) NOT NULL,
  `fec_registro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `persona`
--

INSERT INTO `persona` (`cod_persona`, `nombres`, `ape_paterno`, `ape_materno`, `dni`, `telefono`, `fec_nacimiento`, `sexo`, `est_civil`, `departamento`, `provincia`, `distrito`, `direccion`, `fec_registro`) VALUES
(1003, 'Jesus', 'Piscoya', 'Bances', '74644014', '910029102', '2001-05-03', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Ancón', 'Av. Lima 123', '2023-04-22 01:06:07'),
(1004, 'Maria', 'Mendoza', 'Lopez', '08452140', '998563214', '1998-05-12', 'Femenino', 'Casada', 'Lima', 'Lima', 'Independencia', 'Av. Independencia 456', '2023-04-22 05:07:14'),
(1005, 'VIOLETA', 'BANCES', 'VARGAS', '08618610', '985632145', '1989-08-15', 'Femenino', 'Casado', 'Cusco', 'Paruro', 'Accha', 'Av. Lima 123', '2023-04-22 06:19:03'),
(1006, 'ADRIAN MATHIAS', 'GAMARRA', 'HUAYMACARI', '78456454', '986523145', '1991-04-11', 'Masculino', 'Casado', 'Lima', 'Lima', 'Carabayllo', 'Luna Pizarro 123', '2023-04-22 06:48:49'),
(1007, 'JESUS RAFAEL', 'PISCOYA', 'BANCES', '74644014', '985550510', '2023-04-20', 'Masculino', 'Casado', 'Ica', 'Chincha', 'El Carmen', 'available direction 2', '2023-04-29 18:03:11'),
(1008, 'Oscar', 'Piscoya', 'Bances', '08618450', '998541236', '0000-00-00', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Ancón', 'Av. Lima 123', '2023-04-30 17:47:22');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `triaje`
--

CREATE TABLE `triaje` (
  `cod_triaje` int(11) NOT NULL,
  `cod_enfermera` int(11) NOT NULL,
  `cod_paciente` int(11) NOT NULL,
  `peso` float NOT NULL,
  `talla` int(3) NOT NULL,
  `temperatura` float NOT NULL,
  `presion` varchar(6) NOT NULL,
  `fec_registro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `triaje`
--

INSERT INTO `triaje` (`cod_triaje`, `cod_enfermera`, `cod_paciente`, `peso`, `talla`, `temperatura`, `presion`, `fec_registro`) VALUES
(2, 1000, 1000, 58.5, 160, 37, '120/80', '2023-05-04 05:26:10'),
(3, 1000, 1002, 60, 160, 37, '120/80', '2023-05-04 05:28:59'),
(4, 1000, 1002, 58, 152, 36.5, '120/80', '2023-05-06 03:37:50');

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
  ADD KEY `cod_enfermera` (`cod_enfermera`);

--
-- Indices de la tabla `enfermera`
--
ALTER TABLE `enfermera`
  ADD PRIMARY KEY (`cod_enfermera`),
  ADD KEY `cod_persona` (`cod_persona`);

--
-- Indices de la tabla `especialidad`
--
ALTER TABLE `especialidad`
  ADD PRIMARY KEY (`cod_especialidad`);

--
-- Indices de la tabla `historia_clinica`
--
ALTER TABLE `historia_clinica`
  ADD PRIMARY KEY (`nhc`);

--
-- Indices de la tabla `medico`
--
ALTER TABLE `medico`
  ADD PRIMARY KEY (`cod_medico`),
  ADD KEY `cod_persona` (`cod_persona`),
  ADD KEY `cod_especialidad` (`cod_especialidad`);

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
  MODIFY `cod_atencion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `enfermera`
--
ALTER TABLE `enfermera`
  MODIFY `cod_enfermera` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1002;

--
-- AUTO_INCREMENT de la tabla `especialidad`
--
ALTER TABLE `especialidad`
  MODIFY `cod_especialidad` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1003;

--
-- AUTO_INCREMENT de la tabla `historia_clinica`
--
ALTER TABLE `historia_clinica`
  MODIFY `nhc` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `medico`
--
ALTER TABLE `medico`
  MODIFY `cod_medico` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1001;

--
-- AUTO_INCREMENT de la tabla `paciente`
--
ALTER TABLE `paciente`
  MODIFY `cod_paciente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1003;

--
-- AUTO_INCREMENT de la tabla `persona`
--
ALTER TABLE `persona`
  MODIFY `cod_persona` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1009;

--
-- AUTO_INCREMENT de la tabla `triaje`
--
ALTER TABLE `triaje`
  MODIFY `cod_triaje` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `atencion`
--
ALTER TABLE `atencion`
  ADD CONSTRAINT `atencion_ibfk_1` FOREIGN KEY (`cod_paciente`) REFERENCES `paciente` (`cod_paciente`),
  ADD CONSTRAINT `atencion_ibfk_3` FOREIGN KEY (`cod_especialidad`) REFERENCES `especialidad` (`cod_especialidad`),
  ADD CONSTRAINT `atencion_ibfk_4` FOREIGN KEY (`cod_enfermera`) REFERENCES `enfermera` (`cod_enfermera`);

--
-- Filtros para la tabla `enfermera`
--
ALTER TABLE `enfermera`
  ADD CONSTRAINT `enfermera_ibfk_1` FOREIGN KEY (`cod_persona`) REFERENCES `persona` (`cod_persona`);

--
-- Filtros para la tabla `medico`
--
ALTER TABLE `medico`
  ADD CONSTRAINT `medico_ibfk_1` FOREIGN KEY (`cod_persona`) REFERENCES `persona` (`cod_persona`),
  ADD CONSTRAINT `medico_ibfk_2` FOREIGN KEY (`cod_especialidad`) REFERENCES `especialidad` (`cod_especialidad`);

--
-- Filtros para la tabla `paciente`
--
ALTER TABLE `paciente`
  ADD CONSTRAINT `paciente_ibfk_1` FOREIGN KEY (`cod_persona`) REFERENCES `persona` (`cod_persona`);

--
-- Filtros para la tabla `triaje`
--
ALTER TABLE `triaje`
  ADD CONSTRAINT `triaje_ibfk_1` FOREIGN KEY (`cod_enfermera`) REFERENCES `enfermera` (`cod_enfermera`),
  ADD CONSTRAINT `triaje_ibfk_2` FOREIGN KEY (`cod_paciente`) REFERENCES `paciente` (`cod_paciente`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

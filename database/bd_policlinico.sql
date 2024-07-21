-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 21-07-2024 a las 10:08:01
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.2.4

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
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarPassword` (IN `cod_personals` INT, IN `pass` VARCHAR(70))   BEGIN
UPDATE personal
SET password = pass
WHERE cod_personal = cod_personals;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarPersonal` (IN `cod_personals` INT, IN `correos` VARCHAR(100), IN `telefonos` VARCHAR(9), IN `direccions` VARCHAR(100))   BEGIN
UPDATE personal SET correo = correos
WHERE cod_personal = cod_personals;
SET @cod_per = (SELECT cod_persona FROM personal WHERE cod_personal = cod_personals);
UPDATE persona SET telefono = telefonos, direccion = direccions
WHERE cod_persona = @cod_per;

SELECT m.cod_personal, e.nom_especialidad, m.tipo_personal, p.nombres, p.ape_paterno, p.ape_materno, p.fec_nacimiento, m.correo, p.telefono, p.direccion
FROM personal m
INNER JOIN persona p
INNER JOIN especialidad e
ON m.cod_persona = p.cod_persona
WHERE m.cod_personal = cod_personals;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BuscarPaciente` (IN `dni` VARCHAR(8))   BEGIN
SELECT pa.cod_paciente, pa.nhc, pe.nombres, pe.ape_paterno, pe.ape_materno, DATE_FORMAT(pe.fec_nacimiento, '%d-%m-%Y') AS fec_nacimiento, pe.sexo, pe.est_civil, pa.tip_sangre, pa.don_organos
FROM paciente pa
INNER JOIN persona pe
ON pa.cod_persona = pe.cod_persona
WHERE pe.dni = dni;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BuscarTriaje` (IN `cod_triajes` INT)   BEGIN
SELECT * FROM triaje WHERE cod_triaje = cod_triajes;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListarAtencionesPendientes` ()   BEGIN
SELECT a.cod_atencion, a.cod_paciente, e.nom_especialidad, a.cod_triaje, pe.dni, pe.nombres, pe.ape_paterno, pe.ape_materno, a.fec_registro
FROM atencion a
INNER JOIN paciente pa
INNER JOIN especialidad e
INNER JOIN persona pe
ON a.cod_paciente = pa.cod_paciente AND a.cod_especialidad = e.cod_especialidad AND pa.cod_persona = pe.cod_persona
WHERE a.estado = 1 ORDER BY a.fec_registro;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListarEspecialidad` ()   BEGIN
SELECT * FROM especialidad;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListarHistorialAtenciones` (IN `cod_medicos` INT)   BEGIN
SELECT a.cod_atencion, a.cod_paciente, a.cod_triaje, pe.dni, pe.nombres, pe.ape_paterno, pe.ape_materno, a.fec_modificacion, a.sintomas, a.diagnostico, a.tratamiento, a.observaciones, a.examenes
FROM atencion a
INNER JOIN paciente pa
INNER JOIN persona pe
ON a.cod_paciente = pa.cod_paciente AND pa.cod_persona = pe.cod_persona
WHERE a.cod_medico = cod_medicos AND a.estado = 2
ORDER BY a.fec_modificacion DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListarTriajePendiente` ()   BEGIN
SELECT a.cod_atencion, pa.cod_paciente, a.cod_enfermera, pa.nhc, pe.dni, pe.nombres, pe.ape_paterno, pe.ape_materno, a.fec_registro
FROM atencion a
INNER JOIN paciente pa
INNER JOIN persona pe
ON a.cod_paciente = pa.cod_paciente AND pa.cod_persona = pe.cod_persona
WHERE a.estado = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `LoginPersonal` (IN `user` VARCHAR(20), IN `pass` VARCHAR(70))   BEGIN
SELECT m.cod_personal, e.nom_especialidad, m.tipo_personal, p.nombres, p.ape_paterno, p.ape_materno, p.fec_nacimiento, m.correo, p.telefono, p.direccion
FROM personal m
INNER JOIN persona p
INNER JOIN especialidad e
ON m.cod_persona = p.cod_persona
WHERE m.usuario = user AND m.password = pass;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ModificarAtencion` (IN `codigo` INT, IN `cod_medicos` INT, IN `sintomass` VARCHAR(200), IN `diagnosticos` VARCHAR(200), IN `tratamientos` VARCHAR(200), IN `observacioness` VARCHAR(200), IN `exameness` VARCHAR(200))   BEGIN
UPDATE atencion SET cod_medico = cod_medicos, sintomas = sintomass, diagnostico = diagnosticos, tratamiento = tratamientos, observaciones = observacioness, examenes = exameness, estado = 2, fec_modificacion = null
WHERE cod_atencion = codigo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistrarAtencion` (IN `cod_paciente` INT, IN `cod_especialidad` INT, IN `cod_enfermera` INT)   BEGIN
INSERT INTO atencion VALUES(null, cod_paciente, cod_especialidad, cod_enfermera, null, null, '', '', '', '', '', '', 0, null, null);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistrarEnfermera` (IN `nombre` VARCHAR(50), IN `paterno` VARCHAR(50), IN `materno` VARCHAR(50), IN `dni` VARCHAR(8), IN `telefono` VARCHAR(9), IN `nacimiento` DATE, IN `sexo` VARCHAR(9), IN `civil` VARCHAR(10), IN `departamento` VARCHAR(50), IN `provincia` VARCHAR(50), IN `distrito` VARCHAR(50), IN `direccion` VARCHAR(100), IN `colegiatura` INT, IN `correo` VARCHAR(100), IN `user` VARCHAR(20), IN `pass` VARCHAR(70))   BEGIN
INSERT INTO persona VALUES(null, nombre, paterno, materno, dni, telefono, nacimiento, sexo, civil, departamento, provincia, distrito, direccion, null);
SET @cod_per = (SELECT cod_persona FROM persona ORDER BY 1 DESC LIMIT 1);
INSERT INTO personal VALUES(null, @cod_per, null, 2, correo, user, SHA(pass));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistrarMedico` (IN `nombre` VARCHAR(50), IN `paterno` VARCHAR(50), IN `materno` VARCHAR(50), IN `dni` VARCHAR(8), IN `telefono` VARCHAR(9), IN `nacimiento` DATE, IN `sexo` VARCHAR(9), IN `civil` VARCHAR(10), IN `departamento` VARCHAR(50), IN `provincia` VARCHAR(50), IN `distrito` VARCHAR(50), IN `direccion` VARCHAR(100), IN `cod_especialidad` INT, IN `correo` VARCHAR(100), IN `user` VARCHAR(20), IN `pass` VARCHAR(70))   BEGIN
INSERT INTO persona VALUES(null, nombre, paterno, materno, dni, telefono, nacimiento, sexo, civil, departamento, provincia, distrito, direccion, null);
SET @cod_per = (SELECT cod_persona FROM persona ORDER BY 1 DESC LIMIT 1);
INSERT INTO personal VALUES(null, @cod_per, cod_especialidad, 1, correo, user, SHA(pass));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistrarPaciente` (IN `nombre` VARCHAR(50), IN `paterno` VARCHAR(50), IN `materno` VARCHAR(50), IN `dni` VARCHAR(8), IN `telefono` VARCHAR(9), IN `nacimiento` DATE, IN `sexo` VARCHAR(9), IN `civil` VARCHAR(10), IN `departamento` VARCHAR(50), IN `provincia` VARCHAR(50), IN `distrito` VARCHAR(50), IN `direccion` VARCHAR(100), IN `nhc` INT, IN `sangre` VARCHAR(3), IN `organos` VARCHAR(2))   BEGIN
INSERT INTO persona VALUES(null, nombre, paterno, materno, dni, telefono, nacimiento, sexo, civil, departamento, provincia, distrito, direccion, null);
SET @cod_per = (SELECT cod_persona FROM persona ORDER BY 1 DESC LIMIT 1);
INSERT INTO paciente VALUES(null, nhc, @cod_per, sangre, organos);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistrarTriaje` (IN `cod_atencions` INT, IN `cod_enfermera` INT, IN `cod_pacientes` INT, IN `peso` VARCHAR(6), IN `talla` VARCHAR(4), IN `temperatura` VARCHAR(4), IN `presion` VARCHAR(6))   BEGIN
INSERT INTO triaje VALUES(null, cod_enfermera, cod_pacientes, peso, talla, temperatura, presion, null);
SET @cod_triaje = (SELECT cod_triaje FROM triaje WHERE cod_paciente = cod_pacientes ORDER BY 1 DESC LIMIT 1);
UPDATE atencion SET cod_triaje = @cod_triaje, estado = 1 WHERE cod_atencion = cod_atencions;
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
  `cod_triaje` int(11) DEFAULT NULL,
  `cod_medico` int(11) DEFAULT NULL,
  `sintomas` varchar(200) DEFAULT NULL,
  `diagnostico` varchar(200) DEFAULT NULL,
  `tratamiento` varchar(200) DEFAULT NULL,
  `observaciones` varchar(200) DEFAULT NULL,
  `examenes` varchar(200) DEFAULT NULL,
  `estado` tinyint(1) NOT NULL,
  `fec_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  `fec_modificacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `atencion`
--

INSERT INTO `atencion` (`cod_atencion`, `cod_paciente`, `cod_especialidad`, `cod_enfermera`, `cod_triaje`, `cod_medico`, `sintomas`, `diagnostico`, `tratamiento`, `observaciones`, `examenes`, `estado`, `fec_registro`, `fec_modificacion`) VALUES
(6, 1004, 1004, 1002, 4, 1001, 'Diarrea\nNáuseas', 'Infección estomacal', 'Metronidazol c/9 horas\nalbendazol c/ 12 horas\nX 2 días', '-', '-', 2, '2023-06-19 14:12:49', '2023-06-19 14:32:03'),
(7, 1005, 1004, 1002, 5, 1001, 'fiebre, dolor de cabeza, malestar de cuerpo y congestión nasal.', 'Gripe ', 'Tomar paracetamol, fenilefrina y zanamivir.', 'Tomar bebidas calientes , abrigarse bien.', '-', 2, '2023-06-19 14:29:43', '2023-06-19 14:53:25'),
(8, 1006, 1005, 1002, 6, 1001, 'Dolor al orinar\nsangrado inusual', 'Quistes en los ovarios', 'Analgésicos c/ 8 horas después de comidas\nx 7 días', '-', 'Ecografía', 2, '2023-06-19 14:42:45', '2023-06-19 15:05:20'),
(9, 1007, 1004, 1002, 7, 1001, 'Cansancio\nFatiga\nSueño seguido\nPiel pálida', 'Anemia', 'Hierro en cápsulas\nDieta balanceada\nEvitar dulces, harinas y alcohol', '-', 'Test de sangre', 2, '2023-06-19 14:57:03', '2023-06-19 15:19:01'),
(10, 1008, 1006, 1002, 8, 1001, 'Visión borrosa\nDolor de cabeza\nOjos rojos', 'Miopía\nAstigmatismo', 'Lentes permanentes', '-', 'Medida de vista', 2, '2023-06-19 15:08:41', '2023-06-19 15:33:15'),
(11, 1009, 1004, 1002, 9, 1001, 'Fiebre alta, tos', 'se realizaron las pruebas médicas y se detecto covid', ' una azitromicina diaria', 'sin obervaciones', 'ok', 2, '2023-06-19 15:23:55', '2023-06-19 15:43:34'),
(12, 1010, 1006, 1002, 10, 1001, 'dolor de brazo y dolor de corazón', 'se evaluó al paciente y se identifico una simple fatiga muscular', 'ampoya de omeprazol preventiva', 'sin observaciones ', 'exámen general', 2, '2023-06-19 15:37:53', '2023-06-19 16:01:11'),
(13, 1011, 1006, 1002, 11, 1001, 'dolor de cabeza', 'se evaluó y se identifico que el paciente presenta migraña', 'dosis de ibuprofeno 2 diarias durante 2 semanas', '\nNA', 'n\nNA', 2, '2023-06-19 15:50:48', '2023-06-19 16:11:41'),
(14, 1012, 1004, 1002, 12, 1001, 'dolor de espalda, frío en la espalda', 'se identifico al paciente con principios de neurona atípica. ', 'se realizó una nebulización al paciente y se dió de alta', 'sin obs', 'exámen general ', 2, '2023-06-19 16:02:57', '2023-06-19 16:23:14'),
(15, 1013, 1006, 1002, 13, 1001, 'Dolor estómago\nHinchazón abdominal', 'Helicobacter', 'Amoxicilina 1 diaria / 7 días\nOmeprazol 1 diaria / 7 días\n', 'Sin obs', 'Test estomacal', 2, '2023-06-19 16:19:02', '2023-06-19 16:41:45'),
(16, 1014, 1004, 1002, 14, 1001, 'Aparición de ronchas\nPicor', 'Intoxicación alérgica', 'Cetirizina 2 diarias mañana noche / 7 días\n', 'Sin obs', 'Prueba de sangre ', 2, '2023-06-19 16:35:03', '2023-06-19 16:56:23'),
(17, 1015, 1005, 1002, 15, 1001, 'náuseas y mareos ', 'el resultado de la prueba de embarazo de la paciente es positivo.', 'no aplica', 'sin observaciones ', 'prueba de sangre', 2, '2023-06-19 16:47:23', '2023-06-19 17:10:51'),
(18, 1016, 1006, 1002, 16, 1001, 'Dolor de cabeza\nvisión borrosa', 'Miopía', 'Lentes permanentes', '-', 'Medida de ojos', 2, '2023-06-19 16:59:16', '2023-06-19 17:20:27'),
(19, 1017, 1004, 1002, 17, 1000, 'aa', 'aa', 'aa', 'aa', 'aa', 2, '2023-06-19 17:11:40', '2023-07-22 22:48:03'),
(20, 1018, 1004, 1002, 18, 1001, 'Dolor y molestia en la parte superior del abdomen, náuseas y vómitos.', 'Gastritis ', 'Tomar Omeprazol por 30 días, media hora antes del desayuno.', 'No ingerir cítricos, ají,etc.. comer a la hora correcta.', 'endoscopia gastrointestinal.', 2, '2023-06-19 20:07:56', '2023-06-19 20:30:33'),
(21, 1019, 1004, 1002, 19, NULL, '', '', '', '', '', 1, '2023-06-19 20:19:20', '2023-06-21 16:44:20'),
(22, 1020, 1004, 1002, 20, 1001, 'Dolor de garganta, malestar de cuerpo, fiebre, dolor al ingerir comida.', 'Infección de garganta por estreptococos ', 'Tomar Amoxicilina/Ácido clavulánico200 mg cada 8 horas.', 'Beber mucho líquido mientras recibe amoxicilina/ácido clavulánico.', '-', 2, '2023-06-19 20:33:46', '2023-06-19 20:56:22'),
(23, 1021, 1004, 1002, 21, NULL, '', '', '', '', '', 1, '2023-06-19 20:49:46', '2023-06-21 17:02:46'),
(24, 1022, 1006, 1002, 22, 1001, 'Vista nublada', 'Astigmatismo ambos ojos', 'Uso de anteojos permanente', 'Sin obs', 'Prueba de vista', 2, '2023-06-19 21:03:17', '2023-06-19 21:24:22'),
(25, 1023, 1004, 1002, 23, NULL, '', '', '', '', '', 1, '2023-06-19 21:19:52', '2023-06-21 17:31:52'),
(26, 1024, 1008, 1002, 24, NULL, '', '', '', '', '', 1, '2023-06-20 13:33:35', '2023-06-21 18:11:35'),
(27, 1025, 1006, 1002, 25, NULL, '', '', '', '', '', 1, '2023-06-20 13:47:42', '2023-06-21 18:13:42'),
(28, 1026, 1004, 1002, 26, NULL, '', '', '', '', '', 1, '2023-06-20 13:55:30', '2023-06-21 18:16:30'),
(29, 1030, 1004, 1002, 27, 1001, 'Dolor de vientre', 'Principio de gastritis', 'omeprazol antes de comer\nclaritromicina después de comer\ndieta, sin cítricos, grasas y condimentos\nx 1 mes\n', 'Cita para 19 de Julio', 'Endoscopía', 2, '2023-06-20 14:12:27', '2023-06-20 14:27:42'),
(30, 1031, 1008, 1002, 28, NULL, '', '', '', '', '', 1, '2023-06-20 14:28:37', '2023-06-21 18:24:37'),
(31, 1032, 1006, 1002, 29, NULL, '', '', '', '', '', 1, '2023-06-20 14:40:17', '2023-06-21 18:26:17'),
(32, 1033, 1005, 1002, 30, NULL, '', '', '', '', '', 1, '2023-06-20 14:53:44', '2023-06-21 18:27:44'),
(33, 1034, 1004, 1002, 31, NULL, '', '', '', '', '', 1, '2023-06-20 15:14:42', '2023-06-21 18:28:42'),
(34, 1035, 1008, 1002, 32, NULL, '', '', '', '', '', 1, '2023-06-20 15:29:41', '2023-06-21 18:29:41'),
(35, 1027, 1006, 1002, 33, NULL, '', '', '', '', '', 1, '2023-06-20 15:37:36', '2023-06-21 18:38:36'),
(36, 1028, 1004, 1002, 34, NULL, '', '', '', '', '', 1, '2023-06-20 15:52:27', '2023-06-21 18:39:27'),
(37, 1029, 1006, 1002, 35, NULL, '', '', '', '', '', 1, '2023-06-20 16:09:55', '2023-06-21 18:40:55'),
(38, 1036, 1004, 1002, 36, NULL, '', '', '', '', '', 1, '2023-06-20 16:24:04', '2023-06-21 18:50:04'),
(39, 1037, 1006, 1002, 37, NULL, '', '', '', '', '', 1, '2023-06-20 16:37:18', '2023-06-21 18:52:18'),
(40, 1038, 1008, 1002, 38, NULL, '', '', '', '', '', 1, '2023-06-20 16:52:19', '2023-06-21 18:53:19'),
(41, 1039, 1004, 1002, 39, NULL, '', '', '', '', '', 1, '2023-06-20 17:14:06', '2023-06-21 18:55:06'),
(42, 1040, 1006, 1002, 41, NULL, '', '', '', '', '', 1, '2023-06-20 20:03:46', '2023-06-21 18:56:46'),
(43, 1041, 1005, 1002, 40, NULL, '', '', '', '', '', 1, '2023-06-20 20:15:11', '2023-06-21 18:59:11'),
(44, 1042, 1003, 1002, 42, 1001, 'Dolor de muela ', 'Extracción de muela picada', 'Luego de la extracción tomar naproxeno y Dicloxacilina.', '-', '-', 2, '2023-06-20 20:29:56', '2023-06-24 02:59:12'),
(45, 1043, 1009, 1002, 43, NULL, '', '', '', '', '', 1, '2023-06-20 20:42:35', '2023-06-21 19:06:35'),
(46, 1044, 1003, 1002, 44, 1001, 'Dolor intenso de muela y encía.', 'Extraer muela de juicio', 'Después de la extracción tomar Naproxeno y Dicloxacilina.', '-', '-', 2, '2023-06-21 14:05:29', '2023-06-24 03:01:24'),
(47, 1045, 1006, 1002, 45, NULL, '', '', '', '', '', 1, '2023-06-21 14:18:18', '2023-06-21 19:20:18'),
(48, 1046, 1004, 1002, 46, NULL, '', '', '', '', '', 1, '2023-06-21 14:32:47', '2023-06-21 19:21:47'),
(49, 1047, 1004, 1002, 47, NULL, '', '', '', '', '', 1, '2023-06-21 14:47:25', '2023-06-21 14:47:25'),
(50, 1048, 1000, 1002, 48, 1001, 'dolor fuerte de cabeza, vómitos.', 'Realizar un encefalograma', '\n-', '-', '-', 2, '2023-06-21 14:58:26', '2023-06-24 02:53:34'),
(51, 1049, 1004, 1002, 55, NULL, '', '', '', '', '', 1, '2023-06-21 15:14:30', '2023-06-21 20:13:30'),
(52, 1050, 1006, 1002, 56, NULL, '', '', '', '', '', 1, '2023-06-21 15:28:15', '2023-06-21 20:18:15'),
(53, 1051, 1006, 1002, 59, NULL, '', '', '', '', '', 1, '2023-06-21 15:43:23', '2023-06-21 20:19:23'),
(54, 1052, 1004, 1002, 61, NULL, '', '', '', '', '', 1, '2023-06-21 16:03:35', '2023-06-21 20:20:35'),
(55, 1053, 1004, 1002, 62, NULL, '', '', '', '', '', 1, '2023-06-21 16:18:22', '2023-06-21 20:23:22'),
(56, 1054, 1004, 1002, 58, NULL, '', '', '', '', '', 1, '2023-06-21 16:30:35', '2023-06-21 20:24:35'),
(57, 1055, 1006, 1002, 63, NULL, '', '', '', '', '', 1, '2023-06-21 16:38:02', '2023-06-21 20:26:02'),
(58, 1056, 1004, 1002, 54, NULL, '', '', '', '', '', 1, '2023-06-21 16:54:26', '2023-06-21 20:33:26'),
(59, 1057, 1009, 1002, 53, NULL, '', '', '', '', '', 1, '2023-06-21 17:08:43', '2023-06-21 20:34:43'),
(60, 1058, 1004, 1002, 57, NULL, '', '', '', '', '', 1, '2023-06-21 20:05:44', '2023-06-21 20:34:44'),
(61, 1059, 1006, 1002, 51, NULL, '', '', '', '', '', 1, '2023-06-21 20:19:47', '2023-06-21 20:35:47'),
(62, 1060, 1004, 1002, 52, NULL, '', '', '', '', '', 1, '2023-06-21 20:33:22', '2023-06-21 20:36:22'),
(63, 1061, 1004, 1002, 50, NULL, '', '', '', '', '', 1, '2023-06-21 20:47:23', '2023-06-21 20:39:23'),
(64, 1062, 1006, 1002, 60, NULL, '', '', '', '', '', 1, '2023-06-21 21:02:31', '2023-06-21 20:40:31'),
(65, 1063, 1004, 1002, 49, NULL, '', '', '', '', '', 1, '2023-06-21 21:19:09', '2023-06-21 20:43:09'),
(66, 1067, 1006, 1002, 67, NULL, '', '', '', '', '', 1, '2023-06-22 13:38:07', '2023-06-21 20:45:07'),
(67, 1068, 1004, 1002, 64, NULL, '', '', '', '', '', 1, '2023-06-22 13:46:05', '2023-06-21 20:50:05'),
(68, 1064, 1006, 1002, 65, NULL, '', '', '', '', '', 1, '2023-06-22 13:59:12', '2023-06-21 20:51:12'),
(69, 1069, 1006, 1002, 66, NULL, '', '', '', '', '', 1, '2023-06-22 14:13:06', '2023-06-21 20:53:06'),
(70, 1070, 1004, 1002, 68, NULL, '', '', '', '', '', 1, '2023-06-22 14:25:43', '2023-06-21 20:56:43'),
(71, 1071, 1009, 1002, 69, NULL, '', '', '', '', '', 1, '2023-06-22 14:37:29', '2023-06-21 21:10:29'),
(72, 1072, 1004, 1002, 70, NULL, '', '', '', '', '', 1, '2023-06-22 14:48:40', '2023-06-21 21:11:40'),
(73, 1073, 1009, 1002, 84, NULL, '', '', '', '', '', 1, '2023-06-22 14:53:44', '2023-06-21 21:11:44'),
(74, 1074, 1003, 1002, 71, 1001, 'Dolor al morder y masticar e hipersensibilidad dental.', 'Realizar endodoncia ', 'Venir 3 días consecutivos para el proceso de curación.', 'Evita masticar alimentos duros o pegajosos directamente sobre la pieza.', 'Realizar una mesiorradial.', 2, '2023-06-22 15:12:11', '2023-06-24 03:11:40'),
(75, 1075, 1005, 1002, 72, NULL, '', '', '', '', '', 1, '2023-06-22 15:28:27', '2023-06-21 21:13:27'),
(76, 1076, 1004, 1002, 85, NULL, '', '', '', '', '', 1, '2023-06-22 15:42:58', '2023-06-21 21:14:58'),
(77, 1077, 1009, 1002, 89, NULL, '', '', '', '', '', 1, '2023-06-22 15:57:02', '2023-06-21 21:15:02'),
(78, 1078, 1004, 1002, 93, NULL, '', '', '', '', '', 1, '2023-06-22 16:07:31', '2023-06-21 21:16:31'),
(79, 1079, 1004, 1002, 80, NULL, '', '', '', '', '', 1, '2023-06-22 16:19:35', '2023-06-21 21:16:35'),
(80, 1080, 1004, 1002, 81, NULL, '', '', '', '', '', 1, '2023-06-22 16:24:07', '2023-06-21 21:18:07'),
(81, 1081, 1006, 1002, 79, NULL, '', '', '', '', '', 1, '2023-06-22 16:48:21', '2023-06-21 21:18:21'),
(82, 1082, 1009, 1002, 95, NULL, '', '', '', '', '', 1, '2023-06-22 17:13:48', '2023-06-21 21:19:48'),
(83, 1083, 1006, 1002, 96, NULL, '', '', '', '', '', 1, '2023-06-22 20:08:10', '2023-06-21 21:20:10'),
(84, 1084, 1009, 1002, 98, NULL, '', '', '', '', '', 1, '2023-06-22 20:17:58', '2023-06-21 21:20:58'),
(85, 1085, 1006, 1002, 99, NULL, '', '', '', '', '', 1, '2023-06-22 20:30:16', '2023-06-21 21:23:16'),
(86, 1086, 1002, 1002, 100, 1001, 'dolor de oído.', 'lavado de oído.', '-', '-', '-', 2, '2023-06-23 13:33:54', '2023-06-24 02:56:34'),
(87, 1087, 1004, 1002, 94, NULL, '', '', '', '', '', 1, '2023-06-23 13:46:41', '2023-06-21 21:27:41'),
(88, 1088, 1006, 1002, 78, NULL, '', '', '', '', '', 1, '2023-06-23 13:58:47', '2023-06-21 21:30:47'),
(89, 1089, 1004, 1002, 92, NULL, '', '', '', '', '', 1, '2023-06-23 14:07:53', '2023-06-21 21:32:53'),
(90, 1090, 1008, 1002, 90, 1001, 'Dolor y sensibilidad de talones', 'Tendinitis ', 'Necesita Fisioterapia y tomar naproxeno 500 mg cada 9 horas', 'Tomar descanso, evitar esfuerzos, aplicar hielo sobre la zona de dolor.', '-', 2, '2023-06-23 14:20:52', '2023-07-01 08:04:19'),
(91, 1091, 1003, 1002, 83, 1001, '-', 'Aplicar flúor dental', '-', 'Evitar comer por 2 horas', '-', 2, '2023-06-23 14:26:48', '2023-06-24 03:24:49'),
(92, 1092, 1004, 1002, 97, NULL, '', '', '', '', '', 1, '2023-06-23 14:39:44', '2023-06-21 21:40:44'),
(93, 1093, 1003, 1002, 87, 1001, 'Dolor de muela', 'Curación de 2 dientes', 'tomar Dicloxacilina y naproxeno c/9 horas', 'No comer por 2 horas', '-', 2, '2023-06-23 14:53:54', '2023-06-24 03:26:17'),
(94, 1094, 1008, 1002, 82, 1001, 'Dolor intenso y postura encorvada de espalda.', 'Osteoporosis ', 'Aplicarse ácido zoledrónico Zometa anualmente y tomar Boniva de 800 mg mensual', '-', 'Densitometría ósea', 2, '2023-06-23 15:12:59', '2023-07-01 08:22:23'),
(96, 1095, 1004, 1002, 77, NULL, '', '', '', '', '', 1, '2023-06-23 15:27:25', '2023-06-22 04:13:25'),
(97, 1097, 1005, 1002, 101, NULL, '', '', '', '', '', 1, '2023-06-23 15:38:49', '2023-06-22 04:35:49'),
(98, 1098, 1004, 1002, 102, NULL, '', '', '', '', '', 1, '2023-06-23 15:45:50', '2023-06-22 04:36:50'),
(99, 1099, 1006, 1002, 76, NULL, '', '', '', '', '', 1, '2023-06-23 16:04:10', '2023-06-22 04:38:10'),
(100, 1100, 1006, 1002, 88, 1001, 'Dolor y picazón de ojos, lagrimeo excesivo.', 'Astigmatismo ', 'Uso de lentes a medida', 'Usar lentes sobre todo al usar equipos tecnológicos.', 'Prueba de agudeza visual', 2, '2023-06-23 16:16:02', '2023-07-01 08:13:07'),
(101, 1101, 1008, 1002, 75, NULL, '', '', '', '', '', 1, '2023-06-23 16:28:40', '2023-06-22 04:50:40'),
(102, 1102, 1004, 1002, 103, 1001, 'Fátiga, mareos, debilidad, piel amarillenta.', 'Anemia', 'Tomar ácido fólico y vitamina C', '-', 'Hemograma completo', 2, '2023-06-23 16:34:47', '2023-07-01 08:09:20'),
(103, 1103, 1005, 1002, 91, 1001, 'Pequeñas manchas marrones, fátiga, micción frecuente.', 'Exámen de embarazo positivo', '-', '-', 'Análisis de sangre.', 2, '2023-06-23 16:52:47', '2023-07-01 07:57:46'),
(104, 1104, 1005, 1002, 86, NULL, '', '', '', '', '', 1, '2023-06-23 17:05:26', '2023-06-22 04:54:26'),
(105, 1105, 1006, 1002, 74, NULL, '', '', '', '', '', 1, '2023-06-23 20:07:22', '2023-06-22 04:55:22'),
(106, 1106, 1004, 1002, 73, 1001, 'fiebre', 'se diagnosticó a la paciente con una gripe', 'se recetó que tome dos dosis de panadol diarias', 'sin obs', 'no aplica ', 2, '2023-06-23 20:14:35', '2023-06-25 03:42:42');

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
(1004, 10000, 1009, 'O+', 'No'),
(1005, 10000, 1010, 'O-', 'No'),
(1006, 10000, 1011, 'AB+', 'No'),
(1007, 10000, 1012, 'O+', 'No'),
(1008, 10000, 1013, 'B+', 'No'),
(1009, 10000, 1014, 'B+', 'No'),
(1010, 10000, 1015, 'O+', 'No'),
(1011, 10000, 1016, 'AB+', 'No'),
(1012, 10000, 1017, 'B+', 'No'),
(1013, 10000, 1018, 'O+', 'No'),
(1014, 10000, 1019, 'B+', 'No'),
(1015, 10000, 1020, 'O+', 'No'),
(1016, 10000, 1021, 'B+', 'No'),
(1017, 10000, 1022, 'O+', 'No'),
(1018, 10000, 1023, 'A+', 'No'),
(1019, 10000, 1024, 'AB+', 'No'),
(1020, 10000, 1025, 'O+', 'No'),
(1021, 10000, 1026, 'O+', 'No'),
(1022, 10000, 1027, 'AB+', 'No'),
(1023, 10000, 1028, 'O+', 'No'),
(1024, 10000, 1029, 'O+', 'No'),
(1025, 10000, 1030, 'B+', 'No'),
(1026, 10000, 1031, 'AB+', 'No'),
(1027, 10000, 1032, 'AB+', 'No'),
(1028, 10000, 1033, 'A-', 'No'),
(1029, 10000, 1034, 'AB+', 'No'),
(1030, 10000, 1035, 'O+', 'No'),
(1031, 10000, 1036, 'AB+', 'No'),
(1032, 10000, 1037, 'O+', 'No'),
(1033, 10000, 1038, 'O+', 'No'),
(1034, 10000, 1039, 'AB+', 'No'),
(1035, 10000, 1040, 'A-', 'No'),
(1036, 10000, 1041, 'B+', 'No'),
(1037, 10000, 1042, 'O+', 'No'),
(1038, 10000, 1043, 'AB+', 'No'),
(1039, 10000, 1044, 'A+', 'No'),
(1040, 10000, 1045, 'B-', 'No'),
(1041, 10000, 1046, 'O+', 'No'),
(1042, 10000, 1047, 'B-', 'No'),
(1043, 10000, 1048, 'O+', 'No'),
(1044, 10000, 1049, 'B-', 'No'),
(1045, 10000, 1050, 'B+', 'No'),
(1046, 10000, 1051, 'B+', 'No'),
(1047, 10000, 1052, 'O+', 'No'),
(1048, 10000, 1053, 'A+', 'No'),
(1049, 10000, 1054, 'A+', 'No'),
(1050, 10000, 1055, 'AB-', 'No'),
(1051, 10000, 1056, 'B-', 'No'),
(1052, 10000, 1057, 'B+', 'No'),
(1053, 10000, 1058, 'A-', 'No'),
(1054, 10000, 1059, 'O-', 'No'),
(1055, 10000, 1060, 'O+', 'No'),
(1056, 10000, 1061, 'B-', 'No'),
(1057, 10000, 1062, 'B-', 'Sí'),
(1058, 10000, 1063, 'A+', 'No'),
(1059, 10000, 1064, 'A-', 'Sí'),
(1060, 10000, 1065, 'AB+', 'Sí'),
(1061, 10000, 1066, 'B+', 'No'),
(1062, 10000, 1067, 'O-', 'No'),
(1063, 10000, 1068, 'O-', 'No'),
(1064, 10000, 1069, 'B+', 'No'),
(1067, 10000, 1072, 'B+', 'No'),
(1068, 10000, 1073, 'O-', 'No'),
(1069, 10000, 1074, 'O+', 'Sí'),
(1070, 10000, 1075, 'B+', 'No'),
(1071, 10000, 1076, 'B+', 'Sí'),
(1072, 10000, 1077, 'O-', 'No'),
(1073, 10000, 1078, 'AB+', 'No'),
(1074, 10000, 1079, 'B-', 'No'),
(1075, 10000, 1080, 'B+', 'No'),
(1076, 10000, 1081, 'B+', 'No'),
(1077, 10000, 1082, 'A+', 'No'),
(1078, 10000, 1083, 'O-', 'No'),
(1079, 10000, 1084, 'O-', 'No'),
(1080, 10000, 1085, 'O+', 'No'),
(1081, 10000, 1086, 'AB+', 'No'),
(1082, 10000, 1087, 'B+', 'No'),
(1083, 10000, 1088, 'B+', 'No'),
(1084, 10000, 1089, 'B-', 'No'),
(1085, 10000, 1090, 'B-', 'No'),
(1086, 10000, 1091, 'B-', 'No'),
(1087, 10000, 1092, 'A+', 'No'),
(1088, 10000, 1093, 'B-', 'No'),
(1089, 10000, 1094, 'B+', 'No'),
(1090, 10000, 1095, 'O-', 'No'),
(1091, 10000, 1096, 'AB-', 'No'),
(1092, 10000, 1097, 'B+', 'No'),
(1093, 10000, 1098, 'A-', 'Sí'),
(1094, 10000, 1099, 'A+', 'No'),
(1095, 10000, 1101, 'O+', 'No'),
(1097, 10000, 1102, 'O-', 'Sí'),
(1098, 10000, 1103, 'AB-', 'No'),
(1099, 10000, 1104, 'A-', 'No'),
(1100, 10000, 1105, 'O+', 'No'),
(1101, 10000, 1106, 'AB+', 'Sí'),
(1102, 10000, 1107, 'AB-', 'No'),
(1103, 10000, 1108, 'O+', 'No'),
(1104, 10000, 1109, 'O+', 'No'),
(1105, 10000, 1110, 'B-', 'No'),
(1106, 10000, 1111, 'AB-', 'No'),
(1107, 10000, 1112, 'B+', 'Sí');

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
(1000, 'Jesus', 'Piscoya', 'Bances', '74644014', '999999999', '2001-05-03', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Ancón', 'Av. Lima 123', '2023-04-22 01:06:07'),
(1001, 'Maria', 'Mendoza', 'Lopez', '08452140', '998563214', '1998-05-12', 'Femenino', 'Casada', 'Lima', 'Lima', 'Independencia', 'Av. Independencia 456', '2023-04-22 05:07:14'),
(1005, 'Oscar', 'Piscoya', 'Bances', '08618450', '998541236', '0000-00-00', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Ancón', 'Av. Lima 123', '2023-04-30 17:47:22'),
(1007, 'Rosany', 'Flores', 'Lizana', '41789497', '925163254', '0000-00-00', 'Femenino', 'Casada', 'Lima', 'Lima', 'Independencia', 'Av. Las Américas 435', '2023-06-17 17:28:12'),
(1008, 'Edwin', 'Fuertes', 'Escudero', '06288559', '986321485', '0000-00-00', 'Masculino', 'Casado', 'Lima', 'Lima', 'San Marín de Porres', 'Jr. Santa Catalina 532', '2023-06-17 17:52:21'),
(1009, 'JUAN MOISES', 'CHIROQUE', 'SALAZAR', '08495156', '985521456', '1985-02-03', 'Masculino', 'Casado', 'Lima', 'Lima', 'Carabayllo', 'Jirón San Martín 326', '2023-06-19 14:11:15'),
(1010, 'EDITH HILDA', 'SOLIER', 'QUISPE', '08484881', '995541151', '1982-11-10', 'Femenino', 'Divorciado', 'Lima', 'Lima', 'Comas', 'AV MARISCAL CASTILLA 2720', '2023-06-19 14:28:14'),
(1011, 'FLABIA EMPERATRIZ', 'LAVADO', 'DE SANTOS', '09847515', '985541266', '1994-10-03', 'Femenino', 'Soltero', 'Lima', 'Lima', 'Los Olivos', 'Calle Colón 167', '2023-06-19 14:41:16'),
(1012, 'ALEXIS BERNARDO', 'DIAZ', 'GARCIA', '72012656', '986665215', '1997-03-29', 'Masculino', 'Soltero', 'Lima', 'Lima', 'San Martín de Porres', 'Jirón Santa Catalina 532', '2023-06-19 14:56:38'),
(1013, 'CHARLES', 'CURITIMA', 'CURITIMA', '76328545', '998651115', '1989-07-15', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Comas', 'AV TUPAC AMARU 8189', '2023-06-19 15:08:03'),
(1014, 'DE MIRANDA MAGNOLIA BELLA', 'MONTERO', 'MEZA', '08654515', '996587715', '1978-12-15', 'Femenino', 'Viudo', 'Lima', 'Lima', 'Los Olivos', 'Calle El Altillo 116', '2023-06-19 15:22:31'),
(1015, 'HAYDEE OFELIA', 'CHUMPITAZI', 'DE', '07545815', '995515892', '1982-01-14', 'Femenino', 'Casado', 'Lima', 'Lima', 'Carabayllo', 'Jr Dulanto 136', '2023-06-19 15:37:27'),
(1016, 'YADHIRA BEATRIZ', 'BENDITA', 'MANRIQUE', '72115696', '986523145', '1995-05-24', 'Femenino', 'Soltero', 'Lima', 'Lima', 'San Martín de Porres', 'JR ORTIZ ARRIETA 792', '2023-06-19 15:49:34'),
(1017, 'CESAR DAVID', 'AZUCENA', 'SARMIENTO', '08541215', '986516546', '1977-05-16', 'Masculino', 'Casado', 'Lima', 'Lima', 'San Martín de Porres', 'Avenida Luis Gonzales 766', '2023-06-19 16:02:17'),
(1018, 'FRANK', 'MORALES', 'IPUSHIMA', '76895527', '986632154', '1991-04-06', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Comas', 'JR JOSE SABOGAL 973', '2023-06-19 16:18:46'),
(1019, 'IRMA ROMMY', 'HAYEN', 'TRISTAN', '08541548', '981565465', '1988-06-14', 'Femenino', 'Casado', 'Lima', 'Lima', 'Los Olivos', 'Av Jose Maria Eguren 620', '2023-06-19 16:34:51'),
(1020, 'TERESA', 'HERRERA', 'OLIVA', '07851225', '974851623', '1975-09-18', 'Femenino', 'Casado', 'Lima', 'Lima', 'Los Olivos', 'Av. Palmeras 354', '2023-06-19 16:46:55'),
(1021, 'IVAN GUSTAVO', 'ALVAREZ', 'DAMIAN', '76841266', '982641457', '1989-11-12', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Los Olivos', 'Jirón Pachitea 255', '2023-06-19 16:58:58'),
(1022, 'VDA DE SOTOMAYOR MARLENE', 'BERNAL', 'SIMBRON', '08544512', '987465126', '1971-05-25', 'Femenino', 'Casado', 'Lima', 'Lima', 'Independencia', 'Calle San Federico 354', '2023-06-19 17:10:31'),
(1023, 'VALENTIN', 'CORTEZ', 'CHUNQUE', '07512323', '985111266', '1968-06-08', 'Masculino', 'Casado', 'Lima', 'Lima', 'Carabayllo', 'JR HUIRACOCHA 229', '2023-06-19 20:06:23'),
(1024, 'JUANA ISABEL', 'RIOS', 'REQUEJO', '08456315', '998544156', '1970-09-11', 'Femenino', 'Casado', 'Lima', 'Lima', 'Los Olivos', 'Avenida Luis Gonzales 766', '2023-06-19 20:18:58'),
(1025, 'ELOISA ELIZABETH', 'CASTRO', 'AZNARAN', '08101158', '989133664', '1968-12-01', 'Femenino', 'Casado', 'Lima', 'Lima', 'Los Olivos', 'Av Jose Maria 620', '2023-06-19 20:32:33'),
(1026, 'ROSA PATRICIA', 'SANCHEZ', 'FLORES', '08541152', '998551136', '1968-05-10', 'Femenino', 'Casado', 'Lima', 'Lima', 'Los Olivos', 'Jirón Huancavelica 342', '2023-06-19 20:48:26'),
(1027, 'CARLOS PEDRO', 'TIBURCIO', 'HUERTA', '08641226', '986632554', '1982-04-12', 'Masculino', 'Casado', 'Lima', 'Lima', 'Los Olivos', 'Calle Bolognesi 156', '2023-06-19 21:02:46'),
(1028, 'JEAN STEFANO', 'HUALLASCA', 'DE LA CRUZ', '76882421', '998532165', '1998-05-08', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Carabayllo', 'Calle Leoncio Prado 584', '2023-06-19 21:18:12'),
(1029, 'GUADALUPE SOLEDAD', 'ESPINOZA', 'ULLOA', '25818535', '926586958', '1968-06-20', 'Femenino', 'Soltero', 'Lima', 'Lima', 'Puente Piedra', 'Av.buenos aires 284', '2023-06-20 13:32:09'),
(1030, 'JESUS', 'REYES', 'AGURTO', '45896587', '967586532', '1970-03-07', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Los Olivos', 'Av. las begonias 76', '2023-06-20 13:46:17'),
(1031, 'MILAGROS NOEMI', 'PUERTAS', 'ALBARRACIN', '09887661', '990864657', '1985-03-18', 'Femenino', 'Casado', 'Lima', 'Lima', 'Los Olivos', 'Jirón Las dunias 479', '2023-06-20 13:54:23'),
(1032, 'DANAE YAMILET', 'ZUTA', 'CORDERO', '78542825', '965452878', '1986-01-12', 'Femenino', 'Casado', 'Lima', 'Lima', 'Carabayllo', 'Los frutales c3 15', '2023-06-20 14:11:38'),
(1033, 'EDITH', 'HUAMAN', 'VARGAS', '46259888', '925639774', '1968-01-29', 'Femenino', 'Soltero', 'Lima', 'Lima', 'Comas', 'Señor de los milagros C lote 18', '2023-06-20 14:27:59'),
(1034, 'ALDO ALDAIR', 'LLACSAHUACHE', 'FLORES', '76462121', '990534648', '1998-06-12', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Los Olivos', 'Av Alisos 197', '2023-06-20 14:39:13'),
(1035, 'SEGUNDA IRENE', 'CRUZADO', 'DOMINGUEZ', '07676643', '998733454', '1965-09-15', 'Femenino', 'Divorciado', 'Lima', 'Lima', 'Carabayllo', 'Av Leoncio Prado 694', '2023-06-20 14:52:18'),
(1036, 'RENE', 'BERROCAL', 'BERROCAL', '06984343', '990467364', '1966-07-11', 'Femenino', 'Casado', 'Lima', 'Lima', 'Los Olivos', 'Calle Belisario Suárez 296', '2023-06-20 15:13:28'),
(1037, 'CESAR MANUEL', 'JUAREZ', 'EDEGUARDO', '77683344', '994383641', '1996-02-10', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Independencia', 'Av José Gálvez 963', '2023-06-20 15:28:08'),
(1038, 'MARTA VERONICA', 'MIRANDA', 'RIVERO', '08785425', '998668345', '1972-11-21', 'Femenino', 'Casado', 'Lima', 'Lima', 'Los Olivos', 'Calle Los rosales 364', '2023-06-20 15:36:37'),
(1039, 'NORBERTO GUILLERMO', 'MANCHEGO', 'REYES', '08643318', '990634478', '1980-06-19', 'Masculino', 'Casado', 'Lima', 'Lima', 'San Martín de Porres', 'Jr Santa Cecilia 297', '2023-06-20 15:51:37'),
(1040, 'JOSE EDUARDO', 'MEZA', 'VELASQUEZ', '08694945', '966788046', '1976-02-12', 'Masculino', 'Casado', 'Lima', 'Lima', 'Comas', 'Calle Bella Olinda 288', '2023-06-20 16:08:31'),
(1041, 'ANGEL', 'LEGUA', 'ARIAS', '09887361', '990664846', '1987-05-12', 'Masculino', 'Casado', 'Lima', 'Lima', 'Los Olivos', 'Av Juan Olloa 286', '2023-06-20 16:23:23'),
(1042, 'ROBIN', 'RAMIREZ', 'CHAVEZ', '73869494', '990679849', '1996-02-15', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Los Olivos', 'Jr Huallaga 296', '2023-06-20 16:36:10'),
(1043, 'JORGE', 'SANCHEZ', 'QUISPE', '08975543', '990683438', '1986-05-12', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Independencia', 'Calle Santa Rosa 296', '2023-06-20 16:51:10'),
(1044, 'ROSA LIDIA', 'VENTOCILLA', 'NAPURI', '09887364', '978688484', '1975-06-12', 'Femenino', 'Casado', 'Lima', 'Lima', 'San Martín de Porres', 'Calle Santa María 295', '2023-06-20 17:13:56'),
(1045, 'WILDER EDDINSON', 'SAAVEDRA', 'TUPACYUPANQUI', '08683848', '906787648', '1986-05-12', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Comas', 'Calle Santa Lucia 185', '2023-06-20 20:02:01'),
(1046, 'ROSIO DEL PILAR', 'MORALES', 'BENDEZU', '08637254', '980664848', '1968-03-15', 'Femenino', 'Casado', 'Lima', 'Lima', 'Carabayllo', 'Avenida Julio Ramón 196', '2023-06-20 20:14:53'),
(1047, 'JACKELINE VICTORIA', 'LEON', 'GARCIA', '46056766', '965284528', '1995-10-14', 'Femenino', 'Soltero', 'Lima', 'Lima', 'Los Olivos', 'Av. covida 7661', '2023-06-20 20:28:36'),
(1048, 'MARYCIELO', 'MASCCO', 'BAUTISTA', '72397688', '924365257', '2000-09-22', 'Femenino', 'Soltero', 'Lima', 'Lima', 'Puente Piedra', 'Av. lecaros 45', '2023-06-20 20:41:18'),
(1049, 'JUNIOR ALEXANDER', 'LEGUA', 'RODRIGUEZ', '74155421', '934253682', '1998-12-06', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Carabayllo', 'Av.aras mz P 08', '2023-06-21 14:04:17'),
(1050, 'ROSA', 'VILLEGAS', 'MEDINA', '08676313', '990346487', '1973-12-05', 'Femenino', 'Casado', 'Lima', 'Lima', 'Los Olivos', 'Av Juan Pablo 194', '2023-06-21 14:17:07'),
(1051, 'KENIA TALHIA', 'VARGAS', 'CAUCHE', '77683025', '998766480', '1981-05-12', 'Femenino', 'Casado', 'Lima', 'Lima', 'Comas', 'Calle Leoncio Prado 952', '2023-06-21 14:31:38'),
(1052, 'MARCELINO CELESTINO', 'BARRETO', 'CRISOLO', '09572218', '990685766', '1996-05-12', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Los Olivos', 'Jirón Santo Domingo 185', '2023-06-21 14:46:35'),
(1053, 'JESUS MARTIN', 'CAMARGO', 'GONZALES', '43219587', '923005227', '1973-10-30', 'Masculino', 'Casado', 'Lima', 'Lima', 'Los Olivos', 'Santa maría 971', '2023-06-21 14:57:13'),
(1054, 'JENNY EULALIA', 'RAMOS', 'CARBAJAL', '08672218', '990564843', '1962-03-10', 'Femenino', 'Casado', 'Lima', 'Lima', 'Los Olivos', 'Jirón Honorio delgado 196', '2023-06-21 15:13:21'),
(1055, 'MARIO', 'TINOCO', 'PINAS', '09578466', '990767684', '1983-08-12', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Los Olivos', 'Calle San Pablo 195', '2023-06-21 15:27:03'),
(1056, 'ROSA DAYANA PATRICIA', 'BRIZUELA', 'PALOMINO', '76458310', '990648849', '1999-09-15', 'Femenino', 'Soltero', 'Lima', 'Lima', 'Los Olivos', 'Calle San Antonio 295', '2023-06-21 15:42:15'),
(1057, 'AZUCENA VIRGINIA', 'TARAZONA', 'VEGA', '08643814', '996834201', '1985-05-12', 'Femenino', 'Soltero', 'Lima', 'Lima', 'Independencia', 'Av Tupac Amaru 295', '2023-06-21 16:02:28'),
(1058, 'HALO MARIANO', 'ASENJO', 'CORDOVA', '09864358', '998324884', '1987-04-12', 'Masculino', 'Casado', 'Lima', 'Lima', 'Independencia', 'Calle Santa Ana 295', '2023-06-21 16:17:12'),
(1059, 'FABIANA THAIS', 'MOLLESACA', 'ZEGARRA', '76427458', '990654217', '1994-06-16', 'Femenino', 'Soltero', 'Lima', 'Lima', 'Comas', 'Avenida Labarthe 196', '2023-06-21 16:29:27'),
(1060, 'ANA', 'SANTISTEBAN', 'VARGAS', '72678494', '997328101', '1994-02-06', 'Femenino', 'Soltero', 'Lima', 'Lima', 'Los Olivos', 'Avenida Lucia Alarcón 149', '2023-06-21 16:37:52'),
(1061, 'RICARDO RAUL', 'SUAREZ', 'VEGA', '09763781', '990354864', '1975-05-12', 'Masculino', 'Casado', 'Lima', 'Lima', 'Los Olivos', 'Avenida Julio Ramón 295', '2023-06-21 16:53:15'),
(1062, 'CLAUDIA GISELLA', 'BENAVENTE', 'ARMAS', '45258888', '947596325', '1985-04-03', 'Femenino', 'Viudo', 'Lima', 'Lima', 'Comas', 'Av.tupac amaru 40', '2023-06-21 17:07:26'),
(1063, 'GLORIA MARIA', 'DELGADO', 'ZAMBRANO', '09683848', '960384846', '1983-06-19', 'Femenino', 'Soltero', 'Lima', 'Lima', 'San Martín de Porres', 'Jirón Santo Domingo 195', '2023-06-21 20:04:31'),
(1064, 'LUZ SILVIA', 'OLAECHEA', 'LOPEZ', '09438254', '976033486', '1984-09-12', 'Femenino', 'Soltero', 'Lima', 'Lima', 'Comas', 'Jirón Huallaga 194', '2023-06-21 20:18:38'),
(1065, 'NOHEMI FIORELA', 'CALIZAYA', 'RAMOS', '74539850', '965847558', '1995-02-12', 'Femenino', 'Soltero', 'Lima', 'Lima', 'Los Olivos', 'Av. brisas0976', '2023-06-21 20:32:11'),
(1066, 'LUIS ALBERTO', 'JURUPE', 'CHILENO', '73423560', '953570588', '2001-09-03', 'Masculino', 'Soltero', 'Lima', 'Lima', 'San Martín de Porres', 'jirón Santa Carolina 20', '2023-06-21 20:46:04'),
(1067, 'EDWIN JAIRO', 'CABRERA', 'CARRANZA', '76543754', '990684646', '1994-12-05', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Comas', 'Jirón Lucia Alarcón 105', '2023-06-21 21:01:23'),
(1068, 'YUNIOR MANUEL', 'MOISES', 'OBREGON', '72410976', '925398478', '1990-01-12', 'Masculino', 'Casado', 'Lima', 'Lima', 'Independencia', 'Atahualpa 10 zona 3', '2023-06-21 21:18:15'),
(1069, 'NICOLAS', 'MEJIA', 'JULCA', '09543576', '990678486', '1973-02-10', 'Masculino', 'Casado', 'Lima', 'Lima', 'San Martín de Porres', 'Jirón Santa Lucia 195', '2023-06-22 13:37:25'),
(1072, 'LUZ ESTEFANY', 'SANDOVAL', 'ALCCAHUAMAN', '72539855', '931558780', '1992-11-25', 'Femenino', 'Casado', 'Lima', 'Lima', 'Los Olivos', 'Av.antunez de Mayolo 124', '2023-06-22 13:45:48'),
(1073, 'MARITZA BERTHA', 'PACHECO', 'HERNANDEZ', '08732481', '988305549', '1976-05-12', 'Femenino', 'Casado', 'Lima', 'Lima', 'Independencia', 'Jirón Atahualpa 294', '2023-06-22 13:58:52'),
(1074, 'ROSA LINDA', 'CARDENAS', 'LEANDRO', '09837284', '990676484', '1972-01-08', 'Femenino', 'Casado', 'Lima', 'Lima', 'Los Olivos', 'Av Leoncio Prado 584', '2023-06-22 14:12:56'),
(1075, 'TOMAS', 'TABOADA', 'LOZADA', '25635775', '964520454', '1970-09-28', 'Masculino', 'Casado', 'Lima', 'Lima', 'Puente Piedra', 'Av buenos aires 56', '2023-06-22 14:24:30'),
(1076, 'JANET CAROL', 'BRACAMONTE', 'LUNA', '08784848', '990684846', '1982-05-13', 'Femenino', 'Casado', 'Lima', 'Lima', 'Los Olivos', 'Avenida Los Alisos 284', '2023-06-22 14:36:19'),
(1077, 'DIANA MARISOL', 'SAIRITUPAC', 'VASQUEZ', '74582332', '923210787', '1999-10-01', 'Femenino', 'Soltero', 'Lima', 'Lima', 'Puente Piedra', 'Av.lecaros 23 ', '2023-06-22 14:47:18'),
(1078, 'CONSUELO LISETH', 'ROALCABA', 'VASQUEZ', '76458222', '960684646', '2000-12-09', 'Femenino', 'Soltero', 'Lima', 'Lima', 'Independencia', 'Jirón Santo Domingo 332', '2023-06-22 14:52:33'),
(1079, 'YADIRA LIZETH', 'CORTEZ', 'ESPINOZA', '76785239', '935985485', '1997-02-13', 'Femenino', 'Soltero', 'Lima', 'Lima', 'Los Olivos', 'Santa Catalina 452', '2023-06-22 15:11:57'),
(1080, 'MARIA LAURA', 'HUERTA', 'LOZANO', '08774535', '990385487', '1980-12-09', 'Femenino', 'Soltero', 'Lima', 'Lima', 'San Martín de Porres', 'Avenida Julio Ramón 193', '2023-06-22 15:27:18'),
(1081, 'NATIVIDAD ANDY JHONNY', 'DE', 'LA CRUZ', '44666100', '923520888', '1980-08-28', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Independencia', 'mayta capac 01', '2023-06-22 15:41:47'),
(1082, 'JUANA ELISA', 'SECLEN', 'PEREZ', '76060254', '960057672', '1992-05-12', 'Femenino', 'Soltero', 'Lima', 'Lima', 'Independencia', 'Avenida Tomás Valle 274', '2023-06-22 15:56:55'),
(1083, 'PAMELA STEFANI', 'MUÃOZ', 'PULIDO', '42588965', '942866863', '1987-11-07', 'Femenino', 'Casado', 'Lima', 'Lima', 'Independencia', 'Av tomas valle 12', '2023-06-22 16:06:11'),
(1084, 'MAURICIO', 'CASAPERALTA', 'SUYCO', '44602025', '903022411', '1985-06-10', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Carabayllo', 'Avenida San Juan 391', '2023-06-22 16:18:28'),
(1085, 'MILTON ADAO', 'MORILLO', 'PALLARA', '76933589', '935965847', '1994-08-11', 'Masculino', 'Casado', 'Lima', 'Lima', 'San Martín de Porres', 'santo domingo 211', '2023-06-22 16:23:53'),
(1086, 'PERCY', 'PARHUAY', 'PORRAS', '09632724', '989072464', '1983-02-10', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Los Olivos', 'Jirón Huallaga 196', '2023-06-22 16:47:13'),
(1087, 'PALMIRA OLGA', 'RUIZ', 'LOAYZA', '08568223', '990843735', '1972-09-08', 'Femenino', 'Casado', 'Lima', 'Lima', 'Carabayllo', 'Avenida Tomás Marzano 284', '2023-06-22 17:12:28'),
(1088, 'GUILLERMO', 'MEJIA', 'BARTUREN', '25818536', '968420144', '1988-10-26', 'Masculino', 'Casado', 'Lima', 'Lima', 'Independencia', 'Jirón Ayacucho 561', '2023-06-22 20:07:57'),
(1089, 'LILIANA', 'PASTOR', 'CENTENO', '08679023', '990676488', '1989-05-12', 'Femenino', 'Soltero', 'Lima', 'Lima', 'Independencia', 'Avenida Tomás Valle 195', '2023-06-22 20:16:50'),
(1090, 'GLICERIO', 'VARGAS', 'OSPINO', '08973756', '906546458', '1982-03-12', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Los Olivos', 'Avenida Julio Ramón 795', '2023-06-22 20:29:09'),
(1091, 'MARISOL', 'HANCCO', 'HANCCO', '42586930', '913584732', '1987-12-27', 'Femenino', 'Casado', 'Lima', 'Lima', 'Comas', 'Av. condorcanqui 159', '2023-06-23 13:32:41'),
(1092, 'HELSINKI BAFFIN', 'OCHAVANO', 'GONZALES', '74859322', '987211088', '1990-09-20', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Los Olivos', 'Av. Alfredo mendiola 6237', '2023-06-23 13:45:26'),
(1093, 'JOSE LUIS', 'RAMOS', 'PRIETO', '08663578', '932523700', '1974-03-12', 'Masculino', 'Viudo', 'Lima', 'Lima', 'El Agustino', 'Av. Túpac amaru km 4.5', '2023-06-23 13:57:33'),
(1094, 'VICTOR MANUEL', 'ESPEJO', 'PALACIOS', '22060236', '924918362', '1967-02-25', 'Masculino', 'Divorciado', 'Lima', 'Lima', 'Puente Piedra', 'Av. puente piedra 378', '2023-06-23 14:06:42'),
(1095, 'GLADIS SONIA', 'GUTIERREZ', 'HIDALGO', '05236418', '982172566', '1986-08-28', 'Femenino', 'Casado', 'Lima', 'Lima', 'Los Olivos', 'Av. las palmeras 572', '2023-06-23 14:19:39'),
(1096, 'TOMAS', 'CARPIO', 'FLORES', '03219365', '964207316', '2000-09-16', 'Masculino', 'Soltero', 'Lima', 'Lima', 'San Martín de Porres', 'Av. Paramonga 672', '2023-06-23 14:25:35'),
(1097, 'GERTA PERCILA', 'MANUEL', 'SANTIAGO', '75823647', '980523418', '1986-08-20', 'Femenino', 'Casado', 'Lima', 'Lima', 'Los Olivos', 'Av. Carlos izaguirre 761', '2023-06-23 14:38:23'),
(1098, 'JHONY', 'VARGAS', 'GAMBOA', '25814525', '956365857', '1976-06-13', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Puente Piedra', 'Av. Buenos Aires 101', '2023-06-23 14:52:41'),
(1099, 'YOSHUA DARIO', 'CURO', 'GALVEZ', '75496213', '924553670', '1975-07-31', 'Masculino', 'Casado', 'Lima', 'Lima', 'Los Olivos', 'Jr. Vinchay 4944', '2023-06-23 15:11:47'),
(1101, 'NAOMY LISCIEN', 'VENTOCILLA', 'VASQUEZ', '74324008', '935266369', '1993-10-23', 'Femenino', 'Soltero', 'Lima', 'Lima', 'Los Olivos', 'Av Huallaga 294', '2023-06-23 15:26:24'),
(1102, 'GISELA MILAGROS', 'VALVERDE', 'CHERREPANO', '44732834', '990354364', '1981-12-19', 'Femenino', 'Soltero', 'Lima', 'Lima', 'Independencia', 'Avenida Tahuantinsuyo 147', '2023-06-23 15:37:38'),
(1103, 'ROSA BEATRIZ', 'DIOSES', 'SALINAS', '47583869', '998664843', '1976-09-12', 'Femenino', 'Casado', 'Lima', 'Lima', 'San Martín de Porres', 'Jirón San Carlos 352', '2023-06-23 15:44:39'),
(1104, 'YOSKYN RUSSEL', 'TABOADA', 'REQUENA', '74602131', '990664334', '1990-10-05', 'Masculino', 'Soltero', 'Lima', 'Lima', 'Los Olivos', 'Avenida Tomas Marsano 296', '2023-06-23 16:03:02'),
(1105, 'LUIS ALBERTO', 'GARCIA', 'CAVEZAS', '46763054', '990334348', '1986-10-13', 'Masculino', 'Soltero', 'Lima', 'Lima', 'San Martín de Porres', 'Jirón Santa Carolina 425', '2023-06-23 16:15:49'),
(1106, 'JUAN DE DIOS', 'ARRIETA', 'MENDIZABAL', '08764318', '998646437', '1971-06-10', 'Masculino', 'Casado', 'Lima', 'Lima', 'Comas', 'Avenida Tupac Amaru 385', '2023-06-23 16:27:31'),
(1107, 'ELENA LINDOMIRA', 'NAVARRETE', 'MURILLO', '09753168', '967573400', '1972-08-19', 'Femenino', 'Casado', 'Lima', 'Lima', 'Los Olivos', 'Avenida Leoncio Prado 294', '2023-06-23 16:33:40'),
(1108, 'GREGORIA', 'PORRAS', 'NAHUE', '08893484', '997631380', '1969-03-29', 'Femenino', 'Casado', 'Lima', 'Lima', 'Los Olivos', 'Avenida Luna Pizarro 484', '2023-06-23 16:51:38'),
(1109, 'LIZBETH MARIA GUADALUPE', 'ALDANA', 'DOLORIER', '76462701', '993315047', '1992-12-15', 'Femenino', 'Soltero', 'Lima', 'Lima', 'Independencia', 'Av Tomas valle 482', '2023-06-23 17:04:19'),
(1110, 'IVAN SUNI', 'RIMARACHIN', 'PALACIOS', '46833059', '960684048', '1982-10-30', 'Masculino', 'Casado', 'Lima', 'Lima', 'Comas', 'Jirón Camana 295', '2023-06-23 20:06:13'),
(1111, 'ILIANA', 'GONZALES', 'SAAVEDRA', '09864318', '997321504', '1988-09-21', 'Femenino', 'Casado', 'Lima', 'Lima', 'Los Olivos', 'Av Los Alisos 295', '2023-06-23 20:13:28'),
(1112, 'JESUS RAFAEL', 'PISCOYA', 'BANCES', '74644014', '9999999', '2023-07-22', 'Masculino', 'Soltero', 'Junín', 'Jauja', 'Julcán', 'av ', '2023-07-22 22:46:56');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personal`
--

CREATE TABLE `personal` (
  `cod_personal` int(11) NOT NULL,
  `cod_persona` int(11) NOT NULL,
  `cod_especialidad` int(11) DEFAULT NULL,
  `tipo_personal` int(11) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `usuario` varchar(20) NOT NULL,
  `password` varchar(70) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `personal`
--

INSERT INTO `personal` (`cod_personal`, `cod_persona`, `cod_especialidad`, `tipo_personal`, `correo`, `usuario`, `password`) VALUES
(1000, 1005, 1001, 1, 'oscar@gmail.com', 'oscar', 'f5a1971c2ef02a5ab2263f20895b14e7ac1607d21d28805ca8a7ed31ef802364'),
(1001, 1008, 1004, 1, 'edwinfuertesescudero@gmail.com', 'edwin', '3dfbf1fbdbf9d2eb39e14955dcfd073792ebed8c9b97995210e70c4059be13c9'),
(1002, 1000, NULL, 2, 'jesus@gmail.com', 'jesus', 'a54e71f0e17f5aaf7946e66ab42cf3b1fd4e61d60581736c9f0eb1c3f794eb7c'),
(1003, 1001, NULL, 2, 'maria@gmail.com', 'maria', '94aec9fbed989ece189a7e172c9cf41669050495152bc4c1dbf2a38d7fd85627'),
(1004, 1007, NULL, 2, 'rosa_floresl86@gmail.com', 'rosany', '6a61eb7383e868f226d30d31c95348371760d993de5a098747a36923bdcaf25c');

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
(4, 1000, 1004, 78, 175, 36.8, '118/78', '2023-06-19 14:16:41'),
(5, 1000, 1005, 61, 156, 38.7, '121/79', '2023-06-19 14:31:49'),
(6, 1000, 1006, 62, 162, 37, '120/78', '2023-06-19 14:46:45'),
(7, 1000, 1007, 73, 176, 36.8, '118/78', '2023-06-19 15:01:11'),
(8, 1000, 1008, 65, 162, 37.1, '120/80', '2023-06-19 15:11:12'),
(9, 1000, 1009, 60, 157, 36.9, '125/76', '2023-06-19 15:25:19'),
(10, 1000, 1010, 76, 162, 37.1, '120/80', '2023-06-19 15:41:50'),
(11, 1000, 1011, 64, 161, 37, '119/78', '2023-06-19 15:54:09'),
(12, 1000, 1012, 85, 168, 36.9, '122/78', '2023-06-19 16:07:30'),
(13, 1000, 1013, 78, 175, 37, '120/80', '2023-06-19 16:21:38'),
(14, 1000, 1014, 62, 158, 36.7, '121/78', '2023-06-19 16:38:07'),
(15, 1000, 1015, 78, 160, 37, '120/80', '2023-06-19 16:51:19'),
(16, 1000, 1016, 70, 168, 37, '121/79', '2023-06-19 17:01:12'),
(17, 1000, 1017, 80, 155, 36.8, '119/80', '2023-06-19 17:13:30'),
(18, 1000, 1018, 79, 175, 36.8, '120/80', '2023-06-19 20:10:43'),
(19, 1000, 1019, 81, 158, 37, '122/78', '2023-06-19 20:23:14'),
(20, 1000, 1020, 65, 153, 36.9, '121/80', '2023-06-19 20:36:48'),
(21, 1000, 1021, 64, 155, 37, '120/80', '2023-06-19 20:52:01'),
(22, 1000, 1022, 70, 167, 36.8, '121/80', '2023-06-19 21:05:45'),
(23, 1000, 1023, 64, 163, 36.8, '119/79', '2023-06-19 21:23:45'),
(24, 1000, 1024, 57, 172, 36.9, '120/81', '2023-06-20 13:35:17'),
(25, 1000, 1025, 72, 156, 37.1, '121/80', '2023-06-20 13:49:47'),
(26, 1000, 1026, 55, 163, 36.8, '120/78', '2023-06-20 13:58:12'),
(27, 1000, 1030, 62, 172, 37, '119/79', '2023-06-20 14:15:52'),
(28, 1000, 1031, 64, 170, 37, '120/80', '2023-06-20 14:31:15'),
(29, 1000, 1032, 68, 155, 36.8, '119/78', '2023-06-20 14:44:59'),
(30, 1000, 1033, 58, 159, 37, '121/78', '2023-06-20 14:56:29'),
(31, 1000, 1034, 75, 178, 36.5, '119/80', '2023-06-20 15:18:18'),
(32, 1000, 1035, 65, 166, 37, '120/79', '2023-06-20 15:32:42'),
(33, 1000, 1027, 59, 163, 36.8, '120/79', '2023-06-20 15:39:38'),
(34, 1000, 1028, 76, 175, 36.9, '119/81', '2023-06-20 15:56:15'),
(35, 1000, 1029, 82, 177, 37, '119/79', '2023-06-20 16:11:04'),
(36, 1000, 1036, 68, 157, 37, '119/78', '2023-06-20 16:27:38'),
(37, 1000, 1037, 82, 169, 36.9, '120/79', '2023-06-20 16:39:09'),
(38, 1000, 1038, 69, 177, 36.8, '119/80', '2023-06-20 16:56:52'),
(39, 1000, 1039, 56, 155, 37, '120/79', '2023-06-20 17:18:52'),
(40, 1000, 1041, 59, 160, 36.9, '120/80', '2023-06-20 20:06:00'),
(41, 1000, 1040, 67, 164, 36.9, '120/79', '2023-06-20 20:19:05'),
(42, 1000, 1042, 61, 157, 37, '120/78', '2023-06-20 20:33:53'),
(43, 1000, 1043, 60, 156, 36.8, '119/79', '2023-06-20 20:46:56'),
(44, 1000, 1044, 63, 165, 37, '120/80', '2023-06-21 14:08:06'),
(45, 1000, 1045, 62, 160, 36.9, '119/79', '2023-06-21 14:20:13'),
(46, 1000, 1046, 58, 158, 37, '120/80', '2023-06-21 14:34:29'),
(47, 1000, 1047, 61, 163, 36.8, '120/81', '2023-06-21 14:50:17'),
(48, 1000, 1048, 60, 171, 37, '120/87', '2023-06-21 15:01:11'),
(49, 1000, 1063, 60, 163, 37, '119/80', '2023-06-21 15:18:43'),
(50, 1000, 1061, 58, 155, 36.8, '120/78', '2023-06-21 15:31:02'),
(51, 1000, 1059, 56, 153, 36.9, '120/79', '2023-06-21 15:47:25'),
(52, 1000, 1060, 62, 160, 37, '120/79', '2023-06-21 16:06:44'),
(53, 1000, 1057, 64, 164, 37, '118/81', '2023-06-21 16:20:24'),
(54, 1000, 1056, 67, 178, 37, '120/81', '2023-06-21 16:32:46'),
(55, 1000, 1049, 63, 160, 36.8, '120/79', '2023-06-21 16:41:21'),
(56, 1000, 1050, 84, 180, 36.8, '119/80', '2023-06-21 16:58:49'),
(57, 1000, 1058, 63, 160, 37, '120/79', '2023-06-21 17:12:31'),
(58, 1000, 1054, 74, 174, 36.8, '118/81', '2023-06-21 20:08:53'),
(59, 1000, 1051, 67, 173, 37, '120/81', '2023-06-21 20:21:11'),
(60, 1000, 1062, 82, 179, 36.9, '120/79', '2023-06-21 20:35:32'),
(61, 1000, 1052, 73, 171, 37, '119/80', '2023-06-21 20:49:28'),
(62, 1000, 1053, 83, 168, 37, '119/79', '2023-06-21 21:05:02'),
(63, 1000, 1055, 58, 155, 36.9, '119/81', '2023-06-21 21:21:21'),
(64, 1000, 1068, 62, 161, 37, '120/80', '2023-06-22 13:42:07'),
(65, 1000, 1064, 87, 180, 36.8, '120/79', '2023-06-22 13:48:30'),
(66, 1000, 1069, 59, 160, 37, '119/79', '2023-06-22 14:01:50'),
(67, 1000, 1067, 70, 168, 37, '119/81', '2023-06-22 14:15:21'),
(68, 1000, 1070, 63, 2, 37, '119/79', '2023-06-22 14:28:50'),
(69, 1000, 1071, 61, 162, 36.9, '120/80', '2023-06-22 14:41:12'),
(70, 1000, 1072, 67, 168, 36.9, '118/81', '2023-06-22 14:51:52'),
(71, 1000, 1074, 58, 156, 37, '120/80', '2023-06-22 14:55:06'),
(72, 1000, 1075, 65, 164, 37, '120/79', '2023-06-22 15:14:44'),
(73, 1000, 1106, 65, 162, 37, '118/81', '2023-06-22 15:32:30'),
(74, 1000, 1105, 83, 178, 36.9, '120/81', '2023-06-22 15:44:52'),
(75, 1000, 1101, 79, 173, 36.8, '120/81', '2023-06-22 16:01:16'),
(76, 1000, 1099, 75, 169, 37, '120/81', '2023-06-22 16:10:56'),
(77, 1000, 1095, 65, 170, 36.9, '120/79', '2023-06-22 16:22:18'),
(78, 1000, 1088, 85, 180, 37, '120/81', '2023-06-22 16:28:44'),
(79, 1000, 1081, 60, 157, 36.9, '120/80', '2023-06-22 16:51:06'),
(80, 1000, 1079, 67, 168, 36.8, '119/81', '2023-06-22 17:15:31'),
(81, 1000, 1080, 59, 155, 37.1, '120/79', '2023-06-22 20:12:03'),
(82, 1000, 1094, 63, 160, 37, '119/80', '2023-06-22 20:21:30'),
(83, 1000, 1091, 72, 168, 37.1, '120/80', '2023-06-22 20:33:49'),
(84, 1000, 1073, 59, 157, 36.9, '120/79', '2023-06-23 13:35:11'),
(85, 1000, 1076, 67, 162, 37, '120/81', '2023-06-23 13:48:28'),
(86, 1000, 1104, 58, 156, 37, '120/80', '2023-06-23 14:00:42'),
(87, 1000, 1093, 62, 159, 36.9, '120/79', '2023-06-23 14:11:05'),
(88, 1000, 1100, 71, 168, 37, '119/80', '2023-06-23 14:24:28'),
(89, 1000, 1077, 63, 158, 37, '120/81', '2023-06-23 14:29:51'),
(90, 1000, 1090, 64, 159, 36.9, '119/81', '2023-06-23 14:41:27'),
(91, 1000, 1103, 64, 161, 36.8, '120/11', '2023-06-23 14:56:57'),
(92, 1000, 1089, 73, 168, 37.1, '120/80', '2023-06-23 15:16:23'),
(93, 1000, 1078, 64, 160, 37.1, '120/81', '2023-06-23 15:30:53'),
(94, 1000, 1087, 83, 182, 37.1, '120/79', '2023-06-23 15:40:28'),
(95, 1000, 1082, 62, 158, 36.8, '119/81', '2023-06-23 15:47:55'),
(96, 1000, 1083, 67, 165, 36.9, '120/79', '2023-06-23 16:08:17'),
(97, 1000, 1092, 71, 167, 37.1, '120/81', '2023-06-23 16:19:37'),
(98, 1000, 1084, 64, 158, 37.1, '119/81', '2023-06-23 16:32:04'),
(99, 1000, 1085, 68, 162, 36.8, '119/79', '2023-06-23 16:38:31'),
(100, 1000, 1086, 68, 170, 37, '120/81', '2023-06-23 16:55:04'),
(101, 1000, 1097, 62, 157, 37.1, '120/80', '2023-06-23 17:08:22'),
(102, 1000, 1098, 57, 155, 37.1, '120/80', '2023-06-23 20:09:36'),
(103, 1000, 1102, 60, 157, 37.1, '120/79', '2023-06-23 20:18:16');

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
  MODIFY `cod_atencion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=107;

--
-- AUTO_INCREMENT de la tabla `especialidad`
--
ALTER TABLE `especialidad`
  MODIFY `cod_especialidad` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1010;

--
-- AUTO_INCREMENT de la tabla `paciente`
--
ALTER TABLE `paciente`
  MODIFY `cod_paciente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1108;

--
-- AUTO_INCREMENT de la tabla `persona`
--
ALTER TABLE `persona`
  MODIFY `cod_persona` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1113;

--
-- AUTO_INCREMENT de la tabla `personal`
--
ALTER TABLE `personal`
  MODIFY `cod_personal` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1005;

--
-- AUTO_INCREMENT de la tabla `triaje`
--
ALTER TABLE `triaje`
  MODIFY `cod_triaje` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=104;

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

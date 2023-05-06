<?php
require 'conexion.php';

$obj = new Conexion;
$conexion = $obj->getConexion();

$sql = "CALL VerificarTriaje('" . $_POST['cod_paciente'] . "')";
$resultado = $conexion->query($sql);

if ($row = $resultado->fetch_assoc()) {
    echo json_encode(false);
} else {
    echo json_encode(true);
}
$conexion->close();
?>
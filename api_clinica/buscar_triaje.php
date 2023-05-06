<?php
require 'conexion.php';

$obj = new Conexion;
$conexion = $obj->getConexion();

$sql = "CALL BuscarTriaje('" . $_POST['cod_paciente'] . "')";
$resultado = $conexion->query($sql);

if ($row = $resultado->fetch_assoc()) {
    echo json_encode($row, JSON_UNESCAPED_UNICODE);
} else {
    echo json_encode($row);
}
$conexion->close();
?>
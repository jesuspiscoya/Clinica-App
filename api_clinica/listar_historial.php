<?php
require 'conexion.php';

$obj = new Conexion;
$conexion = $obj->getConexion();

$sql = "CALL ListarHistorialAtenciones('" . $_POST['cod_medico'] . "')";
$resultado = $conexion->query($sql);
$array = array();

while ($row = $resultado->fetch_assoc()) {
    $array[] = $row;
}

echo json_encode($array, JSON_UNESCAPED_UNICODE);
$conexion->close();
?>
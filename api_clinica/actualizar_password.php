<?php
require 'conexion.php';

$obj = new Conexion;
$conexion = $obj->getConexion();

$sql = "CALL ActualizarPassword('" . $_POST['cod_personal'] . "','" . $_POST['password'] . "')";

try {
    $conexion->query($sql);
    echo json_encode(true);
} catch (\Throwable $th) {
    echo json_encode(false);
}
$conexion->close();
?>
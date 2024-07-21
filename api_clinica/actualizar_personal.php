<?php
require 'conexion.php';

$obj = new Conexion;
$conexion = $obj->getConexion();

$sql = "CALL ActualizarPersonal('" . $_POST['cod_personal'] . "','" . $_POST['correo'] . "','" . $_POST['telefono'] . "','" . $_POST['direccion'] . "')";
$resultado = $conexion->query($sql);

if ($row = $resultado->fetch_assoc()) {
    echo json_encode($row, JSON_UNESCAPED_UNICODE);
} else {
    echo json_encode($row);
}
$conexion->close();
?>
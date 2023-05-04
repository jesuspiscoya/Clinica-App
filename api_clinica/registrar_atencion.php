<?php
require 'conexion.php';

$obj = new Conexion;
$conexion = $obj->getConexion();

$sql = "CALL RegistrarAtencion('" . $_POST['cod_paciente'] . "','" . $_POST['cod_especialidad'] . "','" . $_POST['cod_enfermera'] . "')";

try {
    $conexion->query($sql);
    echo json_encode(true);
} catch (\Throwable $th) {
    echo json_encode(false);
}
$conexion->close();
?>
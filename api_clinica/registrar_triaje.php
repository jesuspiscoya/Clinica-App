<?php
require 'conexion.php';

$obj = new Conexion;
$conexion = $obj->getConexion();

$sql = "CALL RegistrarTriaje('" . $_POST['cod_atencion'] . "','" . $_POST['cod_enfermera'] . "','" . $_POST['cod_paciente'] . "','" . $_POST['peso'] . "','" . $_POST['talla'] . "','" . $_POST['temperatura'] . "','" . $_POST['presion'] . "')";

try {
    $conexion->query($sql);
    echo json_encode(true);
} catch (\Throwable $th) {
    echo json_encode(false);
}
$conexion->close();
?>
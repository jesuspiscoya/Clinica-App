<?php
require 'conexion.php';

$obj = new Conexion;
$conexion = $obj->getConexion();

$sql = "CALL ModificarAtencion('" . $_POST['cod_atencion'] . "','" . $_POST['cod_medico'] . "','" . $_POST['sintomas'] . "','" . $_POST['diagnostico'] . "','" . $_POST['tratamiento'] . "','" . $_POST['observaciones'] . "','" . $_POST['examenes'] . "')";

try {
    $conexion->query($sql);
    echo json_encode(true);
} catch (\Throwable $th) {
    echo json_encode(false);
}
$conexion->close();
?>
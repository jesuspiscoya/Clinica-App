<?php
require 'conexion.php';

$obj = new Conexion;
$conexion = $obj->getConexion();

$sql = "CALL RegistrarPaciente('" . $_POST['nombre'] . "','" . $_POST['paterno'] . "','" . $_POST['materno'] . "','" . $_POST['dni'] . "','" . $_POST['telefono'] . "','" . $_POST['nacimiento'] . "','" . $_POST['sexo'] . "','" . $_POST['civil'] . "','" . $_POST['departamento'] . "','" . $_POST['provincia'] . "','" . $_POST['distrito'] . "','" . $_POST['direccion'] . "','" . $_POST['nhc'] . "','" . $_POST['sangre'] . "','" . $_POST['organos'] . "')";

try {
    $conexion->query($sql);
    echo json_encode(true);
} catch (\Throwable $th) {
    echo json_encode(false);
}
$conexion->close();
?>
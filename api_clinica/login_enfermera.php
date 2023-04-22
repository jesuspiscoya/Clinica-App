<?php
require 'conexion.php';

$obj = new Conexion;
$conexion = $obj->getConexion();

$sql = "CALL LoginEnfermera('" . $_POST['usuario'] . "','" . sha1($_POST['password']) . "')";
$resultado = mysqli_query($conexion, $sql);

if ($row = mysqli_fetch_assoc($resultado)) {
    echo json_encode($row);
} else {
    echo json_encode($row);
}
?>
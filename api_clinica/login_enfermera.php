<?php
require 'conexion.php';

$obj = new Conexion;
$conexion = $obj->getConexion();

$sql = "CALL LoginEnfermera('" . $_POST['usuario'] . "','" . sha1($_POST['password']) . "')";
$resultado = mysqli_query($conexion, $sql);

if ($row = $resultado->fetch_assoc()) {
    echo json_encode($row, JSON_UNESCAPED_UNICODE);
} else {
    echo json_encode($row);
}
?>
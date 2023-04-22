<?php
class Conexion
{
    private $conexion;
    private $hostname = 'localhost';
    private $username = 'root';
    private $password = '';
    private $database = 'bd_policlinico';

    public function getConexion()
    {
        $conexion = new mysqli($this->hostname, $this->username, $this->password, $this->database);
        return $conexion->connect_error ? die("Connection failed: " . $conexion->connect_error) : $conexion;
    }
}
?>
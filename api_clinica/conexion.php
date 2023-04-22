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

        if ($conexion->connect_error) {
            return die("Connection failed: " . $conexion->connect_error);
        } else {
            return $conexion;
        }
    }
}
?>
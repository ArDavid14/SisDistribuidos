<?php
// Configuración de la conexión a la base de datos Oracle
$servername = "26.230.98.194"; // Cambia esto por la dirección de tu servidor Oracle
$port = "1521"; // Cambia esto por el puerto de tu servidor Oracle
$service_name = "free"; // Cambia esto por el nombre de tu servicio Oracle
$username = "Hr"; // Cambia esto por tu nombre de usuario de Oracle
$password = "123456789"; // Cambia esto por tu contraseña de Oracle

// Cadena de conexión utilizando el nombre de servicio
$conn = oci_connect($username, $password, "(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=$servername)(PORT=$port))(CONNECT_DATA=(SERVICE_NAME=$service_name)))");

if (!$conn) {
    $e = oci_error();
    die("Conexión fallida: " . $e['message']);
}
?>

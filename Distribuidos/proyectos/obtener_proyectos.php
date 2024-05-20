<?php
// Configuración de la conexión a la base de datos Oracle
$servername = "192.168.1.13"; // Dirección IP del servidor Oracle
$port = "1521"; // Puerto de tu servidor Oracle
$service_name = "free"; // Nombre del servicio Oracle (SID)
$username = "Hr"; // Nombre de usuario de Oracle
$password = "123456789"; // Contraseña de Oracle

// Cadena de conexión utilizando la dirección IP, el puerto y el nombre del servicio
$conn = oci_connect($username, $password, "(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=$servername)(PORT=$port))(CONNECT_DATA=(SERVICE_NAME=$service_name)))");

if (!$conn) {
    $e = oci_error();
    die("Conexión fallida: " . $e['message']);
}

// Preparar la consulta SQL para obtener los proyectos
$sql = "SELECT ID_PROYECTO as id, NOMBRE FROM proyecto";

$stid = oci_parse($conn, $sql);
oci_execute($stid);

// Verificar si se encontraron proyectos
$projects = array();
while ($row = oci_fetch_assoc($stid)) {
    $projects[] = $row;
}

// Devolver los proyectos en formato JSON
echo json_encode($projects);

// Liberar los recursos
oci_free_statement($stid);
oci_close($conn);
?>

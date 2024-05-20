<?php
// Obtener los datos de la solicitud AJAX
$taskId = $_POST['task_id'];
$newState = $_POST['new_state'];

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

// Preparar la consulta SQL para actualizar el estado de la tarea específica
$sql = "UPDATE tarea SET estado='$newState' WHERE id_tarea='$taskId'";

$stid = oci_parse($conn, $sql);
if (oci_execute($stid)) {
    echo "El estado de la tarea se actualizó correctamente";
} else {
    $e = oci_error($stid);
    echo "Error al actualizar el estado de la tarea: " . $e['message'];
}

// Cerrar la conexión
oci_close($conn);
?>

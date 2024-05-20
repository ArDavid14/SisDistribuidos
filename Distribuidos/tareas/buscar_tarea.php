<?php
if (isset($_GET['projectId'])) {
    // Obtener el ID del proyecto desde la URL
    $idproyecto = $_GET['projectId'];

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

    // Preparar la consulta SQL para obtener las tareas del proyecto
    $sql = "SELECT * FROM tarea WHERE fk_id_proyecto = $idproyecto";
    $stid = oci_parse($conn, $sql);
    oci_execute($stid);

    // Verificar si se encontraron tareas
    $tasks = array();
    while ($row = oci_fetch_assoc($stid)) {
        $tasks[] = $row;
    }

    // Devolver las tareas en formato JSON
    echo json_encode($tasks);

    // Liberar los recursos
    oci_free_statement($stid);
    oci_close($conn);
} else {
    echo json_encode(array('error' => 'No se ha proporcionado un ID.'));
}
?>

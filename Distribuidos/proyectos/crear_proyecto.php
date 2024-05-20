<?php
// Configuración de la conexión a la base de datos Oracle
$servername = "192.168.1.13"; // Cambia esto por la dirección de tu servidor Oracle
$port = "1521"; // Cambia esto por el puerto de tu servidor Oracle
$service_name = "free"; // Cambia esto por el nombre de tu servicio Oracle
$username = "Hr"; // Cambia esto por tu nombre de usuario de Oracle
$password = "123456789"; // Cambia esto por tu contraseña de Oracle

// Cadena de conexión utilizando el nombre de servicio
$conn = oci_connect($username, $password, "(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=$servername)(PORT=$port))(CONNECT_DATA=(SERVICE_NAME=$service_name)))");

if (!$conn) {
    $e = oci_error();
    die("Conexión fallida: " . $e['message']);
} else {
    // Envía un mensaje a la consola del navegador si la conexión fue exitosa
    echo "<script>console.log('Conexión a la base de datos establecida');</script>";
}

// Si se ha enviado un nombre de proyecto desde el formulario, intenta insertarlo en la base de datos
if (isset($_POST['projectName'])) {
    // Prepara la consulta SQL para insertar el nuevo proyecto en la tabla "proyectos"
    $projectName = $_POST['projectName'];
    $sql_insert_project = "INSERT INTO proyecto (nombre) VALUES (:projectName)";

    // Prepara y ejecuta la consulta
    $stid = oci_parse($conn, $sql_insert_project);
    oci_bind_by_name($stid, ':projectName', $projectName);

    // Ejecuta la consulta
    if (oci_execute($stid)) {
        echo "<script>window.location.href = 'proyectos.html';</script>";
    } else {
        $e = oci_error($stid);
        echo "Error al crear el proyecto: " . $e['message'];
    }

    // Libera los recursos asociados con la declaración
    oci_free_statement($stid);
}

// Cierra la conexión
oci_close($conn);
?>

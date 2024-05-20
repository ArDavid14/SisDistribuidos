<?php
// Datos de conexión a la base de datos Oracle
$servername = "192.168.1.13"; // Dirección IP del servidor Oracle
$port = "1521"; // Puerto de tu servidor Oracle
$service_name = "free"; // Nombre del servicio Oracle (SID)
$username = "Hr"; // Nombre de usuario de Oracle
$password = "123456789"; // Contraseña de Oracle

// Verificar si se proporcionó el ID del proyecto en la URL
if (isset($_GET['projectId'])) {
    // Obtener el ID del proyecto desde la URL
    $idproyecto = $_GET['projectId'];

    // Cadena de conexión utilizando la dirección IP, el puerto y el nombre del servicio
    $conn = oci_connect($username, $password, "(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=$servername)(PORT=$port))(CONNECT_DATA=(SERVICE_NAME=$service_name)))");

    if (!$conn) {
        $e = oci_error();
        die("Conexión fallida: " . $e['message']);
    }

    // Si se ha enviado un nombre de tarea desde JavaScript, insertarlo en la base de datos
    if (isset($_POST['task_name'])) {
        $task_name = $_POST['task_name'];
        
        // Consulta para insertar la tarea en la tabla de tareas
        $sql = "INSERT INTO tarea (nombre, estado, fk_id_proyecto) VALUES ('$task_name', 'Por Hacer', '$idproyecto')";

        $stid = oci_parse($conn, $sql);
        if (oci_execute($stid)) {
            echo "Tarea agregada correctamente";
        } else {
            $e = oci_error($stid);
            echo "Error al agregar la tarea: " . $e['message'];
        }

        // Liberar recursos
        oci_free_statement($stid);
    } else {
        echo json_encode(array('error' => 'No se ha proporcionado un nombre de tarea.'));
    }

    // Cerrar conexión
    oci_close($conn);
} else {
    echo json_encode(array('error' => 'No se ha proporcionado un ID de proyecto.'));
}
?>

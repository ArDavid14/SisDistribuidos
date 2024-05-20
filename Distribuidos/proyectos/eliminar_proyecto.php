<?php
// Obtener el ID del proyecto a eliminar desde la solicitud
$projectId = $_GET['projectId'];

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

// Iniciar una transacción para realizar la eliminación de forma segura
//oci_set_autocommit($conn, false);

try {
    // Eliminar todas las tareas asociadas al proyecto
    $sqlDeleteTasks = "DELETE FROM TAREA WHERE FK_ID_PROYECTO = :projectId";
    $stmtDeleteTasks = oci_parse($conn, $sqlDeleteTasks);
    oci_bind_by_name($stmtDeleteTasks, ":projectId", $projectId);
    oci_execute($stmtDeleteTasks);

    // Eliminar el proyecto
    $sqlDeleteProject = "DELETE FROM PROYECTO WHERE ID_PROYECTO = :projectId";
    $stmtDeleteProject = oci_parse($conn, $sqlDeleteProject);
    oci_bind_by_name($stmtDeleteProject, ":projectId", $projectId);
    oci_execute($stmtDeleteProject);

    // Confirmar la transacción si todo se ejecutó correctamente
    oci_commit($conn);

    echo json_encode(["message" => "Proyecto eliminado correctamente."]);
} catch (Exception $e) {
    // Si ocurre algún error, deshacer la transacción y devolver un mensaje de error
    oci_rollback($conn);
    echo json_encode(["error" => "Error al eliminar el proyecto: " . $e->getMessage()]);
}

// Cerrar la conexión
oci_close($conn);
?>

<?php
// Verificar si se proporcionó el ID de la tarea
if (isset($_POST['task_id'])) {
    // Obtener el ID de la tarea desde la solicitud
    $taskId = $_POST['task_id'];

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
        // Eliminar la tarea
        $sqlDeleteTask = "DELETE FROM TAREA WHERE ID_TAREA = :taskId";
        $stmtDeleteTask = oci_parse($conn, $sqlDeleteTask);
        oci_bind_by_name($stmtDeleteTask, ":taskId", $taskId);
        oci_execute($stmtDeleteTask);

        // Confirmar la transacción si todo se ejecutó correctamente
        oci_commit($conn);

        echo json_encode(["message" => "Tarea eliminada correctamente."]);
    } catch (Exception $e) {
        // Si ocurre algún error, deshacer la transacción y devolver un mensaje de error
        oci_rollback($conn);
        echo json_encode(["error" => "Error al eliminar la tarea: " . $e->getMessage()]);
    }

    // Cerrar la conexión
    oci_close($conn);
} else {
    echo json_encode(["error" => "No se proporcionó un ID de tarea."]);
}
?>

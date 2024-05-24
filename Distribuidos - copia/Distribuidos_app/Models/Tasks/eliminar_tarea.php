<?php
header('Content-Type: application/json');

// Incluir archivo de configuración de base de datos
include '../../Controllers/Controlador.php';

// Verificar si se proporcionó el ID de la tarea
if (isset($_POST['task_id'])) {
    // Obtener el ID de la tarea desde la solicitud
    $taskId = $_POST['task_id'];

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

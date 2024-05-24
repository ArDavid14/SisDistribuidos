<?php
// Incluir archivo de configuración de base de datos
include '../../Controllers/Controlador.php';

// Verificar si se recibieron los datos necesarios
if (isset($_POST['task_id']) && isset($_POST['new_state']) && isset($_POST['new_date'])) {
    // Capturar datos para evitar inyección de SQL
    $taskId = $_POST['task_id'];
    $newState = $_POST['new_state'];
    $newDate = $_POST['new_date'];

    // Imprimir los valores recibidos para depuración
    error_log("Datos recibidos - task_id: $taskId, new_state: $newState, new_date: $newDate");

    // Crear la consulta SQL para actualizar el estado y la fecha de la tarea
    $sql = "UPDATE TAREA SET ESTADO = :newState, FECHA_FINAL = :newDate WHERE ID_TAREA = :taskId";

    // Prepara y ejecuta la consulta
    $stid = oci_parse($conn, $sql);
    oci_bind_by_name($stid, ':newState', $newState);
    oci_bind_by_name($stid, ':newDate', $newDate);
    oci_bind_by_name($stid, ':taskId', $taskId);

    // Ejecuta la consulta
    if (oci_execute($stid)) {
        // Responder con éxito
        echo json_encode(['success' => true, 'message' => 'Estado de la tarea actualizado correctamente.']);
    } else {
        // Responder con error en caso de fallo
        $e = oci_error($stid);
        error_log("Error al ejecutar la consulta: " . $e['message']);
        echo json_encode(['success' => false, 'message' => 'Error al actualizar el estado de la tarea: ' . $e['message']]);
    }

    // Libera los recursos asociados con la declaración
    oci_free_statement($stid);
} else {
    // Responder con error si faltan datos
    error_log("Datos incompletos - task_id: " . $_POST['task_id'] . ", new_state: " . $_POST['new_state'] . ", new_date: " . $_POST['new_date']);
    echo json_encode(['success' => false, 'message' => 'Datos incompletos.']);
}

// Cerrar la conexión a la base de datos
oci_close($conn);
?>

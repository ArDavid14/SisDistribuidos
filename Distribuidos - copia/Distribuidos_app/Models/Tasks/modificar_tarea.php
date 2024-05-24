<?php

// Incluir archivo de configuración de base de datos
include '../../Controllers/Controlador.php';

// Verificar si se recibieron los datos necesarios
if (isset($_POST['task_id']) && isset($_POST['new_name']) && isset($_POST['new_description'])) {
    // Capturar datos para evitar inyección de SQL
    $taskId = $_POST['task_id'];
    $newName = $_POST['new_name'];
    $newDescription = $_POST['new_description'];

    // Imprimir los valores recibidos para depuración
    error_log("Datos recibidos - task_id: $taskId, new_name: $newName, new_description: $newDescription");

    // Crear la consulta SQL para actualizar el nombre y la descripción de la tarea
    $sql = "UPDATE TAREA SET NOMBRE = :newName, DESCRIPCION = :newDescription WHERE ID_TAREA = :taskId";

    // Prepara y ejecuta la consulta
    $stid = oci_parse($conn, $sql);
    oci_bind_by_name($stid, ':newName', $newName);
    oci_bind_by_name($stid, ':newDescription', $newDescription);
    oci_bind_by_name($stid, ':taskId', $taskId);

    // Ejecuta la consulta
    if (oci_execute($stid)) {
        // Responder con éxito
        echo json_encode(['success' => true, 'message' => 'Tarea modificada correctamente.']);
    } else {
        // Responder con error en caso de fallo
        $e = oci_error($stid);
        error_log("Error al ejecutar la consulta: " . $e['message']);
        echo json_encode(['success' => false, 'message' => 'Error al modificar la tarea: ' . $e['message']]);
    }

    // Libera los recursos asociados con la declaración
    oci_free_statement($stid);
} else {
    // Responder con error si faltan datos
    error_log("Datos incompletos - task_id: " . $_POST['task_id'] . ", new_name: " . $_POST['new_name'] . ", new_description: " . $_POST['new_description']);
    echo json_encode(['success' => false, 'message' => 'Datos incompletos.']);
}

// Cerrar la conexión a la base de datos
oci_close($conn);
?>

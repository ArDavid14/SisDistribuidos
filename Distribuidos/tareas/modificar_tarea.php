<?php
// Incluir archivo de configuración de base de datos
include 'config.php';

// Verificar si se recibieron los datos necesarios
if (isset($_POST['task_id']) && isset($_POST['new_name'])) {
    // Escapar datos para evitar inyección de SQL
    $taskId = mysqli_real_escape_string($conn, $_POST['task_id']);
    $newName = mysqli_real_escape_string($conn, $_POST['new_name']);

    // Crear la consulta SQL para actualizar el nombre de la tarea
    $sql = "UPDATE tareas SET NOMBRE = '$newName' WHERE ID_TAREA = '$taskId'";

    // Ejecutar la consulta
    if (mysqli_query($conn, $sql)) {
        // Responder con éxito
        echo json_encode(['success' => true, 'message' => 'Tarea modificada correctamente.']);
    } else {
        // Responder con error en caso de fallo
        echo json_encode(['success' => false, 'message' => 'Error al modificar la tarea.']);
    }
} else {
    // Responder con error si faltan datos
    echo json_encode(['success' => false, 'message' => 'Datos incompletos.']);
}

// Cerrar la conexión a la base de datos
mysqli_close($conn);
?>

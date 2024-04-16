<?php
// Configurar la conexión a la base de datos
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "planificacion";

// Crear la conexión
$conn = new mysqli($servername, $username, $password, $dbname);

// Verificar la conexión
if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}

// Obtener los datos de la solicitud AJAX
$taskId = $_POST['task_id'];
$newState = $_POST['new_state'];

echo "Task ID: " . $taskId . ", New State: " . $newState; // Para depuración

// Prevenir inyección SQL
$taskId = $conn->real_escape_string($taskId);
$newState = $conn->real_escape_string($newState);

// Preparar la consulta SQL para actualizar el estado de la tarea específica
$sql = "UPDATE tareas SET estado='$newState' WHERE id='$taskId'";

if ($conn->query($sql) === TRUE) {
    echo "El estado de la tarea se actualizó correctamente";
} else {
    echo "Error al actualizar el estado de la tarea: " . $conn->error;
}

// Cerrar la conexión
$conn->close();
?>

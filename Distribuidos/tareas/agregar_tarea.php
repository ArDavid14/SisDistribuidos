<?php

if (isset($_GET['projectId'])) {
    // Obtener el ID de la planta desde la URL
    $idproyecto = $_GET['projectId'];
    // Datos de conexión a la base de datos
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "planificacion";

    // Crear conexión
    $conn = new mysqli($servername, $username, $password, $dbname);

    // Verificar conexión
    if ($conn->connect_error) {
        die("Error de conexión: " . $conn->connect_error);
    }

    // Si se ha enviado un nombre de tarea desde JavaScript, insertarlo en la base de datos
    if(isset($_POST['task_name'])) {
        $task_name = $_POST['task_name'];
        // Consulta para insertar la tarea en la tabla de tareas
        $sql = "INSERT INTO tareas (nombre, estado, proyecto_id) VALUES ('$task_name', 'Por Hacer','$idproyecto')"; // Aquí deberías definir el proyecto_id adecuado tomando en cuenta la lógica de tu aplicación
       if ($conn->query($sql) === TRUE) {
           echo "Tarea agregada correctamente";
       } else {
            echo "Error al agregar la tarea: " . $conn->error;
        }
    }

    // Cerrar conexión
    $conn->close();

} else {
    echo json_encode(array('error' => 'No se ha proporcionado un ID.'));
}
?>




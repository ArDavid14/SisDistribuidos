<?php

// Incluir archivo de configuración de base de datos
include '../../Controllers/Controlador.php';

// Verificar si se proporcionó el ID del proyecto en la URL
if (isset($_GET['projectId'])) {
    // Obtener el ID del proyecto desde la URL
    $idproyecto = $_GET['projectId'];

    // Si se ha enviado un nombre de tarea, una descripción y fechas desde JavaScript, insertarlos en la base de datos
    if (isset($_POST['task_name']) && isset($_POST['task_description']) && isset($_POST['start_date']) && isset($_POST['end_date'])) {
        $task_name = $_POST['task_name'];
        $task_description = $_POST['task_description'];
        $start_date = $_POST['start_date'];
        $end_date = $_POST['end_date'];

        // Consulta para insertar la tarea en la tabla de tareas
        $sql = "INSERT INTO tarea (nombre, estado, fecha_de_inicio, fecha_final, descripcion, fk_id_proyecto) VALUES ('$task_name', 'Por Hacer', TO_DATE('$start_date', 'YYYY-MM-DD'), 'Sin finalizar', '$task_description', '$idproyecto')";

        $stid = oci_parse($conn, $sql);
        if (oci_execute($stid)) {
            echo oci_insert_id($stid); // Retornar el ID de la tarea insertada
        } else {
            $e = oci_error($stid);
            echo "Error al agregar la tarea: " . $e['message'];
        }

        // Liberar recursos
        oci_free_statement($stid);
    } else {
        echo json_encode(array('error' => 'Faltan datos necesarios.'));
    }

    // Cerrar conexión
    oci_close($conn);
} else {
    echo json_encode(array('error' => 'No se ha proporcionado un ID de proyecto.'));
}
?>

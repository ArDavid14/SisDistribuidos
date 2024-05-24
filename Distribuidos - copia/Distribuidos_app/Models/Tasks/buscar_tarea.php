<?php

// Incluir archivo de configuración de base de datos
include '../../Controllers/Controlador.php';

if (isset($_GET['projectId'])) {
    // Obtener el ID del proyecto desde la URL
    $idproyecto = $_GET['projectId'];

    // Preparar la consulta SQL para obtener las tareas del proyecto
    $sql = "SELECT * FROM tarea WHERE fk_id_proyecto = $idproyecto";
    $stid = oci_parse($conn, $sql);
    oci_execute($stid);

    // Verificar si se encontraron tareas
    $tasks = array();
    while ($row = oci_fetch_assoc($stid)) {
        $tasks[] = $row;
    }

    // Devolver las tareas en formato JSON
    echo json_encode($tasks);

    // Liberar los recursos
    oci_free_statement($stid);
    oci_close($conn);
} else {
    echo json_encode(array('error' => 'No se ha proporcionado un ID.'));
}
?>

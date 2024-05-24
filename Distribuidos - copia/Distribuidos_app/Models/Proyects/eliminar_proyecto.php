<?php

// Incluir archivo de configuración de base de datos
include '../../Controllers/Controlador.php';

// Leer el cuerpo de la solicitud
$input = file_get_contents("php://input");
$data = json_decode($input, true);

if (isset($data['projectId'])) {
    $projectId = $data['projectId'];


    // Eliminar tareas asociadas al proyecto
    $sqlDeleteTasks = "DELETE FROM TAREA WHERE FK_ID_PROYECTO = :projectId";
    $stmtDeleteTasks = oci_parse($conn, $sqlDeleteTasks);
    oci_bind_by_name($stmtDeleteTasks, ":projectId", $projectId);

    if (!oci_execute($stmtDeleteTasks)) {
        $e = oci_error($stmtDeleteTasks);
        echo json_encode(["error" => "Error al eliminar tareas del proyecto: " . $e['message']]);
        oci_free_statement($stmtDeleteTasks);
        oci_close($conn);
        exit;
    }

    // Eliminar el proyecto
    $sqlDeleteProject = "DELETE FROM PROYECTO WHERE ID_PROYECTO = :projectId";
    $stmtDeleteProject = oci_parse($conn, $sqlDeleteProject);
    oci_bind_by_name($stmtDeleteProject, ":projectId", $projectId);

    if (oci_execute($stmtDeleteProject)) {
        echo json_encode(["message" => "Proyecto eliminado correctamente."]);
    } else {
        $e = oci_error($stmtDeleteProject);
        echo json_encode(["error" => "Error al eliminar el proyecto: " . $e['message']]);
    }

    oci_free_statement($stmtDeleteTasks);
    oci_free_statement($stmtDeleteProject);
    oci_close($conn);
} else {
    echo json_encode(["error" => "No se ha proporcionado un ID de proyecto."]);
}
?>

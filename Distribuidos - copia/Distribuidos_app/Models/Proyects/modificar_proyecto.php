<?php

// Incluir archivo de configuración de base de datos
include '../../Controllers/Controlador.php';

if (isset($_POST['projectId']) && isset($_POST['newName'])) {
    $projectId = $_POST['projectId'];
    $newName = $_POST['newName'];


    // Actualizar el nombre del proyecto
    $sqlUpdateProject = "UPDATE PROYECTO SET NOMBRE = :newName WHERE ID_PROYECTO = :projectId";
    $stmtUpdateProject = oci_parse($conn, $sqlUpdateProject);
    oci_bind_by_name($stmtUpdateProject, ":newName", $newName);
    oci_bind_by_name($stmtUpdateProject, ":projectId", $projectId);

    if (oci_execute($stmtUpdateProject)) {
        echo json_encode(["message" => "Nombre del proyecto actualizado correctamente."]);
    } else {
        $e = oci_error($stmtUpdateProject);
        echo json_encode(["error" => "Error al actualizar el nombre del proyecto: " . $e['message']]);
    }

    oci_free_statement($stmtUpdateProject);
    oci_close($conn);
} else {
    echo json_encode(["error" => "No se ha proporcionado un ID de proyecto o un nuevo nombre."]);
}
?>

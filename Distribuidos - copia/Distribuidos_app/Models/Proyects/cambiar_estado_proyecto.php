<?php

// Incluir archivo de configuración de base de datos
include '../../Controllers/Controlador.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $projectId = $_POST['projectId'];
    $newStatus = $_POST['newStatus'];

    // Preparar la consulta SQL para cambiar el estado del proyecto
    $sql = "UPDATE proyecto SET ESTADO = :newStatus WHERE ID_PROYECTO = :projectId";

    $stid = oci_parse($conn, $sql);
    oci_bind_by_name($stid, ':newStatus', $newStatus);
    oci_bind_by_name($stid, ':projectId', $projectId);

    if (oci_execute($stid)) {
        echo json_encode(['message' => 'Estado del proyecto actualizado correctamente.']);
    } else {
        $e = oci_error($stid);
        echo json_encode(['error' => 'Error al actualizar el estado del proyecto: ' . $e['message']]);
    }

    oci_free_statement($stid);
    oci_close($conn);
}
?>

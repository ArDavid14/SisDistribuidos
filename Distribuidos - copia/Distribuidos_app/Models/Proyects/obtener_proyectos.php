<?php
// Inicio de sesión
session_start();

// Verificar si el ID de empleado está presente en la sesión
if (!isset($_SESSION['empleado_id'])) {
    http_response_code(401); // Unauthorized
    echo json_encode(array('error' => 'ID de empleado no encontrado en la sesión.'));
    exit();
}

// Incluir archivo de configuración de base de datos
include '../../Controllers/Controlador.php';

try {
    // Obtener el ID de empleado desde la sesión
    $empleado_id = $_SESSION['empleado_id'];

    // Preparar la consulta SQL para obtener los proyectos del empleado logueado
    $sql = "SELECT p.ID_PROYECTO AS id, p.NOMBRE, p.ESTADO 
            FROM proyecto p 
            WHERE p.FK_ID_EMPLEADO = :empleado_id";

    $stmt = oci_parse($conn, $sql);
    oci_bind_by_name($stmt, ":empleado_id", $empleado_id);
    oci_execute($stmt);

    // Obtener los resultados como un arreglo asociativo
    $projects = array();
    while ($row = oci_fetch_assoc($stmt)) {
        $projects[] = $row;
    }

    // Devolver los proyectos en formato JSON
    echo json_encode($projects);

} catch (Exception $ex) {
    http_response_code(500); // Internal Server Error
    echo json_encode(array('error' => 'Error: ' . $ex->getMessage()));
}

// Cerrar la conexión OCI
oci_close($conn);
?>



<?php
session_start();
// Verificar si el ID de empleado está presente en la sesión
if (!isset($_SESSION['empleado_id'])) {
    http_response_code(401); // Unauthorized
    echo json_encode(array('error' => 'ID de empleado no encontrado en la sesión.'));
    exit();
}

// Incluir archivo de configuración de base de datos
include '../../Controllers/Controlador.php';


// Si se ha enviado un nombre de proyecto desde el formulario, intenta insertarlo en la base de datos
if (isset($_POST['projectName'])) {
    // Prepara la consulta SQL para insertar el nuevo proyecto en la tabla "proyectos"
    $projectName = $_POST['projectName'];
    // Obtener el ID de empleado desde la sesión
    $empleado_id = $_SESSION['empleado_id'];
    $sql_insert_project = "INSERT INTO proyecto (nombre, estado, fk_id_empleado) VALUES (:projectName, 'Activo', :empleado_id)";

    // Prepara y ejecuta la consulta
    $stid = oci_parse($conn, $sql_insert_project);
    oci_bind_by_name($stid, ':projectName', $projectName);
    oci_bind_by_name($stid, ":empleado_id", $empleado_id); // Corrección aquí

    // Ejecuta la consulta
    if (oci_execute($stid)) {
        echo "<script>window.location.href = '../../Views/Proyects/proyectos.html';</script>";
    } else {
        $e = oci_error($stid);
        echo "Error al crear el proyecto: " . $e['message'];
    }

    // Libera los recursos asociados con la declaración
    oci_free_statement($stid);
}

// Cierra la conexión
oci_close($conn);
?>

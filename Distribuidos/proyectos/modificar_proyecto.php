<?php
if (isset($_POST['projectId']) && isset($_POST['newName'])) {
    $projectId = $_POST['projectId'];
    $newName = $_POST['newName'];

    // Configuración de la conexión a la base de datos Oracle
    $servername = "192.168.1.13"; // Dirección IP del servidor Oracle
    $port = "1521"; // Puerto de tu servidor Oracle
    $service_name = "free"; // Nombre del servicio Oracle (SID)
    $username = "Hr"; // Nombre de usuario de Oracle
    $password = "123456789"; // Contraseña de Oracle

    // Cadena de conexión utilizando la dirección IP, el puerto y el nombre del servicio
    $conn = oci_connect($username, $password, "(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=$servername)(PORT=$port))(CONNECT_DATA=(SERVICE_NAME=$service_name)))");

    if (!$conn) {
        $e = oci_error();
        die("Conexión fallida: " . $e['message']);
    }

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

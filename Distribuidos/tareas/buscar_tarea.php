<?php
if (isset($_GET['projectId'])) {
    // Obtener el ID de la planta desde la URL
    $idproyecto = $_GET['projectId'];
    // Configurar la conexión a la base de datos
    $servername = "localhost"; // Cambia esto por la dirección de tu servidor MySQL
    $username = "root"; // Cambia esto por tu nombre de usuario de MySQL
    $password = ""; // Cambia esto por tu contraseña de MySQL
    $dbname = "planificacion";

    // Crear la conexión
    $conn = new mysqli($servername, $username, $password, $dbname);

    // Verificar la conexión
    if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
    }

    // Preparar la consulta SQL para obtener los proyectos
    $sql = "SELECT * FROM tareas WHERE proyecto_id = $idproyecto";
    $result = $conn->query($sql);

    // Verificar si se encontraron proyectos
    if ($result->num_rows > 0) {
    // Crear un array para almacenar los proyectos
    $projects = array();

    // Iterar sobre los resultados y agregarlos al array
    while ($row = $result->fetch_assoc()) {
        $projects[] = $row;
    }

    // Devolver los proyectos en formato JSON
    echo json_encode($projects);
    } else {
    echo json_encode(array()); // Devolver un array vacío si no se encontraron proyectos
    }

    // Cerrar la conexión
    $conn->close();

} else {
    echo json_encode(array('error' => 'No se ha proporcionado un ID.'));
}
?>

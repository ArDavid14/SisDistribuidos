<?php
// Configuración de la conexión a la base de datos
$servername = "localhost"; // Cambia esto por la dirección de tu servidor MySQL
$username = "root"; // Cambia esto por tu nombre de usuario de MySQL
$password = ""; // Cambia esto por tu contraseña de MySQL
$dbname = "planificacion";

// Crea la conexión
$conn = new mysqli($servername, $username, $password, $dbname);

// Verifica la conexión
if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
} else {
    // Envía un mensaje a la consola del navegador si la conexión fue exitosa
    echo "<script>console.log('Conexión a la base de datos establecida');</script>";
}

// Si se ha enviado un nombre de proyecto desde el formulario, intenta insertarlo en la base de datos
if (isset($_POST['projectName'])) {
    // Prepara la consulta SQL para insertar el nuevo proyecto en la tabla "proyectos"
    $projectName = $_POST['projectName'];
    $sql_insert_project = "INSERT INTO proyectos (nombre) VALUES ('$projectName')";

    // Ejecuta la consulta
    if ($conn->query($sql_insert_project) === TRUE) {
        echo "<script>window.location.href = 'proyectos.html';</script>";
    } else {
        echo "Error al crear el proyecto: " . $conn->error;
    }
}

// Cierra la conexión
$conn->close();
?>

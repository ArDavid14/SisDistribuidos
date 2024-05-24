<?php

// Incluir archivo de configuración de base de datos
include '../../Controllers/Controlador.php';

session_start();

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $nombre = $_POST["nombre"];
    $cedula = $_POST["cedula"];

    // Verificar si el usuario es un empleado
    $sql = "SELECT * FROM EMPLEADOS WHERE NOMBRE_EMPLEADO = :nombre AND CEDULA_EMPLEADO = :cedula";
    $stmt = oci_parse($conn, $sql);
    oci_bind_by_name($stmt, ":nombre", $nombre);
    oci_bind_by_name($stmt, ":cedula", $cedula);
    oci_execute($stmt);

    // Verificar el resultado de la consulta
    $row = oci_fetch_assoc($stmt);
    if ($row) {
        $empleado_id = $row["ID_EMPLEADO"];

        // Almacenar datos en la sesión
        $_SESSION['nombreEmpleado'] = $nombre;
        $_SESSION['empleado_id'] = $empleado_id;

        // Redirigir al panel del empleado
        header("Location: ../../Views/Proyects/proyectos.html");
        exit();
    } else {
        // Credenciales incorrectas
        $error_message = "Credenciales incorrectas. Por favor, inténtalo de nuevo.";
        header("Location: login.html?error_message=" . urlencode($error_message));
        exit();
    }
}

// Cerrar la conexión
oci_close($conn);
?>

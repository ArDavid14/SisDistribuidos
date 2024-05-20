-- Crear la base de datos planificación si no existe
DROP DATABASE planificacion;
CREATE DATABASE planificacion;

-- Usar la base de datos planificación
USE planificacion;

-- Crear la tabla proyectos
CREATE TABLE proyectos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);

-- Crear la tabla tareas
CREATE TABLE tareas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    estado VARCHAR (255) NOT NULL,
    proyecto_id INT ,
    FOREIGN KEY (proyecto_id) REFERENCES proyectos(id)
);

select * from proyectos;
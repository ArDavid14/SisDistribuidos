document.addEventListener('DOMContentLoaded', function () {
    let selectedProjectId = null;

    const logoutBtn = document.getElementById("logoutBtn");
    logoutBtn.addEventListener("click", function() {
        window.location.href = '../Views/Login/login.html'; // Redirigir a la página de cierre de sesión
    });

    function modifyProject(projectId) {
        selectedProjectId = projectId;
        const newProjectName = prompt('Ingrese el nuevo nombre del proyecto:');
        
        if (newProjectName === null) {
            return; // Si el usuario cancela el prompt
        }

        if (newProjectName.trim() === '') {
            alert('El nombre del proyecto no puede estar vacío.');
            return;
        }

        if (confirm('¿Estás seguro de que deseas cambiar el nombre del proyecto?')) {
            fetch(`../Models/Proyects/modificar_proyecto.php`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: `projectId=${selectedProjectId}&newName=${encodeURIComponent(newProjectName)}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.message) {
                    alert(data.message);
                    fetchProjects();
                } else {
                    alert('Error al modificar el proyecto.');
                }
            })
            .catch(error => console.error('Error al modificar el proyecto:', error));
        }
    }

    function deleteProject(projectId) {
        selectedProjectId = projectId;
        console.log(projectId);
        const confirmDelete = confirm('¿Estás seguro de que deseas eliminar este proyecto? Esta acción eliminará todas las tareas asociadas.');
        if (confirmDelete) {
            if (projectId) {
                fetch('../Models/Proyects/eliminar_proyecto.php', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ projectId: selectedProjectId })
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Error en la respuesta del servidor.');
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.message) {
                        alert(data.message);
                        fetchProjects();
                    } else {
                        alert('Error al eliminar el proyecto: ' + (data.error || 'Error desconocido.'));
                    }
                })
                .catch(error => console.error('Error al eliminar el proyecto:', error));
            } else {
                console.error('El ID del proyecto no está definido.');
            }
        }
    }

    function toggleProjectStatus(projectId, currentStatus) {
        const newStatus = currentStatus === 'Activo' ? 'No activo' : 'Activo';
        if (confirm(`¿Estás seguro de que deseas cambiar el estado del proyecto a ${newStatus}?`)) {
            fetch('../Models/Proyects/cambiar_estado_proyecto.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: `projectId=${projectId}&newStatus=${encodeURIComponent(newStatus)}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.message) {
                    alert(data.message);
                    fetchProjects();
                } else {
                    alert('Error al cambiar el estado del proyecto.');
                }
            })
            .catch(error => console.error('Error al cambiar el estado del proyecto:', error));
        }
    }

    function fetchProjects() {
        fetch('../Models/Proyects/obtener_proyectos.php')
            .then(response => {
                if (!response.ok) {
                    throw new Error('No se pudo obtener la lista de proyectos.');
                }
                return response.json();
            })
            .then(data => {
                const projectsContainer = document.getElementById('projects-container');
                projectsContainer.innerHTML = '';
                data.forEach(project => {
                    const projectItem = document.createElement('div');
                    projectItem.classList.add('project-item');
                    projectItem.textContent = project.NOMBRE;
                    projectItem.dataset.id = project.ID;
                    projectItem.addEventListener('click', () => redirectToTasks(project.ID));

                    // Botón de modificar proyecto
                    const modifyButton = document.createElement('button');
                    modifyButton.textContent = 'Cambiar nombre';
                    modifyButton.addEventListener('click', (event) => {
                        event.stopPropagation();
                        modifyProject(project.ID);
                    });
                    projectItem.appendChild(modifyButton);

                    // Botón de eliminar proyecto
                    const deleteButton = document.createElement('button');
                    deleteButton.textContent = 'Eliminar';
                    deleteButton.addEventListener('click', (event) => {
                        event.stopPropagation();
                        deleteProject(project.ID);
                    });
                    projectItem.appendChild(deleteButton);

                    // Botón de cambiar estado del proyecto
                    const statusButton = document.createElement('button');
                    statusButton.textContent = project.ESTADO;
                    statusButton.addEventListener('click', (event) => {
                        event.stopPropagation();
                        toggleProjectStatus(project.ID, project.ESTADO);
                    });
                    projectItem.appendChild(statusButton);

                    projectsContainer.appendChild(projectItem);
                });
            })
            .catch(error => console.error('Error al obtener proyectos:', error));
    }

    fetchProjects();

    function selectProject(projectId) {
        const projectItems = document.querySelectorAll('.project-item');
        projectItems.forEach(item => {
            item.classList.remove('selected');
        });
        selectedProjectId = projectId;
        const selectedProjectItem = document.querySelector(`.project-item[data-id="${projectId}"]`);
        selectedProjectItem.classList.add('selected');
    }

    function redirectToTasks(projectId) {
        window.location.href = `../tareas/tareas.html?projectId=${projectId}`;
    }
});

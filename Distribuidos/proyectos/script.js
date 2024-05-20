document.addEventListener('DOMContentLoaded', function () {
    let selectedProjectId = null;

    function validateForm() {
        const projectNameInput = document.getElementById('projectName');
        const projectName = projectNameInput.value.trim();

        if (!projectName) {
            alert('Por favor, ingrese un nombre para el proyecto.');
            return false;
        }

        return true;
    }

    function modifyProject(projectId) {
        selectedProjectId = projectId;
        const modifyModal = document.getElementById('modifyProjectModal');
        modifyModal.style.display = 'block';
    }

    function closeModifyModal() {
        const modifyModal = document.getElementById('modifyProjectModal');
        modifyModal.style.display = 'none';
    }

    function confirmModifyProject() {
        const newProjectNameInput = document.getElementById('newProjectName');
        const newProjectName = newProjectNameInput.value.trim();

        if (!newProjectName) {
            alert('Por favor, ingrese un nuevo nombre para el proyecto.');
            return;
        }

        if (confirm('¿Estás seguro de que deseas cambiar el nombre del proyecto?')) {
            fetch('modificar_proyecto.php', {
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
                    closeModifyModal();
                    fetchProjects();
                } else {
                    alert('Error al modificar el proyecto.');
                }
            })
            .catch(error => console.error('Error al modificar el proyecto:', error));
        }
    }

    function deleteProject(projectId) {
        const confirmDelete = confirm('¿Estás seguro de que deseas eliminar este proyecto? Esta acción eliminará todas las tareas asociadas.');
        if (confirmDelete) {
            fetch(`eliminar_proyecto.php?projectId=${projectId}`, {
                method: 'DELETE'
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Error al eliminar el proyecto.');
                }
                return response.json();
            })
            .then(data => {
                alert('Proyecto eliminado correctamente.');
                fetchProjects();
            })
            .catch(error => console.error('Error al eliminar el proyecto:', error));
        }
    }

    function fetchProjects() {
        fetch('obtener_proyectos.php')
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

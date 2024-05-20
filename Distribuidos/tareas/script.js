document.addEventListener('DOMContentLoaded', function () {
    const urlParams = new URLSearchParams(window.location.search);
    const projectId = urlParams.get('projectId');

    var xhr = new XMLHttpRequest();
    xhr.open("GET", `buscar_tarea.php?projectId=${projectId}`, true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            var tasks = JSON.parse(xhr.responseText);
            tasks.forEach(function (task) {
                var listItem = document.createElement("li");
                listItem.textContent = task.NOMBRE;
                listItem.draggable = true;
                listItem.classList.add('draggable');
                listItem.setAttribute('data-task-id', task.ID_TAREA);

                var deleteButton = createDeleteButton(task.ID_TAREA);
                listItem.appendChild(deleteButton);

                var modifyButton = createModifyButton(task.ID_TAREA);
                listItem.appendChild(modifyButton);

                listItem.addEventListener('dragstart', function(e) {
                    const taskId = e.target.getAttribute('data-task-id');
                    e.dataTransfer.setData('text/plain', taskId);
                });

                var containerId;
                switch (task.ESTADO) {
                    case 'Por Hacer':
                        containerId = 'todo';
                        break;
                    case 'En Proceso':
                        containerId = 'in-progress';
                        break;
                    case 'Hecho':
                        containerId = 'done';
                        break;
                    default:
                        containerId = 'todo';
                }
                var defaultContainer = document.getElementById(containerId).querySelector(".task-items");
                addDragListeners(listItem);
                defaultContainer.appendChild(listItem);
            });
        }
    };
    xhr.send();

    function addDragListeners(task) {
        task.addEventListener('dragstart', dragStart);
        task.addEventListener('dragend', dragEnd);
    }

    function dragStart(e) {
        this.classList.add('dragging');
    }

    function dragEnd(e) {
        this.classList.remove('dragging');
    }

    const containers = document.querySelectorAll('.task-item');

    containers.forEach(container => {
        container.addEventListener('dragover', dragOver);
        container.addEventListener('drop', dragDrop);
    });

    function dragOver(e) {
        e.preventDefault();
        if (this.querySelector('.task-items').children.length === 0 || this.querySelector('.task-items').children[0] !== document.querySelector('.dragging')) {
            this.classList.add('over');
        }
    }

    function dragDrop(e) {
        e.preventDefault();
        const taskId = e.dataTransfer.getData('text/plain');

        if (taskId) {
            const draggable = document.querySelector(`[data-task-id="${taskId}"]`);
            const parent = draggable.parentNode;

            if (this !== parent && !this.contains(draggable)) {
                this.querySelector('.task-items').appendChild(draggable);

                let newState;
                switch (this.id) {
                    case 'todo':
                        newState = 'Por Hacer';
                        break;
                    case 'in-progress':
                        newState = 'En Proceso';
                        break;
                    case 'done':
                        newState = 'Hecho';
                        break;
                    default:
                        newState = 'Por Hacer';
                }

                const xhr = new XMLHttpRequest();
                const url = 'actualizar_estado_tarea.php';
                const params = `task_id=${taskId}&new_state=${encodeURIComponent(newState)}`;
                xhr.open('POST', url, true);
                xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                xhr.onreadystatechange = function () {
                    if (xhr.readyState == 4) {
                        if (xhr.status == 200) {
                            console.log(xhr.responseText);
                        } else {
                            console.error('Error en la solicitud AJAX');
                        }
                    }
                };
                xhr.send(params);
            }
        }

        this.classList.remove('over');
    }

    function createDeleteButton(taskId) {
        const deleteButton = document.createElement("button");
        deleteButton.textContent = "Eliminar";
        deleteButton.classList.add("delete-button");
        deleteButton.addEventListener("click", function () {
            if (confirm("¿Estás seguro de que quieres eliminar esta tarea?")) {
                deleteTask(taskId);
            }
        });
        return deleteButton;
    }

    function createModifyButton(taskId) {
        const modifyButton = document.createElement("button");
        modifyButton.textContent = "Cambiar nombre";
        modifyButton.classList.add("modify-button");
        modifyButton.addEventListener("click", function () {
            const newTaskName = prompt("Ingrese el nuevo nombre de la tarea:");
            if (newTaskName === null) {
                return;
            }
            if (newTaskName.trim() === '') {
                alert('El nombre de la tarea no puede estar vacío.');
                return;
            }
            if (confirm('¿Estás seguro de que deseas cambiar el nombre de la tarea?')) {
                modifyTask(taskId, newTaskName);
            }
        });
        return modifyButton;
    }

    function modifyTask(taskId, newTaskName) {
        const xhr = new XMLHttpRequest();
        const url = 'modificar_tarea.php';
        const params = `task_id=${taskId}&new_name=${encodeURIComponent(newTaskName)}`;
        xhr.open('POST', url, true);
        xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                const taskElement = document.querySelector(`[data-task-id="${taskId}"]`);
                taskElement.firstChild.textContent = newTaskName;
                alert('Tarea modificada correctamente.');
            } else if (xhr.readyState == 4) {
                alert('Error al modificar la tarea.');
            }
        };
        xhr.send(params);
    }

    function deleteTask(taskId) {
        const xhr = new XMLHttpRequest();
        const url = 'eliminar_tarea.php';
        const params = `task_id=${taskId}`;
        xhr.open('POST', url, true);
        xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4) {
                if (xhr.status == 200) {
                    const taskToRemove = document.querySelector(`[data-task-id="${taskId}"]`);
                    if (taskToRemove) {
                        taskToRemove.remove();
                    }
                } else {
                    console.error('Error en la solicitud AJAX');
                }
            }
        };
        xhr.send(params);
    }

    // Abrir modal para agregar tarea
    function openModal() {
        const modal = document.getElementById('taskModal');
        modal.style.display = 'block';
    }

    // Cerrar modal
    function closeModal() {
        const modal = document.getElementById('taskModal');
        modal.style.display = 'none';
    }

    // Agregar tarea desde modal
    function addTaskFromModal() {
        const taskNameInput = document.getElementById('taskNameInput');
        const taskName = taskNameInput.value;
        if (taskName.trim() === '') {
            alert('El nombre de la tarea no puede estar vacío.');
            return;
        }
        const xhr = new XMLHttpRequest();
        const url = `agregar_tarea.php?projectId=${projectId}`;
        const params = `task_name=${encodeURIComponent(taskName)}`;
        xhr.open('POST', url, true);
        xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                const taskId = xhr.responseText; // Obtener el ID de la tarea desde la respuesta del servidor
                var listItem = document.createElement("li");
                listItem.textContent = taskName;
                listItem.draggable = true;
                listItem.classList.add('draggable');
                listItem.setAttribute('data-task-id', taskId);

                var deleteButton = createDeleteButton(taskId);
                listItem.appendChild(deleteButton);

                var modifyButton = createModifyButton(taskId);
                listItem.appendChild(modifyButton);

                addDragListeners(listItem);

                var defaultContainer = document.getElementById("todo").querySelector(".task-items");
                defaultContainer.appendChild(listItem);

                taskNameInput.value = ''; // Limpiar el campo de entrada
                closeModal();
            } else if (xhr.readyState == 4) {
                alert('Error al agregar la tarea.');
            }
        };
        xhr.send(params);
        location.reload();
    }

    // Evento click del botón para abrir modal
    const addTaskBtn = document.getElementById('addTaskBtn');
    addTaskBtn.addEventListener('click', openModal);

    // Evento click del botón para agregar tarea desde modal
    const addTaskModalBtn = document.getElementById('addTaskModalBtn');
    addTaskModalBtn.addEventListener('click', addTaskFromModal);

    // Evento click para cerrar modal si se hace clic en la "x"
    const closeBtn = document.querySelector('.close');
    closeBtn.addEventListener('click', closeModal);
});


document.addEventListener('DOMContentLoaded', function () {
    const backBtn = document.getElementById("backBtn");
    backBtn.addEventListener("click", function() {
        window.history.back();
    });

    const logoutBtn = document.getElementById("logoutBtn");
    logoutBtn.addEventListener("click", function() {
        window.location.href = '../Views/Login/login.html'; // Redirigir a la página de cierre de sesión
    });

    const urlParams = new URLSearchParams(window.location.search);
    const projectId = urlParams.get('projectId');

    var xhr = new XMLHttpRequest();
    xhr.open("GET", `../Models/Tasks/buscar_tarea.php?projectId=${projectId}`, true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            var tasks = JSON.parse(xhr.responseText);
            tasks.forEach(function (task) {
                var listItem = document.createElement("li");
                listItem.innerHTML = `
                    <strong>${task.NOMBRE}</strong>
                    <br>Descripción: ${task.DESCRIPCION}
                    <br>Fecha de inicio: ${task.FECHA_DE_INICIO}
                    <br>Fecha final: ${task.FECHA_FINAL}
                `;
                listItem.draggable = true;
                listItem.classList.add('draggable');
                listItem.setAttribute('data-task-id', task.ID_TAREA);

                var deleteButton = createDeleteButton(task.ID_TAREA);
                listItem.appendChild(deleteButton);

                var modifyButton = createModifyButton(task.ID_TAREA, task.NOMBRE, task.DESCRIPCION);
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
                let newDate;
                switch (this.id) {
                    case 'todo':
                        newState = 'Por Hacer';
                        newDate = 'Sin finalizar';
                        break;
                    case 'in-progress':
                        newState = 'En Proceso';
                        newDate = 'Sin finalizar';
                        break;
                    case 'done':
                        newState = 'Hecho';
                        newDate = formatDate(new Date());; // Fecha actual en formato YYYY-MM-DD
                        break;
                    default:
                        newState = 'Por Hacer';
                        newDate = 'Sin finalizar';
                }
    
                const xhr = new XMLHttpRequest();
                const url = '../Models/Tasks/actualizar_estado_tarea.php';
                const params = `task_id=${taskId}&new_state=${encodeURIComponent(newState)}&new_date=${encodeURIComponent(newDate)}`;
                xhr.open('POST', url, true);
                xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                xhr.onreadystatechange = function () {
                    if (xhr.readyState == 4) {
                        if (xhr.status == 200) {
                            const response = JSON.parse(xhr.responseText);
                            if (response.success) {
                                // Actualizar el estado y la fecha de la tarea en el DOM
                                const taskElement = document.querySelector(`[data-task-id="${taskId}"]`);
                                taskElement.querySelector('.task-state').textContent = newState;
                                taskElement.querySelector('.task-date').textContent = newDate;
                                console.log(response.message);
                            } else {
                                console.error('Error al actualizar la tarea:', response.message);
                            }
                        } else {
                            console.error('Error en la solicitud AJAX');
                        }
                    }
                };
                
                xhr.send(params);
                
            }
            setTimeout(() => {
                location.reload();
            }, 700);
        }
    
        this.classList.remove('over');
        location.reload();
    }
    
    function formatDate(date) {
        if (date === 'Sin finalizar') {
            return date;
        }
        let d = new Date(date);
        let year = d.getFullYear().toString().slice(-2);
        let month = (d.getMonth() + 1).toString().padStart(2, '0');
        let day = d.getDate().toString().padStart(2, '0');
        return `${day}/${month}/${year}`;
    }

    function deleteTask(taskId) {
        console.log('Deleting task with ID:', taskId);
        const xhr = new XMLHttpRequest();
        const url = '../Models/Tasks/eliminar_tarea.php';
        const params = `task_id=${taskId}`;
        xhr.open('POST', url, true);
        xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4) {
                console.log('Server response:', xhr.responseText);
                if (xhr.status == 200) {
                    console.log('Task deleted successfully');
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

    function createModifyButton(taskId, taskName, taskDescription) {
        const modifyButton = document.createElement("button");
        modifyButton.textContent = "Cambiar";
        modifyButton.classList.add("modify-button");
        modifyButton.addEventListener("click", function () {
            openModifyModal(taskId, taskName, taskDescription);
        });
        return modifyButton;
    }

    function openModifyModal(taskId, taskName, taskDescription) {
        const modal = document.getElementById('modifyModal');
        const taskNameInput = document.getElementById('modifyTaskNameInput');
        const taskDescriptionInput = document.getElementById('modifyTaskDescriptionInput');

        taskNameInput.value = taskName;
        taskDescriptionInput.value = taskDescription;
        modal.setAttribute('data-task-id', taskId);
        modal.style.display = 'block';
    }

    function closeModal() {
        const modal = document.getElementById('taskModal');
        modal.style.display = 'none';
    }

    function closeModifyModal() {
        const modal = document.getElementById('modifyModal');
        modal.style.display = 'none';
    }

    function modifyTask() {
        const taskId = document.getElementById('modifyModal').getAttribute('data-task-id');
        const taskNameInput = document.getElementById('modifyTaskNameInput');
        const taskDescriptionInput = document.getElementById('modifyTaskDescriptionInput');
        const newTaskName = taskNameInput.value;
        const newTaskDescription = taskDescriptionInput.value;
    
        if (newTaskName.trim() === '') {
            alert('El nombre de la tarea no puede estar vacío.');
            return;
        }
        if (newTaskDescription.trim() === '') {
            alert('La descripción de la tarea no puede estar vacía.');
            return;
        }
    
        const xhr = new XMLHttpRequest();
        const url = '../Models/Tasks/modificar_tarea.php';
        const params = `task_id=${taskId}&new_name=${encodeURIComponent(newTaskName)}&new_description=${encodeURIComponent(newTaskDescription)}`;
        xhr.open('POST', url, true);
        xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                const taskElement = document.querySelector(`[data-task-id="${taskId}"]`);
                taskElement.innerHTML = `
                    <strong>${newTaskName}</strong>
                    <br>Descripción: ${newTaskDescription}
                    <br>Fecha de inicio: ${taskElement.querySelector('br:nth-of-type(2)').textContent.split(': ')[1]}
                    <br>Fecha final: ${taskElement.querySelector('br:nth-of-type(3)').textContent.split(': ')[1]}
                `;
                const deleteButton = createDeleteButton(taskId);
                const modifyButton = createModifyButton(taskId, newTaskName, newTaskDescription);
                taskElement.appendChild(deleteButton);
                taskElement.appendChild(modifyButton);
                alert('Tarea modificada correctamente.');
                closeModifyModal();
            } else if (xhr.readyState == 4) {
                alert('Error al modificar la tarea.');
            }
        };
        xhr.send(params);
        setTimeout(() => {
            location.reload();
        }, 700);
    }
    

    // Abrir modal para agregar tarea
    function openModal() {
        const modal = document.getElementById('taskModal');
        modal.style.display = 'block';
    }

    // Cerrar modal
    const closeButtons = document.querySelectorAll('.close');
    closeButtons.forEach(button => button.addEventListener('click', function() {
        closeModal();
        closeModifyModal();
    }));

    // Agregar tarea desde modal
    function addTaskFromModal() {
        const taskNameInput = document.getElementById('taskNameInput');
        const taskDescriptionInput = document.getElementById('taskDescriptionInput');
        const taskName = taskNameInput.value;
        const taskDescription = taskDescriptionInput.value;

        if (taskName.trim() === '') {
            alert('El nombre de la tarea no puede estar vacío.');
            return;
        }
        if (taskDescription.trim() === '') {
            alert('La descripción de la tarea no puede estar vacía.');
            return;
        }

        const currentDate = new Date().toISOString().split('T')[0]; // Obtener la fecha actual en formato YYYY-MM-DD
        const defaultEndDate = '2025-01-01'; // Fecha final por defecto

        const xhr = new XMLHttpRequest();
        const url = `../Models/Tasks/agregar_tarea.php?projectId=${projectId}`;
        const params = `task_name=${encodeURIComponent(taskName)}&task_description=${encodeURIComponent(taskDescription)}&start_date=${encodeURIComponent(currentDate)}&end_date=${encodeURIComponent(defaultEndDate)}`;
        xhr.open('POST', url, true);
        xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                const taskId = xhr.responseText; // Obtener el ID de la tarea desde la respuesta del servidor
                var listItem = document.createElement("li");
                listItem.innerHTML = `
                    <strong>${taskName}</strong>
                    <br>Descripción: ${taskDescription}
                    <br>Fecha de inicio: ${currentDate}
                    <br>Fecha final: ${defaultEndDate}
                `;
                listItem.draggable = true;
                listItem.classList.add('draggable');
                listItem.setAttribute('data-task-id', taskId);

                var deleteButton = createDeleteButton(taskId);
                listItem.appendChild(deleteButton);

                var modifyButton = createModifyButton(taskId, taskName, taskDescription);
                listItem.appendChild(modifyButton);

                addDragListeners(listItem);

                var defaultContainer = document.getElementById("todo").querySelector(".task-items");
                defaultContainer.appendChild(listItem);

                taskNameInput.value = ''; // Limpiar el campo de entrada
                taskDescriptionInput.value = ''; // Limpiar el campo de descripción
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

    // Evento click del botón para guardar cambios desde modal de modificación
    const modifyTaskModalBtn = document.getElementById('modifyTaskModalBtn');
    modifyTaskModalBtn.addEventListener('click', modifyTask);
});
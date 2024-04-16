document.addEventListener('DOMContentLoaded', function () {

    const urlParams = new URLSearchParams(window.location.search);
    const projectId = urlParams.get('projectId');
    
    var xhr = new XMLHttpRequest();
    xhr.open("GET", `buscar_tarea.php?projectId=${projectId}`, true); // Corregido para incluir el projectId en la URL
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            var tasks = JSON.parse(xhr.responseText);
            tasks.forEach(function (task) {
                var listItem = document.createElement("li");
                listItem.textContent = task.nombre;
                listItem.draggable = true;
                listItem.classList.add('draggable');
                listItem.setAttribute('data-task-id', task.id);

                // Seleccionar el contenedor basado en el estado de la tarea
                var containerId;
                switch (task.estado) {
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
                        containerId = 'todo'; // Contenedor predeterminado si el estado es desconocido
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
        const xhr = new XMLHttpRequest();
        const url = `agregar_tarea.php?projectId=${projectId}`; // Corregido para incluir projectId en la URL
        const params = `task_name=${taskName}`;
        xhr.open("POST", url, true);
        xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                const taskId = xhr.responseText; // Obtener el ID de la tarea desde la respuesta del servidor
                // Crear un nuevo elemento <li> para la tarea
                var listItem = document.createElement("li");
                listItem.textContent = taskName;
                listItem.draggable = true;
                listItem.classList.add('draggable');
                // Agregar los event listeners de arrastrar y soltar
                addDragListeners(listItem);
                // Obtener el contenedor predeterminado como "Por Hacer"
                var defaultContainer = document.getElementById("todo").querySelector(".task-items");
                // Agregar la tarea al contenedor correspondiente
                defaultContainer.appendChild(listItem);
            }
        };
        xhr.send(params);
        closeModal();
    }
    
    // Función para obtener el valor de un parámetro de la URL
    function getParameterByName(name, url) {
        if (!url) url = window.location.href;
        name = name.replace(/[\[\]]/g, '\\$&');
        var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
            results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, ' '));
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

    // Event listeners para la funcionalidad de arrastrar y soltar tareas
    const tasks = document.querySelectorAll('.task-items li');

    tasks.forEach(task => {
        task.addEventListener('dragstart', dragStart);
        task.addEventListener('dragend', dragEnd);
    });

    function dragStart(e) {
        // Obtener el ID de la tarea y establecerlo como dato en el evento de arrastre
        const taskId = e.target.getAttribute('data-task-id');
        e.dataTransfer.setData('text/plain', taskId);
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
        const taskId = e.dataTransfer.getData('text/plain'); // Obtener el ID de la tarea desde el evento de arrastre

        if (taskId) {
            const draggable = document.querySelector(`[data-task-id="${taskId}"]`);
            const parent = draggable.parentNode;

            if (this !== parent && !this.contains(draggable)) {
                // Mover el elemento arrastrable al nuevo contenedor
                this.querySelector('.task-items').appendChild(draggable);

                // Obtener el nuevo estado basado en el ID del contenedor
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
                        newState = 'Por Hacer'; // Estado predeterminado
                }

                // Enviar una solicitud AJAX para actualizar el estado de la tarea
                const xhr = new XMLHttpRequest();
                const url = 'actualizar_estado_tarea.php';
                const params = `task_id=${taskId}&new_state=${encodeURIComponent(newState)}`; // Codificar el nuevo estado
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
});

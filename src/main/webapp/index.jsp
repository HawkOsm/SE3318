<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TODO List | Task Manager</title>
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-color: #00d2ff;
            --secondary-color: #3a7bd5;
            --bg-dark: #0f0c29;
            --success-color: #92fe9d;
            --danger-color: #ff6b6b;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            color: white;
            padding: 20px;
            overflow-y: auto;
        }

        /* Background glow effect */
        .glow {
            position: fixed;
            width: 300px;
            height: 300px;
            background: var(--primary-color);
            filter: blur(150px);
            border-radius: 50%;
            z-index: 0;
            opacity: 0.4;
            animation: pulse 8s infinite alternate;
            top: -100px;
            left: -100px;
        }

        /* Main Container */
        .todo-container {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 700px;
            padding: 2.5rem;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(15px);
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            animation: fadeInDown 1.5s ease-out;
        }

        h1 {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            background: linear-gradient(to right, #00d2ff, #92fe9d);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: -1px;
        }

        .status {
            font-size: 0.9rem;
            color: rgba(255, 255, 255, 0.6);
            text-transform: uppercase;
            letter-spacing: 2px;
            margin-bottom: 1.5rem;
        }

        /* Input Section */
        .input-section {
            display: flex;
            gap: 10px;
            margin-bottom: 2rem;
        }

        .input-section input {
            flex: 1;
            padding: 12px 16px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            color: white;
            font-size: 1rem;
            transition: all 0.3s;
        }

        .input-section input:focus {
            outline: none;
            background: rgba(255, 255, 255, 0.15);
            border-color: var(--primary-color);
            box-shadow: 0 0 10px rgba(0, 210, 255, 0.3);
        }

        .input-section input::placeholder {
            color: rgba(255, 255, 255, 0.5);
        }

        .btn-add {
            padding: 12px 24px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border: none;
            border-radius: 12px;
            color: var(--bg-dark);
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0, 210, 255, 0.3);
        }

        .btn-add:active {
            transform: translateY(0);
        }

        /* Tasks List */
        .tasks-list {
            max-height: 500px;
            overflow-y: auto;
            padding-right: 8px;
        }

        .tasks-list::-webkit-scrollbar {
            width: 6px;
        }

        .tasks-list::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 10px;
        }

        .tasks-list::-webkit-scrollbar-thumb {
            background: rgba(0, 210, 255, 0.3);
            border-radius: 10px;
        }

        .tasks-list::-webkit-scrollbar-thumb:hover {
            background: rgba(0, 210, 255, 0.5);
        }

        .task-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 16px;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            margin-bottom: 10px;
            transition: all 0.3s;
            animation: fadeInUp 0.5s ease-out;
        }

        .task-item:hover {
            background: rgba(255, 255, 255, 0.12);
            border-color: rgba(0, 210, 255, 0.3);
        }

        .task-item.completed {
            opacity: 0.6;
        }

        .task-item.completed .task-text {
            text-decoration: line-through;
            color: rgba(255, 255, 255, 0.5);
        }

        /* Checkbox */
        .task-checkbox {
            width: 20px;
            height: 20px;
            cursor: pointer;
            accent-color: var(--primary-color);
        }

        /* Task Text */
        .task-text {
            flex: 1;
            font-size: 1rem;
            word-break: break-word;
            transition: all 0.3s;
        }

        /* Action Buttons */
        .task-actions {
            display: flex;
            gap: 8px;
        }

        .btn-icon {
            width: 36px;
            height: 36px;
            border: none;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border-radius: 8px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s;
            font-size: 1.2rem;
        }

        .btn-icon:hover {
            transform: scale(1.1);
        }

        .btn-edit:hover {
            background: rgba(0, 210, 255, 0.3);
            color: var(--primary-color);
        }

        .btn-delete:hover {
            background: rgba(255, 107, 107, 0.3);
            color: var(--danger-color);
        }

        /* Edit Mode */
        .edit-input {
            flex: 1;
            padding: 10px 14px;
            background: rgba(255, 255, 255, 0.15);
            border: 1px solid var(--primary-color);
            border-radius: 8px;
            color: white;
            font-size: 1rem;
        }

        .edit-input:focus {
            outline: none;
            box-shadow: 0 0 10px rgba(0, 210, 255, 0.3);
        }

        .btn-save, .btn-cancel {
            padding: 8px 14px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: bold;
            transition: all 0.3s;
        }

        .btn-save {
            background: var(--success-color);
            color: var(--bg-dark);
        }

        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(146, 254, 157, 0.3);
        }

        .btn-cancel {
            background: rgba(255, 255, 255, 0.2);
            color: white;
        }

        .btn-cancel:hover {
            background: rgba(255, 255, 255, 0.3);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 2rem;
            color: rgba(255, 255, 255, 0.5);
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        /* Loading State */
        .loading {
            text-align: center;
            padding: 2rem;
            color: rgba(255, 255, 255, 0.6);
        }

        .spinner {
            display: inline-block;
            width: 30px;
            height: 30px;
            border: 3px solid rgba(0, 210, 255, 0.2);
            border-top-color: var(--primary-color);
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
            margin-right: 10px;
            vertical-align: middle;
        }

        /* Animations */
        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-30px); filter: blur(10px); }
            to { opacity: 1; transform: translateY(0); filter: blur(0); }
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes pulse {
            0% { transform: scale(1); opacity: 0.3; }
            100% { transform: scale(1.5); opacity: 0.6; }
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Task count */
        .task-count {
            font-size: 0.9rem;
            color: rgba(255, 255, 255, 0.6);
            margin-top: 1rem;
            text-align: center;
        }

        /* Responsive */
        @media (max-width: 600px) {
            .todo-container {
                padding: 1.5rem;
                max-width: 100%;
            }

            h1 {
                font-size: 2rem;
            }

            .input-section {
                flex-direction: column;
            }

            .btn-add {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="glow"></div>
    
    <div class="todo-container">
        <p class="status">System Status: Online</p>
        <h1><i class="bi bi-check2-square"></i> TODO List</h1>

        <div class="input-section">
            <input type="text" id="taskInput" placeholder="Add a new task..." />
            <button class="btn-add" onclick="addTask()">
                <i class="bi bi-plus-lg"></i> Add
            </button>
        </div>

        <div id="tasksList" class="tasks-list"></div>

        <div class="task-count">
            <span id="taskCount">Loading tasks...</span>
        </div>
    </div>

    <script>
        const API_BASE_URL = '/api/tasks';

        // Load tasks on page load
        document.addEventListener('DOMContentLoaded', function() {
            loadTasks();

            // Allow Enter key to add task
            document.getElementById('taskInput').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    addTask();
                }
            });
        });

        /**
         * Load all tasks from the API
         */
        async function loadTasks() {
            const tasksList = document.getElementById('tasksList');

            try {
                tasksList.innerHTML = '<div class="loading"><div class="spinner"></div>Loading tasks...</div>';

                const response = await fetch(API_BASE_URL);

                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }

                const tasks = await response.json();

                if (tasks.length === 0) {
                    tasksList.innerHTML = `
                        <div class="empty-state">
                            <i class="bi bi-inbox"></i>
                            <p>No tasks yet. Add one to get started!</p>
                        </div>
                    `;
                    updateTaskCount(0);
                } else {
                    tasksList.innerHTML = '';
                    tasks.forEach(task => {
                        tasksList.appendChild(createTaskElement(task));
                    });
                    updateTaskCount(tasks.length);
                }
            } catch (error) {
                console.error('Error loading tasks:', error);
                tasksList.innerHTML = `
                    <div class="empty-state">
                        <i class="bi bi-exclamation-triangle"></i>
                        <p>Error loading tasks. Please refresh the page.</p>
                    </div>
                `;
            }
        }

        /**
         * Create a task element
         */
        function createTaskElement(task) {
            const div = document.createElement('div');
            div.className = `task-item ${task.completed ? 'completed' : ''}`;
            div.id = `task-${task.id}`;

            div.innerHTML = `
                <input type="checkbox" class="task-checkbox"
                       ${task.completed ? 'checked' : ''}
                       onchange="toggleTask(${task.id}, this.checked)">
                <span class="task-text" data-task-id="${task.id}">${escapeHtml(task.title)}</span>
                <div class="task-actions">
                    <button class="btn-icon btn-edit" onclick="startEditTask(${task.id}, '${escapeHtml(task.title).replace(/'/g, "\\'")}')">
                        <i class="bi bi-pencil"></i>
                    </button>
                    <button class="btn-icon btn-delete" onclick="deleteTask(${task.id})">
                        <i class="bi bi-trash"></i>
                    </button>
                </div>
            `;

            return div;
        }

        /**
         * Add a new task
         */
        async function addTask() {
            const input = document.getElementById('taskInput');
            const title = input.value.trim();

            if (!title) {
                alert('Please enter a task title');
                return;
            }

            try {
                const response = await fetch(API_BASE_URL, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        title: title,
                        completed: false
                    })
                });

                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }

                const newTask = await response.json();
                input.value = '';
                loadTasks();
            } catch (error) {
                console.error('Error adding task:', error);
                alert('Failed to add task. Please try again.');
            }
        }

        /**
         * Toggle task completion status
         */
        async function toggleTask(taskId, completed) {
            try {
                const response = await fetch(`${API_BASE_URL}/${taskId}`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        completed: completed
                    })
                });

                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }

                loadTasks();
            } catch (error) {
                console.error('Error toggling task:', error);
                alert('Failed to update task. Please try again.');
                loadTasks();
            }
        }

        /**
         * Start editing a task
         */
        function startEditTask(taskId, currentTitle) {
            const taskElement = document.getElementById(`task-${taskId}`);

            taskElement.innerHTML = `
                <input type="text" class="edit-input" id="edit-input-${taskId}" value="${currentTitle}" />
                <div class="task-actions">
                    <button class="btn-save" onclick="saveEditTask(${taskId})">
                        <i class="bi bi-check-lg"></i> Save
                    </button>
                    <button class="btn-cancel" onclick="cancelEditTask(${taskId})">
                        <i class="bi bi-x-lg"></i> Cancel
                    </button>
                </div>
            `;

            const input = document.getElementById(`edit-input-${taskId}`);
            input.focus();
            input.select();

            input.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    saveEditTask(taskId);
                } else if (e.key === 'Escape') {
                    cancelEditTask(taskId);
                }
            });
        }

        /**
         * Save edited task
         */
        async function saveEditTask(taskId) {
            const newTitle = document.getElementById(`edit-input-${taskId}`).value.trim();

            if (!newTitle) {
                alert('Task title cannot be empty');
                return;
            }

            try {
                const response = await fetch(`${API_BASE_URL}/${taskId}`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        title: newTitle
                    })
                });

                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }

                loadTasks();
            } catch (error) {
                console.error('Error saving task:', error);
                alert('Failed to save task. Please try again.');
                loadTasks();
            }
        }

        /**
         * Cancel editing a task
         */
        function cancelEditTask(taskId) {
            loadTasks();
        }

        /**
         * Delete a task
         */
        async function deleteTask(taskId) {
            if (!confirm('Are you sure you want to delete this task?')) {
                return;
            }

            try {
                const response = await fetch(`${API_BASE_URL}/${taskId}`, {
                    method: 'DELETE'
                });

                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }

                loadTasks();
            } catch (error) {
                console.error('Error deleting task:', error);
                alert('Failed to delete task. Please try again.');
            }
        }

        /**
         * Update task count display
         */
        function updateTaskCount(total) {
            const taskCount = document.getElementById('taskCount');
            if (total === 0) {
                taskCount.textContent = 'No tasks yet';
            } else if (total === 1) {
                taskCount.textContent = '1 task';
            } else {
                taskCount.textContent = `${total} tasks`;
            }
        }

        /**
         * Escape HTML to prevent XSS
         */
        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }
    </script>
</body>
</html>
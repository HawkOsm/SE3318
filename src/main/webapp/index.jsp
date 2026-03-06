<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TODO List | The Experience</title>
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        :root {
            --primary-color: #00d2ff;
            --secondary-color: #3a7bd5;
            --bg-dark: #0f0c29;
            --success-color: #92fe9d;
            --danger-color: #ff4d6d;
            --warning-color: #ffc107;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding-top: 5vh;
            min-height: 100vh;
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            color: white;
        }

        /* Background glow effects */
        .glow {
            position: fixed;
            width: 300px;
            height: 300px;
            background: var(--primary-color);
            filter: blur(150px);
            border-radius: 50%;
            z-index: 0;
            opacity: 0.3;
            animation: pulse 8s infinite alternate;
            top: 10%;
            left: 20%;
        }

        .glow-2 {
            position: fixed;
            width: 250px;
            height: 250px;
            background: var(--secondary-color);
            filter: blur(150px);
            border-radius: 50%;
            z-index: 0;
            opacity: 0.25;
            animation: pulse 10s infinite alternate-reverse;
            bottom: 10%;
            right: 15%;
        }

        /* Main Container */
        .container {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 600px;
            padding: 2.5rem;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(15px);
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            animation: fadeIn 0.8s ease-out;
        }

        /* Header */
        .header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .header p.status {
            font-size: 0.85rem;
            color: rgba(255, 255, 255, 0.5);
            text-transform: uppercase;
            letter-spacing: 4px;
            margin-bottom: 0.5rem;
            animation: fadeInUp 1s ease-out;
        }

        .header h1 {
            font-size: 3rem;
            background: linear-gradient(to right, #00d2ff, #92fe9d);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: -1px;
            animation: fadeInDown 1s ease-out;
        }

        .header .task-count {
            font-size: 0.9rem;
            color: rgba(255, 255, 255, 0.4);
            margin-top: 0.5rem;
        }

        /* Add Task Form */
        .add-task-form {
            display: flex;
            gap: 10px;
            margin-bottom: 1.5rem;
        }

        .add-task-form input {
            flex: 1;
            padding: 14px 20px;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 16px;
            color: white;
            font-size: 1rem;
            outline: none;
            transition: all 0.3s;
        }

        .add-task-form input::placeholder {
            color: rgba(255, 255, 255, 0.35);
        }

        .add-task-form input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 15px rgba(0, 210, 255, 0.15);
            background: rgba(255, 255, 255, 0.1);
        }

        .btn-add {
            padding: 14px 24px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border: none;
            border-radius: 16px;
            color: white;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 6px;
            white-space: nowrap;
        }

        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 210, 255, 0.35);
        }

        .btn-add:active {
            transform: translateY(0);
        }

        /* Task List */
        .task-list {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .task-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 18px;
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 16px;
            transition: all 0.3s;
            animation: slideIn 0.3s ease-out;
        }

        .task-item:hover {
            background: rgba(255, 255, 255, 0.1);
            border-color: rgba(255, 255, 255, 0.15);
            transform: translateX(4px);
        }

        /* Checkbox */
        .task-checkbox {
            appearance: none;
            width: 22px;
            height: 22px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s;
            flex-shrink: 0;
            position: relative;
        }

        .task-checkbox:checked {
            background: linear-gradient(135deg, var(--primary-color), var(--success-color));
            border-color: transparent;
        }

        .task-checkbox:checked::after {
            content: '\2713';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: var(--bg-dark);
            font-size: 14px;
            font-weight: bold;
        }

        .task-checkbox:hover {
            border-color: var(--primary-color);
        }

        /* Task Title */
        .task-title {
            flex: 1;
            font-size: 1rem;
            color: rgba(255, 255, 255, 0.9);
            transition: all 0.3s;
            word-break: break-word;
        }

        .task-item.completed .task-title {
            text-decoration: line-through;
            color: rgba(255, 255, 255, 0.35);
        }

        /* Edit Input */
        .edit-input {
            flex: 1;
            padding: 6px 12px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid var(--primary-color);
            border-radius: 8px;
            color: white;
            font-size: 1rem;
            outline: none;
        }

        /* Action Buttons */
        .task-actions {
            display: flex;
            gap: 6px;
            flex-shrink: 0;
        }

        .btn-icon {
            width: 34px;
            height: 34px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
            transition: all 0.3s;
            background: rgba(255, 255, 255, 0.08);
            color: rgba(255, 255, 255, 0.6);
        }

        .btn-icon:hover {
            transform: scale(1.1);
        }

        .btn-edit:hover {
            background: rgba(255, 193, 7, 0.2);
            color: var(--warning-color);
        }

        .btn-delete:hover {
            background: rgba(255, 77, 109, 0.2);
            color: var(--danger-color);
        }

        .btn-save:hover {
            background: rgba(146, 254, 157, 0.2);
            color: var(--success-color);
        }

        .btn-cancel:hover {
            background: rgba(255, 255, 255, 0.15);
            color: white;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
            color: rgba(255, 255, 255, 0.35);
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            display: block;
        }

        .empty-state p {
            font-size: 1.1rem;
            letter-spacing: 0;
            text-transform: none;
        }

        /* Loading Spinner */
        .loading {
            text-align: center;
            padding: 2rem;
            color: rgba(255, 255, 255, 0.4);
        }

        .loading .spinner {
            width: 30px;
            height: 30px;
            border: 3px solid rgba(255, 255, 255, 0.1);
            border-top: 3px solid var(--primary-color);
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
            margin: 0 auto 1rem;
        }

        /* Toast Notification */
        .toast {
            position: fixed;
            bottom: 30px;
            right: 30px;
            padding: 14px 24px;
            border-radius: 14px;
            color: white;
            font-size: 0.95rem;
            z-index: 1000;
            transform: translateY(100px);
            opacity: 0;
            transition: all 0.4s cubic-bezier(0.68, -0.55, 0.27, 1.55);
            backdrop-filter: blur(10px);
        }

        .toast.show {
            transform: translateY(0);
            opacity: 1;
        }

        .toast.success {
            background: rgba(146, 254, 157, 0.2);
            border: 1px solid rgba(146, 254, 157, 0.3);
        }

        .toast.error {
            background: rgba(255, 77, 109, 0.2);
            border: 1px solid rgba(255, 77, 109, 0.3);
        }

        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-30px); filter: blur(10px); }
            to { opacity: 1; transform: translateY(0); filter: blur(0); }
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes pulse {
            0% { transform: scale(1); opacity: 0.2; }
            100% { transform: scale(1.5); opacity: 0.4; }
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateX(-20px); }
            to { opacity: 1; transform: translateX(0); }
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Responsive */
        @media (max-width: 640px) {
            body { padding: 1rem; padding-top: 2vh; }
            .container { padding: 1.5rem; }
            .header h1 { font-size: 2.2rem; }
            .add-task-form { flex-direction: column; }
            .btn-add { justify-content: center; }
        }
    </style>
</head>
<body>
    <div class="glow"></div>
    <div class="glow-2"></div>

    <div class="container">
        <div class="header">
            <p class="status">System Status: Online</p>
            <h1><i class="bi bi-check2-square"></i> TODO List</h1>
            <p class="task-count" id="taskCount"></p>
        </div>

        <div class="add-task-form">
            <input type="text" id="taskInput" placeholder="What needs to be done?"
                   autocomplete="off" maxlength="200">
            <button class="btn-add" id="addBtn" onclick="addTask()">
                <i class="bi bi-plus-lg"></i> Add
            </button>
        </div>

        <div id="taskListContainer">
            <div class="loading">
                <div class="spinner"></div>
                <p>Loading tasks...</p>
            </div>
        </div>
    </div>

    <div class="toast" id="toast"></div>

    <script>
        // ===== API Configuration =====
        // Use context path from JSP to build the correct API base URL
        const CONTEXT_PATH = '<%= request.getContextPath() %>';
        const API_BASE = CONTEXT_PATH + '/api/tasks';

        console.log('TODO App: CONTEXT_PATH =', CONTEXT_PATH);
        console.log('TODO App: API_BASE =', API_BASE);

        // ===== Toast Notifications =====
        function showToast(message, type = 'success') {
            const toast = document.getElementById('toast');
            toast.textContent = message;
            toast.className = 'toast ' + type + ' show';
            setTimeout(() => { toast.classList.remove('show'); }, 3000);
        }

        // ===== Load Tasks =====
        async function loadTasks() {
            const container = document.getElementById('taskListContainer');
            try {
                console.log('TODO App: Fetching tasks from', API_BASE);
                const response = await fetch(API_BASE);
                console.log('TODO App: Response status', response.status);

                if (!response.ok) {
                    const text = await response.text();
                    console.error('TODO App: Response body', text);
                    throw new Error('Server returned ' + response.status + ': ' + text);
                }

                const tasks = await response.json();
                console.log('TODO App: Loaded', tasks.length, 'tasks');
                renderTasks(tasks);
            } catch (error) {
                console.error('TODO App: loadTasks error:', error);
                container.innerHTML = '<div class="empty-state"><i class="bi bi-exclamation-triangle"></i><p>Failed to load tasks. Check console for details.</p></div>';
                showToast('Failed to load tasks: ' + error.message, 'error');
            }
        }

        // ===== Render Tasks =====
        function renderTasks(tasks) {
            const container = document.getElementById('taskListContainer');
            const completedCount = tasks.filter(t => t.completed).length;
            document.getElementById('taskCount').textContent =
                tasks.length + ' task' + (tasks.length !== 1 ? 's' : '') +
                ' \u2022 ' + completedCount + ' completed';

            if (tasks.length === 0) {
                container.innerHTML =
                    '<div class="empty-state">' +
                        '<i class="bi bi-inbox"></i>' +
                        '<p>No tasks yet. Add one above!</p>' +
                    '</div>';
                return;
            }

            let html = '<ul class="task-list">';
            tasks.forEach(task => {
                const completedClass = task.completed ? ' completed' : '';
                const checked = task.completed ? ' checked' : '';
                html +=
                    '<li class="task-item' + completedClass + '" data-id="' + task.id + '">' +
                        '<input type="checkbox" class="task-checkbox"' + checked +
                            ' onchange="toggleTask(' + task.id + ', this.checked)">' +
                        '<span class="task-title" id="title-' + task.id + '">' + escapeHtml(task.title) + '</span>' +
                        '<div class="task-actions">' +
                            '<button class="btn-icon btn-edit" onclick="startEdit(' + task.id + ')" title="Edit">' +
                                '<i class="bi bi-pencil"></i>' +
                            '</button>' +
                            '<button class="btn-icon btn-delete" onclick="deleteTask(' + task.id + ')" title="Delete">' +
                                '<i class="bi bi-trash3"></i>' +
                            '</button>' +
                        '</div>' +
                    '</li>';
            });
            html += '</ul>';
            container.innerHTML = html;
        }

        // ===== Add Task =====
        async function addTask() {
            const input = document.getElementById('taskInput');
            const title = input.value.trim();

            if (!title) {
                showToast('Please enter a task title', 'error');
                input.focus();
                return;
            }

            const addBtn = document.getElementById('addBtn');
            addBtn.disabled = true;
            addBtn.innerHTML = '<i class="bi bi-hourglass-split"></i> Adding...';

            try {
                console.log('TODO App: Adding task:', title);
                console.log('TODO App: POST to', API_BASE);

                const response = await fetch(API_BASE, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ title: title, completed: false })
                });

                console.log('TODO App: Add response status', response.status);
                const responseText = await response.text();
                console.log('TODO App: Add response body', responseText);

                if (!response.ok) {
                    throw new Error('Server returned ' + response.status + ': ' + responseText);
                }

                input.value = '';
                showToast('Task added successfully!', 'success');
                await loadTasks();
            } catch (error) {
                console.error('TODO App: addTask error:', error);
                showToast('Failed to add task: ' + error.message, 'error');
            } finally {
                addBtn.disabled = false;
                addBtn.innerHTML = '<i class="bi bi-plus-lg"></i> Add';
            }
        }

        // ===== Toggle Task Completion =====
        async function toggleTask(id, completed) {
            try {
                const response = await fetch(API_BASE + '/' + id, {
                    method: 'PUT',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ completed: completed })
                });

                if (!response.ok) throw new Error('Failed to update');

                await loadTasks();
            } catch (error) {
                console.error('TODO App: toggleTask error:', error);
                showToast('Failed to update task', 'error');
                await loadTasks();
            }
        }

        // ===== Start Edit Mode =====
        function startEdit(id) {
            const titleSpan = document.getElementById('title-' + id);
            const taskItem = titleSpan.closest('.task-item');
            const currentTitle = titleSpan.textContent;

            titleSpan.outerHTML =
                '<input type="text" class="edit-input" id="edit-' + id + '" value="' + escapeAttr(currentTitle) + '"' +
                ' onkeydown="if(event.key===\'Enter\')saveEdit(' + id + ');if(event.key===\'Escape\')loadTasks();">';

            const actionsDiv = taskItem.querySelector('.task-actions');
            actionsDiv.innerHTML =
                '<button class="btn-icon btn-save" onclick="saveEdit(' + id + ')" title="Save">' +
                    '<i class="bi bi-check-lg"></i>' +
                '</button>' +
                '<button class="btn-icon btn-cancel" onclick="loadTasks()" title="Cancel">' +
                    '<i class="bi bi-x-lg"></i>' +
                '</button>';

            document.getElementById('edit-' + id).focus();
        }

        // ===== Save Edit =====
        async function saveEdit(id) {
            const input = document.getElementById('edit-' + id);
            const newTitle = input.value.trim();

            if (!newTitle) {
                showToast('Task title cannot be empty', 'error');
                input.focus();
                return;
            }

            try {
                const response = await fetch(API_BASE + '/' + id, {
                    method: 'PUT',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ title: newTitle })
                });

                if (!response.ok) throw new Error('Failed to update');

                showToast('Task updated!', 'success');
                await loadTasks();
            } catch (error) {
                console.error('TODO App: saveEdit error:', error);
                showToast('Failed to update task', 'error');
            }
        }

        // ===== Delete Task =====
        async function deleteTask(id) {
            try {
                const response = await fetch(API_BASE + '/' + id, {
                    method: 'DELETE'
                });

                if (!response.ok) throw new Error('Failed to delete');

                showToast('Task deleted!', 'success');
                await loadTasks();
            } catch (error) {
                console.error('TODO App: deleteTask error:', error);
                showToast('Failed to delete task', 'error');
            }
        }

        // ===== Utility: Escape HTML =====
        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        // ===== Utility: Escape attribute =====
        function escapeAttr(text) {
            return text.replace(/&/g, '&amp;').replace(/"/g, '&quot;')
                       .replace(/'/g, '&#39;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
        }

        // ===== Enter key to add task =====
        document.getElementById('taskInput').addEventListener('keydown', function(e) {
            if (e.key === 'Enter') addTask();
        });

        // ===== Initial Load =====
        document.addEventListener('DOMContentLoaded', loadTasks);
    </script>
</body>
</html>
document.addEventListener('DOMContentLoaded', () => {
    // API URL - will need to be updated based on the backend server
    const API_URL = 'http://localhost:3000/api/tasks';
    
    // DOM Elements
    const taskForm = document.getElementById('task-form');
    const tasksList = document.getElementById('tasks-list');
    const taskTitleInput = document.getElementById('task-title');
    const taskDescriptionInput = document.getElementById('task-description');
    
    // Load tasks when page loads
    loadTasks();
    
    // Add task form submission
    taskForm.addEventListener('submit', (e) => {
        e.preventDefault();
        
        const title = taskTitleInput.value.trim();
        const description = taskDescriptionInput.value.trim();
        
        if (!title) return;
        
        addTask(title, description);
        
        // Clear form
        taskTitleInput.value = '';
        taskDescriptionInput.value = '';
    });
    
    // Function to load tasks from API
    async function loadTasks() {
        try {
            const response = await fetch(API_URL);
            
            if (!response.ok) {
                throw new Error('Failed to fetch tasks');
            }
            
            const tasks = await response.json();
            displayTasks(tasks);
        } catch (error) {
            console.error('Error loading tasks:', error);
            tasksList.innerHTML = `<div class="error">Error loading tasks. Please try again later.</div>`;
        }
    }
    
    // Function to add a new task
    async function addTask(title, description) {
        try {
            const response = await fetch(API_URL, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ title, description })
            });
            
            if (!response.ok) {
                throw new Error('Failed to add task');
            }
            
            const newTask = await response.json();
            
            // Add the new task to the UI
            displayTask(newTask);
        } catch (error) {
            console.error('Error adding task:', error);
            alert('Failed to add task. Please try again.');
        }
    }
    
    // Function to delete a task
    async function deleteTask(id) {
        try {
            const response = await fetch(`${API_URL}/${id}`, {
                method: 'DELETE'
            });
            
            if (!response.ok) {
                throw new Error('Failed to delete task');
            }
            
            // Remove the task from the UI
            const taskElement = document.getElementById(`task-${id}`);
            if (taskElement) {
                taskElement.remove();
            }
        } catch (error) {
            console.error('Error deleting task:', error);
            alert('Failed to delete task. Please try again.');
        }
    }
    
    // Function to display all tasks
    function displayTasks(tasks) {
        if (tasks.length === 0) {
            tasksList.innerHTML = '<div class="no-tasks">No tasks found. Add a new task above.</div>';
            return;
        }
        
        tasksList.innerHTML = '';
        tasks.forEach(task => displayTask(task));
    }
    
    // Function to display a single task
    function displayTask(task) {
        const taskElement = document.createElement('div');
        taskElement.className = 'task-item';
        taskElement.id = `task-${task.id}`;
        
        taskElement.innerHTML = `
            <div class="task-title">${task.title}</div>
            <div class="task-description">${task.description || 'No description'}</div>
            <div class="task-actions">
                <button class="delete-btn" data-id="${task.id}">Delete</button>
            </div>
        `;
        
        // Add event listener for delete button
        const deleteBtn = taskElement.querySelector('.delete-btn');
        deleteBtn.addEventListener('click', () => {
            deleteTask(task.id);
        });
        
        // Add to the list
        tasksList.appendChild(taskElement);
    }
});

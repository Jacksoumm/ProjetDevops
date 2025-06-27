const express = require('express');
const cors = require('cors');
const sqlite3 = require('sqlite3').verbose();
const path = require('path');


const app = express();
const PORT = process.env.PORT || 3000;


app.use(cors());
app.use(express.json());


const dbPath = path.resolve(__dirname, 'database.db');
const db = new sqlite3.Database(dbPath, (err) => {
    if (err) {
        console.error('Error connecting to database:', err.message);
    } else {
        console.log('Connected to the SQLite database');
        
       
        db.run(`
            CREATE TABLE IF NOT EXISTS tasks (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                description TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        `);
    }
});


app.get('/api/tasks', (req, res) => {
    db.all('SELECT * FROM tasks ORDER BY created_at DESC', [], (err, rows) => {
        if (err) {
            console.error(err.message);
            return res.status(500).json({ error: 'Failed to retrieve tasks' });
        }
        res.json(rows);
    });
});

app.get('/api/tasks/:id', (req, res) => {
    const id = req.params.id;
    
    db.get('SELECT * FROM tasks WHERE id = ?', [id], (err, row) => {
        if (err) {
            console.error(err.message);
            return res.status(500).json({ error: 'Failed to retrieve task' });
        }
        
        if (!row) {
            return res.status(404).json({ error: 'Task not found' });
        }
        
        res.json(row);
    });
});


app.post('/api/tasks', (req, res) => {
    const { title, description } = req.body;
    
    if (!title) {
        return res.status(400).json({ error: 'Title is required' });
    }
    
    db.run(
        'INSERT INTO tasks (title, description) VALUES (?, ?)',
        [title, description || ''],
        function(err) {
            if (err) {
                console.error(err.message);
                return res.status(500).json({ error: 'Failed to create task' });
            }
     
            db.get('SELECT * FROM tasks WHERE id = ?', [this.lastID], (err, row) => {
                if (err) {
                    console.error(err.message);
                    return res.status(500).json({ error: 'Failed to retrieve created task' });
                }
                
                res.status(201).json(row);
            });
        }
    );
});


app.put('/api/tasks/:id', (req, res) => {
    const id = req.params.id;
    const { title, description } = req.body;
    
    if (!title) {
        return res.status(400).json({ error: 'Title is required' });
    }
    
    db.run(
        'UPDATE tasks SET title = ?, description = ? WHERE id = ?',
        [title, description || '', id],
        function(err) {
            if (err) {
                console.error(err.message);
                return res.status(500).json({ error: 'Failed to update task' });
            }
            
            if (this.changes === 0) {
                return res.status(404).json({ error: 'Task not found' });
            }
            
     
            db.get('SELECT * FROM tasks WHERE id = ?', [id], (err, row) => {
                if (err) {
                    console.error(err.message);
                    return res.status(500).json({ error: 'Failed to retrieve updated task' });
                }
                
                res.json(row);
            });
        }
    );
});


app.delete('/api/tasks/:id', (req, res) => {
    const id = req.params.id;
    
    db.run('DELETE FROM tasks WHERE id = ?', [id], function(err) {
        if (err) {
            console.error(err.message);
            return res.status(500).json({ error: 'Failed to delete task' });
        }
        
        if (this.changes === 0) {
            return res.status(404).json({ error: 'Task not found' });
        }
        
        res.json({ message: 'Task deleted successfully' });
    });
});


app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

process.on('SIGINT', () => {
    db.close((err) => {
        if (err) {
            console.error(err.message);
        }
        console.log('Closed the database connection');
        process.exit(0);
    });
});

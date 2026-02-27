package com.example.dao;

import com.example.model.Task;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object (DAO) for Task model.
 * Handles all database operations related to tasks.
 */
public class TaskDAO {
    // Use absolute path or fallback to relative path
    private static final String DB_PATH = System.getProperty("todo.db.path",
            "/home/osm/IdeaProjects/SE3318/todo.db");
    private static final String DB_URL = "jdbc:sqlite:" + DB_PATH;
    private static final String DRIVER = "org.sqlite.JDBC";

    static {
        try {
            Class.forName(DRIVER);
            System.out.println("SQLite JDBC Driver loaded successfully");
            System.out.println("Database path: " + DB_PATH);
        } catch (ClassNotFoundException e) {
            System.err.println("Failed to load SQLite JDBC driver");
            e.printStackTrace();
        }
    }

    /**
     * Initialize the database and create the tasks table if it doesn't exist
     */
    public static void initializeDatabase() {
        String sql = "CREATE TABLE IF NOT EXISTS tasks (" +
                "id INTEGER PRIMARY KEY AUTOINCREMENT," +
                "title TEXT NOT NULL," +
                "completed INTEGER DEFAULT 0" +
                ")";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
            System.out.println("Database initialized successfully");
        } catch (SQLException e) {
            System.err.println("Failed to initialize database: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Get database connection
     */
    private static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL);
    }

    /**
     * Create a new task
     */
    public static Task createTask(Task task) {
        String sql = "INSERT INTO tasks (title, completed) VALUES (?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, task.getTitle());
            pstmt.setInt(2, task.isCompleted() ? 1 : 0);
            pstmt.executeUpdate();

            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    task.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return task;
    }

    /**
     * Get all tasks
     */
    public static List<Task> getAllTasks() {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT id, title, completed FROM tasks";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Task task = new Task();
                task.setId(rs.getInt("id"));
                task.setTitle(rs.getString("title"));
                task.setCompleted(rs.getInt("completed") == 1);
                tasks.add(task);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tasks;
    }

    /**
     * Get a task by id
     */
    public static Task getTaskById(int id) {
        String sql = "SELECT id, title, completed FROM tasks WHERE id = ?";
        Task task = null;

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    task = new Task();
                    task.setId(rs.getInt("id"));
                    task.setTitle(rs.getString("title"));
                    task.setCompleted(rs.getInt("completed") == 1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return task;
    }

    /**
     * Update a task
     */
    public static boolean updateTask(Task task) {
        String sql = "UPDATE tasks SET title = ?, completed = ? WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, task.getTitle());
            pstmt.setInt(2, task.isCompleted() ? 1 : 0);
            pstmt.setInt(3, task.getId());
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Delete a task
     */
    public static boolean deleteTask(int id) {
        String sql = "DELETE FROM tasks WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}


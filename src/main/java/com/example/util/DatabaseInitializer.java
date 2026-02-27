package com.example.util;

import java.sql.*;

/**
 * Database initialization utility.
 * Run this class to initialize the SQLite database with sample data.
 */
public class DatabaseInitializer {

    private static final String DB_URL = "jdbc:sqlite:todo.db";
    private static final String DRIVER = "org.sqlite.JDBC";

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        initializeDatabase();
        insertSampleData();
        displayData();
    }

    /**
     * Create the tasks table if it doesn't exist
     */
    public static void initializeDatabase() {
        String sql = "CREATE TABLE IF NOT EXISTS tasks (" +
                "id INTEGER PRIMARY KEY AUTOINCREMENT," +
                "title TEXT NOT NULL," +
                "completed INTEGER DEFAULT 0" +
                ")";

        try (Connection conn = DriverManager.getConnection(DB_URL);
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
            System.out.println("✓ Database table 'tasks' created successfully!");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Insert sample data for testing
     */
    public static void insertSampleData() {
        String sql = "INSERT INTO tasks (title, completed) VALUES (?, ?)";

        String[][] sampleTasks = {
                {"Complete project setup", "1"},
                {"Create API endpoints", "0"},
                {"Build frontend", "0"},
                {"Test CRUD operations", "0"},
                {"Deploy to production", "0"}
        };

        try (Connection conn = DriverManager.getConnection(DB_URL);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            // Clear existing data first
            try (Statement clearStmt = conn.createStatement()) {
                clearStmt.execute("DELETE FROM tasks");
            }

            for (String[] task : sampleTasks) {
                pstmt.setString(1, task[0]);
                pstmt.setInt(2, Integer.parseInt(task[1]));
                pstmt.addBatch();
            }

            int[] results = pstmt.executeBatch();
            System.out.println("✓ Inserted " + results.length + " sample tasks into the database!");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Display all tasks currently in the database
     */
    public static void displayData() {
        String sql = "SELECT id, title, completed FROM tasks";

        try (Connection conn = DriverManager.getConnection(DB_URL);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            System.out.println("\n--- Current Tasks in Database ---");
            System.out.printf("%-5s | %-35s | %-10s%n", "ID", "Title", "Completed");
            System.out.println("-------|---------------------------------------|----------");

            while (rs.next()) {
                int id = rs.getInt("id");
                String title = rs.getString("title");
                boolean completed = rs.getInt("completed") == 1;
                System.out.printf("%-5d | %-35s | %-10s%n", id, title, completed ? "Yes" : "No");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}


package com.example.servlet;

import com.example.dao.TaskDAO;
import com.example.model.Task;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * REST API Servlet for handling CRUD operations on tasks.
 * Endpoints:
 * - GET /api/tasks - Get all tasks
 * - GET /api/tasks/{id} - Get a specific task
 * - POST /api/tasks - Create a new task
 * - PUT /api/tasks/{id} - Update a task
 * - DELETE /api/tasks/{id} - Delete a task
 */
@WebServlet("/api/tasks/*")
public class TasksServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        super.init();
        // Initialize database on servlet startup
        TaskDAO.initializeDatabase();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // GET /api/tasks - Get all tasks
                getAllTasks(response);
            } else {
                // GET /api/tasks/{id} - Get a specific task
                String[] pathParts = pathInfo.split("/");
                if (pathParts.length == 2 && !pathParts[1].isEmpty()) {
                    int id = Integer.parseInt(pathParts[1]);
                    getTaskById(response, id);
                } else {
                    sendError(response, 400, "Invalid task ID");
                }
            }
        } catch (NumberFormatException e) {
            sendError(response, 400, "Invalid task ID format");
        } catch (Exception e) {
            sendError(response, 500, "Internal server error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String body = request.getReader().lines()
                    .reduce("", (acc, actual) -> acc + actual);

            JsonObject jsonObject = gson.fromJson(body, JsonObject.class);

            if (!jsonObject.has("title") || jsonObject.get("title").getAsString().trim().isEmpty()) {
                sendError(response, 400, "Title is required");
                return;
            }

            Task task = new Task();
            task.setTitle(jsonObject.get("title").getAsString());
            task.setCompleted(jsonObject.has("completed") && jsonObject.get("completed").getAsBoolean());

            Task createdTask = TaskDAO.createTask(task);

            response.setStatus(HttpServletResponse.SC_CREATED);
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(createdTask));
            out.flush();
        } catch (Exception e) {
            sendError(response, 500, "Internal server error: " + e.getMessage());
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Add CORS headers
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String pathInfo = request.getPathInfo();
            String[] pathParts = pathInfo.split("/");

            if (pathParts.length != 2 || pathParts[1].isEmpty()) {
                sendError(response, 400, "Invalid task ID");
                return;
            }

            int id = Integer.parseInt(pathParts[1]);

            String body = request.getReader().lines()
                    .reduce("", (acc, actual) -> acc + actual);

            JsonObject jsonObject = gson.fromJson(body, JsonObject.class);

            Task existingTask = TaskDAO.getTaskById(id);
            if (existingTask == null) {
                sendError(response, 404, "Task not found");
                return;
            }

            if (jsonObject.has("title") && !jsonObject.get("title").getAsString().trim().isEmpty()) {
                existingTask.setTitle(jsonObject.get("title").getAsString());
            }

            if (jsonObject.has("completed")) {
                existingTask.setCompleted(jsonObject.get("completed").getAsBoolean());
            }

            boolean updated = TaskDAO.updateTask(existingTask);

            if (updated) {
                PrintWriter out = response.getWriter();
                out.print(gson.toJson(existingTask));
                out.flush();
            } else {
                sendError(response, 500, "Failed to update task");
            }
        } catch (NumberFormatException e) {
            sendError(response, 400, "Invalid task ID format");
        } catch (Exception e) {
            sendError(response, 500, "Internal server error: " + e.getMessage());
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Add CORS headers
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String pathInfo = request.getPathInfo();
            String[] pathParts = pathInfo.split("/");

            if (pathParts.length != 2 || pathParts[1].isEmpty()) {
                sendError(response, 400, "Invalid task ID");
                return;
            }

            int id = Integer.parseInt(pathParts[1]);

            Task task = TaskDAO.getTaskById(id);
            if (task == null) {
                sendError(response, 404, "Task not found");
                return;
            }

            boolean deleted = TaskDAO.deleteTask(id);

            if (deleted) {
                JsonObject successResponse = new JsonObject();
                successResponse.addProperty("message", "Task deleted successfully");
                PrintWriter out = response.getWriter();
                out.print(successResponse.toString());
                out.flush();
            } else {
                sendError(response, 500, "Failed to delete task");
            }
        } catch (NumberFormatException e) {
            sendError(response, 400, "Invalid task ID format");
        } catch (Exception e) {
            sendError(response, 500, "Internal server error: " + e.getMessage());
        }
    }

    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle CORS preflight
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setStatus(HttpServletResponse.SC_OK);
    }

    /**
     * Get all tasks
     */
    private void getAllTasks(HttpServletResponse response) throws IOException {
        List<Task> tasks = TaskDAO.getAllTasks();
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(tasks));
        out.flush();
    }

    /**
     * Get a specific task by id
     */
    private void getTaskById(HttpServletResponse response, int id) throws IOException {
        Task task = TaskDAO.getTaskById(id);

        if (task == null) {
            sendError(response, 404, "Task not found");
            return;
        }

        PrintWriter out = response.getWriter();
        out.print(gson.toJson(task));
        out.flush();
    }

    /**
     * Send error response
     */
    private void sendError(HttpServletResponse response, int statusCode, String message) throws IOException {
        response.setStatus(statusCode);
        JsonObject errorResponse = new JsonObject();
        errorResponse.addProperty("error", message);
        PrintWriter out = response.getWriter();
        out.print(errorResponse.toString());
        out.flush();
    }
}


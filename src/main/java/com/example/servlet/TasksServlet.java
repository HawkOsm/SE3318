package com.example.servlet;

import com.example.dao.TaskDAO;
import com.example.model.Task;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
@WebServlet(urlPatterns = "/api/tasks/*", loadOnStartup = 1)
public class TasksServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private transient Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("TasksServlet: init() called - servlet is loading!");
        TaskDAO.initializeDatabase();
        System.out.println("TasksServlet: Database initialized successfully");
    }

    /**
     * Set common response headers (CORS + JSON content type)
     */
    private void setCorsAndJsonHeaders(HttpServletResponse response) {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Accept");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setCorsAndJsonHeaders(response);
        System.out.println("TasksServlet: doGet called, pathInfo=" + request.getPathInfo());

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                getAllTasks(response);
            } else {
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
            System.err.println("TasksServlet doGet error: " + e.getMessage());
            e.printStackTrace();
            sendError(response, 500, "Internal server error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setCorsAndJsonHeaders(response);
        System.out.println("TasksServlet: doPost called, pathInfo=" + request.getPathInfo());

        try {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }
            String body = sb.toString();
            System.out.println("TasksServlet: POST body = " + body);

            if (body.trim().isEmpty()) {
                sendError(response, 400, "Request body is empty");
                return;
            }

            JsonObject jsonObject = gson.fromJson(body, JsonObject.class);

            if (jsonObject == null || !jsonObject.has("title") || jsonObject.get("title").getAsString().trim().isEmpty()) {
                sendError(response, 400, "Title is required");
                return;
            }

            Task task = new Task();
            task.setTitle(jsonObject.get("title").getAsString().trim());
            task.setCompleted(jsonObject.has("completed") && jsonObject.get("completed").getAsBoolean());

            Task createdTask = TaskDAO.createTask(task);
            System.out.println("TasksServlet: Task created with id=" + createdTask.getId());

            response.setStatus(HttpServletResponse.SC_CREATED);
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(createdTask));
            out.flush();
        } catch (Exception e) {
            System.err.println("TasksServlet doPost error: " + e.getMessage());
            e.printStackTrace();
            sendError(response, 500, "Internal server error: " + e.getMessage());
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setCorsAndJsonHeaders(response);
        System.out.println("TasksServlet: doPut called, pathInfo=" + request.getPathInfo());

        try {
            String pathInfo = request.getPathInfo();

            if (pathInfo == null || pathInfo.equals("/")) {
                sendError(response, 400, "Task ID is required");
                return;
            }

            String[] pathParts = pathInfo.split("/");

            if (pathParts.length != 2 || pathParts[1].isEmpty()) {
                sendError(response, 400, "Invalid task ID");
                return;
            }

            int id = Integer.parseInt(pathParts[1]);

            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }
            String body = sb.toString();
            System.out.println("TasksServlet: PUT body = " + body);

            JsonObject jsonObject = gson.fromJson(body, JsonObject.class);

            Task existingTask = TaskDAO.getTaskById(id);
            if (existingTask == null) {
                sendError(response, 404, "Task not found");
                return;
            }

            if (jsonObject.has("title") && !jsonObject.get("title").getAsString().trim().isEmpty()) {
                existingTask.setTitle(jsonObject.get("title").getAsString().trim());
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
            System.err.println("TasksServlet doPut error: " + e.getMessage());
            e.printStackTrace();
            sendError(response, 500, "Internal server error: " + e.getMessage());
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setCorsAndJsonHeaders(response);
        System.out.println("TasksServlet: doDelete called, pathInfo=" + request.getPathInfo());

        try {
            String pathInfo = request.getPathInfo();

            if (pathInfo == null || pathInfo.equals("/")) {
                sendError(response, 400, "Task ID is required");
                return;
            }

            String[] pathParts = pathInfo.split("/");

            if (pathParts.length != 2 || pathParts[1].isEmpty()) {
                sendError(response, 400, "Invalid task ID");
                return;
            }

            int id = Integer.parseInt(pathParts[1]);

            boolean deleted = TaskDAO.deleteTask(id);

            if (deleted) {
                JsonObject successResponse = new JsonObject();
                successResponse.addProperty("message", "Task deleted successfully");
                PrintWriter out = response.getWriter();
                out.print(successResponse.toString());
                out.flush();
            } else {
                sendError(response, 404, "Task not found or already deleted");
            }
        } catch (NumberFormatException e) {
            sendError(response, 400, "Invalid task ID format");
        } catch (Exception e) {
            System.err.println("TasksServlet doDelete error: " + e.getMessage());
            e.printStackTrace();
            sendError(response, 500, "Internal server error: " + e.getMessage());
        }
    }

    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Accept");
        response.setStatus(HttpServletResponse.SC_OK);
    }

    private void getAllTasks(HttpServletResponse response) throws IOException {
        List<Task> tasks = TaskDAO.getAllTasks();
        System.out.println("TasksServlet: getAllTasks returning " + tasks.size() + " tasks");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(tasks));
        out.flush();
    }

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

    private void sendError(HttpServletResponse response, int statusCode, String message) throws IOException {
        response.setStatus(statusCode);
        JsonObject errorResponse = new JsonObject();
        errorResponse.addProperty("error", message);
        PrintWriter out = response.getWriter();
        out.print(errorResponse.toString());
        out.flush();
    }
}

# SQLite Database Setup - Complete Guide

## ✅ Database Created Successfully!

Your SQLite database (`todo.db`) has been created and is fully compatible with the backend structure.

---

## 📍 Database File Location
```
/home/osm/IdeaProjects/SE3318/todo.db
```

---

## 📊 Database Schema

The database contains a single table named `tasks` with the following structure:

```sql
CREATE TABLE tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    completed INTEGER DEFAULT 0
)
```

### Column Details:
- **id**: Auto-incrementing integer primary key (unique identifier for each task)
- **title**: Text field storing the task description (required)
- **completed**: Integer field (0 or 1) indicating task completion status (defaults to 0 = incomplete)

---

## 📋 Sample Data

The database comes pre-populated with 5 sample tasks:

| ID | Title | Completed |
|----|-------|-----------|
| 4 | Complete project setup | Yes |
| 5 | Create API endpoints | No |
| 6 | Build frontend | No |
| 7 | Test CRUD operations | No |
| 8 | Deploy to production | No |

---

## 🔧 How the Database Works

### Database Connection String
```
jdbc:sqlite:todo.db
```

### JDBC Driver
```
org.sqlite.JDBC
```

### Dependency
```xml
<dependency>
    <groupId>org.xerial</groupId>
    <artifactId>sqlite-jdbc</artifactId>
    <version>3.44.0.0</version>
</dependency>
```

---

## 🚀 REST API Integration

Your backend is fully configured to use this database. The TaskDAO class handles all database operations:

### Available Operations

**1. CREATE (POST)**
```
POST /api/tasks
Content-Type: application/json

{
  "title": "New Task",
  "completed": false
}
```

**2. READ (GET)**
```
GET /api/tasks              # Get all tasks
GET /api/tasks/{id}         # Get specific task
```

**3. UPDATE (PUT)**
```
PUT /api/tasks/{id}
Content-Type: application/json

{
  "title": "Updated Title",
  "completed": true
}
```

**4. DELETE (DELETE)**
```
DELETE /api/tasks/{id}
```

---

## 🛠️ Utility: DatabaseInitializer

A utility class was created to help manage the database:

**Location**: `src/main/java/com/example/util/DatabaseInitializer.java`

**Features**:
- Creates the tasks table if it doesn't exist
- Inserts sample data for testing
- Displays current database contents

**Usage**:
```bash
mvn exec:java -Dexec.mainClass="com.example.util.DatabaseInitializer"
```

---

## 📝 Steps to Recreate the Database

If you need to reset the database or recreate it from scratch:

### Option 1: Using Java (Recommended)
```bash
cd /home/osm/IdeaProjects/SE3318
mvn clean compile
mvn exec:java -Dexec.mainClass="com.example.util.DatabaseInitializer"
```

### Option 2: Manual Reset
1. Delete the existing `todo.db` file:
   ```bash
   rm /home/osm/IdeaProjects/SE3318/todo.db
   ```

2. Run the DatabaseInitializer again:
   ```bash
   mvn exec:java -Dexec.mainClass="com.example.util.DatabaseInitializer"
   ```

---

## ✨ Database Compatibility

✅ Fully integrated with TaskDAO  
✅ Supports all CRUD operations  
✅ Pre-configured connection string  
✅ Auto-incremented ID generation  
✅ Sample data for testing  
✅ Type-safe prepared statements  

---

## 🧪 Testing the API

Once your application is deployed, you can test the endpoints:

```bash
# Get all tasks
curl http://localhost:8080/my-webapp-project/api/tasks

# Get specific task
curl http://localhost:8080/my-webapp-project/api/tasks/4

# Create new task
curl -X POST http://localhost:8080/my-webapp-project/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title":"Buy groceries","completed":false}'

# Update task
curl -X PUT http://localhost:8080/my-webapp-project/api/tasks/4 \
  -H "Content-Type: application/json" \
  -d '{"title":"Complete project setup","completed":true}'

# Delete task
curl -X DELETE http://localhost:8080/my-webapp-project/api/tasks/4
```

---

## 📁 Project Structure

```
SE3318/
├── todo.db                          ← Your database file
├── pom.xml                          ← Dependencies configured
├── src/
│   └── main/
│       ├── java/com/example/
│       │   ├── model/Task.java      ← Task model
│       │   ├── dao/TaskDAO.java     ← Database operations
│       │   ├── servlet/TasksServlet.java ← REST API
│       │   └── util/DatabaseInitializer.java ← Setup utility
│       └── webapp/
│           ├── index.jsp
│           └── WEB-INF/web.xml
└── target/                          ← Compiled classes
```

---

## ✅ Verification

The database has been verified:
- ✅ File exists at correct location
- ✅ Table schema is correct
- ✅ Sample data is populated
- ✅ SQLite format is valid
- ✅ All columns are accessible

You're ready to use the database with your backend API!


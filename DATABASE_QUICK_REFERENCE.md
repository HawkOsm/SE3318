# SQLite Database Setup - Quick Reference

## 🎯 What Was Done

1. **Created SQLite Database** (`todo.db`)
   - Location: `/home/osm/IdeaProjects/SE3318/todo.db`
   - Format: SQLite 3 binary format

2. **Created Database Table** (`tasks`)
   - Columns: `id` (INTEGER PRIMARY KEY AUTOINCREMENT), `title` (TEXT), `completed` (INTEGER)

3. **Populated Sample Data**
   - 5 sample tasks pre-loaded for testing

4. **Created Utility Class** (`DatabaseInitializer`)
   - Automates database creation and initialization
   - Can reset database if needed

---

## 📍 File Locations

| File | Path |
|------|------|
| Database | `/home/osm/IdeaProjects/SE3318/todo.db` |
| Setup Guide | `/home/osm/IdeaProjects/SE3318/DATABASE_SETUP.md` |
| Initializer | `src/main/java/com/example/util/DatabaseInitializer.java` |
| Task DAO | `src/main/java/com/example/dao/TaskDAO.java` |
| Servlet | `src/main/java/com/example/servlet/TasksServlet.java` |
| Model | `src/main/java/com/example/model/Task.java` |

---

## 🚀 Quick Start Commands

### Build Project
```bash
cd /home/osm/IdeaProjects/SE3318
mvn clean compile
```

### Initialize/Reset Database
```bash
mvn exec:java -Dexec.mainClass="com.example.util.DatabaseInitializer"
```

### Build WAR File
```bash
mvn package
```

---

## 🔌 Database Connection Details

| Property | Value |
|----------|-------|
| URL | `jdbc:sqlite:todo.db` |
| Driver | `org.sqlite.JDBC` |
| File | `todo.db` (in project root) |

---

## 📊 Table Schema

```sql
CREATE TABLE tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    completed INTEGER DEFAULT 0
)
```

---

## ✅ Compatibility Checklist

- ✅ Backend: Fully integrated with TaskDAO
- ✅ CRUD: All Create, Read, Update, Delete operations supported
- ✅ REST API: `/api/tasks/*` endpoints ready
- ✅ JSON: Gson configured for serialization
- ✅ Maven: All dependencies in pom.xml
- ✅ Sample Data: Pre-populated for testing

---

## 🎓 Next Steps

1. **Deploy the application**
   ```bash
   mvn package
   # Deploy WAR file to Tomcat
   ```

2. **Test the API** (after deployment)
   - GET all tasks: `http://localhost:8080/my-webapp-project/api/tasks`
   - Create new task: `POST http://localhost:8080/my-webapp-project/api/tasks`
   - etc.

3. **Build frontend** to interact with the API

---

## 🆘 Troubleshooting

### Database not found
```bash
# Recreate it
mvn exec:java -Dexec.mainClass="com.example.util.DatabaseInitializer"
```

### Need to clear all data
```bash
# Delete and recreate
rm /home/osm/IdeaProjects/SE3318/todo.db
mvn exec:java -Dexec.mainClass="com.example.util.DatabaseInitializer"
```

### Verify database integrity
```bash
cd /home/osm/IdeaProjects/SE3318
python3 -c "import sqlite3; c=sqlite3.connect('todo.db').cursor(); c.execute('SELECT * FROM tasks'); print('Tasks:', c.fetchall())"
```

---

## 📞 Support References

- SQLite JDBC: https://github.com/xerial/sqlite-jdbc
- JDBC: https://docs.oracle.com/javase/tutorial/jdbc/
- Maven: https://maven.apache.org/


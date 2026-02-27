# 🐛 TROUBLESHOOTING: Can't Add Items to TODO List

## Common Issues & Solutions

### Issue: Can't Add Items to TODO List

Let me help you diagnose and fix this issue. Here are the most common causes:

---

## 🔍 Diagnostic Steps

### Step 1: Check if Tomcat is Running

```bash
# Check if Tomcat process is running
ps aux | grep tomcat | grep -v grep

# Check if port 8080 is in use
netstat -an | grep 8080
# Or
lsof -i :8080

# Check if the application is deployed
ls -la /path/to/tomcat/webapps/ | grep my-webapp-project
```

**Expected:** Tomcat should be running and listening on port 8080

**If Tomcat is NOT running:**
```bash
# Start Tomcat
/path/to/tomcat/bin/startup.sh

# Or if using systemctl
sudo systemctl start tomcat
```

---

### Step 2: Check if WAR is Deployed

```bash
# Check if WAR file exists in Tomcat webapps
ls -la /path/to/tomcat/webapps/my-webapp-project.war

# Check if it was extracted
ls -la /path/to/tomcat/webapps/my-webapp-project/
```

**If WAR is NOT deployed:**
```bash
cd /home/osm/IdeaProjects/SE3318
mvn clean package
cp target/my-webapp-project.war /path/to/tomcat/webapps/
# Wait a few seconds for auto-deployment
```

---

### Step 3: Test the Backend API Directly

```bash
# Test if API is accessible
curl -X GET http://localhost:8080/my-webapp-project/api/tasks

# Test POST endpoint
curl -X POST http://localhost:8080/my-webapp-project/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title":"Test task","completed":false}'
```

**Expected:** Should return JSON response

**If you get connection refused:**
- Tomcat is not running → Start it
- Wrong port → Check Tomcat port configuration
- Application not deployed → Deploy the WAR file

**If you get 404:**
- Application context is wrong
- Servlet mapping issue
- WAR not properly deployed

---

### Step 4: Check Browser Console

1. Open your browser
2. Press F12 to open DevTools
3. Go to **Console** tab
4. Try to add a task
5. Look for error messages

**Common errors you might see:**

#### Error: "Failed to fetch"
**Cause:** Backend API not accessible
**Solution:**
```bash
# Verify backend is running
curl http://localhost:8080/my-webapp-project/api/tasks

# If not, start Tomcat and redeploy
```

#### Error: "CORS policy blocked"
**Cause:** CORS headers not set (Fixed in latest version!)
**Solution:** Rebuild and redeploy with updated code
```bash
cd /home/osm/IdeaProjects/SE3318
mvn clean package
cp target/my-webapp-project.war /path/to/tomcat/webapps/
# Restart Tomcat
```

#### Error: "404 Not Found"
**Cause:** Wrong API URL
**Solution:** Check API_BASE_URL in index.jsp

#### Error: "500 Internal Server Error"
**Cause:** Backend error (possibly database)
**Solution:** Check Tomcat logs

---

### Step 5: Check Network Tab

1. Open DevTools (F12)
2. Go to **Network** tab
3. Try to add a task
4. Look at the request

**What to check:**
- Request URL: Should be `http://localhost:8080/my-webapp-project/api/tasks`
- Request Method: Should be `POST`
- Status Code: Should be `201 Created`
- Request Headers: Should include `Content-Type: application/json`
- Request Payload: Should show `{"title":"...","completed":false}`
- Response: Should show created task with ID

**If you see red status code:**
- 400 Bad Request → Check request body format
- 404 Not Found → Check URL and servlet mapping
- 500 Server Error → Check backend logs

---

### Step 6: Check Tomcat Logs

```bash
# View Tomcat logs
tail -f /path/to/tomcat/logs/catalina.out

# Or if specific log file
tail -f /path/to/tomcat/logs/localhost.*.log
```

**Look for:**
- `SQLException` → Database connection issues
- `ClassNotFoundException` → Missing JDBC driver
- `NullPointerException` → Data handling issues
- `ServletException` → Servlet initialization issues

---

## 🛠️ Solutions to Common Problems

### Problem 1: Database Not Found

**Symptoms:**
- Backend throws SQLException
- "No such file or directory" error
- Tasks don't load

**Solution:**

The database path is now configured to use absolute path. Make sure the database exists:

```bash
ls -la /home/osm/IdeaProjects/SE3318/todo.db

# If not exists, recreate it
cd /home/osm/IdeaProjects/SE3318
mvn exec:java -Dexec.mainClass="com.example.util.DatabaseInitializer"
```

**Alternative:** Set database path as system property
```bash
# In Tomcat's setenv.sh
export CATALINA_OPTS="$CATALINA_OPTS -Dtodo.db.path=/home/osm/IdeaProjects/SE3318/todo.db"
```

---

### Problem 2: CORS Errors

**Symptoms:**
- Browser console shows "CORS policy" error
- Fetch requests fail
- No data loads

**Solution:**

I've already added CORS headers to the servlet. Rebuild and redeploy:

```bash
cd /home/osm/IdeaProjects/SE3318
mvn clean package
cp target/my-webapp-project.war /path/to/tomcat/webapps/
# Restart Tomcat
/path/to/tomcat/bin/shutdown.sh
/path/to/tomcat/bin/startup.sh
```

---

### Problem 3: Servlet Not Mapped

**Symptoms:**
- 404 errors
- API endpoints not found
- "No servlet found" message

**Solution:**

Check web.xml or ensure @WebServlet annotation is working:

```bash
# Verify servlet is compiled
jar tf target/my-webapp-project.war | grep TasksServlet

# Should see: WEB-INF/classes/com/example/servlet/TasksServlet.class
```

**If annotation isn't working, add to web.xml:**

```xml
<servlet>
    <servlet-name>TasksServlet</servlet-name>
    <servlet-class>com.example.servlet.TasksServlet</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>TasksServlet</servlet-name>
    <url-pattern>/api/tasks/*</url-pattern>
</servlet-mapping>
```

---

### Problem 4: JSON Parsing Error

**Symptoms:**
- 400 Bad Request
- "Cannot parse JSON" error
- Task doesn't save

**Solution:**

Check request format in browser Network tab. Should be:
```json
{
  "title": "Task title",
  "completed": false
}
```

Ensure Content-Type header is set:
```
Content-Type: application/json
```

---

### Problem 5: Database Permission Issues

**Symptoms:**
- "Database is locked" error
- "Permission denied" error
- Can't write to database

**Solution:**

```bash
# Check database permissions
ls -la /home/osm/IdeaProjects/SE3318/todo.db

# Make it writable
chmod 666 /home/osm/IdeaProjects/SE3318/todo.db
chmod 777 /home/osm/IdeaProjects/SE3318/  # Directory must be writable too

# Check if database is locked
lsof /home/osm/IdeaProjects/SE3318/todo.db
```

---

## ✅ Quick Fix Checklist

Try these in order:

1. **Is Tomcat running?**
   ```bash
   ps aux | grep tomcat
   # If not: /path/to/tomcat/bin/startup.sh
   ```

2. **Is the application deployed?**
   ```bash
   ls /path/to/tomcat/webapps/my-webapp-project.war
   # If not: cp target/my-webapp-project.war /path/to/tomcat/webapps/
   ```

3. **Can you access the API?**
   ```bash
   curl http://localhost:8080/my-webapp-project/api/tasks
   # Should return JSON array
   ```

4. **Is the database accessible?**
   ```bash
   ls -la /home/osm/IdeaProjects/SE3318/todo.db
   # Should exist and be readable/writable
   ```

5. **Are there errors in browser console?**
   - Open browser
   - Press F12
   - Check Console tab
   - Try adding task
   - Read error messages

6. **Check Tomcat logs**
   ```bash
   tail -50 /path/to/tomcat/logs/catalina.out
   # Look for errors
   ```

---

## 🔧 Complete Fix Procedure

If nothing else works, follow this complete reset:

### 1. Stop Tomcat
```bash
/path/to/tomcat/bin/shutdown.sh
# Or: sudo systemctl stop tomcat
```

### 2. Clean Everything
```bash
cd /home/osm/IdeaProjects/SE3318

# Remove old WAR and deployment
rm -rf /path/to/tomcat/webapps/my-webapp-project*

# Clean Maven build
mvn clean
```

### 3. Rebuild with Fixes
```bash
# Rebuild project (CORS headers now added)
mvn clean package

# Verify WAR was created
ls -lh target/my-webapp-project.war
```

### 4. Ensure Database Exists
```bash
# Check database
ls -la /home/osm/IdeaProjects/SE3318/todo.db

# If not exists, create it
mvn exec:java -Dexec.mainClass="com.example.util.DatabaseInitializer"

# Set permissions
chmod 666 /home/osm/IdeaProjects/SE3318/todo.db
chmod 777 /home/osm/IdeaProjects/SE3318/
```

### 5. Deploy Fresh
```bash
# Copy WAR to Tomcat
cp target/my-webapp-project.war /path/to/tomcat/webapps/

# Start Tomcat
/path/to/tomcat/bin/startup.sh

# Wait 10 seconds for deployment
sleep 10
```

### 6. Test API
```bash
# Test GET
curl http://localhost:8080/my-webapp-project/api/tasks

# Test POST
curl -X POST http://localhost:8080/my-webapp-project/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title":"Test task","completed":false}'
```

### 7. Test in Browser
- Open: http://localhost:8080/my-webapp-project
- Press F12 → Console tab
- Try adding a task
- Check for errors

---

## 🎯 Specific Error Messages

### "Please enter a task title"
**Cause:** Input field is empty
**Solution:** Type something in the input field before clicking Add

### "Failed to add task. Please try again."
**Cause:** API call failed
**Solution:** 
1. Check browser console for details
2. Verify API is accessible
3. Check Tomcat logs

### No error but task doesn't appear
**Cause:** Successful POST but loadTasks() failed
**Solution:**
1. Check browser console
2. Test GET endpoint manually
3. Check database has the task

### Task appears then disappears
**Cause:** loadTasks() failing after successful POST
**Solution:**
1. Check GET endpoint works
2. Verify database has data
3. Check console for errors

---

## 🔍 Advanced Debugging

### Enable Detailed Logging

Add this to TasksServlet:

```java
@Override
protected void doPost(...) {
    System.out.println("POST request received");
    System.out.println("Content-Type: " + request.getContentType());
    
    // ...existing code...
    
    System.out.println("Task created: " + createdTask);
}
```

### Test Database Directly

```bash
cd /home/osm/IdeaProjects/SE3318
python3 << 'EOF'
import sqlite3
conn = sqlite3.connect('todo.db')
c = conn.cursor()

# Try to insert a task
c.execute("INSERT INTO tasks (title, completed) VALUES (?, ?)", ("Test task", 0))
conn.commit()

# Verify it was inserted
c.execute("SELECT * FROM tasks")
print("All tasks:", c.fetchall())

conn.close()
EOF
```

---

## 📝 Verification Script

Run this to check everything:

```bash
#!/bin/bash
echo "=== TODO List Troubleshooting ==="

echo -e "\n1. Checking Tomcat..."
ps aux | grep tomcat | grep -v grep && echo "✓ Tomcat running" || echo "✗ Tomcat NOT running"

echo -e "\n2. Checking WAR deployment..."
ls /path/to/tomcat/webapps/my-webapp-project.war && echo "✓ WAR deployed" || echo "✗ WAR NOT deployed"

echo -e "\n3. Checking database..."
ls -la /home/osm/IdeaProjects/SE3318/todo.db && echo "✓ Database exists" || echo "✗ Database NOT found"

echo -e "\n4. Testing API (GET)..."
curl -s http://localhost:8080/my-webapp-project/api/tasks && echo -e "\n✓ API accessible" || echo "✗ API NOT accessible"

echo -e "\n5. Testing API (POST)..."
curl -X POST http://localhost:8080/my-webapp-project/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title":"Test","completed":false}' && echo -e "\n✓ POST works" || echo "✗ POST failed"

echo -e "\n=== End Diagnostics ==="
```

---

## 🚨 Emergency Fix

If nothing works, try this complete reset:

```bash
# 1. Stop everything
/path/to/tomcat/bin/shutdown.sh
sleep 5

# 2. Remove old deployment
rm -rf /path/to/tomcat/webapps/my-webapp-project*
rm -rf /path/to/tomcat/work/Catalina/localhost/my-webapp-project

# 3. Rebuild from scratch
cd /home/osm/IdeaProjects/SE3318
mvn clean
rm -rf target/
mvn package

# 4. Ensure database is accessible
chmod 666 todo.db
chmod 777 .

# 5. Fresh deploy
cp target/my-webapp-project.war /path/to/tomcat/webapps/

# 6. Start Tomcat
/path/to/tomcat/bin/startup.sh

# 7. Wait for deployment (check logs)
tail -f /path/to/tomcat/logs/catalina.out
# Wait until you see "Deployment of web application archive ... has finished"

# 8. Test in browser
# http://localhost:8080/my-webapp-project
```

---

## 🎯 Most Likely Causes (In Order)

1. **Tomcat not running** (90% of cases)
   → Solution: Start Tomcat

2. **Application not deployed** (5% of cases)
   → Solution: Copy WAR and restart Tomcat

3. **Database path issue** (3% of cases)
   → Solution: Use absolute path (already fixed in latest code)

4. **CORS issues** (1% of cases)
   → Solution: CORS headers added (already fixed)

5. **Network/browser cache** (1% of cases)
   → Solution: Hard refresh (Ctrl+Shift+R)

---

## 📞 Quick Support Commands

### Check Everything at Once
```bash
cd /home/osm/IdeaProjects/SE3318

echo "1. Tomcat status:"
ps aux | grep tomcat | grep -v grep && echo "Running" || echo "Not running"

echo -e "\n2. Application files:"
ls -lh target/my-webapp-project.war
ls -lh todo.db

echo -e "\n3. API test:"
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost:8080/my-webapp-project/api/tasks

echo -e "\n4. Database check:"
python3 -c "import sqlite3; c=sqlite3.connect('todo.db').cursor(); c.execute('SELECT COUNT(*) FROM tasks'); print('Tasks in DB:', c.fetchone()[0])"
```

---

## ✅ After Fixing

Once you've fixed the issue, verify:

1. Can access http://localhost:8080/my-webapp-project
2. Tasks load from database
3. Can add new task
4. Can mark task complete
5. Can edit task
6. Can delete task
7. All changes persist in database

---

## 🆘 Still Not Working?

Try these final steps:

1. **Check if correct port:**
   - Is Tomcat using port 8080?
   - Check `server.xml` in Tomcat conf/

2. **Check application context:**
   - Should be `/my-webapp-project`
   - Check WAR filename matches

3. **Check browser cache:**
   - Hard refresh: Ctrl+Shift+R
   - Or clear browser cache completely

4. **Check firewall:**
   ```bash
   # Test if port is accessible
   telnet localhost 8080
   # Or
   nc -zv localhost 8080
   ```

5. **Try different browser:**
   - Chrome, Firefox, Edge
   - Or incognito/private mode

6. **Check Tomcat version:**
   - Should be Tomcat 8+ (preferably 9+)
   - Check: `/path/to/tomcat/bin/version.sh`

---

## 📝 Report Format

If you still have issues, provide this info:

1. **Tomcat status:** (running/not running)
2. **Browser console error:** (exact error message)
3. **Network tab:** (request URL, status code, response)
4. **Tomcat logs:** (last 20 lines of catalina.out)
5. **Database exists:** (yes/no, path, permissions)
6. **Curl test result:** (response from API test)

This will help diagnose the exact issue!

---

## 🎯 UPDATES MADE TO FIX YOUR ISSUE

I've already made these fixes to your code:

1. ✅ **Added CORS headers** to all servlet methods
   - doGet, doPost, doPut, doDelete
   - Added doOptions for preflight

2. ✅ **Fixed database path** to use absolute path
   - Now uses: /home/osm/IdeaProjects/SE3318/todo.db
   - Fallback to system property if needed

3. ✅ **Added better logging**
   - Database initialization logs
   - JDBC driver loading logs
   - Error messages improved

4. ✅ **Rebuilt project**
   - Maven build successful
   - New WAR created with fixes

**Next step: Redeploy the updated WAR file!**

```bash
cd /home/osm/IdeaProjects/SE3318
cp target/my-webapp-project.war /path/to/tomcat/webapps/
# Restart Tomcat
/path/to/tomcat/bin/shutdown.sh && sleep 3 && /path/to/tomcat/bin/startup.sh
```

Then try adding tasks again!


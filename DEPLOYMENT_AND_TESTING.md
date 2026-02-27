# Deployment & Testing Guide

## 🚀 Deployment Instructions

### Prerequisites
- Apache Tomcat installed and running
- Maven installed
- Java 8+ installed
- SQLite database created (`todo.db`)

### Step 1: Build the Application
```bash
cd /home/osm/IdeaProjects/SE3318
mvn clean package
```

**Output:** `target/my-webapp-project.war`

### Step 2: Deploy to Tomcat
```bash
# Copy WAR file to Tomcat webapps directory
cp target/my-webapp-project.war /path/to/tomcat/webapps/

# Restart Tomcat
# Linux/Mac:
/path/to/tomcat/bin/shutdown.sh
/path/to/tomcat/bin/startup.sh

# Or if using systemctl:
sudo systemctl restart tomcat
```

### Step 3: Verify Deployment
- Open browser: `http://localhost:8080/my-webapp-project`
- Should see TODO list interface
- Tasks from database should load automatically

---

## 🧪 Testing Guide

### Test 1: Load Application
**Steps:**
1. Open `http://localhost:8080/my-webapp-project` in browser
2. Open DevTools (F12) → Console tab

**Expected Results:**
- ✓ Page loads without errors
- ✓ "Loading tasks..." displays briefly
- ✓ 5 sample tasks appear (from database)
- ✓ No errors in console

**Test Data:**
- Task 1: "Complete project setup" (✓ completed)
- Task 2: "Create API endpoints" (pending)
- Task 3: "Build frontend" (pending)
- Task 4: "Test CRUD operations" (pending)
- Task 5: "Deploy to production" (pending)

---

### Test 2: Add New Task

**Steps:**
1. Type "Buy groceries" in input field
2. Click "Add" button or press Enter
3. Check database

**Expected Results:**
- ✓ Task appears immediately in list
- ✓ Input field clears
- ✓ Task count updates
- ✓ Task saved to database

**Verify in Database:**
```bash
cd /home/osm/IdeaProjects/SE3318
python3 << 'EOF'
import sqlite3
conn = sqlite3.connect('todo.db')
c = conn.cursor()
c.execute("SELECT * FROM tasks WHERE title='Buy groceries'")
print(c.fetchone())
conn.close()
EOF
```

---

### Test 3: Complete Task

**Steps:**
1. Click checkbox on Task 2 ("Create API endpoints")
2. Verify visual feedback
3. Check database

**Expected Results:**
- ✓ Checkbox becomes checked
- ✓ Task text shows strikethrough
- ✓ Task opacity reduces
- ✓ Database updated (completed=1)

**Verify in Database:**
```bash
python3 << 'EOF'
import sqlite3
conn = sqlite3.connect('todo.db')
c = conn.cursor()
c.execute("SELECT * FROM tasks WHERE id=5")  # Create API endpoints
print(c.fetchone())
conn.close()
EOF
```

---

### Test 4: Uncomplete Task

**Steps:**
1. Click checkbox on completed task (Task 2 again)
2. Verify visual feedback
3. Check database

**Expected Results:**
- ✓ Checkbox becomes unchecked
- ✓ Strikethrough removed
- ✓ Opacity returns to normal
- ✓ Database updated (completed=0)

---

### Test 5: Edit Task

**Steps:**
1. Click pen icon on Task 3 ("Build frontend")
2. Clear existing text
3. Type "Build amazing frontend"
4. Click Save button
5. Check database

**Expected Results:**
- ✓ Task converts to edit mode
- ✓ Input field becomes editable
- ✓ Text pre-selected
- ✓ Save/Cancel buttons appear
- ✓ Task updated in list
- ✓ Database updated

**Alternative:**
- Press Enter to save
- Press Escape to cancel

---

### Test 6: Cancel Edit

**Steps:**
1. Click pen icon on a task
2. Type new text
3. Press Escape or click Cancel
4. Check if text reverted

**Expected Results:**
- ✓ Edit mode exits
- ✓ Original text restored
- ✓ Database unchanged

---

### Test 7: Delete Task

**Steps:**
1. Click trash icon on Task 3
2. Confirm deletion
3. Check database

**Expected Results:**
- ✓ Confirmation dialog appears
- ✓ Task removed from list
- ✓ Task count updates
- ✓ Database updated (task deleted)

---

### Test 8: Reject Delete

**Steps:**
1. Click trash icon on a task
2. Click "Cancel" on confirmation
3. Verify task remains

**Expected Results:**
- ✓ Confirmation dialog appears
- ✓ Task remains after cancellation
- ✓ Database unchanged

---

### Test 9: API Error Handling

**Steps:**
1. Stop backend API/Tomcat
2. Try to add a new task
3. Observe error handling

**Expected Results:**
- ✓ Error message displays
- ✓ No blank/hung UI
- ✓ User can still interact
- ✓ Console shows error details

---

### Test 10: Mobile Responsiveness

**Steps:**
1. Open DevTools (F12)
2. Click mobile device icon
3. Test all functions

**Expected Results on Mobile:**
- ✓ Layout stacks vertically
- ✓ Input spans full width
- ✓ Buttons readable and clickable
- ✓ Icons display correctly
- ✓ Scrolling works smoothly
- ✓ No horizontal scroll

---

## 🔍 Browser DevTools Inspection

### Check Network Activity
1. Open DevTools (F12)
2. Go to Network tab
3. Perform action (add, edit, delete)

**Expected Requests:**
- `GET /my-webapp-project/api/tasks` - Load all tasks
- `POST /my-webapp-project/api/tasks` - Create task
- `PUT /my-webapp-project/api/tasks/{id}` - Update task
- `DELETE /my-webapp-project/api/tasks/{id}` - Delete task

### Check Console
1. Open DevTools (F12)
2. Go to Console tab

**Expected:**
- ✓ No JavaScript errors
- ✓ No 404 errors
- ✓ No CORS issues (if configured)

### Check Application Data
1. Go to Application tab
2. Check Local Storage/Session Storage

**Expected:**
- Tasks loaded from API, not from local storage

---

## 📊 Database Verification

### Verify All Tasks
```bash
cd /home/osm/IdeaProjects/SE3318
python3 << 'EOF'
import sqlite3
conn = sqlite3.connect('todo.db')
c = conn.cursor()
c.execute("SELECT * FROM tasks ORDER BY id")
for row in c.fetchall():
    print(row)
conn.close()
EOF
```

### Count Tasks
```bash
python3 << 'EOF'
import sqlite3
conn = sqlite3.connect('todo.db')
c = conn.cursor()
c.execute("SELECT COUNT(*) FROM tasks")
print(f"Total tasks: {c.fetchone()[0]}")
conn.close()
EOF
```

### Reset Database
```bash
cd /home/osm/IdeaProjects/SE3318
# Delete database
rm todo.db

# Rebuild and reinitialize
mvn exec:java -Dexec.mainClass="com.example.util.DatabaseInitializer"
```

---

## 🚨 Common Issues & Solutions

### Issue: "Cannot GET /my-webapp-project"
**Cause:** Tomcat not running or WAR not deployed
**Solution:** 
1. Check Tomcat is running: `netstat -an | grep 8080`
2. Verify WAR file exists in webapps
3. Check Tomcat logs: `tail logs/catalina.out`

### Issue: Tasks Not Loading
**Cause:** API not responding
**Solution:**
1. Check backend running: `http://localhost:8080/my-webapp-project/api/tasks`
2. Check database exists: `ls -la todo.db`
3. Check console errors (F12)

### Issue: Changes Not Saving
**Cause:** Backend API error
**Solution:**
1. Check network tab in DevTools
2. Check HTTP response status
3. Check backend logs
4. Verify database writable: `chmod 666 todo.db`

### Issue: Icons Not Showing
**Cause:** Bootstrap CDN unreachable
**Solution:**
1. Check internet connection
2. Check firewall/proxy
3. Download icons locally as fallback

### Issue: Styling Broken
**Cause:** CSS not loading
**Solution:**
1. Hard refresh: Ctrl+Shift+R
2. Clear browser cache
3. Check console for CSS errors

---

## ✅ Final Verification Checklist

- [ ] Application deploys without errors
- [ ] Tasks load from database on startup
- [ ] Add task functionality works
- [ ] Complete/uncomplete task works
- [ ] Edit task functionality works
- [ ] Delete task functionality works
- [ ] All changes persist in database
- [ ] UI is responsive on mobile
- [ ] Bootstrap Icons display correctly
- [ ] No JavaScript console errors
- [ ] API calls show in Network tab
- [ ] Empty state shows when no tasks
- [ ] Task count updates correctly
- [ ] Animations smooth
- [ ] Error handling graceful

---

## 📝 Performance Testing

### Load Test
```bash
# Using Apache Bench (if available)
ab -n 100 -c 10 http://localhost:8080/my-webapp-project/api/tasks
```

### Expected Results:
- ✓ Response time < 100ms
- ✓ No failed requests
- ✓ Consistent performance

---

## 🔐 Security Testing

1. **XSS Prevention**
   - Try adding task with HTML: `<script>alert('xss')</script>`
   - Expected: Script displayed as text, not executed

2. **Input Validation**
   - Try adding empty task
   - Expected: Alert message, no task created

3. **SQL Injection**
   - Try task title: `'; DROP TABLE tasks; --`
   - Expected: Treated as normal text, no SQL executed

---

## 📞 Support

For issues, check:
1. Browser console (F12)
2. Network tab (F12)
3. Backend logs
4. Database integrity
5. API endpoint accessibility


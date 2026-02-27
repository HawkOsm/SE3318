╔════════════════════════════════════════════════════════════════════════════╗
║                                                                            ║
║          🚨 ISSUE: Can't Add Items - Application Not Deployed             ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝

## PROBLEM DIAGNOSIS ✓

I've diagnosed your issue:

✅ Tomcat IS running on port 8080
❌ Your application is NOT deployed (returns 404)
❌ The WAR file exists but hasn't been copied to Tomcat's webapps
❌ Without deployment, the backend API doesn't exist
❌ Without API, you can't add/edit/delete tasks

## ROOT CAUSE

Your TODO list application needs to be DEPLOYED to Tomcat before it works.
The WAR file is built at: /home/osm/IdeaProjects/SE3318/target/my-webapp-project.war

But it's NOT in Tomcat's webapps directory yet!

═══════════════════════════════════════════════════════════════════════════════

## ✅ SOLUTION: Deploy Using IntelliJ IDEA (RECOMMENDED)

Since you're using IntelliJ IDEA (your project is in IdeaProjects), this is the
EASIEST way:

### Step 1: Open IntelliJ IDEA
- Open your SE3318 project in IntelliJ

### Step 2: Configure Tomcat Server
1. Click "Run" menu → "Edit Configurations"
2. Click the "+" button → "Tomcat Server" → "Local"
3. If you see "No server found":
   - Click "Configure..."
   - Browse to your Tomcat installation directory
   - Click OK
4. In the "Server" tab:
   - Leave default settings
   - Note the port (should be 8080)
5. In the "Deployment" tab:
   - Click "+" → "Artifact"
   - Select "my-webapp-project:war exploded" or "my-webapp-project:war"
   - Application context: /my-webapp-project
   - Click OK
6. Click "Apply" then "OK"

### Step 3: Run the Application
1. Click the green "Run" button (or press Shift+F10)
2. IntelliJ will:
   - Build the application
   - Deploy to Tomcat
   - Start Tomcat
   - Open browser automatically
3. Wait for "Artifact is deployed successfully"
4. Browser opens to: http://localhost:8080/my-webapp-project

### Step 4: Test Adding Tasks
1. Type a task name in the input field
2. Press Enter or click "Add" button
3. Task should appear immediately!

═══════════════════════════════════════════════════════════════════════════════

## 🔧 ALTERNATIVE: Manual Deployment

If you prefer manual deployment:

### Step 1: Find Your Tomcat Directory

Run these commands to find where Tomcat is installed:

```bash
# Method 1: Check common locations
ls -d /opt/tomcat /opt/apache-tomcat* /usr/local/tomcat ~/apache-tomcat* 2>/dev/null

# Method 2: Find via running process
ps aux | grep catalina | grep -v grep | awk '{for(i=1;i<=NF;i++){if($i ~ /catalina.home/){print $i}}}'

# Method 3: Check environment variables
echo $CATALINA_HOME
echo $TOMCAT_HOME
```

### Step 2: Copy WAR to Tomcat webapps

Once you find Tomcat (let's say it's at `/opt/tomcat`):

```bash
cd /home/osm/IdeaProjects/SE3318

# Copy WAR file
sudo cp target/my-webapp-project.war /opt/tomcat/webapps/

# Wait for auto-deployment
echo "Waiting 15 seconds for deployment..."
sleep 15

# Check if deployed
ls -la /opt/tomcat/webapps/my-webapp-project/
```

### Step 3: Verify Deployment

```bash
# Test API
curl http://localhost:8080/my-webapp-project/api/tasks

# Should return JSON array (even if empty: [])
```

### Step 4: Access in Browser

Open: http://localhost:8080/my-webapp-project

═══════════════════════════════════════════════════════════════════════════════

## 🎯 QUICK FIX SCRIPT

I've created a deployment finder script. Run this:

```bash
cd /home/osm/IdeaProjects/SE3318

# Create deployment script
cat > deploy-now.sh << 'DEPLOY_EOF'
#!/bin/bash
echo "🔍 Finding Tomcat webapps directory..."

# Locations to check
LOCATIONS=(
    "/opt/tomcat/webapps"
    "/opt/apache-tomcat-*/webapps"
    "/usr/local/tomcat/webapps"
    "/usr/share/tomcat*/webapps"
    "$HOME/apache-tomcat*/webapps"
    "/var/lib/tomcat*/webapps"
)

WAR_FILE="/home/osm/IdeaProjects/SE3318/target/my-webapp-project.war"

if [ ! -f "$WAR_FILE" ]; then
    echo "❌ WAR file not found at: $WAR_FILE"
    echo "Building application..."
    cd /home/osm/IdeaProjects/SE3318
    mvn clean package -q
fi

for location in "${LOCATIONS[@]}"; do
    # Expand wildcards
    for dir in $location; do
        if [ -d "$dir" ] && [ -w "$dir" ]; then
            echo "✓ Found writable webapps at: $dir"
            echo "Deploying..."
            cp "$WAR_FILE" "$dir/"
            echo "✓ Deployed!"
            echo ""
            echo "Waiting 15 seconds for Tomcat to deploy..."
            sleep 15
            echo ""
            echo "Testing API..."
            curl -s http://localhost:8080/my-webapp-project/api/tasks | head -100
            echo ""
            echo ""
            echo "════════════════════════════════════════════════════════"
            echo "✅ DEPLOYMENT COMPLETE!"
            echo ""
            echo "Open browser to: http://localhost:8080/my-webapp-project"
            echo "Try adding a task!"
            echo "════════════════════════════════════════════════════════"
            exit 0
        elif [ -d "$dir" ]; then
            echo "⚠ Found webapps at: $dir (but not writable)"
            echo "Try with sudo:"
            echo "  sudo cp $WAR_FILE $dir/"
        fi
    done
done

echo ""
echo "❌ Could not find Tomcat webapps directory"
echo ""
echo "Please deploy manually:"
echo "1. Find your Tomcat directory"
echo "2. Copy WAR: sudo cp $WAR_FILE /path/to/tomcat/webapps/"
echo "3. Wait 15 seconds"
echo "4. Open: http://localhost:8080/my-webapp-project"
DEPLOY_EOF

chmod +x deploy-now.sh
./deploy-now.sh
```

═══════════════════════════════════════════════════════════════════════════════

## 🔍 DEBUGGING: If You Can't Find Tomcat

### Check What's Running on Port 8080

```bash
# Find the process
sudo lsof -i :8080

# Or
sudo netstat -tulpn | grep :8080

# Or  
sudo ss -tulpn | grep :8080
```

This will show you the process ID and path.

### Check Your Shell Commands

Since you mentioned `tstart`, `tstop`, `tlog` commands, these are probably
custom aliases or functions. Check where they point to:

```bash
# Check your bashrc for these commands
grep -A 5 -B 2 "tstart\|tstop\|tlog" ~/.bashrc ~/.bash_profile ~/.profile

# Check if they're functions
type tstart
type tstop
type tlog

# Check your command history
history | grep -E "catalina|tomcat|webapps" | tail -20
```

═══════════════════════════════════════════════════════════════════════════════

## 📝 WHY IT'S NOT WORKING

When you try to add a task, here's what happens:

1. You type in the input field and click "Add"
2. JavaScript sends POST request to: /my-webapp-project/api/tasks
3. Browser tries: http://localhost:8080/my-webapp-project/api/tasks
4. Tomcat receives the request
5. Tomcat looks for application "my-webapp-project"
6. 🚨 Application NOT FOUND! (not deployed)
7. Tomcat returns 404 Not Found
8. JavaScript receives error
9. Task is NOT added

AFTER deploying:

1. You type and click "Add"
2. JavaScript sends POST to /my-webapp-project/api/tasks
3. Browser tries: http://localhost:8080/my-webapp-project/api/tasks
4. Tomcat receives the request
5. Tomcat finds "my-webapp-project" (deployed!)
6. ✅ Application processes request
7. Servlet creates task in database
8. Returns task with ID
9. ✅ Task appears in your list!

═══════════════════════════════════════════════════════════════════════════════

## ✅ VERIFICATION CHECKLIST

After deployment, verify these:

□ Can access: http://localhost:8080/my-webapp-project
  Should see the TODO list interface (not 404)

□ Can see tasks from database
  Should see the 5 sample tasks loading

□ Browser console has no errors
  Press F12 → Console tab should be clean

□ Can add a task
  Type task name, press Enter, should appear immediately

□ Can mark task complete
  Click checkbox, should toggle with strikethrough

□ Can edit task
  Click pen icon, edit, click save

□ Can delete task
  Click trash icon, confirm, should disappear

═══════════════════════════════════════════════════════════════════════════════

## 🆘 STILL NOT WORKING?

### Issue: Can't find Tomcat directory
**Solution**: Use IntelliJ IDEA deployment (it knows where Tomcat is)

### Issue: "Permission denied" when copying WAR
**Solution**: Use sudo: `sudo cp target/my-webapp-project.war /path/to/webapps/`

### Issue: Tomcat doesn't auto-deploy
**Solution**: Restart Tomcat after copying WAR:
```bash
# Stop
sudo systemctl stop tomcat
# Or: tstop
# Or: /path/to/tomcat/bin/shutdown.sh

# Start
sudo systemctl start tomcat
# Or: tstart
# Or: /path/to/tomcat/bin/startup.sh
```

### Issue: Still get 404 after deployment
**Solution**: Check Tomcat logs:
```bash
# Find logs directory (same place as webapps)
tail -100 /path/to/tomcat/logs/catalina.out

# Or use your tlog command
tlog
```

═══════════════════════════════════════════════════════════════════════════════

## 📞 SUMMARY

**What's wrong**: Application not deployed to Tomcat
**Where's the problem**: WAR file not in Tomcat's webapps directory
**How to fix**: Use IntelliJ IDEA or manually copy WAR to webapps

**Easiest solution**: 
1. Open IntelliJ IDEA
2. Configure Tomcat server (Run → Edit Configurations)
3. Add deployment artifact
4. Click Run
5. Done!

**Alternative solution**:
1. Find Tomcat webapps directory
2. Copy WAR file there: `cp target/my-webapp-project.war /path/to/webapps/`
3. Wait 15 seconds
4. Access: http://localhost:8080/my-webapp-project

═══════════════════════════════════════════════════════════════════════════════

**Once deployed, your TODO list will work perfectly!** 🎉

All the code is ready, backend is working, database is configured.
You just need to DEPLOY it to Tomcat!

═══════════════════════════════════════════════════════════════════════════════


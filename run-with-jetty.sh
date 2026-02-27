# 🚨 URGENT FIX: Can't Add Items - Application Not Deployed

## Current Status
- ✅ Tomcat IS running
- ❌ Application returns 404 (NOT deployed)
- ❌ Can't add items because backend is not accessible

---

## 🎯 ROOT CAUSE

**The WAR file has NOT been deployed to Tomcat's webapps directory!**

When you access `http://localhost:8080/my-webapp-project`, you get 404 because the application doesn't exist in Tomcat.

---

## ✅ SOLUTION (Choose One)

### Solution 1: Deploy Through IntelliJ IDEA (EASIEST if using IntelliJ)

Since your project is in `IdeaProjects`, you're likely using IntelliJ IDEA:

1. **Open IntelliJ IDEA**
2. **Open your project** (SE3318)
3. **Configure Tomcat:**
   - Go to: `Run` → `Edit Configurations`
   - Click `+` → `Tomcat Server` → `Local`
   - Configure Tomcat home directory
   - In `Deployment` tab, click `+` → `Artifact` → Select `my-webapp-project:war exploded`
   - Application context: `/my-webapp-project`
   - Click `Apply` and `OK`

4. **Run the application:**
   - Click the green Run button (or press Shift+F10)
   - IntelliJ will deploy and start Tomcat

5. **Test:**
   - Browser opens automatically
   - Try adding a task

---

### Solution 2: Find and Deploy to Tomcat Manually

#### Step 1: Find Your Tomcat Directory

Try these commands to find Tomcat:

```bash
# Check common locations
ls /opt/tomcat 2>/dev/null && echo "Found at /opt/tomcat"
ls /opt/apache-tomcat* 2>/dev/null && echo "Found at /opt/apache-tomcat*"
ls /usr/local/tomcat 2>/dev/null && echo "Found at /usr/local/tomcat"
ls ~/apache-tomcat* 2>/dev/null && echo "Found at ~/apache-tomcat*"

# Or check where Tomcat process is running from
ps aux | grep java | grep catalina
```

#### Step 2: Deploy the WAR File

Once you find Tomcat directory (let's say it's `/opt/tomcat`):

```bash
cd /home/osm/IdeaProjects/SE3318

# Copy WAR to webapps
cp target/my-webapp-project.war /opt/tomcat/webapps/

# Wait for auto-deployment (15 seconds)
sleep 15

# Check if deployed
ls -la /opt/tomcat/webapps/my-webapp-project/
```

#### Step 3: Verify Deployment

```bash
# Check Tomcat logs
tail -50 /opt/tomcat/logs/catalina.out

# Test API
curl http://localhost:8080/my-webapp-project/api/tasks
```

---

### Solution 3: Use Alternative Deployment Method

If you can't find webapps directory, try setting Tomcat location explicitly:

#### Create Tomcat Config Script:

```bash
cd /home/osm/IdeaProjects/SE3318

# Create config file
cat > tomcat-config.sh << 'CONFIGEOF'
#!/bin/bash
# Find Tomcat webapps directory and deploy

# Try common locations
WEBAPPS_LOCATIONS=(
    "/opt/tomcat/webapps"
    "/opt/apache-tomcat*/webapps"
    "/usr/local/tomcat/webapps"
    "/usr/share/tomcat/webapps"
    "~/apache-tomcat*/webapps"
    "/var/lib/tomcat/webapps"
)

for location in "${WEBAPPS_LOCATIONS[@]}"; do
    if [ -d "$location" ] || ls -d $location 2>/dev/null; then
        echo "Found webapps at: $location"
        echo "Deploying..."
        cp target/my-webapp-project.war $location/
        echo "✓ Deployed!"
        echo ""
        echo "Wait 15 seconds then access:"
        echo "http://localhost:8080/my-webapp-project"
        exit 0
    fi
done

echo "❌ Could not find Tomcat webapps directory"
echo "Please manually copy:"
echo "  cp target/my-webapp-project.war /path/to/tomcat/webapps/"
CONFIGEOF

chmod +x tomcat-config.sh
./tomcat-config.sh
```

---

## 🔧 Quick Fix Right Now

Since Tomcat is running but app isn't deployed, do this:

### Step 1: Find where your tstart command deploys to

```bash
# Run tlog to see logs and find webapps path
tlog | grep -i "webapps\|catalina.home" | tail -20

# Or check your shell history
history | grep -E "cp.*war|deploy" | tail -10
```

### Step 2: Manually deploy

```bash
cd /home/osm/IdeaProjects/SE3318

# The WAR file is ready here:
ls -lh target/my-webapp-project.war

# Copy it to wherever your Tomcat webapps is
# (You need to know your Tomcat location)
# Example:
# cp target/my-webapp-project.war /path/to/tomcat/webapps/
```

### Step 3: Verify deployment

```bash
# After copying, wait 15 seconds
sleep 15

# Test API
curl http://localhost:8080/my-webapp-project/api/tasks

# If you see JSON array (even empty []), it's working!
```

---

## 🎯 Alternative: Run with Embedded Jetty

If Tomcat deployment is problematic, I can create an embedded Jetty runner:

<function_calls>
<invoke name="create_file">
<parameter name="content">#!/bin/bash

echo "🚀 Starting TODO List Application with Embedded Server..."
echo ""

cd /home/osm/IdeaProjects/SE3318

# Check if Maven is available
if ! command -v mvn &> /dev/null; then
    echo "❌ Maven not found"
    exit 1
fi

echo "Building application..."
mvn clean package -q

if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

echo "✓ Build successful"
echo ""

# Run with Jetty Maven plugin
echo "Starting application with Jetty..."
echo "Access at: http://localhost:8080/my-webapp-project"
echo ""
echo "Press Ctrl+C to stop"
echo ""

mvn jetty:run


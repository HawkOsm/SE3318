#!/bin/bash

# TODO List Application - Fix and Redeploy Script
# This script fixes common issues and redeploys the application

echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║  TODO List Application - Fix & Redeploy                             ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""

PROJECT_DIR="/home/osm/IdeaProjects/SE3318"
TOMCAT_DIR="${TOMCAT_HOME:-/opt/tomcat}"
APP_NAME="my-webapp-project"

cd "$PROJECT_DIR" || exit 1

echo "📍 Project directory: $PROJECT_DIR"
echo "📍 Tomcat directory: $TOMCAT_DIR"
echo ""

# Step 1: Check database
echo "Step 1: Checking database..."
if [ -f "$PROJECT_DIR/todo.db" ]; then
    echo "✓ Database exists: todo.db"
    chmod 666 "$PROJECT_DIR/todo.db"
    chmod 777 "$PROJECT_DIR"
    echo "✓ Database permissions set"
else
    echo "⚠ Database not found. Creating..."
    mvn exec:java -Dexec.mainClass="com.example.util.DatabaseInitializer" -q
    chmod 666 "$PROJECT_DIR/todo.db"
    chmod 777 "$PROJECT_DIR"
    echo "✓ Database created"
fi
echo ""

# Step 2: Clean and rebuild
echo "Step 2: Building application..."
mvn clean package -q
if [ $? -eq 0 ]; then
    echo "✓ Build successful"
else
    echo "✗ Build failed. Check errors above."
    exit 1
fi
echo ""

# Step 3: Stop Tomcat
echo "Step 3: Stopping Tomcat..."
if [ -f "$TOMCAT_DIR/bin/shutdown.sh" ]; then
    "$TOMCAT_DIR/bin/shutdown.sh" 2>/dev/null
    sleep 3
    echo "✓ Tomcat stopped"
else
    echo "⚠ Tomcat shutdown script not found at $TOMCAT_DIR/bin/shutdown.sh"
    echo "   Please stop Tomcat manually if it's running"
fi
echo ""

# Step 4: Clean old deployment
echo "Step 4: Cleaning old deployment..."
rm -rf "$TOMCAT_DIR/webapps/${APP_NAME}.war"
rm -rf "$TOMCAT_DIR/webapps/${APP_NAME}"
rm -rf "$TOMCAT_DIR/work/Catalina/localhost/${APP_NAME}"
echo "✓ Old deployment removed"
echo ""

# Step 5: Deploy new WAR
echo "Step 5: Deploying new WAR..."
if [ -f "$PROJECT_DIR/target/${APP_NAME}.war" ]; then
    cp "$PROJECT_DIR/target/${APP_NAME}.war" "$TOMCAT_DIR/webapps/"
    echo "✓ WAR file copied to Tomcat"
else
    echo "✗ WAR file not found at $PROJECT_DIR/target/${APP_NAME}.war"
    exit 1
fi
echo ""

# Step 6: Start Tomcat
echo "Step 6: Starting Tomcat..."
if [ -f "$TOMCAT_DIR/bin/startup.sh" ]; then
    "$TOMCAT_DIR/bin/startup.sh"
    echo "✓ Tomcat started"
else
    echo "⚠ Tomcat startup script not found at $TOMCAT_DIR/bin/startup.sh"
    echo "   Please start Tomcat manually"
fi
echo ""

# Step 7: Wait for deployment
echo "Step 7: Waiting for deployment (15 seconds)..."
sleep 15
echo "✓ Deployment should be complete"
echo ""

# Step 8: Test API
echo "Step 8: Testing API..."
API_URL="http://localhost:8080/${APP_NAME}/api/tasks"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL" 2>/dev/null)

if [ "$HTTP_CODE" = "200" ]; then
    echo "✓ API is responding (HTTP $HTTP_CODE)"
    echo ""
    echo "Testing POST..."
    curl -X POST "$API_URL" \
        -H "Content-Type: application/json" \
        -d '{"title":"Test from script","completed":false}' \
        -s | head -100
    echo ""
else
    echo "⚠ API returned HTTP $HTTP_CODE"
    echo "   Check Tomcat logs: tail -f $TOMCAT_DIR/logs/catalina.out"
fi
echo ""

# Final instructions
echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║  Deployment Complete                                                ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""
echo "✅ Next Steps:"
echo ""
echo "1. Open browser and go to:"
echo "   http://localhost:8080/${APP_NAME}"
echo ""
echo "2. Or use diagnostic tool:"
echo "   http://localhost:8080/${APP_NAME}/diagnostic.html"
echo ""
echo "3. Try adding a task:"
echo "   - Type task name in input field"
echo "   - Press Enter or click Add button"
echo ""
echo "4. If issues persist, check:"
echo "   - Browser console (F12 → Console)"
echo "   - Network tab (F12 → Network)"
echo "   - Tomcat logs: tail -f $TOMCAT_DIR/logs/catalina.out"
echo ""
echo "5. Use diagnostic tool to identify specific issues"
echo ""
echo "📚 For more help, see: TROUBLESHOOTING_GUIDE.md"
echo ""

# Show Tomcat logs location
echo "📝 Tomcat logs:"
echo "   $TOMCAT_DIR/logs/catalina.out"
echo ""


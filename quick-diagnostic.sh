#!/bin/bash

echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║  TODO List - Quick Diagnostic & Fix                                 ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""

PROJECT_DIR="/home/osm/IdeaProjects/SE3318"
cd "$PROJECT_DIR" || exit 1

# Check 1: Is backend needed?
echo "🔍 Checking if you're accessing the file directly..."
echo ""
echo "IMPORTANT: The TODO list requires a running backend server!"
echo ""
echo "❌ WRONG WAY: Opening index.jsp directly in browser"
echo "   file:///home/osm/IdeaProjects/SE3318/src/main/webapp/index.jsp"
echo "   → This WON'T work! API calls fail!"
echo ""
echo "✅ CORRECT WAY: Access through Tomcat server"
echo "   http://localhost:8080/my-webapp-project"
echo "   → This WILL work! API calls succeed!"
echo ""

# Check 2: Test if backend is accessible
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Testing backend API..."
echo ""

API_URL="http://localhost:8080/my-webapp-project/api/tasks"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL" 2>/dev/null)

if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ Backend API is WORKING!"
    echo "   Status: HTTP $HTTP_CODE"
    echo "   URL: $API_URL"
    echo ""

    echo "Testing task retrieval..."
    TASKS=$(curl -s "$API_URL" 2>/dev/null)
    TASK_COUNT=$(echo "$TASKS" | python3 -c "import sys, json; print(len(json.load(sys.stdin)))" 2>/dev/null || echo "0")
    echo "   Found $TASK_COUNT tasks in database"
    echo ""

    echo "Testing task creation..."
    CREATE_RESPONSE=$(curl -X POST "$API_URL" \
        -H "Content-Type: application/json" \
        -d '{"title":"Test from diagnostic","completed":false}' \
        -s 2>/dev/null)

    if echo "$CREATE_RESPONSE" | grep -q '"id"'; then
        echo "✅ Task creation WORKS!"
        echo "   Response: $CREATE_RESPONSE"
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "🎉 BACKEND IS WORKING PERFECTLY!"
        echo ""
        echo "✅ Solution: Access your app through the web server:"
        echo "   http://localhost:8080/my-webapp-project"
        echo ""
        echo "   DO NOT open the JSP file directly!"
        echo ""
    else
        echo "⚠️  Task creation returned unexpected response"
        echo "   Response: $CREATE_RESPONSE"
    fi

else
    echo "❌ Backend API is NOT responding!"
    echo "   Status: HTTP $HTTP_CODE"
    echo "   URL: $API_URL"
    echo ""

    # Check if Tomcat is running
    if ps aux | grep -i "tomcat" | grep -v grep > /dev/null; then
        echo "✓ Tomcat process is running"
        echo ""
        echo "⚠️  But API is not accessible. Possible causes:"
        echo "   1. Application not deployed (WAR not copied)"
        echo "   2. Application failed to start (check logs)"
        echo "   3. Wrong port or context path"
        echo ""
        echo "Try running your tstart command:"
        echo "   tstart"
        echo ""
        echo "Then check logs with:"
        echo "   tlog"
        echo ""
    else
        echo "❌ Tomcat is NOT running!"
        echo ""
        echo "✅ SOLUTION: Start Tomcat with your command:"
        echo "   tstart"
        echo ""
        echo "Then wait 15 seconds and run this script again:"
        echo "   ./quick-diagnostic.sh"
        echo ""
    fi
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 Quick Fix Steps:"
echo ""
echo "1. Start Tomcat:"
echo "   tstart"
echo ""
echo "2. Deploy application:"
echo "   cp $PROJECT_DIR/target/my-webapp-project.war /path/to/tomcat/webapps/"
echo "   (Replace /path/to/tomcat with your actual Tomcat path)"
echo ""
echo "3. Wait 15 seconds for deployment"
echo ""
echo "4. Access through web browser:"
echo "   http://localhost:8080/my-webapp-project"
echo ""
echo "5. Open browser console (F12) and try adding a task"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📞 For detailed help, see: TROUBLESHOOTING_GUIDE.md"
echo ""


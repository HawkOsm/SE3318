#!/bin/bash

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  TODO List - Automatic Deployment Finder                       ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

PROJECT_DIR="/home/osm/IdeaProjects/SE3318"
WAR_FILE="$PROJECT_DIR/target/my-webapp-project.war"

cd "$PROJECT_DIR" || exit 1

# Check if WAR exists
if [ ! -f "$WAR_FILE" ]; then
    echo "⚠️  WAR file not found. Building..."
    mvn clean package -q
    if [ $? -ne 0 ]; then
        echo "❌ Build failed"
        exit 1
    fi
    echo "✓ Build successful"
fi

echo "📦 WAR file ready: $(ls -lh $WAR_FILE | awk '{print $9, $5}')"
echo ""

# Find Tomcat webapps
echo "🔍 Searching for Tomcat webapps directory..."
echo ""

LOCATIONS=(
    "/opt/tomcat/webapps"
    "/opt/apache-tomcat-*/webapps"
    "/usr/local/tomcat/webapps"
    "/usr/share/tomcat/webapps"
    "/usr/share/tomcat8/webapps"
    "/usr/share/tomcat9/webapps"
    "/var/lib/tomcat/webapps"
    "/var/lib/tomcat8/webapps"
    "/var/lib/tomcat9/webapps"
    "$HOME/tomcat/webapps"
    "$HOME/apache-tomcat*/webapps"
)

FOUND=0

for location in "${LOCATIONS[@]}"; do
    # Expand wildcards
    for dir in $location; do
        if [ -d "$dir" ]; then
            echo "Found: $dir"

            # Check if writable
            if [ -w "$dir" ]; then
                echo "  ✓ Writable"
                echo ""
                echo "Deploying to: $dir"
                cp "$WAR_FILE" "$dir/"

                if [ $? -eq 0 ]; then
                    FOUND=1
                    echo "✓ WAR file copied successfully!"
                    echo ""
                    echo "Waiting 15 seconds for Tomcat to deploy..."

                    for i in {15..1}; do
                        echo -ne "\r⏳ $i seconds remaining...  "
                        sleep 1
                    done
                    echo ""
                    echo ""

                    # Test deployment
                    echo "Testing deployment..."
                    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/my-webapp-project/api/tasks)

                    if [ "$HTTP_CODE" = "200" ]; then
                        echo "✅ SUCCESS! Application is deployed and working!"
                        echo ""
                        curl -s http://localhost:8080/my-webapp-project/api/tasks | python3 -m json.tool 2>/dev/null || curl -s http://localhost:8080/my-webapp-project/api/tasks
                        echo ""
                        echo ""
                        echo "════════════════════════════════════════════════════════"
                        echo "✅ DEPLOYMENT SUCCESSFUL!"
                        echo ""
                        echo "🌐 Open browser to:"
                        echo "   http://localhost:8080/my-webapp-project"
                        echo ""
                        echo "Try adding a task now! 🎉"
                        echo "════════════════════════════════════════════════════════"
                        exit 0
                    else
                        echo "⚠️  API returned HTTP $HTTP_CODE"
                        echo "   Checking if app is still deploying..."

                        # Wait a bit more
                        sleep 10
                        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/my-webapp-project/api/tasks)

                        if [ "$HTTP_CODE" = "200" ]; then
                            echo "✅ SUCCESS! Application is now working!"
                            echo ""
                            echo "🌐 Open browser to:"
                            echo "   http://localhost:8080/my-webapp-project"
                            exit 0
                        else
                            echo "❌ Application not responding yet"
                            echo "   Check Tomcat logs:"
                            echo "   tail -100 $(dirname $dir)/../logs/catalina.out"
                        fi
                    fi
                    break 2
                else
                    echo "❌ Failed to copy WAR file"
                fi
            else
                echo "  ⚠️  Not writable - try with sudo:"
                echo "     sudo cp $WAR_FILE $dir/"
                echo ""
            fi
        fi
    done
done

if [ $FOUND -eq 0 ]; then
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "❌ Could not find writable Tomcat webapps directory"
    echo "════════════════════════════════════════════════════════"
    echo ""
    echo "🔧 MANUAL DEPLOYMENT REQUIRED:"
    echo ""
    echo "1. Find your Tomcat installation:"
    echo "   ps aux | grep catalina"
    echo "   echo \$CATALINA_HOME"
    echo ""
    echo "2. Copy WAR to webapps:"
    echo "   sudo cp $WAR_FILE /path/to/tomcat/webapps/"
    echo ""
    echo "3. Wait 15 seconds for deployment"
    echo ""
    echo "4. Access application:"
    echo "   http://localhost:8080/my-webapp-project"
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo ""
    echo "📝 OR USE INTELLIJ IDEA:"
    echo ""
    echo "1. Open IntelliJ IDEA with your project"
    echo "2. Run → Edit Configurations"
    echo "3. Add Tomcat Server → Local"
    echo "4. Add Deployment artifact"
    echo "5. Click Run"
    echo ""
    echo "════════════════════════════════════════════════════════"
fi


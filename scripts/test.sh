#!/bin/bash
set -e

echo "Testing K8s Assignment Applications..."

# Test each application
for app in app1 app2 app3; do
    echo "Testing $app..."
    
    response=$(curl -s http://localhost/$app)
    
    if [[ $response == *"pod_name"* ]] && [[ $response == *"pod_ip"* ]]; then
        echo "✓ $app is working correctly"
        echo "  Response: $response"
    else
        echo "✗ $app is not working properly"
        echo "  Response: $response"
        exit 1
    fi
    
    echo ""
done

echo "All applications are working correctly!"
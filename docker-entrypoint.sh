#!/bin/sh

# This script injects environment variables into the Flutter web app at runtime
# by creating a JavaScript file that sets window.ENV

set -e

# Create env-config.js with environment variables
cat > /usr/share/nginx/html/env-config.js <<EOF
window.ENV = {
  API_BASE_URL: "${API_BASE_URL:-http://localhost:3000/api/v1}"
};
EOF

echo "Environment configuration created:"
cat /usr/share/nginx/html/env-config.js

# Execute the CMD
exec "$@"

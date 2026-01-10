#!/bin/sh
set -e

: "${API_BASE_URL:?API_BASE_URL must be set via docker-compose environment}"
# Default backend URL if not set
export BACKEND_URL="${BACKEND_URL:-http://finca_app_backend:3000}"

# Generate env-config.js file
cat > /usr/share/nginx/html/env-config.js <<EOF
window.ENV = {
  API_BASE_URL: "${API_BASE_URL}"
};
EOF

# Ensure env-config.js is loaded in index.html (if inline injection was attempted previously or if template is clean)
# We trust the index.html has <script src="env-config.js"></script> as per source.
# If previous run modified it, the container rebuild (fresh copy) restores it.

echo "Generated env-config.js with content:"
cat /usr/share/nginx/html/env-config.js

# Security: Remove .env file from assets if it exists to prevent exposure
if [ -f /usr/share/nginx/html/assets/.env ]; then
    rm -f /usr/share/nginx/html/assets/.env
    echo "Secured: Removed .env file from assets"
fi

echo "Injected configuration into index.html: ${CONFIG_CONTENT}"

# Inyectar BACKEND_URL en nginx.conf
sed -i "s|{{BACKEND_URL}}|${BACKEND_URL}|g" /etc/nginx/nginx.conf

# Remove source map references explicitly from known files to prevent browser warnings
echo "Stripping source maps from JS files..."
if [ -f /usr/share/nginx/html/flutter_bootstrap.js ]; then
    sed -i '/sourceMappingURL/d' /usr/share/nginx/html/flutter_bootstrap.js
fi
if [ -f /usr/share/nginx/html/main.dart.js ]; then
    sed -i '/sourceMappingURL/d' /usr/share/nginx/html/main.dart.js
fi

# Fallback verify all js
find /usr/share/nginx/html -name "*.js" -type f -exec sed -i '/sourceMappingURL=/d' {} \;


exec "$@"

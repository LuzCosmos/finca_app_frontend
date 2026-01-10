#!/bin/sh
set -e

: "${API_BASE_URL:?API_BASE_URL must be set via docker-compose environment}"
# Default backend URL if not set
export BACKEND_URL="${BACKEND_URL:-http://finca_app_backend:3000}"

# Construct the configuration script
CONFIG_CONTENT="window.ENV = { API_BASE_URL: \"${API_BASE_URL}\" };"

# Inject configuration directly into index.html
# Replaces <script src="env-config.js"></script> with the actual script
sed -i "s|<script src=\"env-config.js\"></script>|<script>${CONFIG_CONTENT}</script>|g" /usr/share/nginx/html/index.html

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

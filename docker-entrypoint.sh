#!/bin/sh
set -e

: "${API_BASE_URL:?API_BASE_URL must be set via docker-compose environment}"
# Default backend URL if not set
export BACKEND_URL="${BACKEND_URL:-http://finca_app_backend:3000}"

cat > /usr/share/nginx/html/env-config.js <<EOF
window.ENV = {
  API_BASE_URL: "${API_BASE_URL}"
};
EOF

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

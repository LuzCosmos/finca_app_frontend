# Stage 1: Build the Flutter Web App
FROM ghcr.io/cirruslabs/flutter:3.38.10 AS build

WORKDIR /app

# Copy dependency definitions
COPY pubspec.yaml pubspec.lock ./

# Get dependencies
RUN flutter pub get

# Copy source code
COPY . .

# .dockerignore excluye .env; el pubspec declara ese asset — copiamos plantilla segura.
RUN cp dotenv.template .env

# Web/shared no deben importar SQLite FFI (app_database_mobile / drift native).
RUN if grep -rE 'app_database_mobile|package:drift/native\.dart' lib/modules/web lib/modules/shared --include='*.dart' 2>/dev/null | grep -q .; then \
      echo 'ERROR: lib/modules/web o shared importan capa SQLite nativa'; \
      exit 1; \
    fi

# Build the web application (--no-wasm-dry-run: universal_html usa dart:js, aviso esperado)
RUN flutter build web --release --no-wasm-dry-run

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy environment configuration script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Copy built web app from the builder stage
COPY --from=build /app/build/web /usr/share/nginx/html

# Use custom entrypoint to inject environment variables at runtime
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

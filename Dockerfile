# Stage: Serve with Nginx
FROM nginx:alpine

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy environment configuration script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Copy pre-built web app (built in CI/GitHub Actions)
# CI will place the contents of build/web in the build context
RUN rm -rf /usr/share/nginx/html/*
COPY build/web /usr/share/nginx/html

# Use custom entrypoint to inject environment variables at runtime
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

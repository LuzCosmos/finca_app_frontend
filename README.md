# finca_app_frontend

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
- [online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

## 🚀 Deployment Instructions (CI/CD + Docker)

This project uses a production-ready strategy where the Flutter Web app is built in CI (GitHub Actions) and served by a lightweight Nginx container.

### 1. Build & Push (GitHub Actions)
The workflow in `.github/workflows/frontend.yml` handles the build automatically:
1.  **Trigger:** Every push to `main` branch.
2.  **Process:** Installs Flutter → Builds Web Release → Builds Nginx Docker Image → Pushes to Registry (GHCR).

### 2. Manual Local Test (Docker)
To test the Docker container locally:
1.  **Build the Flutter Web app:**
    ```bash
    flutter build web --release
    ```
2.  **Start the container:**
    ```bash
    docker-compose up -d --build
    ```
    *The app will be available at `http://localhost:8080`.*

### 3. Server Deployment
To deploy on your Ubuntu server:
1.  Ensure **Docker** and **Docker Compose** are installed.
2.  Copy `docker-compose.yaml` and `.env` to the server.
3.  Set your environment variables in `.env` (especially `API_BASE_URL`).
4.  Run:
    ```bash
    docker-compose pull
    docker-compose up -d
    ```

---

## 🛠 Useful Commands
- **Generate code (Drift/Mocks):** `flutter pub run build_runner build --delete-conflicting-outputs`
- **Run in debug mode:** `flutter run -d chrome`


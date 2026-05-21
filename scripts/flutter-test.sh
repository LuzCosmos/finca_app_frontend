#!/usr/bin/env bash
# Evita crash del reporter compacto con nombres de test + ruta largos (Flutter #?).
set -euo pipefail
cd "$(dirname "$0")/.."
flutter test --reporter expanded "$@"

#!/usr/bin/env bash
set -e

DEST_DIR="${HOME}/.local/lib/qt6/qml/org/kde/plasma/workspace/osd"
PLASMA_ENV_FILE="${HOME}/.config/plasma-workspace/env/qml.sh"

echo "==> Uninstalling Minimal Breeze OSD..."

if [ -d "${DEST_DIR}" ]; then
    rm -rf "${DEST_DIR}"
    echo "==> Removed ${DEST_DIR}"
fi

if [ -f "${PLASMA_ENV_FILE}" ]; then
    rm -f "${PLASMA_ENV_FILE}"
    echo "==> Removed ${PLASMA_ENV_FILE}"
fi

echo "==> Restarting Plasma Shell..."
systemctl --user restart plasma-plasmashell.service 2>/dev/null || true

echo "==> Restored stock KDE Plasma OSD successfully."

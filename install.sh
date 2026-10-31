#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST_DIR="${HOME}/.local/lib/qt6/qml/org/kde/plasma/workspace/osd"
ENV_DIR="${HOME}/.config/environment.d"
ENV_FILE="${ENV_DIR}/10-qml.conf"
PLASMA_ENV_DIR="${HOME}/.config/plasma-workspace/env"
PLASMA_ENV_FILE="${PLASMA_ENV_DIR}/qml.sh"

echo "==> Installing Minimal Breeze OSD for KDE Plasma 6..."

# If shared library does not exist, attempt to build it
if [ ! -f "${SCRIPT_DIR}/libplasmashell_osd.so" ]; then
    echo "==> Building libplasmashell_osd.so from source..."
    (cd "${SCRIPT_DIR}/src" && ./build.sh)
fi

mkdir -p "${DEST_DIR}/src"

echo "==> Copying files to ${DEST_DIR}..."
cp -f --remove-destination "${SCRIPT_DIR}/Osd.qml" "${DEST_DIR}/"
cp -f --remove-destination "${SCRIPT_DIR}/OsdItem.qml" "${DEST_DIR}/"
cp -f --remove-destination "${SCRIPT_DIR}/qmldir" "${DEST_DIR}/"
cp -f --remove-destination "${SCRIPT_DIR}/plasmashell_osd.qmltypes" "${DEST_DIR}/"
cp -f --remove-destination "${SCRIPT_DIR}/libplasmashell_osd.so" "${DEST_DIR}/"
cp -rf --remove-destination "${SCRIPT_DIR}/src/"* "${DEST_DIR}/src/"
chmod +x "${DEST_DIR}/src/build.sh"

echo "==> Configuring QML import paths..."
mkdir -p "${ENV_DIR}"
if ! grep -q "QML2_IMPORT_PATH" "${ENV_FILE}" 2>/dev/null; then
    echo 'QML2_IMPORT_PATH="${HOME}/.local/lib/qt6/qml:${QML2_IMPORT_PATH}"' >> "${ENV_FILE}"
fi

mkdir -p "${PLASMA_ENV_DIR}"
cat << 'EOF' > "${PLASMA_ENV_FILE}"
#!/bin/sh
export QML2_IMPORT_PATH="${HOME}/.local/lib/qt6/qml:${QML2_IMPORT_PATH}"
EOF
chmod +x "${PLASMA_ENV_FILE}"

echo "==> Restarting Plasma Shell..."
systemctl --user restart plasma-plasmashell.service 2>/dev/null || true

echo "==> Installation complete! The OSD is now active."

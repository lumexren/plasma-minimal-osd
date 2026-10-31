#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

MOC=$(command -v moc-qt6 2>/dev/null || command -v /usr/lib/qt6/moc 2>/dev/null || command -v moc 2>/dev/null || true)

if [ -z "$MOC" ]; then
    echo "Error: Qt 6 'moc' not found." >&2
    exit 1
fi

"$MOC" -I/usr/include/qt6 -I/usr/include/qt6/QtCore plugin.h -o moc_plugin.cpp
"$MOC" -I/usr/include/qt6 -I/usr/include/qt6/QtCore -I/usr/include/PlasmaQuick osdwindow.h -o moc_osdwindow.cpp

g++ -fPIC -shared -O2 -std=c++20 \
  -I. \
  -I/usr/include/PlasmaQuick \
  -I/usr/include/Plasma \
  -I/usr/include/KF6/KWindowSystem \
  -I/usr/include/KF6 \
  $(pkg-config --cflags Qt6Quick Qt6Qml Qt6Core Qt6Gui Qt6DBus) \
  osdwindow.cpp moc_osdwindow.cpp plugin.cpp moc_plugin.cpp \
  -o ../libplasmashell_osd.so \
  $(pkg-config --libs Qt6Quick Qt6Qml Qt6Core Qt6Gui Qt6DBus) \
  -lPlasmaQuick -lKF6WindowSystem -lwayland-client

rm -f moc_plugin.cpp moc_osdwindow.cpp

echo "Build successful -> ../libplasmashell_osd.so"

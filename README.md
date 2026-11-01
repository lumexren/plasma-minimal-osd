![plasma-minimal-osd](https://img.shields.io/badge/plasma--minimal--osd-gray?style=for-the-badge&logo=kde&logoColor=white) 
![License](https://img.shields.io/badge/License-GPL--2.0-orange?style=for-the-badge) 
![Stars](https://img.shields.io/github/stars/lumexren/plasma-minimal-osd?style=for-the-badge&color=DAA520) 
![Issues](https://img.shields.io/github/issues/lumexren/plasma-minimal-osd?style=for-the-badge) 
![Last Commit](https://img.shields.io/github/last-commit/lumexren/plasma-minimal-osd?style=for-the-badge&color=F7A41D) 
<br>

**A clean, minimal, and bottom-aligned On-Screen Display (OSD) replacement for KDE Plasma 6**

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Requirements](#requirements)
- [Installation](#installation)
- [Building from Source](#building-from-source)
- [Testing](#testing)
- [Uninstallation](#uninstallation)
- [Acknowledgments](#acknowledgments)

## Overview

`plasma-minimal-osd` is a clean, modern, and bottom-aligned On-Screen Display (OSD) replacement for **KDE Plasma 6** on Wayland and X11.

Designed to blend natively into KDE's **Breeze** theme while solving common placement and layout quirks of the default OSD, it repositions the display right above your bottom panel and dynamically follows cursor/window focus across multiple monitors.

## Features

- **Bottom-Screen Placement** - Positions the OSD floating comfortably right above your bottom panel (~70px from the screen bottom) instead of KWin's default 2/3 vertical position.
- **Dynamic Multi-Monitor Tracking** - Uses KWin's D-Bus interface (`org.kde.KWin.activeOutputName`) to automatically appear on whichever monitor your cursor or active window is on.
- **Native Breeze Design** - Minimalist 6px rounded progress bar, genuine Breeze typography, and palette accent colors (`Kirigami.Theme.highlightColor`).
- **Modern Brightness Indicator** - Replaces the legacy CRT monitor graphic with crisp Breeze sun icons (`brightness-high` / `brightness-low`) and perfectly aligns monitor model subtitles with the progress slider.
- **Balanced Content Padding** - Text-only notifications (e.g., *Audio Muted*, *Caps Lock*) dynamically hug their content with clean, symmetrical horizontal margins.
- **Persistent Across Updates** - Resides in your user directory (`~/.local/lib/qt6/qml`) and survives desktop package updates.

## Architecture

| Component | Path / Identifier | Description |
|:----------|:------------------|:------------|
| **QML Component** | `Osd.qml` / `OsdItem.qml` | Modernized Kirigami OSD interface with bottom alignment and dynamic layout |
| **Wayland Integration** | `libplasmashell_osd.so` | C++ Qt6 plugin binding to Wayland plasma-shell protocol and KWin D-Bus |
| **QML Module Definition** | `qmldir` & `plasmashell_osd.qmltypes` | Qt6 QML module registration (`org.kde.plasma.workspace.osd`) |

## Requirements

- **Desktop:** KDE Plasma 6.0 or newer
- **Display Server:** Wayland (X11 supported)
- **Toolkit:** Qt 6 (QtQuick, Kirigami, PlasmaQuick)

## Installation

### Automatic (Recommended)

Clone the repository and run the installation script:

```bash
git clone https://github.com/lumexren/plasma-minimal-osd.git
cd plasma-minimal-osd
chmod +x install.sh
./install.sh
```

The script copies the module files to `~/.local/lib/qt6/qml/org/kde/plasma/workspace/osd/`, sets the `QML2_IMPORT_PATH` session environment variables, and restarts `plasmashell`.

### Manual Installation

1. Copy the module files to your local Qt6 QML directory:
   ```bash
   mkdir -p ~/.local/lib/qt6/qml/org/kde/plasma/workspace/osd
   cp Osd.qml OsdItem.qml qmldir plasmashell_osd.qmltypes libplasmashell_osd.so ~/.local/lib/qt6/qml/org/kde/plasma/workspace/osd/
   ```

2. Register the QML import path for your user session:
   ```bash
   mkdir -p ~/.config/environment.d
   echo 'QML2_IMPORT_PATH="${HOME}/.local/lib/qt6/qml:${QML2_IMPORT_PATH}"' >> ~/.config/environment.d/10-qml.conf

   mkdir -p ~/.config/plasma-workspace/env
   cat << 'EOF' > ~/.config/plasma-workspace/env/qml.sh
   #!/bin/sh
   export QML2_IMPORT_PATH="${HOME}/.local/lib/qt6/qml:${QML2_IMPORT_PATH}"
   EOF
   chmod +x ~/.config/plasma-workspace/env/qml.sh
   ```

3. Restart Plasma Shell:
   ```bash
   systemctl --user restart plasma-plasmashell.service
   ```

## Building from Source

If you want to recompile the C++ Wayland integration module (`libplasmashell_osd.so`):

### Build Dependencies (Arch Linux / CachyOS)

```bash
sudo pacman -S base-devel qt6-base qt6-declarative plasma-workspace
```

### Build Command

```bash
cd src
./build.sh
```

## Testing

You can preview the OSD without touching your hardware keys via D-Bus:

```bash
# Test volume progress
qdbus6 org.kde.plasmashell /org/kde/osdService volumeChanged 70

# Test muted notification
qdbus6 org.kde.plasmashell /org/kde/osdService showText "audio-volume-muted" "Audio Muted"

# Test brightness with display label
qdbus6 org.kde.plasmashell /org/kde/osdService screenBrightnessChanged 60 "DP-1" "Primary Monitor" 0 "(0,0,1920,1080)"
```

## Uninstallation

To revert back to the default KDE Plasma OSD:

```bash
chmod +x uninstall.sh
./uninstall.sh
```

## Acknowledgments

- **KDE Plasma Team** - For creating the Breeze design system and Plasma desktop environment.
- **David Edmundson** - For the original upstream Plasma OSD implementation.
- **Community** - For feedback, testing, and contributions.

---

<div align="center">

**Built with ❤️ by lumexren**

*Star ⭐ this repo if you find it useful!*<br>
*Join our [Fluxer](https://fluxer.gg/xnTFlhV0) for support and updates!*

This project is licensed under the **GNU General Public License v2.0 or later**. See [LICENSE](./LICENSE) for details.

</div>

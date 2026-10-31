/*
    SPDX-FileCopyrightText: 2014 Martin Klapetek <mklapetek@kde.org>
    SPDX-FileCopyrightText: 2026 David Edmundson <davidedmundson@kde.org>
    SPDX-FileCopyrightText: 2026 Minimal Breeze OSD for KDE Plasma 6

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import org.kde.kirigami as Kirigami

import org.kde.plasma.workspace.osd

OsdWindow {
    id: window

    LayoutMirroring.enabled: Application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property alias timeout: osd.timeout
    property alias osdValue: osd.osdValue
    property alias osdMaxValue: osd.osdMaxValue
    property alias osdAdditionalText: osd.osdAdditionalText
    property alias icon: osd.icon
    property alias showingProgress: osd.showingProgress

    width: Math.min(Screen.desktopAvailableWidth / 2, mainItem.implicitWidth) + leftPadding + rightPadding
    height: mainItem.implicitHeight + topPadding + bottomPadding
    bottomMargin: 70

    onVisibleChanged: {
        if (visible) {
            updateWaylandPosition();
        }
    }
    onOsdValueChanged: {
        if (visible) {
            updateWaylandPosition();
        }
    }
    onOsdAdditionalTextChanged: {
        if (visible) {
            updateWaylandPosition();
        }
    }
    onShowingProgressChanged: {
        if (visible) {
            updateWaylandPosition();
        }
    }

    mainItem: OsdItem {
        id: osd
    }
}

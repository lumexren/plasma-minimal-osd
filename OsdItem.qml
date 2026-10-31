/*
    SPDX-FileCopyrightText: 2014 Martin Klapetek <mklapetek@kde.org>
    SPDX-FileCopyrightText: 2019 Kai Uwe Broulik <kde@broulik.de>
    SPDX-FileCopyrightText: 2026 Minimal Breeze OSD for KDE Plasma 6

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

Item {
    id: root

    property int timeout: 1800
    property var osdValue
    property int osdMaxValue: 100
    property string osdAdditionalText: ""
    property string icon: ""
    property bool showingProgress: false

    function formatPercent(number) {
        return i18nc("Percentage value", "%1%", number);
    }

    readonly property bool isDark: Kirigami.Theme.textColor.r > 0.5
    readonly property real numericValue: {
        const val = Number(root.osdValue);
        return isNaN(val) ? 0 : val;
    }
    readonly property real currentRatio: {
        if (!root.osdMaxValue || root.osdMaxValue <= 0) return 0;
        return Math.max(0, Math.min(root.numericValue / root.osdMaxValue, 1.0));
    }

    readonly property bool hasSubtitle: root.showingProgress && !!root.osdAdditionalText && root.osdAdditionalText.length > 0

    readonly property color barColor: {
        if (root.numericValue <= 100) {
            return Kirigami.Theme.highlightColor;
        } else if (root.numericValue <= 125) {
            return Kirigami.Theme.neutralTextColor;
        } else {
            return Kirigami.Theme.negativeTextColor;
        }
    }

    readonly property string effectiveIcon: {
        if (root.showingProgress && root.numericValue <= 0 && root.icon.indexOf("volume") !== -1) {
            return "audio-volume-muted";
        }
        if (root.icon === "video-display-brightness") {
            return root.numericValue > 50 ? "brightness-high" : "brightness-low";
        }
        return root.icon;
    }

    implicitWidth: {
        if (root.showingProgress) {
            if (root.hasSubtitle) {
                return Math.max(320, Math.min(Screen.desktopAvailableWidth / 2, Math.ceil(subtitleMetrics.advanceWidth + 110)));
            }
            return 300;
        }
        const iconW = (root.icon && root.icon !== "") ? 22 : 0;
        const spacingW = iconW > 0 ? Kirigami.Units.largeSpacing : 0;
        return Math.ceil(iconW + spacingW + textLabel.implicitWidth + (Kirigami.Units.largeSpacing * 2));
    }

    implicitHeight: {
        if (root.showingProgress) {
            return root.hasSubtitle ? 52 : 42;
        }
        return Math.max(42, Math.ceil(textLabel.implicitHeight + (Kirigami.Units.largeSpacing * 2)));
    }

    TextMetrics {
        id: valueMetrics
        font.family: Kirigami.Theme.defaultFont.family
        font.pixelSize: Kirigami.Theme.defaultFont.pixelSize
        font.weight: Font.DemiBold
        text: root.formatPercent(root.osdMaxValue > 100 ? 150 : 100)
    }

    TextMetrics {
        id: subtitleMetrics
        font.family: Kirigami.Theme.defaultFont.family
        font.pixelSize: Kirigami.Theme.smallFont.pixelSize
        font.weight: Font.Normal
        text: root.osdAdditionalText || ""
    }

    Item {
        anchors.fill: parent
        anchors.leftMargin: Kirigami.Units.largeSpacing
        anchors.rightMargin: Kirigami.Units.largeSpacing
        anchors.topMargin: root.hasSubtitle ? 6 : 8
        anchors.bottomMargin: root.hasSubtitle ? 6 : 8

        RowLayout {
            anchors.fill: parent
            visible: root.showingProgress
            spacing: Kirigami.Units.largeSpacing

            Kirigami.Icon {
                id: iconItem
                Layout.preferredWidth: root.hasSubtitle ? 24 : 22
                Layout.preferredHeight: root.hasSubtitle ? 24 : 22
                Layout.alignment: Qt.AlignVCenter
                source: root.effectiveIcon + (Application.layoutDirection === Qt.RightToLeft ? "-rtl" : "")
                visible: valid && root.effectiveIcon !== ""
                color: Kirigami.Theme.textColor
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: 3

                Text {
                    id: deviceLabel
                    Layout.fillWidth: true
                    visible: root.hasSubtitle
                    text: root.osdAdditionalText || ""
                    elide: Text.ElideRight
                    font.family: Kirigami.Theme.defaultFont.family
                    font.pixelSize: Kirigami.Theme.smallFont.pixelSize
                    font.weight: Font.Normal
                    color: Kirigami.Theme.textColor
                    opacity: 0.75
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: Kirigami.Units.largeSpacing

                    Item {
                        id: sliderContainer
                        Layout.fillWidth: true
                        Layout.preferredHeight: 6
                        Layout.alignment: Qt.AlignVCenter

                        Rectangle {
                            anchors.fill: parent
                            radius: 3
                            color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, root.isDark ? 0.16 : 0.12)
                        }

                        Rectangle {
                            id: fillBar
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            radius: 3
                            color: root.barColor
                            visible: width > 0
                            width: Math.max(0, Math.min(sliderContainer.width * root.currentRatio, sliderContainer.width))

                            Behavior on width {
                                NumberAnimation {
                                    duration: 120
                                    easing.type: Easing.OutCubic
                                }
                            }
                        }
                    }

                    Text {
                        id: percentText
                        Layout.preferredWidth: Math.ceil(valueMetrics.advanceWidth)
                        Layout.alignment: Qt.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        text: root.formatPercent(Math.round(root.numericValue))
                        font.family: Kirigami.Theme.defaultFont.family
                        font.pixelSize: Kirigami.Theme.defaultFont.pixelSize
                        font.weight: Font.DemiBold
                        color: Kirigami.Theme.textColor
                    }
                }
            }
        }

        RowLayout {
            anchors.fill: parent
            visible: !root.showingProgress
            spacing: Kirigami.Units.largeSpacing

            Kirigami.Icon {
                Layout.preferredWidth: 22
                Layout.preferredHeight: 22
                Layout.alignment: Qt.AlignVCenter
                source: root.icon + (Application.layoutDirection === Qt.RightToLeft ? "-rtl" : "")
                visible: valid && root.icon !== ""
                color: Kirigami.Theme.textColor
            }

            Text {
                id: textLabel
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                text: (root.osdValue ?? root.osdAdditionalText) ?? ""
                font.family: Kirigami.Theme.defaultFont.family
                font.pixelSize: Kirigami.Theme.defaultFont.pixelSize
                font.weight: Font.DemiBold
                color: Kirigami.Theme.textColor
                wrapMode: Text.Wrap
            }
        }
    }
}

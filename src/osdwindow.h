/*
    SPDX-FileCopyrightText: 2026 David Edmundson <davidedmundson@kde.org>
    SPDX-FileCopyrightText: 2026 Minimal Breeze OSD for KDE Plasma 6

    SPDX-License-Identifier: GPL-2.0-or-later
*/

#pragma once

#include <plasmaquick/plasmawindow.h>
#include <QShowEvent>
#include <QResizeEvent>

class OsdWindow : public PlasmaQuick::PlasmaWindow
{
    Q_OBJECT
    Q_PROPERTY(int targetY READ targetY WRITE setTargetY NOTIFY targetYChanged)
    Q_PROPERTY(int bottomMargin READ bottomMargin WRITE setBottomMargin NOTIFY bottomMarginChanged)
public:
    explicit OsdWindow();

    int targetY() const { return m_targetY; }
    void setTargetY(int y);

    int bottomMargin() const { return m_bottomMargin; }
    void setBottomMargin(int margin);

    Q_INVOKABLE void updateWaylandPosition();

Q_SIGNALS:
    void targetYChanged();
    void bottomMarginChanged();

protected:
    void showEvent(QShowEvent *event) override;
    void resizeEvent(QResizeEvent *event) override;

private:
    int m_targetY = -1;
    int m_bottomMargin = 70;
    void applyPosition();
};

/*
    SPDX-FileCopyrightText: 2026 David Edmundson <davidedmundson@kde.org>
    SPDX-FileCopyrightText: 2026 Minimal Breeze OSD for KDE Plasma 6

    SPDX-License-Identifier: GPL-2.0-or-later
*/

#include "osdwindow.h"

#include <plasmaquick/plasmashellwaylandintegration.h>
#include <QScreen>
#include <QGuiApplication>
#include <QDBusInterface>
#include <QDBusReply>

OsdWindow::OsdWindow()
{
    PlasmaShellWaylandIntegration::get(this)->setRole(QtWayland::org_kde_plasma_surface::role_onscreendisplay);
    PlasmaShellWaylandIntegration::get(this)->setTakesFocus(false);

    setFlag(Qt::WindowDoesNotAcceptFocus, true);
    setFlag(Qt::WindowTransparentForInput, true);

    connect(this, &QWindow::widthChanged, this, &OsdWindow::updateWaylandPosition);
    connect(this, &QWindow::heightChanged, this, &OsdWindow::updateWaylandPosition);
    connect(this, &QWindow::screenChanged, this, &OsdWindow::updateWaylandPosition);
}

void OsdWindow::setTargetY(int y)
{
    if (m_targetY != y) {
        m_targetY = y;
        Q_EMIT targetYChanged();
        applyPosition();
    }
}

void OsdWindow::setBottomMargin(int margin)
{
    if (m_bottomMargin != margin) {
        m_bottomMargin = margin;
        Q_EMIT bottomMarginChanged();
        applyPosition();
    }
}

void OsdWindow::applyPosition()
{
    QScreen *targetScreen = nullptr;

    QDBusInterface kwinIface(QStringLiteral("org.kde.KWin"),
                             QStringLiteral("/KWin"),
                             QStringLiteral("org.kde.KWin"),
                             QDBusConnection::sessionBus());
    if (kwinIface.isValid()) {
        QDBusReply<QString> reply = kwinIface.call(QStringLiteral("activeOutputName"));
        if (reply.isValid() && !reply.value().isEmpty()) {
            const QString activeName = reply.value();
            for (QScreen *s : QGuiApplication::screens()) {
                if (s->name() == activeName) {
                    targetScreen = s;
                    break;
                }
            }
        }
    }

    if (!targetScreen) {
        targetScreen = screen();
    }
    if (!targetScreen) {
        targetScreen = QGuiApplication::primaryScreen();
    }
    if (!targetScreen) {
        return;
    }

    if (screen() != targetScreen) {
        setScreen(targetScreen);
    }

    QRect sGeom = targetScreen->geometry();
    int posX = sGeom.x() + (sGeom.width() - width()) / 2;
    int posY;
    if (m_targetY >= 0) {
        posY = sGeom.y() + m_targetY;
    } else {
        posY = sGeom.y() + sGeom.height() - height() - m_bottomMargin;
    }

    setPosition(QPoint(posX, posY));
    PlasmaShellWaylandIntegration::get(this)->setPosition(QPoint(posX, posY));
}

void OsdWindow::updateWaylandPosition()
{
    applyPosition();
}

void OsdWindow::showEvent(QShowEvent *event)
{
    PlasmaQuick::PlasmaWindow::showEvent(event);
    applyPosition();
}

void OsdWindow::resizeEvent(QResizeEvent *event)
{
    PlasmaQuick::PlasmaWindow::resizeEvent(event);
    applyPosition();
}

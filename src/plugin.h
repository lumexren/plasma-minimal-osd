/*
    SPDX-FileCopyrightText: 2026 Minimal Breeze OSD for KDE Plasma 6

    SPDX-License-Identifier: GPL-2.0-or-later
*/

#pragma once

#include <QQmlEngineExtensionPlugin>

class org_kde_plasma_workspace_osdPlugin : public QQmlEngineExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlEngineExtensionInterface")
public:
    explicit org_kde_plasma_workspace_osdPlugin(QObject *parent = nullptr);
    void initializeEngine(QQmlEngine *engine, const char *uri) override;
};

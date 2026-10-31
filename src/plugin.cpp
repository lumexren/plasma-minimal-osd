/*
    SPDX-FileCopyrightText: 2026 Minimal Breeze OSD for KDE Plasma 6

    SPDX-License-Identifier: GPL-2.0-or-later
*/

#include "plugin.h"
#include "osdwindow.h"

#include <QtQml/qqml.h>
#include <QtQml/qqmlmoduleregistration.h>

void qml_register_types_org_kde_plasma_workspace_osd()
{
    qmlRegisterType<OsdWindow>("org.kde.plasma.workspace.osd", 254, 0, "OsdWindow");
}

static const QQmlModuleRegistration registration("org.kde.plasma.workspace.osd", qml_register_types_org_kde_plasma_workspace_osd);

org_kde_plasma_workspace_osdPlugin::org_kde_plasma_workspace_osdPlugin(QObject *parent)
    : QQmlEngineExtensionPlugin(parent)
{
}

void org_kde_plasma_workspace_osdPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    QQmlEngineExtensionPlugin::initializeEngine(engine, uri);
}

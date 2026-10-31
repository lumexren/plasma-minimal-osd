/*
    SPDX-FileCopyrightText: 2026 Minimal Breeze OSD for KDE Plasma 6

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#pragma once

namespace QtWayland {
    struct org_kde_plasma_surface {
        enum role {
            role_normal = 0,
            role_desktop = 1,
            role_panel = 2,
            role_onscreendisplay = 3,
            role_notification = 4,
            role_tooltip = 5,
            role_criticalnotification = 6,
            role_appletpopup = 7,
        };
        enum panel_behavior {
            panel_behavior_always_visible = 0,
            panel_behavior_auto_hide = 1,
            panel_behavior_windows_can_cover = 2,
            panel_behavior_windows_go_below = 3,
        };
    };
}

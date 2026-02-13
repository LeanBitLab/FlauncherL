/*
 * FLauncher
 * Copyright (C) 2021  Étienne Fesser
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:flauncher/widgets/side_panel_dialog.dart';
import 'package:flauncher/widgets/settings/applications_panel_page.dart';
import 'package:flauncher/widgets/settings/launcher_sections_panel_page.dart';
import 'package:flauncher/widgets/settings/gradient_panel_page.dart';
import 'package:flauncher/widgets/settings/launcher_section_panel_page.dart';
import 'package:flauncher/widgets/settings/settings_panel_page.dart';
import 'package:flauncher/widgets/settings/status_bar_panel_page.dart';
import 'package:flauncher/widgets/settings/wallpaper_panel_page.dart';
import 'package:flauncher/widgets/settings/wifi_usage_period_page.dart';
import 'package:flauncher/widgets/settings/back_button_action_page.dart';
import 'package:flauncher/widgets/settings/date_time_format_page.dart';
import 'package:flauncher/widgets/settings/app_details_page.dart';
import 'package:flauncher/widgets/settings/accent_color_page.dart';
import 'package:flauncher/widgets/settings/brightness_settings_page.dart';
import 'package:flauncher/widgets/settings/misc_panel_page.dart';
import 'package:flauncher/widgets/settings/interface_settings_page.dart';
import 'package:flauncher/widgets/settings/general_settings_page.dart';
import 'package:flauncher/models/app.dart';
import 'package:flutter/material.dart';

class SettingsPanel extends StatefulWidget {
  final String? initialRoute;

  const SettingsPanel({Key? key, this.initialRoute}) : super(key: key);

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await _navigatorKey.currentState!.maybePop(),
      child: Scaffold(
        backgroundColor: Colors.black54, // Dim the background
        body: Stack(
          children: [
            // Tap outside to close
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(color: Colors.transparent),
            ),
            // The side panel
            SidePanelDialog(
              width: 350,
              isRightSide: false,
              child: Navigator(
                key: _navigatorKey,
                initialRoute: widget.initialRoute ?? SettingsPanelPage.routeName,
                onGenerateRoute: (settings) {
                  switch (settings.name) {
                    case SettingsPanelPage.routeName:
                      return MaterialPageRoute(builder: (_) => SettingsPanelPage());
                    case GeneralSettingsPage.routeName:
                      return MaterialPageRoute(builder: (_) => GeneralSettingsPage());
                    case InterfaceSettingsPage.routeName:
                      return MaterialPageRoute(builder: (_) => InterfaceSettingsPage());
                    case WallpaperPanelPage.routeName:
                      return MaterialPageRoute(builder: (_) => WallpaperPanelPage());
                    case StatusBarPanelPage.routeName:
                      return MaterialPageRoute(builder: (_) => StatusBarPanelPage());
                    case GradientPanelPage.routeName:
                      return MaterialPageRoute(builder: (_) => GradientPanelPage());
                    case ApplicationsPanelPage.routeName:
                      return MaterialPageRoute(builder: (_) => ApplicationsPanelPage());
                    case LauncherSectionsPanelPage.routeName:
                      return MaterialPageRoute(builder: (_) => LauncherSectionsPanelPage());
                    case LauncherSectionPanelPage.routeName:
                      return MaterialPageRoute(
                          builder: (_) => LauncherSectionPanelPage(sectionIndex: settings.arguments as int?));
                    case WifiUsagePeriodPage.routeName:
                      return MaterialPageRoute(builder: (_) => WifiUsagePeriodPage());
                    case BackButtonActionPage.routeName:
                      return MaterialPageRoute(builder: (_) => BackButtonActionPage());
                    case DateTimeFormatPage.routeName:
                      return MaterialPageRoute(builder: (_) => DateTimeFormatPage());
                    case MiscPanelPage.routeName:
                      return MaterialPageRoute(builder: (_) => MiscPanelPage());
                    case AccentColorPage.routeName:
                      return MaterialPageRoute(builder: (_) => AccentColorPage());
                    case BrightnessSettingsPage.routeName:
                      return MaterialPageRoute(builder: (_) => BrightnessSettingsPage());
                    case AppDetailsPage.routeName:
                      return MaterialPageRoute(
                          builder: (_) => AppDetailsPage(application: settings.arguments as App));
                    default:
                      throw ArgumentError.value(settings.name, "settings.name", "Route not supported.");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

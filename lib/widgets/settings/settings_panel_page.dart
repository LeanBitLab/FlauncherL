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

import 'package:flauncher/providers/apps_service.dart';
import 'package:flauncher/providers/settings_service.dart';
import 'package:flauncher/widgets/ensure_visible.dart';
import 'package:flauncher/widgets/settings/applications_panel_page.dart';
import 'package:flauncher/widgets/settings/launcher_sections_panel_page.dart';
import 'package:flauncher/widgets/settings/misc_panel_page.dart';
import 'package:flauncher/widgets/settings/flauncher_about_dialog.dart';
import 'package:flauncher/widgets/settings/status_bar_panel_page.dart';
import 'package:flauncher/widgets/settings/wallpaper_panel_page.dart';
import 'package:flauncher/widgets/settings/date_time_format_page.dart';
import 'package:flauncher/widgets/settings/back_button_action_page.dart';
import 'package:flauncher/widgets/settings/wifi_usage_period_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../rounded_switch_list_tile.dart';
import 'back_button_actions.dart';
import 'focusable_settings_tile.dart';

class SettingsPanelPage extends StatelessWidget {
  static const String routeName = "settings_panel";

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Consumer<SettingsService>(
      builder: (context, settingsService, __) => Column(
        children: [
          Text(localizations.settings, style: Theme.of(context).textTheme.titleLarge),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  EnsureVisible(
                    alignment: 0.5,
                    child: FocusableSettingsTile(
                      autofocus: true,
                      leading: const Icon(Icons.apps),
                      title: Text(localizations.applications, style: Theme.of(context).textTheme.bodyMedium),
                      onPressed: () => Navigator.of(context).pushNamed(ApplicationsPanelPage.routeName),
                    ),
                  ),
                  FocusableSettingsTile(
                    leading: const Icon(Icons.category),
                    title: Text(localizations.launcherSections, style: Theme.of(context).textTheme.bodyMedium),
                    onPressed: () => Navigator.of(context).pushNamed(LauncherSectionsPanelPage.routeName),
                  ),
                  FocusableSettingsTile(
                    leading: const Icon(Icons.wallpaper_outlined),
                    title: Text(localizations.wallpaper, style: Theme.of(context).textTheme.bodyMedium),
                    onPressed: () => Navigator.of(context).pushNamed(WallpaperPanelPage.routeName),
                  ),
                  FocusableSettingsTile(
                    leading: const Icon(Icons.tips_and_updates),
                    title: Text(localizations.statusBar, style: Theme.of(context).textTheme.bodyMedium),
                    onPressed: () => Navigator.of(context).pushNamed(StatusBarPanelPage.routeName),
                  ),
                  const Divider(),
                  FocusableSettingsTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: Text(localizations.systemSettings, style: Theme.of(context).textTheme.bodyMedium),
                    onPressed: () => context.read<AppsService>().openSettings(),
                  ),
                  FocusableSettingsTile(
                    leading: const Icon(Icons.screenshot_monitor),
                    title: Text('Screensaver Settings', style: Theme.of(context).textTheme.bodyMedium),
                    onPressed: () => _openScreensaverSettings(),
                  ),



                  FocusableSettingsTile(
                    leading: const Icon(Icons.date_range),
                    title: Text(localizations.dateAndTimeFormat, style: Theme.of(context).textTheme.bodyMedium),
                    onPressed: () => Navigator.of(context).pushNamed(DateTimeFormatPage.routeName),
                  ),
                  FocusableSettingsTile(
                    leading: const Icon(Icons.arrow_back),
                    title: Text(localizations.backButtonAction, style: Theme.of(context).textTheme.bodyMedium),
                    onPressed: () => Navigator.of(context).pushNamed(BackButtonActionPage.routeName),
                  ),
                  FocusableSettingsTile(
                    leading: const Icon(Icons.wifi),
                    title: Text('WiFi Usage Period', style: Theme.of(context).textTheme.bodyMedium),
                    onPressed: () => Navigator.of(context).pushNamed(WifiUsagePeriodPage.routeName),
                  ),
// ...
                  FocusableSettingsTile(
                    leading: const Icon(Icons.miscellaneous_services),
                    title: Text("Miscellaneous", style: Theme.of(context).textTheme.bodyMedium),
                    onPressed: () => Navigator.of(context).pushNamed(MiscPanelPage.routeName),
                  ),
                  const Divider(),
                  FocusableSettingsTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(localizations.aboutFlauncher, style: Theme.of(context).textTheme.bodyMedium),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => FutureBuilder<PackageInfo>(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, snapshot) => snapshot.connectionState == ConnectionState.done
                            ? FLauncherAboutDialog(packageInfo: snapshot.data!)
                            : Container(),
                      )
                    )
                  )
                ]
              )
            )
          )
        ]
      )
    );
  }



  Future<void> _openScreensaverSettings() async {
    // Open Android screensaver settings with native fallbacks
    const platform = MethodChannel('me.efesser.flauncher/method');
    platform.invokeMethod('openScreensaverSettings');
  }
}

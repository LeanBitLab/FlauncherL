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

import 'package:flauncher/providers/wallpaper_service.dart';
import 'package:flauncher/widgets/settings/focusable_settings_tile.dart';
import 'package:flauncher/widgets/settings/gradient_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WallpaperPanelPage extends StatelessWidget {
  static const String routeName = "wallpaper_panel";

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Column(
        children: [
          Text(localizations.wallpaper, style: Theme.of(context).textTheme.titleLarge),
          Divider(),
          FocusableSettingsTile(
            autofocus: true,
            leading: Icon(Icons.gradient),
            title: Text(localizations.gradient, style: Theme.of(context).textTheme.bodyMedium),
            onPressed: () => Navigator.of(context).pushNamed(GradientPanelPage.routeName),
          ),
          FocusableSettingsTile(
            leading: Icon(Icons.insert_drive_file_outlined),
            title: Text(localizations.picture, style: Theme.of(context).textTheme.bodyMedium),
            onPressed: () async {
              try {
                await context.read<WallpaperService>().pickWallpaper();
              } on NoFileExplorerException {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 8),
                    content: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Text(localizations.dialogTextNoFileExplorer)
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      );
  }
}

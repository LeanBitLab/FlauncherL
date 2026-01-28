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

import 'dart:async';
import 'package:flauncher/providers/apps_service.dart';
import 'package:flauncher/widgets/settings/focusable_settings_tile.dart';
import 'package:flauncher/widgets/settings/launcher_section_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/category.dart';

class LauncherSectionsPanelPage extends StatefulWidget {
  static const String routeName = "launcher_sections_panel";

  @override
  State<LauncherSectionsPanelPage> createState() => _LauncherSectionsPanelPageState();
}

class _LauncherSectionsPanelPageState extends State<LauncherSectionsPanelPage> {
  int? _movingIndex;

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(localizations.launcherSections, style: Theme.of(context).textTheme.titleLarge),
        Divider(),
        Consumer<AppsService>(
          builder: (_, service, __) {
            List<LauncherSection> sections = service.launcherSections;

            return Expanded(
              child: ReorderableListView.builder(
                buildDefaultDragHandles: false,
                padding: EdgeInsets.only(bottom: 80),
                itemCount: sections.length,
                onReorder: (int oldIndex, int newIndex) {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  context.read<AppsService>().moveSection(oldIndex, newIndex);
                },
                itemBuilder: (context, index) {
                  final section = sections[index];
                  return _section(context, section, index, sections.length);
                },
              ),
            );
          },
        ),
        SizedBox(height: 4, width: 0),
        FocusableSettingsTile(
          leading: Icon(Icons.add),
          title: Text(localizations.addSection, style: Theme.of(context).textTheme.bodyMedium),
          onPressed: () {
            Navigator.pushNamed(context, LauncherSectionPanelPage.routeName);
          },
        ),
      ],
    );
  }

  Timer? _longPressTimer;
  bool _isLongPress = false;

  void _handleSelectDown(int index) {
    if (_movingIndex != null) return; // Ignore long press logic if already moving
    if (_isLongPress) return; // Already triggered long press
    if (_longPressTimer?.isActive ?? false) return; // Already waiting (repeat), don't reset timer

    _isLongPress = false;
    _longPressTimer?.cancel();
    _longPressTimer = Timer(const Duration(milliseconds: 500), () {
      _isLongPress = true;
      setState(() {
        _movingIndex = index;
      });
      // Optional: Add haptic feedback here
    });
  }

  void _handleSelectUp(int index) {
    if (_longPressTimer?.isActive ?? false) {
      _longPressTimer?.cancel();
      // Only navigate if we didn't just trigger long press AND we weren't already moving
      if (!_isLongPress && _movingIndex == null) {
         Navigator.pushNamed(context, LauncherSectionPanelPage.routeName, arguments: index);
      }
    }
    _isLongPress = false;
  }

  Widget _section(BuildContext context, LauncherSection section, int index, int totalCount) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    String title = localizations.spacer;
    if (section is Category) {
      title = section.name;

      if (title == localizations.spacer) {
        title = localizations.disambiguateCategoryTitle(title);
      }
    }

    final bool isMoving = _movingIndex == index;

    return Padding(
      // Use ObjectKey to ensure uniqueness even if IDs collide across different types
      key: ObjectKey(section),
      padding: EdgeInsets.only(bottom: 8),
      child: Focus(
        onKeyEvent: (node, event) {
          if (isMoving) {
            if (event is KeyDownEvent) {
               if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                if (index > 0) {
                   _move(index, index - 1);
                   return KeyEventResult.handled;
                }
              } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                if (index < totalCount - 1) {
                  _move(index, index + 1);
                  return KeyEventResult.handled;
                }
              } else if (event.logicalKey == LogicalKeyboardKey.select || event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.gameButtonA || event.logicalKey == LogicalKeyboardKey.escape) {
                _endMove();
                return KeyEventResult.handled;
              }
            }
          } else {
             // Not Moving - Handle Long Press for Sort, Short Press for Settings
             if (event.logicalKey == LogicalKeyboardKey.select || event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.gameButtonA) {
               if (event is KeyDownEvent) {
                 _handleSelectDown(index);
                 return KeyEventResult.handled;
               } else if (event is KeyUpEvent) {
                 _handleSelectUp(index);
                 return KeyEventResult.handled;
               }
             }
          }
          return KeyEventResult.ignored;
        },
        child: Builder(
          builder: (context) {
            final bool focused = Focus.of(context).hasFocus;
            return Card(
              color: isMoving ? Theme.of(context).colorScheme.primaryContainer : null,
              margin: EdgeInsets.zero,
              shape: focused ? RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(12)
              ) : null,
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                title: Text(title,
                    style: isMoving
                        ? Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer)
                        : Theme.of(context).textTheme.bodyMedium),
                trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       if (isMoving) ...[
                         Icon(Icons.keyboard_arrow_up, color: Theme.of(context).colorScheme.onPrimaryContainer),
                         Icon(Icons.keyboard_arrow_down, color: Theme.of(context).colorScheme.onPrimaryContainer),
                         SizedBox(width: 8),
                       ],
                       // Setting icon removed as requested
                    ]
                ),
                leading: ReorderableDragStartListener(
                  index: index,
                  child: Icon(Icons.drag_handle, color: isMoving ? Theme.of(context).colorScheme.onPrimaryContainer : null),
                ),
                onTap: () {
                   if (isMoving) {
                      _endMove();
                   } else {
                      Navigator.pushNamed(context, LauncherSectionPanelPage.routeName, arguments: index);
                   }
                },
                onLongPress: () {
                   if (!isMoving) {
                      setState(() {
                        _movingIndex = index;
                      });
                   }
                },
              ),
            );
          }
        ),
      ),
    );
  }

  void _move(int oldIndex, int newIndex) {
    context.read<AppsService>().moveSectionInMemory(oldIndex, newIndex);
    setState(() {
      _movingIndex = newIndex;
    });
  }

  void _endMove() {
    context.read<AppsService>().persistSectionsOrder();
    setState(() {
      _movingIndex = null;
    });
  }
}

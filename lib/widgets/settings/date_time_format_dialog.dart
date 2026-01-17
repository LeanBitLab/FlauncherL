/*
 * FLauncher
 * Copyright (C) 2021  Oscar Rojas
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Date format presets
const List<(String format, String example)> dateFormatPresets = [
  ('EEEE d', 'Friday 17'),
  ('E d', 'Fri 17'),
  ('dd/MM/y', '17/01/2026'),
  ('MMM d, y', 'Jan 17, 2026'),
  ('d MMMM', '17 January'),
  ('M/d/y', '1/17/2026'),
];

// Time format presets (using 3:45 PM / 15:45 for clear 12h/24h distinction)
const List<(String format, String example)> timeFormatPresets = [
  ('H:mm', '15:45'),
  ('HH:mm', '15:45'),
  ('hh:mm', '03:45'),
  ('h:mm a', '3:45 PM'),
  ('hh:mm a', '03:45 PM'),
  ('H:mm:ss', '15:45:30'),
];

class DateTimeFormatDialog extends StatefulWidget {
  final String _initialDateFormat;
  final String _initialTimeFormat;

  const DateTimeFormatDialog(String initialDateFormat, String initialTimeFormat, {super.key}) :
        _initialDateFormat = initialDateFormat,
        _initialTimeFormat = initialTimeFormat;

  @override
  State<DateTimeFormatDialog> createState() => _DateTimeFormatDialogState();
}

class _DateTimeFormatDialogState extends State<DateTimeFormatDialog> {
  late String _selectedDateFormat;
  late String _selectedTimeFormat;

  @override
  void initState() {
    super.initState();
    _selectedDateFormat = widget._initialDateFormat;
    _selectedTimeFormat = widget._initialTimeFormat;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return SimpleDialog(
      insetPadding: const EdgeInsets.only(bottom: 60),
      contentPadding: const EdgeInsets.all(24),
      title: Text(localizations.dateAndTimeFormat),
      children: [
        // Live preview
        _buildPreview(),
        
        const SizedBox(height: 24),
        const Divider(),
        
        // Date format section
        Text(
          localizations.date,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        
        ...dateFormatPresets.asMap().entries.map((entry) => RadioListTile<String>(
          autofocus: entry.key == 0,  // Autofocus first item
          dense: true,
          title: Text(entry.value.$2),  // Example display
          subtitle: Text(entry.value.$1, style: TextStyle(fontSize: 12, color: Colors.grey)),
          value: entry.value.$1,
          groupValue: _selectedDateFormat,
          onChanged: (value) {
            setState(() => _selectedDateFormat = value!);
          },
        )),
        
        const SizedBox(height: 16),
        const Divider(),
        
        // Time format section
        Text(
          localizations.time,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        
        ...timeFormatPresets.map((preset) => RadioListTile<String>(
          dense: true,
          title: Text(preset.$2),
          subtitle: Text(preset.$1, style: TextStyle(fontSize: 12, color: Colors.grey)),
          value: preset.$1,
          groupValue: _selectedTimeFormat,
          onChanged: (value) {
            setState(() => _selectedTimeFormat = value!);
          },
        )),
        
        const SizedBox(height: 24),
        
        // OK button
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.pop(context, (_selectedDateFormat, _selectedTimeFormat));
            },
            child: const Text('OK'),
          ),
        ),
      ],
    );
  }

  Widget _buildPreview() {
    final now = DateTime.now();
    String preview = '';

    try {
      if (_selectedDateFormat.isNotEmpty) {
        preview = DateFormat(_selectedDateFormat, Platform.localeName).format(now);
      }
      if (_selectedTimeFormat.isNotEmpty) {
        if (preview.isNotEmpty) preview += ' — ';
        preview += DateFormat(_selectedTimeFormat, Platform.localeName).format(now);
      }
    } catch (e) {
      preview = 'Invalid format';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        preview.isEmpty ? 'Select formats below' : preview,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

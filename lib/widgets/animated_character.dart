/*
 * FLauncher
 * Copyright (C) 2024 LeanBitLab
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

import 'package:flutter/material.dart';

/// A widget that displays a single character with smooth fade/slide animation
/// when the character changes.
class AnimatedCharacter extends StatelessWidget {
  final String character;
  final TextStyle? textStyle;
  final Duration duration;

  const AnimatedCharacter({
    super.key,
    required this.character,
    this.textStyle,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (Widget child, Animation<double> animation) {
        // Determine if this is the incoming or outgoing widget
        final isNewChild = child.key == ValueKey(character);
        
        // Slide animation: old slides up, new slides in from below
        final slideOffset = isNewChild
            ? Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
            : Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.5));
        
        return SlideTransition(
          position: slideOffset.animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: Alignment.center,
          children: [
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      child: Text(
        character,
        key: ValueKey(character),
        style: textStyle,
      ),
    );
  }
}

/// A row of animated characters for displaying time/date with smooth transitions
class AnimatedTimeDisplay extends StatelessWidget {
  final String displayText;
  final TextStyle? textStyle;

  const AnimatedTimeDisplay({
    super.key,
    required this.displayText,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: displayText.split('').map((char) {
        return AnimatedCharacter(
          character: char,
          textStyle: textStyle,
        );
      }).toList(),
    );
  }
}

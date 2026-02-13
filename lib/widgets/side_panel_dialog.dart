import 'package:flauncher/actions.dart';
import 'package:flutter/material.dart';

class SidePanelDialog extends StatelessWidget {
  final Widget child;
  final double width;
  final bool isRightSide;

  const SidePanelDialog({
    required this.child,
    this.width = 250,
    this.isRightSide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isRightSide ? Alignment.centerRight : Alignment.centerLeft,
      child: Material(
        color: const Color(0xFF1E1E1E),
        elevation: 24,
        borderRadius: BorderRadius.horizontal(
          right: isRightSide ? Radius.zero : const Radius.circular(28),
          left: isRightSide ? const Radius.circular(28) : Radius.zero,
        ),
        child: Container(
          width: width,
          padding: const EdgeInsets.all(16),
          child: Actions(
            actions: { BackIntent: BackAction(context) },
            child: child,
          ),
        ),
      ),
    );
  }
}

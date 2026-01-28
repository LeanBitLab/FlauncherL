
import 'package:flauncher/actions.dart';
import 'package:flutter/material.dart';

class SidePanelDialog extends StatelessWidget {
  final Widget child;
  final double width;
  final bool isRightSide;

  const SidePanelDialog({
    required this.child,
    this.width = 250,
    this.isRightSide = false, // Default to Left side as requested now
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.of(context).size.width - width;
    
    return Dialog(
      backgroundColor: Theme.of(context).primaryColor,
      insetPadding: isRightSide 
          ? EdgeInsets.only(left: horizontalPadding, right: 16) // Add small padding on the attached side
          : EdgeInsets.only(right: horizontalPadding, left: 16), // Add small padding on the attached side
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: Align(
        alignment: isRightSide ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: width, // Explicit width for the container
          padding: EdgeInsets.all(16),
          child: Actions(actions: { BackIntent: BackAction(context) }, child: child),
        ),
      ),
    );
  }
}

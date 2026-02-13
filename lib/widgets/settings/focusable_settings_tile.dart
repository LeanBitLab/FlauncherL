import 'package:flutter/material.dart';

class FocusableSettingsTile extends StatefulWidget {
  final Widget title;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onPressed;
  final bool autofocus;

  const FocusableSettingsTile({
    Key? key,
    required this.title,
    this.leading,
    this.trailing,
    this.onPressed,
    this.autofocus = false,
  }) : super(key: key);

  @override
  State<FocusableSettingsTile> createState() => _FocusableSettingsTileState();
}

class _FocusableSettingsTileState extends State<FocusableSettingsTile> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Actions(
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) => widget.onPressed?.call()),
          ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(onInvoke: (_) => widget.onPressed?.call()),
        },
        child: Focus(
          autofocus: widget.autofocus,
          onFocusChange: (hasFocus) => setState(() => _focused = hasFocus),
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 50),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _focused ? Colors.white.withOpacity(0.05) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: _focused
                    ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
                    : Border.all(color: Colors.transparent, width: 2),
                boxShadow: _focused
                    ? const [BoxShadow(color: Colors.black54, blurRadius: 8, spreadRadius: 1)]
                    : null,
              ),
              child: Row(
                children: [
                  if (widget.leading != null) ...[
                    widget.leading!,
                    const SizedBox(width: 16),
                  ],
                  Expanded(child: widget.title),
                  if (widget.trailing != null) ...[
                    const SizedBox(width: 16),
                    widget.trailing!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

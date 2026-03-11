import 'package:flutter/material.dart';

class TrackedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;
  final bool isFullWidth;
  final bool isOutlined;
  final double verticalPadding;

  const TrackedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
    this.isFullWidth = true,
    this.isOutlined = false,
    this.verticalPadding = 16,
  });

  @override
  Widget build(BuildContext context) {
    final style = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor:
                foregroundColor ?? Theme.of(context).primaryColor,
            side: BorderSide(
              color: foregroundColor ?? Theme.of(context).primaryColor,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: verticalPadding,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor:
                backgroundColor ?? Theme.of(context).primaryColor,
            foregroundColor: foregroundColor ?? Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: verticalPadding,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          );

    Widget button = isOutlined
        ? OutlinedButton.icon(
            style: style as OutlinedButton? == null ? style : style,
            icon: Icon(icon ?? Icons.touch_app, size: 20),
            label: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: onPressed,
          )
        : ElevatedButton.icon(
            style: style,
            icon: Icon(icon ?? Icons.touch_app, size: 20),
            label: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: onPressed,
          );

    return isFullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}

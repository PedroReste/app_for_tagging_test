import 'package:flutter/material.dart';
import '../analytics/analytics_service.dart';

class TrackedButton extends StatelessWidget {
  final String label;
  final String eventName;
  final String screen;
  final Map<String, Object>? parameters;
  final VoidCallback onPressed;
  final Color? color;
  final IconData? icon;
  final bool isLoading;

  const TrackedButton({
    super.key,
    required this.label,
    required this.eventName,
    required this.screen,
    required this.onPressed,
    this.parameters,
    this.color,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[400],
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(icon ?? Icons.touch_app),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: isLoading
            ? null
            : () async {
                // 🏷️ Dispara o evento no Firebase Analytics
                await AnalyticsService().trackEvent(
                  eventName: eventName,
                  screen: screen,
                  parameters: parameters,
                );
                onPressed();
              },
      ),
    );
  }
}

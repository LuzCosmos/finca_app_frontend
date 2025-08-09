import 'package:flutter/material.dart';

class MessageBanner extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;

  /// main constructor
  /// @param message
  /// @param icon
  /// @param backgroundColor
  /// @param textColor
  ///
  const MessageBanner({
    super.key,
    required this.message,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
  });

  /// error constructor
  /// @param message
  factory MessageBanner.error(String message) {
    return MessageBanner(
      message: message,
      icon: Icons.error,
      backgroundColor: Colors.red.shade50,
      textColor: Colors.red.shade700,
    );
  }

  /// success constructor
  /// @param message
  factory MessageBanner.success(String message) {
    return MessageBanner(
      message: message,
      icon: Icons.check_circle,
      backgroundColor: Colors.green.shade50,
      textColor: Colors.green.shade700,
    );
  }

  /// warning constructor
  /// @param message
  factory MessageBanner.warning(String message) {
    return MessageBanner(
      message: message,
      icon: Icons.warning,
      backgroundColor: Colors.yellow.shade100,
      textColor: Colors.orange.shade800,
    );
  }

  /// info constructor
  /// @param message
  factory MessageBanner.info(String message) {
    return MessageBanner(
      message: message,
      icon: Icons.info,
      backgroundColor: Colors.blue.shade50,
      textColor: Colors.blue.shade700,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 5, left: 1, right: 0),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: textColor.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

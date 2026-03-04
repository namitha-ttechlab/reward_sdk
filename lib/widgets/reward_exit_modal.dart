import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RewardExitModal extends StatelessWidget {
  final String title;
  final String subtitle;
  final String stayButtonText;
  final String leaveButtonText;
  final IconData icon;
  final Color primaryColor;
  final Color iconColor;

  const RewardExitModal({
    super.key,
    required this.title,
    required this.subtitle,
    this.stayButtonText = "Stay & Save",
    this.leaveButtonText = "Still Leave",
    this.icon = Icons.shopping_cart_outlined,
    this.primaryColor = Colors.deepPurple,
    this.iconColor = Colors.orange,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String subtitle,
    String stayButtonText = "Stay & Save",
    String leaveButtonText = "Still Leave",
    IconData icon = Icons.shopping_cart_outlined,
    Color primaryColor = Colors.deepPurple,
    Color iconColor = Colors.orange,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => RewardExitModal(
        title: title,
        subtitle: subtitle,
        stayButtonText: stayButtonText,
        leaveButtonText: leaveButtonText,
        icon: icon,
        primaryColor: primaryColor,
        iconColor: iconColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        title,
        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: primaryColor),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 60, color: iconColor),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(leaveButtonText, style: const TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(stayButtonText),
        ),
      ],
    );
  }
}

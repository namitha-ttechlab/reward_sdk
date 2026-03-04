import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RewardBottomSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const RewardBottomSheet({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.check_circle,
    this.iconColor = Colors.green,
    this.backgroundColor = Colors.white,
  });

  static void show(
    BuildContext context, {
    required String title,
    required String subtitle,
    IconData icon = Icons.check_circle,
    Color iconColor = Colors.green,
    Color backgroundColor = Colors.white,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RewardBottomSheet(
        title: title,
        subtitle: subtitle,
        icon: icon,
        iconColor: iconColor,
        backgroundColor: backgroundColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 80),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

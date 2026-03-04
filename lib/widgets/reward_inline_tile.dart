import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RewardInlineTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String couponCode;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final VoidCallback? onTap;

  const RewardInlineTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.couponCode,
    this.icon = Icons.confirmation_number,
    this.primaryColor = Colors.deepPurple,
    this.secondaryColor = Colors.amber,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: secondaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: secondaryColor.withOpacity(0.3), width: 2),
          ),
          child: Row(
            children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
              ],
            ),
          ),
          Text(
            couponCode,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: primaryColor,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

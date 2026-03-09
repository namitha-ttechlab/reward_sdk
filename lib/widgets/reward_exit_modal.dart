import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'reward_scratch_card.dart';

class RewardExitModal extends StatelessWidget {
  final String title;
  final String subtitle;
  final String stayButtonText;
  final String leaveButtonText;
  final IconData icon;
  final Color primaryColor;
  final Color iconColor;

  // Scratch card parameters
  final Widget? rewardChild;
  final String? scratchTitle;
  final Color? scratchOverlayColor;
  final double? scratchAspectRatio;

  const RewardExitModal({
    super.key,
    required this.title,
    required this.subtitle,
    this.stayButtonText = "Claim Reward",
    this.leaveButtonText = "Still Leave",
    this.icon = Icons.card_giftcard,
    this.primaryColor = Colors.deepPurple,
    this.iconColor = Colors.amber,
    this.rewardChild,
    this.scratchTitle,
    this.scratchOverlayColor,
    this.scratchAspectRatio,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String subtitle,
    String stayButtonText = "Claim Reward",
    String leaveButtonText = "Still Leave",
    IconData icon = Icons.card_giftcard,
    Color primaryColor = Colors.deepPurple,
    Color iconColor = Colors.amber,
    Widget? rewardChild,
    String? scratchTitle,
    Color? scratchOverlayColor,
    double? scratchAspectRatio,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => RewardExitModal(
        title: title,
        subtitle: subtitle,
        stayButtonText: stayButtonText,
        leaveButtonText: leaveButtonText,
        icon: icon,
        primaryColor: primaryColor,
        iconColor: iconColor,
        rewardChild: rewardChild,
        scratchTitle: scratchTitle,
        scratchOverlayColor: scratchOverlayColor,
        scratchAspectRatio: scratchAspectRatio,
      ),
    );
  }

  void _showScratchBottomSheet(BuildContext context) {
    Navigator.of(context).pop(true); // close the dialog first
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.48,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              scratchTitle ?? 'Your Reward',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: RewardScratchCard(
                overlayColor: scratchOverlayColor ?? const Color(0xFFBDBDBD),
                aspectRatio: scratchAspectRatio ?? 1.0,
                title: scratchTitle ?? 'Scratch to Reveal',
                child: rewardChild ?? const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with glowing background
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: iconColor),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            // Claim Button (primary action)
            if (rewardChild != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showScratchBottomSheet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    stayButtonText,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            // Leave button (secondary)
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                leaveButtonText,
                style: TextStyle(color: Colors.grey[500], fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'reward_scratch_card.dart';

class RewardInlineTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String couponCode;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final VoidCallback? onTap;
  final Widget? rewardChild;
  final String? scratchTitle;
  final Color? scratchOverlayColor;
  final Size? scratchSize;
  final Color? scratchBarrierColor;
  final VoidCallback? onRevealed;

  const RewardInlineTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.couponCode,
    this.icon = Icons.confirmation_number,
    this.primaryColor = Colors.deepPurple,
    this.secondaryColor = Colors.amber,
    this.onTap,
    this.rewardChild,
    this.scratchTitle,
    this.scratchOverlayColor,
    this.scratchSize,
    this.scratchBarrierColor,
    this.onRevealed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: InkWell(
        onTap: () {
          if (rewardChild != null) {
            RewardScratchCard.showOverlay(
              context,
              child: rewardChild!,
              size: scratchSize ?? const Size(300, 200),
              title: scratchTitle ?? 'Scratch to Reveal',
              overlayColor: scratchOverlayColor ?? const Color(0xFFBDBDBD),
              barrierColor: scratchBarrierColor ?? const Color(0x99000000),
              onRevealed: onRevealed ?? () {},
            );
          }
          if (onTap != null) {
            onTap!();
          }
        },
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
        ),
      ),
    );
  }
}

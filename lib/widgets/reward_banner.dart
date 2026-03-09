import 'package:flutter/material.dart';
import 'reward_scratch_card.dart';

class RewardBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final VoidCallback? onTap;
  final Widget? rewardChild;
  final String? scratchTitle;
  final Color? scratchOverlayColor;
  final Size? scratchSize;
  final double? scratchAspectRatio;
  final Color? scratchBarrierColor;

  const RewardBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onButtonPressed,
    this.icon = Icons.celebration,
    this.primaryColor = Colors.deepPurple,
    this.secondaryColor = Colors.amber,
    this.onTap,
    this.rewardChild,
    this.scratchTitle,
    this.scratchOverlayColor,
    this.scratchSize,
    this.scratchAspectRatio,
    this.scratchBarrierColor,
  });

  void _handleTap(BuildContext context) {
    if (rewardChild != null) {
      RewardScratchCard.showOverlay(
        context,
        child: rewardChild!,
        size: scratchSize ?? const Size(300, 300),
        title: scratchTitle ?? 'Scratch to Reveal',
        overlayColor: scratchOverlayColor ?? const Color(0xFFBDBDBD),
        aspectRatio: scratchAspectRatio ?? 0.8,
        barrierColor: scratchBarrierColor ?? const Color(0x99000000),
      );
    }
    if (onTap != null) {
      onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleTap(context),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    onButtonPressed();
                    _handleTap(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

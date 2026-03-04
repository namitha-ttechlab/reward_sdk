import 'package:flutter/material.dart';

class RewardStickyBadge extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final double radius;
  final double bottom;
  final double right;
  final VoidCallback onTap;

  const RewardStickyBadge({
    super.key,
    required this.onTap,
    this.icon = Icons.star,
    this.iconColor = Colors.white,
    this.backgroundColor = Colors.deepPurple,
    this.radius = 28,
    this.bottom = 20,
    this.right = 20,
  });


  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      right: right,
      child: GestureDetector(

        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: radius,
            backgroundColor: backgroundColor,
            child: Icon(icon, color: iconColor, size: radius * 1.07),
          ),
        ),
      ),
    );
  }
}

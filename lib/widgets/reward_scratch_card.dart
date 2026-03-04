import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class RewardScratchCard extends StatefulWidget {
  final Widget child;
  final Color overlayColor;
  final String title;
  final IconData icon;
  final VoidCallback onRevealed;
  final double threshold;

  const RewardScratchCard({
    super.key,
    required this.child,
    this.overlayColor = const Color(0xFFBDBDBD),
    this.title = 'Scratch to Reveal',
    this.icon = Icons.stars_rounded,
    required this.onRevealed,
    this.threshold = 0.5,
  });

  static void show(
    BuildContext context, {
    required Widget child,
    Color overlayColor = const Color(0xFFBDBDBD),
    String title = 'Scratch to Reveal',
    IconData icon = Icons.stars_rounded,
    required VoidCallback onRevealed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                ),
              ],
            ),
            const SizedBox(height: 12),
            RewardScratchCard(
              overlayColor: overlayColor,
              title: title,
              icon: icon,
              onRevealed: onRevealed,
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  static void showBottomSheet(
    BuildContext context, {
    required Widget child,
    Color overlayColor = const Color(0xFFBDBDBD),
    String title = 'Scratch to Reveal',
    IconData icon = Icons.stars_rounded,
    required VoidCallback onRevealed,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: RewardScratchCard(
                overlayColor: overlayColor,
                title: title,
                icon: icon,
                onRevealed: onRevealed,
                child: child,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static void showOverlay(
    BuildContext context, {
    required Widget child,
    Size size = const Size(300, 300),
    Color overlayColor = const Color(0xFFBDBDBD),
    Color barrierColor = const Color(0x99000000),
    String title = 'Scratch to Reveal',
    IconData icon = Icons.stars_rounded,
    required VoidCallback onRevealed,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => entry.remove(),
              child: Container(
                color: barrierColor,
              ),
            ),
            Center(
              child: SizedBox(
                width: size.width,
                height: size.height + 60,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () => entry.remove(),
                        icon: const Icon(Icons.close, color: Colors.white, size: 28),
                      ),
                    ),
                    Expanded(
                      child: RewardScratchCard(
                        overlayColor: overlayColor,
                        title: title,
                        icon: icon,
                        onRevealed: onRevealed,
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    overlay.insert(entry);
  }

  @override
  State<RewardScratchCard> createState() => _RewardScratchCardState();
}

class _RewardScratchCardState extends State<RewardScratchCard> with SingleTickerProviderStateMixin {
  final List<Offset?> _points = [];
  bool _isRevealed = false;
  late AnimationController _controller;
  late Animation<double> _revealAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _revealAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkReveal() {
    if (_isRevealed) return;

    // Estimation logic: if points cover enough area, reveal.
    // In a production app, we might use image bit manipulation, 
    // but for UI performance, we can estimate based on point count or grid coverage.
    if (_points.whereType<Offset>().length > 150) { 
      _reveal();
    }
  }

  void _reveal() {
    if (!_isRevealed) {
      setState(() {
        _isRevealed = true;
      });
      _controller.forward();
      widget.onRevealed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
            // Bottom Layer: The Reward
            Center(
              child: AnimatedBuilder(
                animation: _revealAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isRevealed ? 0.8 + (0.2 * _revealAnimation.value) : 0.8,
                    child: Opacity(
                      opacity: (_isRevealed ? 0.5 + (0.5 * _revealAnimation.value) : 1.0).clamp(0.0, 1.0),
                      child: widget.child,
                    ),
                  );
                },
              ),
            ),

            // Top Layer: Scratchable Surface
            if (!_isRevealed)
              GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    _points.add(details.localPosition);
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    _points.add(details.localPosition);
                    _checkReveal();
                  });
                },
                onPanEnd: (_) {
                  setState(() {
                    _points.add(null);
                  });
                },
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(seconds: 2),
                  builder: (context, value, child) {
                    return CustomPaint(
                      painter: _ScratchPainter(
                        points: _points,
                        overlayColor: widget.overlayColor,
                        title: widget.title,
                        icon: widget.icon,
                        pulseValue: value,
                      ),
                      size: Size.infinite,
                    );
                  },
                  onEnd: () {}, // Handled by looping tween if needed, but builder is fine for continuous
                ),
              ),
            
            // Success Overlay Animation
            if (_isRevealed)
              IgnorePointer(
                child: AnimatedBuilder(
                  animation: _revealAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: (1.0 - _revealAnimation.value).clamp(0.0, 1.0),
                      child: Container(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    ),
   );
  }
}

class _ScratchPainter extends CustomPainter {
  final List<Offset?> points;
  final Color overlayColor;
  final String title;
  final IconData icon;
  final double pulseValue;

  _ScratchPainter({
    required this.points,
    required this.overlayColor,
    required this.title,
    required this.icon,
    this.pulseValue = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw the Overlay Layer
    final paint = Paint()
      ..color = overlayColor
      ..isAntiAlias = true;

    // Premium Holographic/Metallic Effect with Shine
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final shineOffset = (pulseValue * 2 - 1) * size.width;
    final gradient = LinearGradient(
      colors: [
        overlayColor,
        overlayColor.withAlpha(220),
        Colors.white.withOpacity(0.3),
        overlayColor.withAlpha(220),
        overlayColor,
      ],
      stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
      begin: Alignment(pulseValue * 4 - 2, -1),
      end: Alignment(pulseValue * 4, 1),
    ).createShader(rect);

    canvas.saveLayer(rect, Paint());
    
    // Draw background
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(24)),
      Paint()..shader = gradient,
    );

    // Draw pattern (subtle lines for texture)
    final patternPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1.0;
    for (double i = 0; i < size.width + size.height; i += 10) {
      canvas.drawLine(Offset(i, 0), Offset(i - size.height, size.height), patternPaint);
    }

    // Draw Text & Icon with Pulse
    final pulseScale = 1.0 + (0.05 * math.sin(pulseValue * math.pi)); // Subtle pulse
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: title,
        style: TextStyle(
          color: Colors.black.withOpacity(0.4 + (0.2 * pulseValue)),
          fontWeight: FontWeight.w700,
          fontSize: 16,
          letterSpacing: 1.2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: size.width);

    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: 48,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: Colors.black.withOpacity(0.4),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    iconPainter.paint(
      canvas,
      Offset(
        size.width / 2 - iconPainter.width / 2,
        size.height / 2 - iconPainter.height / 2 - 20,
      ),
    );

    textPainter.paint(
      canvas,
      Offset(
        size.width / 2 - textPainter.width / 2,
        size.height / 2 + 30,
      ),
    );

    // 2. Erase the Scratch Paths
    final erasePaint = Paint()
      ..blendMode = BlendMode.clear
      ..strokeWidth = 40.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, erasePaint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ScratchPainter oldDelegate) => true;
}

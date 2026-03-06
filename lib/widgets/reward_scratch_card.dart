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
  final double aspectRatio;

  const RewardScratchCard({
    super.key,
    required this.child,
    this.overlayColor = const Color(0xFFBDBDBD),
    this.title = 'Scratch here to reveal',
    this.icon = Icons.stars_rounded,
    required this.onRevealed,
    this.threshold = 0.5,
    this.aspectRatio = 1.0,
  });

  static void show(
    BuildContext context, {
    required Widget child,
    Color overlayColor = const Color(0xFFBDBDBD),
    String title = 'Scratch to Reveal',
    IconData icon = Icons.stars_rounded,
    required VoidCallback onRevealed,
    double aspectRatio = 1.0,
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
              aspectRatio: aspectRatio,
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
    double aspectRatio = 1.0,
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
                aspectRatio: aspectRatio,
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
    double aspectRatio = 0.8,
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
                        aspectRatio: aspectRatio,
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
      aspectRatio: widget.aspectRatio,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
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
                        color: Colors.white.withValues(alpha: 0.8),
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
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.saveLayer(rect, Paint());
    
    // Draw background color and premium gradient
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(24));
    
    final gradient = LinearGradient(
      colors: [
        overlayColor,
        overlayColor.withAlpha(200),
        Colors.white.withValues(alpha: 0.15),
        overlayColor.withAlpha(200),
        overlayColor,
      ],
      stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
      begin: Alignment(pulseValue * 4 - 2, -1),
      end: Alignment(pulseValue * 4, 1),
    ).createShader(rect);
    
    canvas.drawRRect(rrect, Paint()..shader = gradient);

    final cellSize = 40.0;
    final strokeWidth = 12.0;
    final patternPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.clipRRect(rrect);
    
    for (double x = -cellSize; x < size.width + cellSize; x += cellSize) {
      for (double y = -cellSize; y < size.height + cellSize; y += cellSize) {
        // Deterministic flip based on grid position for a consistent but "random" look
        final isFlip = (((x + cellSize) / cellSize).floor() + ((y + cellSize) / cellSize).floor()) % 2 == 0;
        
        if (isFlip) {
          canvas.drawArc(Rect.fromCircle(center: Offset(x, y), radius: cellSize / 2), 0, math.pi / 2, false, patternPaint);
          canvas.drawArc(Rect.fromCircle(center: Offset(x + cellSize, y + cellSize), radius: cellSize / 2), math.pi, math.pi / 2, false, patternPaint);
        } else {
          canvas.drawArc(Rect.fromCircle(center: Offset(x + cellSize, y), radius: cellSize / 2), math.pi / 2, math.pi / 2, false, patternPaint);
          canvas.drawArc(Rect.fromCircle(center: Offset(x, y + cellSize), radius: cellSize / 2), -math.pi / 2, math.pi / 2, false, patternPaint);
        }
      }
    }

    // Draw Content centered together as a block
    final contentOpacity = (0.9 + (0.1 * math.sin(pulseValue * math.pi))).clamp(0.0, 1.0);
    
    // Draw white circle background for the icon
    final circleRadius = 45.0;
    final iconSize = 48.0;
    const spacing = 20.0;
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: title.toUpperCase(),
        style: TextStyle(
          color: Colors.white.withValues(alpha: contentOpacity),
          fontWeight: FontWeight.w800,
          fontSize: 18,
          letterSpacing: 1.5,
          shadows: [
            Shadow(color: Colors.black.withValues(alpha: 0.1), offset: const Offset(0, 2), blurRadius: 4),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: size.width - 40);

    final totalContentHeight = (circleRadius * 2) + spacing + textPainter.height;
    final centerY = size.height / 2;
    final topOffset = (size.height - totalContentHeight) / 2;

    // Center of the white circle
    final circleCenter = Offset(size.width / 2, topOffset + circleRadius);
    
    final circlePaint = Paint()
        ..color = Colors.white.withValues(alpha: contentOpacity)
        ..style = PaintingStyle.fill;

    final shadowPath = Path()
      ..addOval(Rect.fromCircle(center: circleCenter, radius: circleRadius));
    
    canvas.drawShadow(shadowPath, Colors.black.withOpacity(0.1), 4.0, false);
    canvas.drawCircle(circleCenter, circleRadius, circlePaint);

    // Draw Icon inside the white circle
    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: iconSize,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: overlayColor.withValues(alpha: 0.9), // Icon matches background color
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    iconPainter.paint(
      canvas,
      Offset(
        circleCenter.dx - iconPainter.width / 2,
        circleCenter.dy - iconPainter.height / 2,
      ),
    );

    textPainter.paint(
      canvas,
      Offset(
        size.width / 2 - textPainter.width / 2,
        circleCenter.dy + circleRadius + spacing,
      ),
    );

    // 2. Erase the Scratch Paths
    final erasePaint = Paint()
      ..blendMode = BlendMode.clear
      ..strokeWidth = 45.0
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

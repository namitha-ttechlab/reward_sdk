import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'reward_confetti_cannon.dart';

class RewardScratchCard extends StatefulWidget {
  final Widget child;
  final Color overlayColor;
  final String title;
  final IconData icon;
  final double threshold;
  final double? width;
  final double? height;
  final double aspectRatio;

  const RewardScratchCard({
    super.key,
    required this.child,
    this.overlayColor = const Color(0xFF1A237E), // Deep dark blue
    this.title = 'Scratch here to reveal',
    this.icon = Icons.redeem_outlined, // Gift icon outline
    this.threshold = 0.5,
    this.aspectRatio = 1.0,
    this.width,
    this.height,
  });

  static void show(
    BuildContext context, {
    required Widget child,
    Color overlayColor = const Color(0xFF1A237E),
    String title = 'Scratch here to reveal',
    IconData icon = Icons.redeem_outlined,
    double aspectRatio = 1.0,
    double? width,
    double? height,
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
              aspectRatio: aspectRatio,
              width: width,
              height: height,
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
    Color overlayColor = const Color(0xFF1A237E),
    String title = 'Scratch here to reveal',
    IconData icon = Icons.redeem_outlined,
    double aspectRatio = 1.0,
    double? width,
    double? height,
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
                aspectRatio: aspectRatio,
                width: width,
                height: height,
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
    Color overlayColor = const Color(0xFF1A237E),
    Color barrierColor = const Color(0x99000000),
    String title = 'Scratch here to reveal',
    IconData icon = Icons.redeem_outlined,
    double aspectRatio = 0.8,
    double? width,
    double? height,
  }) {
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
                width: width ?? size.width,
                height: (height ?? size.height) + 60,
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
                        aspectRatio: aspectRatio,
                        width: width ?? size.width,
                        height: height ?? size.height,
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

    Overlay.of(context).insert(entry);
  }

  @override
  State<RewardScratchCard> createState() => _RewardScratchCardState();
}

class _RewardScratchCardState extends State<RewardScratchCard> with SingleTickerProviderStateMixin {
  final List<Offset?> _points = [];
  bool _isRevealed = false;
  late AnimationController _controller;
  late Animation<double> _revealAnimation;
  final GlobalKey<RewardConfettiCannonState> _confettiKey = GlobalKey<RewardConfettiCannonState>();

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
      _confettiKey.currentState?.trigger();
    }
  }
  @override
  Widget build(BuildContext context) {
    Widget content = RewardConfettiCannon(
      key: _confettiKey,
      colors: [widget.overlayColor, Colors.white],
      child: Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
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
    ));

    if (widget.width != null || widget.height != null) {
      return content;
    }

    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: content,
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
    
    // Create solid dark blue gradient
    final gradient = LinearGradient(
      colors: [
        overlayColor,
        Color.lerp(overlayColor, Colors.black, 0.2)!, // Solid darkened variant
        Color.lerp(overlayColor, Colors.black, 0.1)!, // Solid slightly darker
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(rect);
    
    canvas.drawRRect(rrect, Paint()..shader = gradient);

    // Draw subtle abstract swirl/wave pattern
    final wavePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    
    // Create multiple long, undulating swirly paths
    for (int i = 0; i < 5; i++) {
      final startY = (size.height / 4) * i;
      path.moveTo(-50, startY);
      
      for (double x = 0; x < size.width + 100; x += 40) {
        final dy = 30 * math.sin((x / 50) + i);
        final cx = x + 20;
        final cy = startY + dy + (20 * math.cos(x / 30));
        path.quadraticBezierTo(cx, cy, x + 40, startY + (20 * math.sin((x + 40) / 40)));
      }
    }
    
    // Add some "swirls"
    for (int i = 0; i < 4; i++) {
        final centerX = (size.width / 3) * i;
        final centerY = (size.height / 3) * (i % 2 == 0 ? 1 : 2);
        
        for (double r = 10; r < 80; r += 20) {
            canvas.drawArc(
                Rect.fromCircle(center: Offset(centerX, centerY), radius: r),
                i * math.pi / 2,
                math.pi,
                false,
                wavePaint
            );
        }
    }

    canvas.drawPath(path, wavePaint);

    // Draw Content centered together as a block
    final contentOpacity = (0.9 + (0.1 * math.sin(pulseValue * math.pi))).clamp(0.0, 1.0);
    
    // Gift icon metrics
    final iconRadius = 45.0;
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

    final totalContentHeight = (iconRadius * 2) + spacing + textPainter.height;
    final topOffset = (size.height - totalContentHeight) / 2;

    // Center of the icon
    final iconCenter = Offset(size.width / 2, topOffset + iconRadius);
    
    // We draw only the icon outline on the blue gradient background

    // Draw Icon outline
    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: iconSize,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: Colors.white.withValues(alpha: contentOpacity * 0.9),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    iconPainter.paint(
      canvas,
      Offset(
        iconCenter.dx - iconPainter.width / 2,
        iconCenter.dy - iconPainter.height / 2,
      ),
    );

    textPainter.paint(
      canvas,
      Offset(
        size.width / 2 - textPainter.width / 2,
        iconCenter.dy + iconRadius + spacing,
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

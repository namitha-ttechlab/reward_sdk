import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    this.overlayColor = const Color(0xFF3D5CE0), // Vibrant blue
    this.title = 'Scratch here to reveal',
    this.icon = Icons.redeem_outlined, 
    this.threshold = 0.5,
    this.aspectRatio = 1.0,
    this.width,
    this.height,
  });

  static void show(
    BuildContext context, {
    required Widget child,
    Color overlayColor = const Color(0xFF3D5CE0),
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
    Color overlayColor = const Color(0xFF3D5CE0),
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
    Color overlayColor = const Color(0xFF3D5CE0),
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

  // SVG surface picture
  ui.Picture? _svgPicture;
  Size? _svgViewBox;

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
    _loadSvg();
  }

  Future<void> _loadSvg() async {
    // Try both paths: package-prefixed (for SDK consumers) and bare path (for internal use)
    const paths = [
      'packages/reward_sdk/lib/asset/scratch_transparent (7).svg',
      'lib/asset/scratch_transparent (7).svg',
    ];

    for (final path in paths) {
      try {
        final loader = SvgAssetLoader(path);
        final pictureInfo = await vg.loadPicture(loader, null);
        if (mounted) {
          setState(() {
            _svgPicture = pictureInfo.picture;
            _svgViewBox = pictureInfo.size;
          });
        }
        return; // Success — stop trying
      } catch (_) {
        // Try next path
      }
    }
    // All paths failed; plain gradient fallback will be used automatically
  }


  @override
  void dispose() {
    _svgPicture?.dispose();
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
                        svgPicture: _svgPicture,
                        svgViewBox: _svgViewBox,
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
  final ui.Picture? svgPicture;
  final Size? svgViewBox;

  _ScratchPainter({
    required this.points,
    required this.overlayColor,
    required this.title,
    required this.icon,
    this.pulseValue = 0.0,
    this.svgPicture,
    this.svgViewBox,
  });

  @override
 void paint(Canvas canvas, Size size) {
  final rect = Rect.fromLTWH(0, 0, size.width, size.height);

  canvas.saveLayer(rect, Paint());

  final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(24));

  // Background gradient (UNCHANGED)
  final bgGrad = LinearGradient(
    colors: [
      overlayColor,
      Color.lerp(overlayColor, Colors.black, 0.18)!,
      Color.lerp(overlayColor, Colors.black, 0.10)!,
    ],
    stops: const [0.0, 0.6, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ).createShader(rect);

  canvas.drawRRect(rrect, Paint()..shader = bgGrad);

  // ─────────────────────────────────────
  // SVG SURFACE PATTERN
  // ─────────────────────────────────────

  if (svgPicture != null && svgViewBox != null && svgViewBox!.width > 0) {
    canvas.save();
    // Scale the SVG to cover the entire card surface
    final double scaleX = size.width / svgViewBox!.width;
    final double scaleY = size.height / svgViewBox!.height;
    // Use cover scaling (take the larger scale so it always fills)
    final double scale = math.max(scaleX, scaleY);
    final double dx = (size.width - svgViewBox!.width * scale) / 2;
    final double dy = (size.height - svgViewBox!.height * scale) / 2;
    canvas.translate(dx, dy);
    canvas.scale(scale);
    canvas.drawPicture(svgPicture!);
    canvas.restore();
  }

  // ─────────────────────────────────────
  // ICON + TEXT (UNCHANGED)
  // ─────────────────────────────────────

  final contentOpacity =
      (0.85 + (0.15 * math.sin(pulseValue * math.pi))).clamp(0.0, 1.0);

  const double iconBoxSize = 80.0;
  const double spacing = 16.0;

  final displayTitle =
      title == 'Scratch to Reveal' ? 'Scratch here to reveal' : title;

  final textPainter = TextPainter(
    text: TextSpan(
      text: displayTitle,
      style: TextStyle(
        color: Colors.white.withValues(alpha: contentOpacity),
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: size.width - 40);

  final totalContentHeight = iconBoxSize + spacing + textPainter.height;
  final topOffset = (size.height - totalContentHeight) / 2;

  final double cx = size.width / 2;
  final double cy = topOffset + iconBoxSize / 2;

  final iconPaint = Paint()
    ..color = Colors.white.withValues(alpha: contentOpacity * 0.85)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 6
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  final double w = iconBoxSize * 0.75;
  final double h = iconBoxSize * 0.7;

  final Rect bottomRect = Rect.fromCenter(
      center: Offset(cx, cy + h * 0.25), width: w * 0.9, height: h * 0.6);

  canvas.drawRRect(
      RRect.fromRectAndRadius(bottomRect, const Radius.circular(8)),
      iconPaint);

  final Rect lidRect = Rect.fromCenter(
      center: Offset(cx, cy - h * 0.15), width: w, height: h * 0.25);

  canvas.drawRRect(
      RRect.fromRectAndRadius(lidRect, const Radius.circular(8)),
      iconPaint);

  canvas.drawLine(
      Offset(cx, cy - h * 0.275), Offset(cx, cy - h * 0.025), iconPaint);

  canvas.drawLine(
      Offset(cx, cy - h * 0.05), Offset(cx, cy + h * 0.55), iconPaint);

  final Path bowPath = Path();

  bowPath.moveTo(cx - 3, cy - h * 0.275);
  bowPath.cubicTo(
    cx - w * 0.45,
    cy - h * 0.55,
    cx - w * 0.1,
    cy - h * 0.8,
    cx,
    cy - h * 0.275,
  );

  bowPath.moveTo(cx + 3, cy - h * 0.275);
  bowPath.cubicTo(
    cx + w * 0.45,
    cy - h * 0.55,
    cx + w * 0.1,
    cy - h * 0.8,
    cx,
    cy - h * 0.275,
  );

  canvas.drawPath(bowPath, iconPaint);

  textPainter.paint(
    canvas,
    Offset(
      size.width / 2 - textPainter.width / 2,
      topOffset + iconBoxSize + spacing,
    ),
  );

  // ─────────────────────────────────────
  // SCRATCH ERASE
  // ─────────────────────────────────────

  final erasePaint = Paint()
    ..blendMode = BlendMode.clear
    ..strokeWidth = 45
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

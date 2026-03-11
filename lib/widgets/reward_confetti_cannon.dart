import 'dart:math' as math;
import 'package:flutter/material.dart';

enum ParticleShape { square, circle, triangle, star, ribbon }

// Global random to avoid recreating
final _random = math.Random();

class _Particle {
  late Offset position;
  late Offset velocity;
  late Color color;
  late double size;
  late double rotation;
  late double rotationSpeed;
  late ParticleShape shape;
  late double opacity;
  late double life;
  late double wobble;
  late double wobbleSpeed;
  late double tilt;
  late double tiltSpeed;
  
  // Ribbon trail
  final List<Offset> trail = [];
  final int maxTrailLength = 15;

  _Particle(Offset startPos, Color startColor, {double? customAngle, double? customSpeed}) {
    position = startPos;
    // Default angles if not provided
    final angle = customAngle ?? (-math.pi / 2 + (_random.nextDouble() - 0.5) * 1.2); 
    final speed = customSpeed ?? (20.0 + _random.nextDouble() * 30.0); // Slightly faster for full screen blast
    velocity = Offset(math.cos(angle) * speed, math.sin(angle) * speed);
    color = startColor;
    size = 6.0 + _random.nextDouble() * 10.0;
    rotation = _random.nextDouble() * math.pi * 2;
    rotationSpeed = (_random.nextDouble() - 0.5) * 0.4;
    opacity = 1.0;
    life = 1.0;
    wobble = _random.nextDouble() * math.pi * 2;
    wobbleSpeed = 0.1 + _random.nextDouble() * 0.2;
    tilt = _random.nextDouble() * math.pi * 2;
    tiltSpeed = 0.05 + _random.nextDouble() * 0.1;
    
    final shapes = ParticleShape.values;
    shape = shapes[_random.nextInt(shapes.length)];
  }

  void update() {
    // Air resistance + Gravity
    velocity = Offset(velocity.dx * 0.97, (velocity.dy + 0.6) * 0.97);
    position += velocity;
    
    rotation += rotationSpeed;
    wobble += wobbleSpeed;
    tilt += tiltSpeed;
    
    if (shape == ParticleShape.ribbon) {
      trail.insert(0, position);
      if (trail.length > maxTrailLength) {
        trail.removeLast();
      }
    }

    life -= 0.006;
    if (life < 0) life = 0;
    opacity = life;
  }
}

class RewardConfettiController extends ChangeNotifier {
  VoidCallback? _onBurst;
  
  void burst() {
    _onBurst?.call();
  }
  
  void _setBurstCallback(VoidCallback callback) {
    _onBurst = callback;
  }
}

class RewardConfettiCannon extends StatefulWidget {
  final List<Color>? colors;
  final Duration duration;
  final Widget child;
  final RewardConfettiController? controller;

  const RewardConfettiCannon({
    super.key,
    this.colors,
    this.duration = const Duration(seconds: 4),
    this.controller,
    required this.child,
  });

  @override
  State<RewardConfettiCannon> createState() => RewardConfettiCannonState();
}

class RewardConfettiCannonState extends State<RewardConfettiCannon> with TickerProviderStateMixin {
  late AnimationController _cannonController;
  late AnimationController _particleController;
  final List<_Particle> _particles = [];
  bool _isAnimating = false;
  bool _showCannons = false;
  List<Offset> _blastPositions = [];
  OverlayEntry? _overlayEntry;

  final List<Color> _defaultColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
  ];

  @override
  void initState() {
    super.initState();

    _cannonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addListener(() {
        if (_particles.isNotEmpty) {
          setState(() {
            for (var i = _particles.length - 1; i >= 0; i--) {
              _particles[i].update();
              if (_particles[i].life <= 0 && _particles[i].trail.isEmpty) {
                _particles.removeAt(i);
              }
            }
          });
          _updateOverlay();
        }
        if (_particles.isEmpty && _isAnimating && _particleController.isCompleted) {
          _removeOverlay();
          setState(() {
            _isAnimating = false;
          });
        }
      });
      
    widget.controller?._setBurstCallback(trigger);
  }

  @override
  void dispose() {
    _removeOverlay();
    _cannonController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _updateOverlay() {
    if (!mounted) return;
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: Listenable.merge([_particleController, _cannonController]),
              builder: (context, child) {
                return CustomPaint(
                  painter: _ConfettiPainter(
                    particles: _particles,
                    cannonScale: CurvedAnimation(parent: _cannonController, curve: Curves.elasticOut).value,
                    showCannons: _showCannons,
                    blastPositions: _blastPositions,
                  ),
                );
              },
            ),
          ),
        ),
      );
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
  void trigger() async {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
      _particles.clear();
      _showCannons = true;
    });

    if (!mounted) return;
    final screenSize = MediaQuery.of(context).size;
    final colors = widget.colors ?? _defaultColors;

    _blastPositions = [
      Offset(50, screenSize.height - 50),
      Offset(screenSize.width - 50, screenSize.height - 50),
    ];
    
    _updateOverlay();

    // Pop the cannons up
    await _cannonController.forward(from: 0.0);
    await Future.delayed(const Duration(milliseconds: 100)); // small hold
    
    if (!mounted) return;

    setState(() {
      _showCannons = false; // Hide cannons as blast happens
    });

    // Angles for blasting inwards and UPWARDS
    final double rightBlastAngle = -math.pi / 2.5; // More upward
    final double leftBlastAngle = -math.pi + math.pi / 2.5;

    // Initial strong blast from BOTH sides
    for (int i = 0; i < 70; i++) {
      // Left cannon
      double angleL = rightBlastAngle + (_random.nextDouble() - 0.5) * 0.6;
      _particles.add(_Particle(
        _blastPositions[0], 
        colors[_random.nextInt(colors.length)], 
        customAngle: angleL,
        customSpeed: 25.0 + _random.nextDouble() * 30.0, // Faster/higher
      ));
      
      // Right cannon
      double angleR = leftBlastAngle + (_random.nextDouble() - 0.5) * 0.6;
      _particles.add(_Particle(
        _blastPositions[1], 
        colors[_random.nextInt(colors.length)], 
        customAngle: angleR,
        customSpeed: 25.0 + _random.nextDouble() * 30.0,
      ));
    }
    
    _updateOverlay();
    _particleController.forward(from: 0.0);

    // Stage 2 (Aftershock burst)
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      for (int i = 0; i < 50; i++) {
        // Left cannon
        double angleL = rightBlastAngle + (_random.nextDouble() - 0.5) * 0.8;
        _particles.add(_Particle(
          _blastPositions[0], 
          colors[_random.nextInt(colors.length)],
          customAngle: angleL,
          customSpeed: 20.0 + _random.nextDouble() * 25.0,
        ));
        
        // Right cannon
        double angleR = leftBlastAngle + (_random.nextDouble() - 0.5) * 0.8;
        _particles.add(_Particle(
          _blastPositions[1], 
          colors[_random.nextInt(colors.length)],
          customAngle: angleR,
          customSpeed: 20.0 + _random.nextDouble() * 25.0,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double cannonScale;
  final bool showCannons;
  final List<Offset> blastPositions;

  _ConfettiPainter({
    required this.particles,
    this.cannonScale = 0.0,
    this.showCannons = false,
    this.blastPositions = const [],
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (showCannons && cannonScale > 0.0) {
      for (int i = 0; i < blastPositions.length; i++) {
        final pos = blastPositions[i];
        final textPainter = TextPainter(
          text: const TextSpan(
            text: '🎉',
            style: TextStyle(fontSize: 60),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        canvas.save();
        canvas.translate(pos.dx, pos.dy);
        
        // Mirror the right cannon (index 1) so it points inwards
        final double scaleX = (i == 1) ? -cannonScale : cannonScale;
        
        // Scale from bottom center of the emoji
        canvas.scale(scaleX, cannonScale);
        textPainter.paint(
          canvas,
          Offset(-textPainter.width / 2, -textPainter.height + 10), // Adjust so blast originates near top
        );
        canvas.restore();
      }
    }

    for (final p in particles) {
      final paint = Paint()
        ..color = p.color.withValues(alpha: p.opacity)
        ..style = PaintingStyle.fill;

      if (p.shape == ParticleShape.ribbon && p.trail.length > 1) {
        _drawLongRibbon(canvas, p, paint);
        continue;
      }

      canvas.save();
      canvas.translate(p.position.dx, p.position.dy);
      
      // Simulate 3D flip by scaling width with wobble
      final flipScale = math.sin(p.wobble);
      canvas.scale(flipScale, 1.0);
      canvas.rotate(p.rotation + p.tilt);

      switch (p.shape) {
        case ParticleShape.square:
          canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size), paint);
          break;
        case ParticleShape.circle:
          canvas.drawCircle(Offset.zero, p.size / 2, paint);
          break;
        case ParticleShape.triangle:
          _drawPolygon(canvas, 3, p.size / 2, paint);
          break;
        case ParticleShape.star:
          _drawStar(canvas, Offset.zero, 5, p.size / 2, p.size, paint);
          break;
        default:
          break;
      }
      canvas.restore();
    }
  }

  void _drawPolygon(Canvas canvas, int sides, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < sides; i++) {
      final angle = (math.pi * 2 / sides) * i;
      final x = math.cos(angle) * radius;
      final y = math.sin(angle) * radius;
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawLongRibbon(Canvas canvas, _Particle p, Paint paint) {
    final path = Path();
    path.moveTo(p.trail[0].dx, p.trail[0].dy);
    
    for (int i = 1; i < p.trail.length; i++) {
      // Add subtle wave to the trail
      final wave = math.sin(p.wobble + i * 0.5) * 3.0;
      path.lineTo(p.trail[i].dx + wave, p.trail[i].dy);
    }
    
    final strokePaint = Paint()
      ..color = paint.color.withValues(alpha: p.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;
      
    canvas.drawPath(path, strokePaint);
  }

  void _drawStar(Canvas canvas, Offset center, int points, double innerRadius, double outerRadius, Paint paint) {
    final path = Path();
    final angle = (math.pi * 2) / points;
    for (int i = 0; i < points; i++) {
      double x = center.dx + math.cos(i * angle - math.pi / 2) * outerRadius;
      double y = center.dy + math.sin(i * angle - math.pi / 2) * outerRadius;
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
      
      x = center.dx + math.cos(i * angle + angle / 2 - math.pi / 2) * innerRadius;
      y = center.dy + math.sin(i * angle + angle / 2 - math.pi / 2) * innerRadius;
      path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawRibbon(Canvas canvas, double size, Paint paint) {
    final path = Path();
    path.moveTo(-size / 2, 0);
    path.quadraticBezierTo(0, -size / 2, size / 2, 0);
    path.quadraticBezierTo(0, size / 2, -size / 2, 0);
    
    final strokePaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}

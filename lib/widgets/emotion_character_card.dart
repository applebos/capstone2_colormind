import 'dart:math';
import 'package:flutter/material.dart';
import '../models/emotion_character.dart';

class EmotionCharacterCard extends StatefulWidget {
  final EmotionCharacter character;
  final String emotion;
  final double size;
  final bool isInteractive;
  final List<String> accessoryEmotions;

  const EmotionCharacterCard({
    super.key,
    required this.character,
    required this.emotion,
    this.size = 200,
    this.isInteractive = true,
    this.accessoryEmotions = const [],
  });

  @override
  State<EmotionCharacterCard> createState() => _EmotionCharacterCardState();
}

class _EmotionCharacterCardState extends State<EmotionCharacterCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String? _currentMessage;
  bool _isHappy = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isInteractive) return;
    setState(() {
      _currentMessage = widget
          .character
          .greetings[Random().nextInt(widget.character.greetings.length)];
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _currentMessage = null;
        });
      }
    });
  }

  void _handleDoubleTap() {
    if (!widget.isInteractive) return;
    setState(() {
      _isHappy = true;
      _currentMessage = "헤헤, 기분 좋아요!";
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isHappy = false;
          _currentMessage = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onDoubleTap: _handleDoubleTap,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Speech Bubble Area (Fixed Height)
            SizedBox(
              height: 60,
              child: _currentMessage != null
                  ? FadeTransition(
                      opacity: _controller,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          _currentMessage!,
                          style: TextStyle(
                            color: widget.character.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 8),
            // Character
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: CharacterPainter(
                    color: widget.character.color,
                    accentColor: widget.character.accentColor,
                    animationValue: _controller.value,
                    appearance: widget.character.appearance,
                    isHappy: _isHappy,
                    accessoryEmotions: widget.accessoryEmotions,
                    emotionName: widget.emotion,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              widget.character.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CharacterPainter extends CustomPainter {
  final Color color;
  final Color accentColor;
  final double animationValue;
  final CharacterAppearance appearance;
  final bool isHappy;
  final List<String> accessoryEmotions;
  final String emotionName; // Added to identify specific emotion

  CharacterPainter({
    required this.color,
    required this.accentColor,
    required this.animationValue,
    required this.appearance,
    required this.isHappy,
    this.accessoryEmotions = const [],
    required this.emotionName,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5;

    // Breathing effect
    final breath = isHappy
        ? sin(animationValue * 20) * 5
        : sin(animationValue * pi) * 3;
    final currentRadius = radius + breath;

    // Draw specific character base based on emotion name
    _drawCharacterBody(canvas, center, currentRadius);

    // Draw Face
    _drawFace(canvas, center, currentRadius);

    // Draw Accessories (Secondary emotions)
    _drawAccessories(canvas, center, currentRadius);
  }

  void _drawCharacterBody(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [accentColor, color],
        center: const Alignment(-0.3, -0.3),
        radius: 1.2,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    final path = Path();

    switch (emotionName) {
      case '우호성': // Friendly - Jelly round
        path.addOval(Rect.fromCircle(center: center, radius: radius));
        // Warm light particles
        _drawParticles(
          canvas,
          center,
          radius,
          Colors.white.withValues(alpha: 0.5),
        );
        break;
      case '기대': // Anticipation - Active
        path.addOval(Rect.fromCircle(center: center, radius: radius));
        // Sand particles
        _drawParticles(canvas, center, radius, Colors.orangeAccent);
        break;
      case '감사': // Gratitude - Druid
        path.addOval(Rect.fromCircle(center: center, radius: radius));
        // Vines/Leaves
        _drawVines(canvas, center, radius);
        break;
      case '행복': // Happiness - Sun
        // Sun rays
        _drawSunRays(canvas, center, radius);
        path.addOval(Rect.fromCircle(center: center, radius: radius));
        break;
      case '사랑': // Love - Angel
        // Wings
        _drawWings(canvas, center, radius);
        path.addOval(Rect.fromCircle(center: center, radius: radius));
        break;
      case '낙관': // Optimism - Hero
        // Cape
        _drawCape(canvas, center, radius);
        path.addOval(Rect.fromCircle(center: center, radius: radius));
        break;
      case '신뢰': // Trust - Knight
        // Shield shape body
        path.moveTo(center.dx - radius, center.dy - radius * 0.9);
        path.lineTo(center.dx + radius, center.dy - radius * 0.9);
        path.lineTo(center.dx + radius, center.dy + radius * 0.2);
        path.quadraticBezierTo(
          center.dx,
          center.dy + radius * 1.8,
          center.dx - radius,
          center.dy + radius * 0.2,
        );
        path.close();
        break;
      case '분노': // Anger - Volcano
        // Rough rock shape
        for (double i = 0; i < pi * 2; i += pi / 8) {
          double r = radius + sin(i * 5) * 10;
          double x = center.dx + cos(i) * r;
          double y = center.dy + sin(i) * r;
          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        // Magma cracks
        _drawCracks(canvas, center, radius);
        break;
      case '오만': // Arrogance - Noble
        // High collar
        _drawCollar(canvas, center, radius);
        path.addOval(Rect.fromCircle(center: center, radius: radius));
        break;
      case '비우호성': // Unfriendly - Hedgehog
        // Spiky body
        final spikes = 16;
        final angleStep = pi * 2 / spikes;
        for (int i = 0; i < spikes; i++) {
          final angle = i * angleStep;
          final outerR = radius * 1.2;
          final innerR = radius * 0.8;
          path.lineTo(
            center.dx + cos(angle) * outerR,
            center.dy + sin(angle) * outerR,
          );
          path.lineTo(
            center.dx + cos(angle + angleStep / 2) * innerR,
            center.dy + sin(angle + angleStep / 2) * innerR,
          );
        }
        path.close();
        break;
      case '혐오': // Disgust - Slime
        // Dripping slime shape
        path.addOval(Rect.fromCircle(center: center, radius: radius));
        // Bubbles
        _drawBubbles(canvas, center, radius);
        break;
      case '두려움': // Fear - Shadow
        // Small trembling body
        final tremble = sin(animationValue * 50) * 3;
        path.addOval(
          Rect.fromCircle(
            center: center + Offset(tremble, 0),
            radius: radius * 0.8,
          ),
        );
        break;
      case '비관': // Pessimism - Cloud
        // Cloud shape
        path.addOval(Rect.fromCircle(center: center, radius: radius * 0.8));
        path.addOval(
          Rect.fromCircle(
            center: center + Offset(radius * 0.6, -radius * 0.2),
            radius: radius * 0.5,
          ),
        );
        path.addOval(
          Rect.fromCircle(
            center: center + Offset(-radius * 0.6, -radius * 0.2),
            radius: radius * 0.5,
          ),
        );
        // Rain
        _drawRain(canvas, center, radius);
        break;
      case '후회': // Regret - Ghost
        // Ghost tail
        path.addOval(Rect.fromCircle(center: center, radius: radius));
        // Chains
        _drawChains(canvas, center, radius);
        break;
      case '슬픔': // Sadness - Water
        // Droplet shape
        path.moveTo(center.dx, center.dy - radius * 1.3);
        path.cubicTo(
          center.dx + radius * 1.1,
          center.dy - radius * 0.5,
          center.dx + radius * 1.1,
          center.dy + radius,
          center.dx,
          center.dy + radius,
        );
        path.cubicTo(
          center.dx - radius * 1.1,
          center.dy + radius,
          center.dx - radius * 1.1,
          center.dy - radius * 0.5,
          center.dx,
          center.dy - radius * 1.3,
        );
        // Puddle
        canvas.drawOval(
          Rect.fromCenter(
            center: center + Offset(0, radius * 1.2),
            width: radius * 1.5,
            height: radius * 0.3,
          ),
          paint,
        );
        break;
      case '수치심': // Shame - Hiding
        // Curled up ball
        path.addOval(Rect.fromCircle(center: center, radius: radius * 0.9));
        break;
      case '겸손': // Humility - Meditating
        // Simple round
        path.addOval(Rect.fromCircle(center: center, radius: radius));
        // Lotus light
        _drawLotus(canvas, center, radius);
        break;
      case '부끄러움': // Shyness - Rabbit
        // Rabbit ears
        path.addOval(Rect.fromCircle(center: center, radius: radius));
        final earPaint = Paint()..color = color;
        canvas.drawOval(
          Rect.fromCenter(
            center: center + Offset(-radius * 0.4, -radius),
            width: radius * 0.3,
            height: radius,
          ),
          earPaint,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: center + Offset(radius * 0.4, -radius),
            width: radius * 0.3,
            height: radius,
          ),
          earPaint,
        );
        break;
      case '놀람': // Surprise - Clown
        // Spiky hair
        path.addOval(Rect.fromCircle(center: center, radius: radius));
        _drawSparks(canvas, center, radius);
        break;
      default:
        path.addOval(Rect.fromCircle(center: center, radius: radius));
    }

    canvas.drawShadow(path, color.withValues(alpha: 0.3), 10, true);
    canvas.drawPath(path, paint);
  }

  // Helper drawing methods for effects
  void _drawParticles(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
  ) {
    final particlePaint = Paint()..color = color;
    for (int i = 0; i < 5; i++) {
      final angle = animationValue * 2 * pi + (i * 2 * pi / 5);
      final offset = Offset(
        cos(angle) * radius * 1.2,
        sin(angle) * radius * 1.2,
      );
      canvas.drawCircle(center + offset, 3, particlePaint);
    }
  }

  void _drawSunRays(Canvas canvas, Offset center, double radius) {
    final rayPaint = Paint()
      ..color = Colors.yellowAccent.withValues(alpha: 0.5)
      ..strokeWidth = 4;
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4 + animationValue;
      final start = center + Offset(cos(angle) * radius, sin(angle) * radius);
      final end =
          center + Offset(cos(angle) * radius * 1.5, sin(angle) * radius * 1.5);
      canvas.drawLine(start, end, rayPaint);
    }
  }

  void _drawWings(Canvas canvas, Offset center, double radius) {
    final wingPaint = Paint()..color = Colors.white.withValues(alpha: 0.8);
    final path = Path();
    // Left wing
    path.moveTo(center.dx - radius * 0.5, center.dy);
    path.quadraticBezierTo(
      center.dx - radius * 1.5,
      center.dy - radius,
      center.dx - radius * 1.5,
      center.dy + radius * 0.5,
    );
    path.quadraticBezierTo(
      center.dx - radius,
      center.dy + radius * 0.5,
      center.dx - radius * 0.5,
      center.dy + radius * 0.2,
    );
    // Right wing
    path.moveTo(center.dx + radius * 0.5, center.dy);
    path.quadraticBezierTo(
      center.dx + radius * 1.5,
      center.dy - radius,
      center.dx + radius * 1.5,
      center.dy + radius * 0.5,
    );
    path.quadraticBezierTo(
      center.dx + radius,
      center.dy + radius * 0.5,
      center.dx + radius * 0.5,
      center.dy + radius * 0.2,
    );
    canvas.drawPath(path, wingPaint);
  }

  void _drawCape(Canvas canvas, Offset center, double radius) {
    final capePaint = Paint()..color = Colors.redAccent;
    final path = Path();
    path.moveTo(center.dx - radius * 0.8, center.dy);
    path.quadraticBezierTo(
      center.dx,
      center.dy + radius * 1.5,
      center.dx + radius * 0.8,
      center.dy,
    );
    canvas.drawPath(path, capePaint);
  }

  void _drawCracks(Canvas canvas, Offset center, double radius) {
    final crackPaint = Paint()
      ..color = Colors.yellowAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path();
    path.moveTo(center.dx - radius * 0.5, center.dy);
    path.lineTo(center.dx - radius * 0.2, center.dy + radius * 0.2);
    path.lineTo(center.dx, center.dy - radius * 0.1);
    path.lineTo(center.dx + radius * 0.4, center.dy + radius * 0.3);
    canvas.drawPath(path, crackPaint);
  }

  void _drawCollar(Canvas canvas, Offset center, double radius) {
    final collarPaint = Paint()..color = Colors.deepPurple.shade800;
    final path = Path();
    path.moveTo(center.dx - radius, center.dy);
    path.lineTo(center.dx - radius * 1.2, center.dy - radius * 0.8);
    path.lineTo(center.dx + radius * 1.2, center.dy - radius * 0.8);
    path.lineTo(center.dx + radius, center.dy);
    canvas.drawPath(path, collarPaint);
  }

  void _drawBubbles(Canvas canvas, Offset center, double radius) {
    final bubblePaint = Paint()
      ..color = Colors.greenAccent.withValues(alpha: 0.6);
    canvas.drawCircle(
      center +
          Offset(radius * 0.5, -radius * 0.8 + sin(animationValue * 10) * 5),
      5,
      bubblePaint,
    );
    canvas.drawCircle(
      center +
          Offset(-radius * 0.3, -radius * 0.9 + cos(animationValue * 10) * 5),
      3,
      bubblePaint,
    );
  }

  void _drawRain(Canvas canvas, Offset center, double radius) {
    final rainPaint = Paint()
      ..color = Colors.blueGrey
      ..strokeWidth = 2;
    for (int i = 0; i < 3; i++) {
      final x = center.dx + (i - 1) * radius * 0.5;
      final y = center.dy + radius + (animationValue * 20 + i * 10) % 20;
      canvas.drawLine(Offset(x, y), Offset(x, y + 10), rainPaint);
    }
  }

  void _drawChains(Canvas canvas, Offset center, double radius) {
    final chainPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 1.1),
      0,
      pi,
      false,
      chainPaint,
    );
  }

  void _drawLotus(Canvas canvas, Offset center, double radius) {
    final lotusPaint = Paint()
      ..color = Colors.pinkAccent.withValues(alpha: 0.3);
    for (int i = 0; i < 6; i++) {
      final angle = i * pi / 3;
      final petalPos =
          center + Offset(cos(angle) * radius * 1.2, sin(angle) * radius * 1.2);
      canvas.drawCircle(petalPos, 5, lotusPaint);
    }
  }

  void _drawSparks(Canvas canvas, Offset center, double radius) {
    final sparkPaint = Paint()..color = Colors.yellow;
    if (sin(animationValue * 20) > 0) {
      canvas.drawCircle(center + Offset(radius, -radius), 5, sparkPaint);
      canvas.drawCircle(center + Offset(-radius, -radius), 5, sparkPaint);
    }
  }

  void _drawVines(Canvas canvas, Offset center, double radius) {
    final vinePaint = Paint()
      ..color = Colors.green.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.9),
      0,
      pi * 2,
      false,
      vinePaint,
    );
  }

  void _drawFace(Canvas canvas, Offset center, double radius) {
    final pupilColor = Colors.black87;
    final eyeY = center.dy - radius * 0.1;
    final eyeOffset = radius * 0.35;

    final eyePaint = Paint()
      ..color = pupilColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final mouthPaint = Paint()
      ..color = pupilColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Custom Face Logic based on Emotion
    if (isHappy) {
      _drawArcEye(canvas, center.dx - eyeOffset, eyeY, eyePaint);
      _drawArcEye(canvas, center.dx + eyeOffset, eyeY, eyePaint);
      // Open mouth
      final mouthPath = Path();
      mouthPath.moveTo(center.dx - 10, center.dy + radius * 0.25);
      mouthPath.quadraticBezierTo(
        center.dx,
        center.dy + radius * 0.25 + 15,
        center.dx + 10,
        center.dy + radius * 0.25,
      );
      mouthPath.close();
      canvas.drawPath(mouthPath, Paint()..color = pupilColor);
    } else {
      switch (emotionName) {
        case '분노':
        case '혐오':
        case '비우호성':
        case '오만':
          // Angry eyes
          canvas.drawLine(
            Offset(center.dx - eyeOffset - 8, eyeY - 5),
            Offset(center.dx - eyeOffset + 8, eyeY + 2),
            eyePaint,
          );
          canvas.drawLine(
            Offset(center.dx + eyeOffset - 8, eyeY + 2),
            Offset(center.dx + eyeOffset + 8, eyeY - 5),
            eyePaint,
          );
          // Grumpy mouth
          canvas.drawArc(
            Rect.fromCircle(
              center: Offset(center.dx, center.dy + radius * 0.3),
              radius: 6,
            ),
            pi + 0.2,
            pi - 0.4,
            false,
            mouthPaint,
          );
          break;
        case '슬픔':
        case '비관':
        case '후회':
        case '두려움':
          // Sad eyes
          canvas.drawLine(
            Offset(center.dx - eyeOffset - 8, eyeY + 2),
            Offset(center.dx - eyeOffset + 8, eyeY - 5),
            eyePaint,
          );
          canvas.drawLine(
            Offset(center.dx + eyeOffset - 8, eyeY - 5),
            Offset(center.dx + eyeOffset + 8, eyeY + 2),
            eyePaint,
          );
          // Sad mouth
          canvas.drawArc(
            Rect.fromCircle(
              center: Offset(center.dx, center.dy + radius * 0.3),
              radius: 6,
            ),
            pi + 0.2,
            pi - 0.4,
            false,
            mouthPaint,
          );
          break;
        case '놀람':
          // O eyes
          canvas.drawCircle(Offset(center.dx - eyeOffset, eyeY), 5, eyePaint);
          canvas.drawCircle(Offset(center.dx + eyeOffset, eyeY), 5, eyePaint);
          // O mouth
          canvas.drawCircle(
            Offset(center.dx, center.dy + radius * 0.3),
            5,
            eyePaint,
          );
          break;
        default:
          // Normal eyes with blink
          final blink = sin(animationValue * pi * 4);
          if (blink > 0.95) {
            canvas.drawLine(
              Offset(center.dx - eyeOffset - 8, eyeY),
              Offset(center.dx - eyeOffset + 8, eyeY),
              eyePaint,
            );
            canvas.drawLine(
              Offset(center.dx + eyeOffset - 8, eyeY),
              Offset(center.dx + eyeOffset + 8, eyeY),
              eyePaint,
            );
          } else {
            canvas.drawCircle(
              Offset(center.dx - eyeOffset, eyeY),
              6,
              Paint()..color = pupilColor,
            );
            canvas.drawCircle(
              Offset(center.dx + eyeOffset, eyeY),
              6,
              Paint()..color = pupilColor,
            );
            // Shine
            canvas.drawCircle(
              Offset(center.dx - eyeOffset + 2, eyeY - 2),
              2,
              Paint()..color = Colors.white,
            );
            canvas.drawCircle(
              Offset(center.dx + eyeOffset + 2, eyeY - 2),
              2,
              Paint()..color = Colors.white,
            );
          }
          // Smile
          canvas.drawArc(
            Rect.fromCircle(
              center: Offset(center.dx, center.dy + radius * 0.25),
              radius: 8,
            ),
            0.2,
            pi - 0.4,
            false,
            mouthPaint,
          );
      }
    }
  }

  void _drawAccessories(Canvas canvas, Offset center, double radius) {
    for (int i = 0; i < accessoryEmotions.length; i++) {
      final emotion = accessoryEmotions[i];

      switch (emotion) {
        case '행복': // Happiness
          _drawSunRays(canvas, center, radius * 0.5); // Small sun effect
          break;
        case '낙관': // Optimism
          // Flag (simplified as small flag)
          final flagPaint = Paint()..color = Colors.amber;
          canvas.drawRect(
            Rect.fromLTWH(center.dx + radius * 0.5, center.dy - radius, 10, 10),
            flagPaint,
          );
          canvas.drawLine(
            Offset(center.dx + radius * 0.5, center.dy - radius),
            Offset(center.dx + radius * 0.5, center.dy - radius + 20),
            Paint()
              ..color = Colors.brown
              ..strokeWidth = 2,
          );
          break;
        case '슬픔': // Sadness
          _drawTear(
            canvas,
            center + Offset(radius * 0.4, radius * 0.1),
            radius * 0.15,
          );
          break;
        case '분노': // Anger
          _drawSteam(
            canvas,
            center + Offset(-radius * 0.5, -radius * 0.9),
            radius * 0.3,
          );
          break;
        case '놀람': // Surprise
          _drawExclamation(
            canvas,
            center + Offset(-radius * 0.9, -radius * 0.2),
            radius * 0.3,
          );
          break;
        case '사랑': // Love
          _drawHeartAccessory(
            canvas,
            center + Offset(0, -radius * 0.9),
            radius * 0.25,
          );
          break;
        case '신뢰': // Trust
          _drawHalo(canvas, center + Offset(0, -radius * 1.1), radius * 0.6);
          break;
        case '두려움': // Fear
          _drawSweat(
            canvas,
            center + Offset(-radius * 0.3, -radius * 0.5),
            radius * 0.15,
          );
          break;
        case '우호성': // Friendly
          _drawFlower(
            canvas,
            center + Offset(radius * 0.6, -radius * 0.6),
            radius * 0.25,
          );
          break;
        case '오만': // Arrogance
          _drawCrown(canvas, center + Offset(0, -radius * 1.0), radius * 0.4);
          break;
        case '비우호성': // Unfriendly
          _drawThunder(
            canvas,
            center + Offset(-radius * 0.6, -radius * 0.8),
            radius * 0.3,
          );
          break;
        case '감사': // Gratitude
          _drawRibbon(canvas, center + Offset(0, radius * 0.8), radius * 0.3);
          break;
        case '겸손': // Humility
          _drawSprout(canvas, center + Offset(0, -radius * 0.9), radius * 0.2);
          break;
        case '후회': // Regret
          _drawClock(
            canvas,
            center + Offset(-radius * 0.7, -radius * 0.7),
            radius * 0.25,
          );
          break;
        case '수치심': // Shame
        case '부끄러움': // Shyness
          _drawBlush(
            canvas,
            center + Offset(-radius * 0.4, radius * 0.2),
            radius * 0.15,
          );
          _drawBlush(
            canvas,
            center + Offset(radius * 0.4, radius * 0.2),
            radius * 0.15,
          );
          break;
        case '기대': // Anticipation
          // Goggles (simplified)
          final gogglePaint = Paint()
            ..color = Colors.grey
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2;
          canvas.drawCircle(
            center + Offset(-10, -radius * 0.5),
            8,
            gogglePaint,
          );
          canvas.drawCircle(center + Offset(10, -radius * 0.5), 8, gogglePaint);
          break;
        case '비관': // Pessimism
          // Small cloud
          final cloudPaint = Paint()..color = Colors.grey;
          canvas.drawCircle(
            center + Offset(radius * 0.5, -radius * 0.8),
            10,
            cloudPaint,
          );
          break;
        case '혐오': // Disgust
          // Flies/Stink lines
          final stinkPaint = Paint()
            ..color = Colors.green
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1;
          canvas.drawArc(
            Rect.fromCircle(
              center: center + Offset(radius * 0.5, -radius * 0.5),
              radius: 10,
            ),
            0,
            pi,
            false,
            stinkPaint,
          );
          break;
      }
    }
  }


  void _drawTear(Canvas canvas, Offset pos, double size) {
    final paint = Paint()..color = Colors.blueAccent;
    final path = Path();
    path.moveTo(pos.dx, pos.dy - size);
    path.quadraticBezierTo(pos.dx + size, pos.dy + size, pos.dx, pos.dy + size);
    path.quadraticBezierTo(pos.dx - size, pos.dy + size, pos.dx, pos.dy - size);
    canvas.drawPath(path, paint);
  }

  void _drawSteam(Canvas canvas, Offset pos, double size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(pos.dx - size * 0.5, pos.dy + size);
    path.quadraticBezierTo(pos.dx, pos.dy, pos.dx + size * 0.5, pos.dy - size);
    canvas.drawPath(path, paint);

    final path2 = Path();
    path2.moveTo(pos.dx, pos.dy + size * 0.8);
    path2.quadraticBezierTo(
      pos.dx + size * 0.5,
      pos.dy - 0.2 * size,
      pos.dx + size,
      pos.dy - size * 1.2,
    );
    canvas.drawPath(path2, paint);
  }

  void _drawExclamation(Canvas canvas, Offset pos, double size) {
    final paint = Paint()..color = Colors.redAccent;
    // Bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(pos.dx, pos.dy - size * 0.2),
          width: size * 0.3,
          height: size * 1.2,
        ),
        Radius.circular(size * 0.15),
      ),
      paint,
    );
    // Dot
    canvas.drawCircle(Offset(pos.dx, pos.dy + size * 0.8), size * 0.2, paint);
  }

  void _drawHeartAccessory(Canvas canvas, Offset pos, double size) {
    final paint = Paint()..color = Colors.pinkAccent;
    final path = Path();
    path.moveTo(pos.dx, pos.dy + size * 0.3);
    path.cubicTo(
      pos.dx + size,
      pos.dy - size * 0.5,
      pos.dx + size * 0.5,
      pos.dy - size,
      pos.dx,
      pos.dy - size * 0.3,
    );
    path.cubicTo(
      pos.dx - size * 0.5,
      pos.dy - size,
      pos.dx - size,
      pos.dy - size * 0.5,
      pos.dx,
      pos.dy + size * 0.3,
    );
    canvas.drawPath(path, paint);
  }

  void _drawHalo(Canvas canvas, Offset pos, double size) {
    final paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawOval(
      Rect.fromCenter(center: pos, width: size * 1.5, height: size * 0.4),
      paint,
    );
  }

  void _drawSweat(Canvas canvas, Offset pos, double size) {
    final paint = Paint()..color = Colors.blue.withValues(alpha: 0.6);
    final path = Path();
    path.moveTo(pos.dx, pos.dy - size);
    path.quadraticBezierTo(
      pos.dx + size * 0.8,
      pos.dy + size,
      pos.dx,
      pos.dy + size,
    );
    path.quadraticBezierTo(
      pos.dx - size * 0.8,
      pos.dy + size,
      pos.dx,
      pos.dy - size,
    );
    canvas.drawPath(path, paint);
  }

  // --- New Accessories ---

  void _drawFlower(Canvas canvas, Offset pos, double size) {
    final paint = Paint()..color = Colors.pinkAccent;
    final centerPaint = Paint()..color = Colors.yellow;

    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * pi) / 5;
      final petalPos =
          pos + Offset(cos(angle) * size * 0.6, sin(angle) * size * 0.6);
      canvas.drawCircle(petalPos, size * 0.4, paint);
    }
    canvas.drawCircle(pos, size * 0.3, centerPaint);
  }

  void _drawCrown(Canvas canvas, Offset pos, double size) {
    final paint = Paint()..color = Colors.amber;
    final path = Path();
    path.moveTo(pos.dx - size, pos.dy + size * 0.5);
    path.lineTo(pos.dx - size, pos.dy - size * 0.5);
    path.lineTo(pos.dx - size * 0.3, pos.dy);
    path.lineTo(pos.dx, pos.dy - size * 0.8);
    path.lineTo(pos.dx + size * 0.3, pos.dy);
    path.lineTo(pos.dx + size, pos.dy - size * 0.5);
    path.lineTo(pos.dx + size, pos.dy + size * 0.5);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawThunder(Canvas canvas, Offset pos, double size) {
    final paint = Paint()..color = Colors.yellowAccent;
    final path = Path();
    path.moveTo(pos.dx + size * 0.2, pos.dy - size);
    path.lineTo(pos.dx - size * 0.5, pos.dy);
    path.lineTo(pos.dx, pos.dy);
    path.lineTo(pos.dx - size * 0.2, pos.dy + size);
    path.lineTo(pos.dx + size * 0.5, pos.dy);
    path.lineTo(pos.dx, pos.dy);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawRibbon(Canvas canvas, Offset pos, double size) {
    final paint = Paint()..color = Colors.redAccent;
    final path = Path();
    // Left loop
    path.addOval(
      Rect.fromCenter(
        center: pos + Offset(-size * 0.5, 0),
        width: size,
        height: size * 0.6,
      ),
    );
    // Right loop
    path.addOval(
      Rect.fromCenter(
        center: pos + Offset(size * 0.5, 0),
        width: size,
        height: size * 0.6,
      ),
    );
    canvas.drawPath(path, paint);
    canvas.drawCircle(pos, size * 0.2, paint);
  }

  void _drawSprout(Canvas canvas, Offset pos, double size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(pos.dx, pos.dy + size);
    path.quadraticBezierTo(pos.dx, pos.dy, pos.dx - size, pos.dy - size * 0.5);
    path.moveTo(pos.dx, pos.dy);
    path.quadraticBezierTo(pos.dx, pos.dy, pos.dx + size, pos.dy - size * 0.5);
    canvas.drawPath(path, paint);

    // Leaves
    canvas.drawOval(
      Rect.fromCenter(
        center: pos + Offset(-size, -size * 0.5),
        width: size * 0.8,
        height: size * 0.4,
      ),
      Paint()..color = Colors.green,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: pos + Offset(size, -size * 0.5),
        width: size * 0.8,
        height: size * 0.4,
      ),
      Paint()..color = Colors.green,
    );
  }

  void _drawClock(Canvas canvas, Offset pos, double size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(pos, size, paint);
    canvas.drawLine(pos, pos + Offset(0, -size * 0.6), paint); // Hour hand
    canvas.drawLine(
      pos,
      pos + Offset(size * 0.4, size * 0.4),
      paint,
    ); // Minute hand
  }

  void _drawBlush(Canvas canvas, Offset pos, double size) {
    final paint = Paint()..color = Colors.redAccent.withValues(alpha: 0.3);
    canvas.drawOval(
      Rect.fromCenter(center: pos, width: size * 2, height: size),
      paint,
    );

    // Lines
    final linePaint = Paint()
      ..color = Colors.redAccent.withValues(alpha: 0.5)
      ..strokeWidth = 2;
    canvas.drawLine(
      pos + Offset(-size * 0.5, -size * 0.2),
      pos + Offset(-size * 0.2, size * 0.2),
      linePaint,
    );
    canvas.drawLine(
      pos + Offset(0, -size * 0.2),
      pos + Offset(size * 0.3, size * 0.2),
      linePaint,
    );
  }

  void _drawArcEye(Canvas canvas, double x, double y, Paint paint) {
    final path = Path();
    path.moveTo(x - 8, y + 3);
    path.quadraticBezierTo(x, y - 5, x + 8, y + 3);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CharacterPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isHappy != isHappy ||
        oldDelegate.appearance != appearance ||
        oldDelegate.accessoryEmotions != accessoryEmotions ||
        oldDelegate.emotionName != emotionName;
  }
}

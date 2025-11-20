import 'package:flutter/material.dart';

class InteractiveCropper extends StatefulWidget {
  final Widget image;
  final Rect initialRect;
  final Function(Rect) onRectChanged;
  final Size imageSize;

  const InteractiveCropper({
    super.key,
    required this.image,
    required this.initialRect,
    required this.onRectChanged,
    required this.imageSize,
  });

  @override
  State<InteractiveCropper> createState() => _InteractiveCropperState();
}

class _InteractiveCropperState extends State<InteractiveCropper> {
  late Rect _cropRect;
  final double _handleSize = 16.0;

  @override
  void initState() {
    super.initState();
    _cropRect = widget.initialRect;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double scaleX = constraints.maxWidth / widget.imageSize.width;
        final double scaleY = constraints.maxHeight / widget.imageSize.height;
        final double scale = scaleX < scaleY ? scaleX : scaleY;

        final double displayWidth = widget.imageSize.width * scale;
        final double displayHeight = widget.imageSize.height * scale;

        final double offsetX = (constraints.maxWidth - displayWidth) / 2;
        final double offsetY = (constraints.maxHeight - displayHeight) / 2;

        Rect displayRect = Rect.fromLTWH(
          _cropRect.left * scale + offsetX,
          _cropRect.top * scale + offsetY,
          _cropRect.width * scale,
          _cropRect.height * scale,
        );

        return Stack(
          alignment: Alignment.center,
          children: [
            // Image
            SizedBox(
              width: displayWidth,
              height: displayHeight,
              child: widget.image,
            ),

            // Cropper overlay
            CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _CropPainter(displayRect),
            ),

            // --- INTERACTIVE HANDLES ---
            // Top-left
            _buildHandle(
              top: displayRect.top - _handleSize / 2,
              left: displayRect.left - _handleSize / 2,
              onDrag: (dx, dy) {
                final newLeft = _cropRect.left + dx / scale;
                final newTop = _cropRect.top + dy / scale;
                final newRight = _cropRect.right;
                final newBottom = _cropRect.bottom;
                setState(() {
                  _cropRect = Rect.fromLTRB(newLeft, newTop, newRight, newBottom);
                  widget.onRectChanged(_cropRect);
                });
              },
            ),
            // Top-right
            _buildHandle(
              top: displayRect.top - _handleSize / 2,
              left: displayRect.right - _handleSize / 2,
              onDrag: (dx, dy) {
                final newRight = _cropRect.right + dx / scale;
                final newTop = _cropRect.top + dy / scale;
                final newLeft = _cropRect.left;
                final newBottom = _cropRect.bottom;
                setState(() {
                  _cropRect = Rect.fromLTRB(newLeft, newTop, newRight, newBottom);
                  widget.onRectChanged(_cropRect);
                });
              },
            ),
            // Bottom-left
            _buildHandle(
              top: displayRect.bottom - _handleSize / 2,
              left: displayRect.left - _handleSize / 2,
              onDrag: (dx, dy) {
                final newLeft = _cropRect.left + dx / scale;
                final newBottom = _cropRect.bottom + dy / scale;
                final newTop = _cropRect.top;
                final newRight = _cropRect.right;
                setState(() {
                  _cropRect = Rect.fromLTRB(newLeft, newTop, newRight, newBottom);
                  widget.onRectChanged(_cropRect);
                });
              },
            ),
            // Bottom-right
            _buildHandle(
              top: displayRect.bottom - _handleSize / 2,
              left: displayRect.right - _handleSize / 2,
              onDrag: (dx, dy) {
                final newRight = _cropRect.right + dx / scale;
                final newBottom = _cropRect.bottom + dy / scale;
                final newLeft = _cropRect.left;
                final newTop = _cropRect.top;
                setState(() {
                  _cropRect = Rect.fromLTRB(newLeft, newTop, newRight, newBottom);
                  widget.onRectChanged(_cropRect);
                });
              },
            ),
            // Main drag area
            Positioned(
              top: displayRect.top + _handleSize / 2,
              left: displayRect.left + _handleSize / 2,
              width: displayRect.width - _handleSize,
              height: displayRect.height - _handleSize,
              child: GestureDetector(
                onPanUpdate: (details) {
                  final newLeft = _cropRect.left + details.delta.dx / scale;
                  final newTop = _cropRect.top + details.delta.dy / scale;
                  setState(() {
                    _cropRect = Rect.fromLTWH(newLeft, newTop, _cropRect.width, _cropRect.height);
                    widget.onRectChanged(_cropRect);
                  });
                },
                child: Container(
                  color: Colors.transparent, // Make it hittable
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHandle({
    required double top,
    required double left,
    required Function(double, double) onDrag,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onPanUpdate: (details) => onDrag(details.delta.dx, details.delta.dy),
        child: Container(
          width: _handleSize,
          height: _handleSize,
          decoration: BoxDecoration(
            color: Colors.blue.withAlpha((255 * 0.7).round()),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      ),
    );
  }
}

class _CropPainter extends CustomPainter {
  final Rect rect;

  _CropPainter(this.rect);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()..color = Colors.black.withAlpha((255 * 0.5).round());
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRect(rect),
      ),
      backgroundPaint,
    );

    final Paint borderPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(rect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

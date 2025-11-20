import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../utils/opencv_cropper.dart' as cropper;
import '../widgets/interactive_cropper.dart';

class CropPreviewScreen extends StatefulWidget {
  final String originalImagePath;
  final Rect initialCropRect;
  final Uint8List? debugPreviewBytes;

  const CropPreviewScreen({
    super.key,
    required this.originalImagePath,
    required this.initialCropRect,
    this.debugPreviewBytes,
  });

  @override
  State<CropPreviewScreen> createState() => _CropPreviewScreenState();
}

class _CropPreviewScreenState extends State<CropPreviewScreen> {
  bool _isProcessing = false;
  bool _showDebugView = false;
  late Rect _currentCropRect;
  Size? _imageSize;
  late Image _image;

  @override
  void initState() {
    super.initState();
    _currentCropRect = widget.initialCropRect;
    _image = Image.file(File(widget.originalImagePath));
    // Decode the image to get its dimensions
    _image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        if (mounted) {
          setState(() {
            _imageSize = Size(
              info.image.width.toDouble(),
              info.image.height.toDouble(),
            );
          });
        }
      }),
    );
  }

  Future<void> _handleCropAndAnalyze() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final croppedBytes = await cropper.cropImageWithRect(widget.originalImagePath, _currentCropRect);
      if (!mounted) return;
      Navigator.pop(context, croppedBytes);
    } catch (e) {
      debugPrint("Error cropping image: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지 자르기 실패: $e')),
      );
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _handleUseOriginal() async {
    try {
      final file = File(widget.originalImagePath);
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      Navigator.pop(context, bytes);
    } catch (e) {
      debugPrint("Error reading original image: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('원본 이미지 읽기 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('영역 조절'),
        actions: [
          if (widget.debugPreviewBytes != null)
            IconButton(
              icon: Icon(_showDebugView ? Icons.crop : Icons.bug_report),
              tooltip: '디버그 보기',
              onPressed: () {
                setState(() {
                  _showDebugView = !_showDebugView;
                });
              },
            ),
          if (!_isProcessing)
            TextButton(
              onPressed: () => Navigator.pop(context, null), // Cancel
              child: const Text('취소', style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: (_imageSize == null)
                  ? const CircularProgressIndicator()
                  : _showDebugView && widget.debugPreviewBytes != null
                      ? Image.memory(widget.debugPreviewBytes!)
                      : InteractiveCropper(
                          image: _image,
                          imageSize: _imageSize!,
                          initialRect: _currentCropRect,
                          onRectChanged: (newRect) {
                            _currentCropRect = newRect;
                          },
                        ),
            ),
          ),
          if (_isProcessing)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            )
          else
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: _handleUseOriginal,
                    child: const Text('원본 사용'),
                  ),
                  FilledButton(
                    onPressed: _handleCropAndAnalyze,
                    child: const Text('자르기 & 분석'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

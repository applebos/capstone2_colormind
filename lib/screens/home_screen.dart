import 'dart:io';
import 'dart:typed_data';
import 'package:colormind/music_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../utils/opencv_cropper.dart' as cropper;
import '../emotion_predictor.dart';
import 'result_screen.dart';
import 'crop_preview_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  bool _isPredicting = false;
  late final EmotionPredictor _predictor;
  late final Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializePredictor();
  }

  Future<void> _initializePredictor() async {
    _predictor = await EmotionPredictor.create();
  }

  @override
  void dispose() {
    _predictor.close();
    super.dispose();
  }

  /// Handles picking an image from the gallery and performing emotion prediction.
  /// Navigates to the ResultScreen upon successful prediction.
  Future<void> _pickImageAndPredict(ImageSource source) async {
    Provider.of<MusicService>(context, listen: false).pauseMusic();
    String? imagePath;

    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      imagePath = pickedFile?.path;
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('이미지 처리 중 오류 발생: $e')));
      return;
    }

    if (imagePath == null) {
      if (mounted) {
        Provider.of<MusicService>(context, listen: false).resume();
      }
      return; // User canceled the picker
    }

    // --- New Interactive Crop Flow ---
    File finalImageFile;
    try {
      // 1. Detect initial crop rectangle
      final initialCropRect = await cropper.detectBoundingBox(imagePath);
      final debugPreviewBytes = await cropper.getDebugPreview(imagePath);

      if (!mounted) return;

      if (initialCropRect == null) {
        // If detection fails, use the original image
        finalImageFile = File(imagePath);
      } else {
        // 2. Show interactive crop screen
        final Uint8List? confirmedBytes = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CropPreviewScreen(
              originalImagePath: imagePath!,
              initialCropRect: initialCropRect,
              debugPreviewBytes: debugPreviewBytes,
            ),
          ),
        );

        // 3. Handle result
        if (confirmedBytes == null) {
          // User cancelled
          if (mounted) Provider.of<MusicService>(context, listen: false).resume();
          return;
        }

        // 4. Save confirmed image to a temporary file
        final tempDir = await getTemporaryDirectory();
        final fileName = 'processed_${DateTime.now().millisecondsSinceEpoch}.png';
        final processedFile = File(path.join(tempDir.path, fileName));
        await processedFile.writeAsBytes(confirmedBytes);
        finalImageFile = processedFile;
      }
    } catch (e) {
      debugPrint("Cropping flow failed: $e");
      finalImageFile = File(imagePath); // Fallback to original image
    }
    // --- End of New Interactive Crop Flow ---

    setState(() {
      _isPredicting = true;
      _image = finalImageFile;
    });

    try {
      final probVector = await _predictor.predict(finalImageFile);
      final predVector = probVector.map((v) => v > 0.4 ? 1 : 0).toList();

      if (!mounted) return;
      if (_image != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              image: _image!,
              probVector: probVector,
              predVector: predVector,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error during prediction: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isPredicting = false;
        });
      }
    }
  }

  Widget _buildPickerButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Theme.of(context).dividerColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).shadowColor.withAlpha((255 * 0.1).round()),
              spreadRadius: 5,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Theme.of(context).hintColor),
              const SizedBox(height: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'ColorMind',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Theme.of(context).appBarTheme.titleTextStyle?.color,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: FutureBuilder<void>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'AI 모델을 준비하고 있어요...',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                '모델 초기화 실패: \${snapshot.error}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }

          return Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),
                      Text(
                        '당신의 그림 속 감정을 발견해보세요',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '갤러리에서 그림을 선택하면 AI가 감정을 분석해드려요.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                      const SizedBox(height: 48),
                      const Spacer(flex: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildPickerButton(
                            context,
                            icon: Icons.add_photo_alternate_outlined,
                            label: '그림 선택하기',
                            onTap: () =>
                                _pickImageAndPredict(ImageSource.gallery),
                          ),
                          _buildPickerButton(
                            context,
                            icon: Icons.camera_alt_outlined,
                            label: '카메라로 찍기',
                            onTap: () =>
                                _pickImageAndPredict(ImageSource.camera),
                          ),
                        ],
                      ),
                      const Spacer(flex: 3),
                    ],
                  ),
                ),
              ),
              if (_isPredicting)
                Container(
                  color: Theme.of(
                    context,
                  ).splashColor.withAlpha((255 * 0.5).round()),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '감정을 분석하고 있어요...',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

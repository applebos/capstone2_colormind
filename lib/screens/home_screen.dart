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
import 'package:colormind/providers/character_provider.dart';
import 'package:colormind/widgets/emotion_character_card.dart';
import 'result_screen.dart';
import 'crop_preview_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  bool _isPredictorInitialized = false;
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
    _isPredictorInitialized = true;
  }

  @override
  void dispose() {
    if (_isPredictorInitialized) {
      _predictor.close();
    }
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
          if (mounted) {
            Provider.of<MusicService>(context, listen: false).resume();
          }
          return;
        }

        // 4. Save confirmed image to a temporary file
        final tempDir = await getTemporaryDirectory();
        final fileName =
            'processed_${DateTime.now().millisecondsSinceEpoch}.png';
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
      _image = finalImageFile; // This line was missing
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
    required String subLabel,
    required VoidCallback onTap,
    required Color color,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        width: 160,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 32, color: iconColor),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subLabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                '모델 초기화 실패: ${snapshot.error}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                physics: const AlwaysScrollableScrollPhysics(), // Scroll physics restored
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    // Title
                    Text(
                      'ColorMind',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Character
                    Consumer<CharacterProvider>(
                      builder: (context, provider, child) {
                        return EmotionCharacterCard(
                          character: provider.currentCharacter,
                          emotion: provider.currentEmotionName,
                          size: 150,
                          isInteractive: true,
                          accessoryEmotions: provider.topEmotions,
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    
                    // Header Text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          Text(
                            '당신의 그림 속\n감정을 발견해보세요',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.color,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'AI가 그림을 분석하여\n숨겨진 감정을 찾아드립니다.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withOpacity(0.7),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Cards Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildPickerButton(
                          context,
                          icon: Icons.image_outlined,
                          label: '갤러리',
                          subLabel: '사진 선택하기',
                          onTap: () =>
                              _pickImageAndPredict(ImageSource.gallery),
                          color: const Color(0xFFFFAB91), // Soft Coral
                          iconColor: const Color(0xFFD84315),
                        ),
                        const SizedBox(width: 20),
                        _buildPickerButton(
                          context,
                          icon: Icons.camera_alt_outlined,
                          label: '카메라',
                          subLabel: '사진 촬영하기',
                          onTap: () => _pickImageAndPredict(ImageSource.camera),
                          color: const Color(0xFFCE93D8), // Soft Purple
                          iconColor: const Color(0xFF8E24AA),
                        ),
                      ],
                    ),
                    const SizedBox(height: 200), // Bottom padding Increased
                  ],
                ),
              ),
              if (_isPredicting)
                Container(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
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

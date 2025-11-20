import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'image_preprocess.dart';
import 'models/emotion_model.dart';

class EmotionPredictor {
  late Interpreter _interpreter;

  // Private constructor
  EmotionPredictor._();

  // Static instance
  static EmotionPredictor? _instance;

  // Public factory constructor
  static Future<EmotionPredictor> create() async {
    if (_instance == null) {
      final predictor = EmotionPredictor._();
      await predictor.loadModel();
      _instance = predictor;
    }
    return _instance!;
  }

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/emotion_model_bs1.tflite');
    } catch (e) {
      debugPrint('Error loading model: $e');
      rethrow;
    }
  }

  Future<List<double>> predict(File imageFile) async {
    // Preprocess the image and get the input tensor
    final input = await preprocessImage(imageFile, targetSize: 224);

    // The model expects a 4D tensor [1, 224, 224, 3]
    final inputTensor = input.reshape([1, 224, 224, 3]);

    // Prepare the output tensor, filled with zeros
    final outputTensor = List.filled(allEmotions.length, 0.0).reshape([1, allEmotions.length]);

    // Run inference
    _interpreter.run(inputTensor, outputTensor);

    // Post-process the output
    final probVector = List<double>.from(outputTensor[0]);

    // Apply correction factors
    for (int i = 0; i < probVector.length; i++) {
      probVector[i] *= allEmotions[i].correctionFactor;
    }

    return probVector;
  }

  void close() {
    _interpreter.close();
    _instance = null; // Reset the instance so it can be re-created if needed
  }
}

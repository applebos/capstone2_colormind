import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

Future<Float32List> preprocessImage(
  File imageFile, {
  int targetSize = 224,
}) async {
  final bytes = await imageFile.readAsBytes();
  final oriImage = img.decodeImage(bytes);

  if (oriImage == null) {
    throw Exception('Failed to decode image. The format might be unsupported.');
  }

  // Resize the image to the target size.
  // Using interpolation for better quality.
  final resized = img.copyResize(
    oriImage,
    width: targetSize,
    height: targetSize,
    interpolation: img.Interpolation.average,
  );

  // Convert the resized image to a Float32List of normalized pixel values.
  final input = Float32List(targetSize * targetSize * 3);
  int bufferIndex = 0;
  for (int y = 0; y < resized.height; y++) {
    for (int x = 0; x < resized.width; x++) {
      final pixel = resized.getPixel(x, y);
      input[bufferIndex++] = pixel.r / 255.0;
      input[bufferIndex++] = pixel.g / 255.0;
      input[bufferIndex++] = pixel.b / 255.0;
    }
  }

  // Reshape to [1, targetSize, targetSize, 3] as expected by the model.
  return input.buffer.asFloat32List();
}

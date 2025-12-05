import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;


Future<Rect?> detectBoundingBox(String imagePath) async {
  final mat = cv.imread(imagePath);
  if (mat.isEmpty) return null;

  final double imageWidth = mat.cols.toDouble();
  final double imageHeight = mat.rows.toDouble();

  final gray = cv.cvtColor(mat, cv.COLOR_BGR2GRAY);
  final blurred = cv.gaussianBlur(gray, (5, 5), 0);
  final edges = cv.canny(blurred, 50, 150);

  final contoursData = cv.findContours(
    edges,
    cv.RETR_TREE,
    cv.CHAIN_APPROX_SIMPLE,
  );
  final contours = contoursData.$1;
  final hierarchy = contoursData.$2;

  final List<cv.Rect> innermostRectangles = [];
  final imageArea = imageHeight * imageWidth;
  final minArea = imageArea * 0.05; // Minimum 5% of image area

  for (int i = 0; i < contours.length; i++) {
    if (hierarchy.elementAt(i).val[2] == -1) {
      final contour = contours.elementAt(i);
      final area = cv.contourArea(contour);

      if (area < minArea) continue;

      final peri = cv.arcLength(contour, true);
      final approx = cv.approxPolyDP(contour, 0.02 * peri, true);

      if (approx.length == 4) {
        innermostRectangles.add(cv.boundingRect(contour));
      }
      approx.dispose();
    }
  }

  // Clean up OpenCV objects
  mat.dispose();
  gray.dispose();
  blurred.dispose();
  edges.dispose();
  contours.dispose();
  hierarchy.dispose();

  if (innermostRectangles.isEmpty) {
    return Rect.fromLTWH(0, 0, imageWidth, imageHeight);
  } else {
    // Find the largest among the innermost rectangles
    innermostRectangles.sort(
      (a, b) => (b.width * b.height).compareTo(a.width * a.height),
    );
    final largestRect = innermostRectangles.first;
    return Rect.fromLTWH(
      largestRect.x.toDouble(),
      largestRect.y.toDouble(),
      largestRect.width.toDouble(),
      largestRect.height.toDouble(),
    );
  }
}

Future<Uint8List?> getDebugPreview(String imagePath) async {
  final mat = cv.imread(imagePath);
  if (mat.isEmpty) return null;

  final gray = cv.cvtColor(mat, cv.COLOR_BGR2GRAY);
  final blurred = cv.gaussianBlur(gray, (5, 5), 0);
  final edges = cv.canny(blurred, 50, 150);
  // Use RETR_TREE to find all contours
  final contoursData = cv.findContours(
    edges,
    cv.RETR_TREE,
    cv.CHAIN_APPROX_SIMPLE,
  );
  final contours = contoursData.$1;
  final hierarchy = contoursData.$2;

  cv.drawContours(mat, contours, -1, cv.Scalar(0, 0, 255, 255), thickness: 2);

  final encoded = cv.imencode(".png", mat);

  mat.dispose();
  gray.dispose();
  blurred.dispose();
  edges.dispose();
  contours.dispose();
  hierarchy.dispose();

  return encoded.$2;
}

Future<Uint8List?> cropImageWithRect(String imagePath, Rect cropRect) async {
  final mat = cv.imread(imagePath);
  if (mat.isEmpty) return null;

  final cvRect = cv.Rect(
    cropRect.left.toInt(),
    cropRect.top.toInt(),
    cropRect.width.toInt(),
    cropRect.height.toInt(),
  );
  final croppedMat = mat.region(cvRect);

  final encoded = cv.imencode(".png", croppedMat);

  mat.dispose();
  croppedMat.dispose();

  return encoded.$2;
}

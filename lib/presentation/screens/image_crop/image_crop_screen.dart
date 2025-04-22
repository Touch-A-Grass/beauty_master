import 'dart:math';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ImageCropScreen extends StatefulWidget {
  final Uint8List image;

  const ImageCropScreen({super.key, required this.image});

  @override
  State<ImageCropScreen> createState() => _ImageCropScreenState();
}

class _ImageCropScreenState extends State<ImageCropScreen> {
  final controller = CropController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Обрезать изображение')),
      body: Stack(
        children: [
          Crop(
            image: widget.image,
            onCropped: (result) {
              if (result is CropSuccess) {
                context.maybePop(result.croppedImage);
              }
            },
            controller: controller,
            interactive: true,
            fixCropRect: true,
            baseColor: Colors.transparent,
            maskColor: Colors.black.withValues(alpha: 0.5),
            willUpdateScale: (newScale) => newScale < 5,
            withCircleUi: true,
            cornerDotBuilder: (size, edgeAlignment) => SizedBox.square(dimension: size),
            initialRectBuilder: InitialRectBuilder.withBuilder((viewportRect, imageRect) {
              return Rect.fromCircle(
                center: viewportRect.center,
                radius: min(viewportRect.width, viewportRect.height) / 2 - 16,
              );
            }),
          ),
          Positioned(
            bottom: 16 + MediaQuery.of(context).padding.bottom,
            right: 16,
            left: 16,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: IconButton(
                onPressed: () {
                  controller.crop();
                },
                icon: Icon(Icons.check_rounded, size: 32,),
                style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.surface)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

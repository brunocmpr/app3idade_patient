import 'package:app3idade_patient/services/network_image_service.dart';
import 'package:flutter/material.dart';

class ImageHeroPage extends StatelessWidget {
  final int imageId;
  final networkImageService = NetworkImageService();

  ImageHeroPage({super.key, required this.imageId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Hero(
            tag: imageId,
            child: networkImageService.createImageWidget(imageId, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}

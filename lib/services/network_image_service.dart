import 'package:app3idade_patient/services/api.dart';
import 'package:flutter/material.dart';

class NetworkImageService {
  final baseUri = '/images';

  Image createImageWidget(int imageId, {double? height, double? width, BoxFit? fit}) {
    return Image.network(
      buildFullUrl(imageId),
      headers: API.headerAuthorization,
      width: width,
      height: height,
      fit: fit,
    );
  }

  String buildFullUrl(int imageId) => 'http://${API.url}$baseUri/$imageId';
}

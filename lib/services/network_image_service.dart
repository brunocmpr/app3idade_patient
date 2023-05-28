import 'package:app3idade_patient/services/api.dart';
import 'package:flutter/material.dart';

class NetworkImageService {
  final baseUri = '/images';

  Image createImageWidget(MapEntry<int, int> entry) {
    return Image.network(
      buildFullUrl(entry.value),
      headers: API.headerAuthorization,
      width: 100,
      height: 100,
      fit: BoxFit.contain,
    );
  }

  String buildFullUrl(int imageId) => 'http://${API.url}$baseUri/$imageId';
}

import 'package:app3idade_patient/models/dose.dart';
import 'package:app3idade_patient/models/patient.dart';
import 'package:app3idade_patient/models/drug.dart';
import 'package:app3idade_patient/models/patient.dart';
import 'package:app3idade_patient/routes/routes.dart';
import 'package:app3idade_patient/services/network_image_service.dart';
import 'package:app3idade_patient/views/image_hero_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class DoseDisplay extends StatelessWidget {
  final networkImageService = NetworkImageService();
  final Dose? _dose;
  static const _titleSize = 30.0;
  static const _htmlBodySize = 28.0;
  static const _thumbnailSize = 100.0;

  DoseDisplay(this._dose, {super.key});

  Widget buildHeroThumbnail(int imageId, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.imageHeroPage,
          arguments: imageId,
        );
      },
      child: Hero(
        tag: imageId,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: networkImageService.createImageWidget(imageId,
              height: _thumbnailSize, width: _thumbnailSize, fit: BoxFit.contain),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_dose == null) {
      return Container(
        decoration: BoxDecoration(color: Colors.grey.shade300),
        child: const Center(
          child: Text('Nenhum medicamento selecionado', style: TextStyle(fontSize: 20, color: Colors.black)),
        ),
      );
    }

    Widget profilePicture;
    if (_dose!.drugPlan.patient.imageIds != null && _dose!.drugPlan.patient.imageIds!.isNotEmpty) {
      profilePicture = buildHeroThumbnail(_dose!.drugPlan.patient.imageIds!.asMap().entries.first.value, context);
    } else {
      profilePicture = const Icon(Icons.account_box, size: _thumbnailSize, color: Colors.grey);
    }

    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade300),
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Positioned(top: 0, right: 0, child: profilePicture),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, _thumbnailSize + 20, 0),
                child: Column(
                  children: [
                    Text(
                      "${_dose!.drugPlan.drug.name} - ${_dose!.drugPlan.patient.preferredName}",
                      style: const TextStyle(fontSize: _titleSize),
                    ),
                    if (_dose!.drugPlan.drug.imageIds != null && _dose!.drugPlan.drug.imageIds!.isNotEmpty)
                      const SizedBox(height: 16),
                    if (_dose!.drugPlan.drug.imageIds != null && _dose!.drugPlan.drug.imageIds!.isNotEmpty)
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: _dose!.drugPlan.drug.imageIds!
                            .asMap()
                            .entries
                            .map((entry) => buildHeroThumbnail(entry.value, context))
                            .toList(),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (_dose!.drugPlan.drug.instructions != null)
                Expanded(
                  child: SingleChildScrollView(
                    child: Html(
                      data: _dose!.drugPlan.drug.instructions,
                      style: {"body": Style(fontSize: const FontSize(_htmlBodySize))},
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

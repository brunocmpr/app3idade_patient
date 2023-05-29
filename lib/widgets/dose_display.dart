import 'package:app3idade_patient/models/dose.dart';
import 'package:app3idade_patient/models/patient.dart';
import 'package:app3idade_patient/models/drug.dart';
import 'package:app3idade_patient/models/patient.dart';
import 'package:app3idade_patient/services/network_image_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class DoseDisplay extends StatelessWidget {
  final networkImageService = NetworkImageService();
  final Dose? _dose;
  static const _titleSize = 30.0;
  static const _htmlBodySize = 24.0;

  DoseDisplay(this._dose, {super.key});

  Widget buildThumbnail(MapEntry<int, int> entry) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: networkImageService.createImageWidget(entry.value, height: 100, width: 100, fit: BoxFit.contain),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_dose == null) {
      return Container(
        decoration: BoxDecoration(color: Colors.grey.shade300),
        child: const Center(
          child: Text('Nenhum medicamento selecionado'),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade300),
      padding: const EdgeInsets.all(16),
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
              children: _dose!.drugPlan.drug.imageIds!.asMap().entries.map(buildThumbnail).toList(),
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
    );
  }
}

import 'package:app3idade_patient/models/dose.dart';
import 'package:app3idade_patient/models/patient.dart';
import 'package:app3idade_patient/models/drug.dart';
import 'package:app3idade_patient/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class DoseDisplay extends StatelessWidget {
  final Dose? _dose;
  static const _titleSize = 30.0;
  static const _htmlBodySize = 24.0;

  const DoseDisplay(this._dose, {super.key});

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${_dose!.drugPlan.drug.name} - ${_dose!.drugPlan.patient.preferredName}",
              style: const TextStyle(fontSize: _titleSize),
            ),
            const SizedBox(height: 16),
            if (_dose!.drugPlan.drug.instructions != null)
              Html(
                data: _dose!.drugPlan.drug.instructions,
                style: {
                  "body":
                      Style(fontSize: const FontSize(_htmlBodySize)), // Increase the font size as per your preference
                },
              ),
          ],
        ));
  }
}

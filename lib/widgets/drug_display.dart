import 'package:app3idade_patient/models/dose.dart';
import 'package:flutter/material.dart';

class DrugDisplay extends StatelessWidget {
  final Dose? _dose;

  const DrugDisplay(this._dose, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade300),
      child: Center(
        child: Text((_dose != null) ? _dose!.drugPlan.drug.nameAndStrength : 'Nenhum medicamento selecionado'),
      ),
    );
  }
}

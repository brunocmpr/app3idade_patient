import 'package:app3idade_patient/models/dose.dart';
import 'package:app3idade_patient/util/util.dart';
import 'package:flutter/material.dart';

class DoseListItem extends StatelessWidget {
  final Dose _dose;
  final ValueChanged<Dose> _valueChanged;
  const DoseListItem(this._dose, this._valueChanged, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(formatDateTime(_dose.dateTime)),
        subtitle: Text(_dose.drugPlan.patient.preferredName),
        trailing: Text(_dose.drugPlan.drug.nameAndStrength),
        onTap: () {
          _valueChanged.call(_dose);
        },
      ),
    );
  }
}

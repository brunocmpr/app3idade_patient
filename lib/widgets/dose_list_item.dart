import 'package:app3idade_patient/models/dose.dart';
import 'package:app3idade_patient/models/drug_plan.dart';
import 'package:app3idade_patient/models/patient.dart';
import 'package:app3idade_patient/services/network_image_service.dart';
import 'package:app3idade_patient/util/util.dart';
import 'package:flutter/material.dart';

class DoseListItem extends StatelessWidget {
  final Dose _dose;
  final ValueChanged<Dose> _valueChanged;
  final networkImageService = NetworkImageService();
  DoseListItem(this._dose, this._valueChanged, {super.key});

  @override
  Widget build(BuildContext context) {
    Widget profilePicture;
    if (_dose.drugPlan.patient.imageIds != null && _dose.drugPlan.patient.imageIds!.isNotEmpty) {
      profilePicture = networkImageService.createImageWidget(
        _dose.drugPlan.patient.imageIds!.asMap().entries.first.value,
        height: 100,
        width: 100,
        fit: BoxFit.cover,
      );
    } else {
      profilePicture = const Placeholder(
        fallbackHeight: 100,
        fallbackWidth: 100,
      );
    }
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

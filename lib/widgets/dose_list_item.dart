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
    const photoSize = 64.0;
    if (_dose.drugPlan.patient.imageIds != null && _dose.drugPlan.patient.imageIds!.isNotEmpty) {
      profilePicture = networkImageService.createImageWidget(
        _dose.drugPlan.patient.imageIds!.asMap().entries.first.value,
        height: photoSize,
        width: photoSize,
        fit: BoxFit.cover,
      );
    } else {
      profilePicture = const Icon(Icons.account_box, size: photoSize, color: Colors.grey);
    }
    return Card(
      child: Row(
        children: [
          const SizedBox(width: 4),
          profilePicture,
          Expanded(
            child: ListTile(
              title: Text(formatDateTime(_dose.dateTime), style: const TextStyle(fontSize: 24, color: Colors.black)),
              subtitle:
                  Text(_dose.drugPlan.patient.preferredName, style: const TextStyle(fontSize: 24, color: Colors.black)),
              trailing: Container(
                constraints: const BoxConstraints(maxWidth: 280),
                child: Text(
                  _dose.drugPlan.drug.nameAndStrength,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 24, color: Colors.black),
                ),
              ),
              onTap: () => _valueChanged.call(_dose),
            ),
          ),
        ],
      ),
    );
  }
}

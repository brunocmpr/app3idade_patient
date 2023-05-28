import 'package:app3idade_patient/models/dose.dart';
import 'package:app3idade_patient/widgets/dose_list_item.dart';
import 'package:flutter/material.dart';

class DoseList extends StatelessWidget {
  final List<Dose>? _doses;
  final ValueChanged<Dose> _valueChanged;
  const DoseList(this._doses, this._valueChanged, {super.key});

  @override
  Widget build(BuildContext context) {
    if (_doses == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (_doses!.isEmpty) {
      return const Center(child: Text('Nenhuma dose para as próximas horas.'));
    }

    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: ListView.builder(
        itemCount: _doses!.length,
        itemBuilder: (context, index) {
          return DoseListItem(_doses![index], _valueChanged);
        },
      ),
    );
  }
}

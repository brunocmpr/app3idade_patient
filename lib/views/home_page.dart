import 'package:app3idade_patient/models/custom_posology.dart';
import 'package:app3idade_patient/models/dose.dart';
import 'package:app3idade_patient/models/drug.dart';
import 'package:app3idade_patient/models/drug_plan.dart';
import 'package:app3idade_patient/models/patient.dart';
import 'package:app3idade_patient/widgets/dose_list.dart';
import 'package:app3idade_patient/widgets/drug_display.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({Key? key, required this.token}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Dose> _doses;
  Dose? _selectedDose;
  static const double padding = 16;

  @override
  void initState() {
    super.initState();
    _loadData();
    if (_doses.isNotEmpty) {
      _selectedDose = _doses[0];
    }
  }

  void _loadData() {
    _doses = [
      Dose(
        DateTime.now().add(const Duration(hours: 1)),
        DrugPlan(1, Patient(1, 'Geraldo', 'Campera'), Drug(1, 'Paracetamol', '250 mg', [], null), PosologyType.custom,
            null, [
          CustomPosology(
            1,
            DateTime.now().add(const Duration(hours: 1)),
          )
        ]),
      ),
      Dose(
        DateTime.now().add(const Duration(hours: 2)),
        DrugPlan(
            1, Patient(1, 'Sônia', 'Campera'), Drug(1, 'Divalcon ER', '500 mg', [], null), PosologyType.custom, null, [
          CustomPosology(
            1,
            DateTime.now().add(const Duration(hours: 2)),
          )
        ]),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.greenAccent),
        child: Padding(
          padding: const EdgeInsets.all(padding),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: DoseList(
                  _doses,
                  (Dose dose) => setState(() {
                    _selectedDose = dose;
                  }),
                ),
              ),
              const SizedBox(width: padding),
              Expanded(
                flex: 6,
                child: DrugDisplay(_selectedDose),
              )
            ],
          ),
        ),
      ),
    );
  }
}

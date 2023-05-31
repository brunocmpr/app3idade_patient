import 'dart:async';

import 'package:app3idade_patient/models/dose.dart';
import 'package:app3idade_patient/services/dose_service.dart';
import 'package:app3idade_patient/widgets/dose_list.dart';
import 'package:app3idade_patient/widgets/dose_display.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({Key? key, required this.token}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _doseService = DoseService();
  List<Dose>? _doses;
  Dose? _selectedDose;
  static const double _padding = 16;
  static const int _refreshIntervalMinutes = 10;
  late Timer _timer = Timer.periodic(const Duration(minutes: _refreshIntervalMinutes), (Timer t) => _loadData());

  @override
  void initState() {
    super.initState();
    _loadData();
    if (_doses != null && _doses!.isNotEmpty) {
      _selectedDose = _doses![0];
    }
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    var doses = await _doseService.findNextDoses();
    setState(() {
      _doses = doses;
      if (_selectedDose == null && _doses != null && _doses!.isNotEmpty) {
        _selectedDose = _doses![0];
      }
    });
  }

  void startTimer() {
    if (_timer.isActive) return;
    _timer = Timer.periodic(const Duration(minutes: _refreshIntervalMinutes), (Timer t) => _loadData());
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
          padding: const EdgeInsets.all(_padding),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: DoseList(
                  _doses,
                  selectedDoseChanged: (dose) {
                    setState(() {
                      _selectedDose = dose;
                    });
                  },
                  refreshRequested: (value) async {
                    _timer.cancel();
                    await _loadData();
                    startTimer();
                  },
                ),
              ),
              const SizedBox(width: _padding),
              Expanded(
                flex: 6,
                child: DoseDisplay(_selectedDose),
              )
            ],
          ),
        ),
      ),
    );
  }
}

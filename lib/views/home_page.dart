import 'dart:async';

import 'package:app3idade_patient/models/dose.dart';
import 'package:app3idade_patient/services/auth_service.dart';
import 'package:app3idade_patient/services/dose_service.dart';
import 'package:app3idade_patient/util/util.dart';
import 'package:app3idade_patient/widgets/dose_list.dart';
import 'package:app3idade_patient/widgets/dose_display.dart';
import 'package:app3idade_patient/widgets/animated_icon_button.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({Key? key, required this.token}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _doseService = DoseService();
  final _authService = AuthService();
  List<Dose>? _doses;
  Dose? _selectedDose;
  static const double _padding = 16;
  static const int _refreshIntervalMinutes = 2;
  late Timer _refreshTimer = Timer.periodic(const Duration(seconds: _refreshIntervalMinutes), (Timer t) => _loadData());
  String? _currentDateTime;

  final List<Dose> _alertDoses = [];
  Timer? _alertTimer;
  final _audioPlayer = AudioPlayer();
  bool _isAlertState = false;
  static const _alertAudioPath = 'audios/alert.wav';

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _loadData();
    if (_doses != null && _doses!.isNotEmpty) {
      _selectedDose = _doses![0];
    }
    _startTimer();
    _setAudioPlayer();
  }

  void _setAudioPlayer() {
    _audioPlayer.setVolume(1);
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    _alertTimer?.cancel();
    _audioPlayer.release();
    super.dispose();
  }

  Future<void> _loadData() async {
    _alertTimer?.cancel();
    var doses = await _doseService.findNextDoses();
    setState(() {
      _doses = doses;
      if (_selectedDose == null && _doses != null && _doses!.isNotEmpty) {
        _selectedDose = _doses![0];
      }
      _scheduleAlert();
    });
  }

  void _scheduleAlert() {
    if (_doses != null && _doses!.isNotEmpty) {
      final nextDose = _doses![0];
      final timeUntilNextDose = nextDose.dateTime.difference(DateTime.now());

      if (timeUntilNextDose.inMilliseconds > 0) {
        _alertTimer = Timer(timeUntilNextDose, _executeAlert);
      }
    }
  }

  void _executeAlert() {
    if (_doses == null) return;
    pushDosesToAlertQueue();
    _startAlert();
  }

  void _startAlert() {
    _audioPlayer.play(AssetSource(_alertAudioPath));
    setState(() {
      _isAlertState = true;
    });
  }

  void _stopAlert() {
    _audioPlayer.stop();
    setState(() {
      _isAlertState = false;
    });
  }

  void pushDosesToAlertQueue() {
    setState(() {
      final matchingDoses = _doses!.where((dose) => dose.dateTime.isAtSameMomentAs(_doses![0].dateTime)).toList();
      _alertDoses.addAll(matchingDoses);
      _selectedDose = _alertDoses[0];
      _doses!.removeWhere((dose) => matchingDoses.contains(dose));
    });
  }

  void _startTimer() {
    if (_refreshTimer.isActive) return;
    _refreshTimer = Timer.periodic(const Duration(minutes: _refreshIntervalMinutes), (Timer t) => _loadData());
  }

  String _getGreetings() {
    var hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "Bom dia";
    } else if (hour >= 12 && hour < 18) {
      return "Boa tarde";
    }
    return "Boa noite";
  }

  void _updateDateTime() {
    final now = DateTime.now();
    var formattedDateTime = formatDateTimeSeconds(now);
    setState(() {
      _currentDateTime = formattedDateTime;
    });
    Future.delayed(const Duration(seconds: 1)).then((_) => _updateDateTime());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Center(child: Text('${_getGreetings()}! ${_currentDateTime ?? ''}', style: const TextStyle(fontSize: 24))),
        actions: [
          IconButton(
            onPressed: () {
              _authService.logoutAndGoToLogin(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.greenAccent),
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          child: Row(
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  children: [
                    Visibility(
                      visible: _isAlertState,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Expanded(
                            child: Text(
                              'Lembrete de horário! Para desligar o alarme, pressione o botão:',
                              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                          ),
                          AnimatedIconButton(
                            iconSize: 80,
                            onPressed: () {
                              _stopAlert();
                            },
                            startColor: Colors.yellow.shade800,
                            endColor: Colors.red.shade700,
                            icon: Icons.alarm_rounded,
                            iconColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !_isAlertState && _alertDoses.isNotEmpty,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            constraints: const BoxConstraints(maxWidth: 350),
                            child: Text(
                              'Após tomar o${_alertDoses.length > 1 ? 's' : ''}'
                              ' ${_alertDoses.length > 1 ? _alertDoses.length : ''}'
                              ' medicamento${_alertDoses.length > 1 ? 's' : ''} abaixo, pressione o botão:',
                              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                          ),
                          AnimatedIconButton(
                            iconSize: 80,
                            onPressed: () {
                              clearAlertDoses();
                            },
                            startColor: Colors.green.shade500,
                            endColor: Colors.green.shade800,
                            iconColor: Colors.white,
                            icon: Icons.done,
                          ),
                        ],
                      ),
                    ),
                    Visibility(visible: _alertDoses.isNotEmpty, child: const SizedBox(height: 16.0)),
                    Expanded(
                      child: DoseList(
                        _alertDoses.isEmpty ? _doses : _alertDoses,
                        selectedDoseChanged: (dose) {
                          setState(() {
                            _selectedDose = dose;
                          });
                        },
                        refreshRequested: (value) async {
                          _refreshTimer.cancel();
                          await _loadData();
                          _startTimer();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: _padding),
              Expanded(
                flex: 8,
                child: DoseDisplay(_selectedDose),
              )
            ],
          ),
        ),
      ),
    );
  }

  void clearAlertDoses() {
    _alertDoses.clear();
    setState(() {
      if (_doses!.isNotEmpty) {
        _selectedDose = _doses![0];
      } else {
        _selectedDose = null;
      }
    });
  }
}

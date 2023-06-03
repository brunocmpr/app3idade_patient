import 'dart:async';

import 'package:app3idade_patient/models/dose.dart';
import 'package:app3idade_patient/services/auth_service.dart';
import 'package:app3idade_patient/services/dose_service.dart';
import 'package:app3idade_patient/util/util.dart';
import 'package:app3idade_patient/widgets/dose_list.dart';
import 'package:app3idade_patient/widgets/dose_display.dart';
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
  bool _isAudioPlaying = false;
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
    playAlertAudio();
  }

  void playAlertAudio() {
    _audioPlayer.play(AssetSource(_alertAudioPath));
    setState(() {
      _isAudioPlaying = true;
    });
  }

  void _stopAudio() {
    _audioPlayer.stop();
    setState(() {
      _isAudioPlaying = false;
    });
  }

  void pushDosesToAlertQueue() {
    setState(() {
      final matchingDoses = _doses!.where((dose) => dose.dateTime.isAtSameMomentAs(_doses![0].dateTime)).toList();
      _alertDoses.addAll(matchingDoses);
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
        title: Center(child: Text('${_getGreetings()}! ${_currentDateTime ?? ''}')),
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
                flex: 4,
                child: DoseList(
                  _doses,
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

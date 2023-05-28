import 'package:app3idade_patient/models/dose.dart';
import 'package:app3idade_patient/models/drug_plan.dart';
import 'package:app3idade_patient/models/uniform_posology.dart';
import 'package:app3idade_patient/services/drug_plan_service.dart';
import 'package:flutter/material.dart';

class DoseService {
  final Duration durationFromNow;
  final drugPlanService = DrugPlanService();

  DoseService({this.durationFromNow = const Duration(hours: 24)});

  Future<List<Dose>> findNextDoses() async {
    List<DrugPlan> plans = await drugPlanService.findAll();
    List<Dose> dosesCustomPosology = extractNextCustomPosologyDoses(plans);
    List<Dose> dosesWeeklyPosology = extractNextWeeklyPosologyDoses(plans);
    List<Dose> dosesUniformPosology = extractNextUniformPosologyDoses(plans);
    List<Dose> doses = [...dosesCustomPosology, ...dosesWeeklyPosology, ...dosesUniformPosology];
    doses.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return doses;
  }

  List<Dose> extractNextCustomPosologyDoses(List<DrugPlan> drugPlans) {
    List<DrugPlan> customPosologyPlans = drugPlans.where((plan) => plan.customPosologies != null).toList();
    List<Dose> doses = [];
    for (var plan in customPosologyPlans) {
      for (var posology in plan.customPosologies!) {
        if (posology.dateTime.isAfter(DateTime.now()) &&
            posology.dateTime.isBefore(DateTime.now().add(durationFromNow))) {
          doses.add(Dose(posology.dateTime, plan));
        }
      }
    }
    return doses;
  }

  List<Dose> extractNextWeeklyPosologyDoses(List<DrugPlan> plans) {
    List<DrugPlan> weeklyPosologyPlans = plans.where((plan) => plan.weeklyPosology != null).toList();
    List<Dose> doses = [];

    DateTime now = DateTime.now();
    DateTime endDateTime = now.add(durationFromNow);

    for (var plan in weeklyPosologyPlans) {
      DateTime startDateTime = plan.weeklyPosology!.startDateTime;
      if (startDateTime.isBefore(endDateTime)) {
        for (var weeklyPosologyDateTime in plan.weeklyPosology!.weeklyPosologyDateTimes) {
          int dayOfWeek = weeklyPosologyDateTime.dayOfWeek;
          TimeOfDay time = weeklyPosologyDateTime.time;

          DateTime dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
          while (dateTime.isBefore(endDateTime)) {
            if (dateTime.weekday == dayOfWeek) {
              if (dateTime.isAfter(now)) {
                doses.add(Dose(dateTime, plan));
              }
            }
            dateTime = dateTime.add(const Duration(days: 1));
          }
        }
      }
    }

    return doses;
  }

  List<Dose> extractNextUniformPosologyDoses(List<DrugPlan> plans) {
    List<DrugPlan> uniformPosologyPlans = plans.where((plan) => plan.uniformPosology != null).toList();
    List<Dose> doses = [];

    DateTime now = DateTime.now();
    DateTime endDateTime = now.add(durationFromNow);

    for (var plan in uniformPosologyPlans) {
      DateTime startDateTime = plan.uniformPosology!.startDateTime;
      DateTime? planEndDateTime = plan.uniformPosology!.endDateTime;

      int timeLength = plan.uniformPosology!.timeLength;
      TimeUnit timeUnit = plan.uniformPosology!.timeUnit;

      Duration interval;

      if (timeUnit == TimeUnit.hour) {
        interval = Duration(hours: timeLength);
      } else if (timeUnit == TimeUnit.minute) {
        interval = Duration(minutes: timeLength);
      } else {
        interval = Duration(days: timeLength);
      }

      DateTime dateTime = startDateTime;

      while (dateTime.isBefore(planEndDateTime ?? endDateTime)) {
        if (dateTime.isAfter(now) && dateTime.isBefore(endDateTime)) {
          doses.add(Dose(dateTime, plan));
        }
        dateTime = dateTime.add(interval);
      }
    }

    return doses;
  }
}

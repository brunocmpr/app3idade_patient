import 'package:app3idade_patient/models/drug_plan.dart';
import 'package:app3idade_patient/repository/drug_plan_repository.dart';

class DrugPlanService {
  final drugPlanRepository = DrugPlanRepository();

  Future<DrugPlan> createDrugPlan(DrugPlan drugPlan) {
    return drugPlanRepository.createDrugPLan(drugPlan);
  }

  Future<List<DrugPlan>> findAll() {
    return drugPlanRepository.findAll();
  }
}

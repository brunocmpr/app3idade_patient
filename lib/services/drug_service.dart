import 'dart:io';

import 'package:app3idade_patient/models/drug.dart';
import 'package:app3idade_patient/repository/drug_repository.dart';

class DrugService {
  DrugRepository drugRepository = DrugRepository();

  Future<Drug> createDrug(Drug drug, List<File>? images) {
    return drugRepository.create(drug, images);
  }

  Future<List<Drug>> findAll() {
    return drugRepository.findAll();
  }
}

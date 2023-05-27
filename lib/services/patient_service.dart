import 'dart:io';

import 'package:app3idade_patient/models/patient.dart';
import 'package:app3idade_patient/repository/patient_repository.dart';

class PatientService {
  PatientRepository patientRepository = PatientRepository();

  Future<Patient> findById(int id) async {
    return patientRepository.deleteById(id);
  }

  Future<Patient> createPatient(Patient user, List<File>? images) async {
    return patientRepository.create(user, images);
  }

  Future<Patient> createUpdateUser(Patient user) async {
    return patientRepository.update(user);
  }

  Future<Patient> deleteUserById(int id) async {
    return patientRepository.deleteById(id);
  }

  Future<List<Patient>> findAll() {
    return patientRepository.findAll();
  }
}

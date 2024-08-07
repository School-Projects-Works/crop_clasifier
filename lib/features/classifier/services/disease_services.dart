import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_clasifier/features/classifier/data/disease_model.dart';

class DiseaseServices {
  static final CollectionReference _reference =
      FirebaseFirestore.instance.collection('diseases');

  static String getDiseaseId() {
    return _reference.doc().id;
  }

  static Future<bool> createDisease(DiseaseModel disease) async {
    try {
      await _reference.doc(disease.id).set(disease.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateDisease(
      String id, Map<String, dynamic> disease) async {
    try {
      await _reference.doc(id).update(disease);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteDisease(String id) async {
    try {
      await _reference.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<DiseaseModel?> getDiseaseById(String id) async {
    try {
      var data = await _reference.doc(id).get();
      if (data.exists) {
        return DiseaseModel.fromMap(data.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }
}

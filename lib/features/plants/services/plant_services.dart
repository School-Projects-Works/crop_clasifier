import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/plant_model.dart';

class PlantServices {
  static CollectionReference plantCollection =
      FirebaseFirestore.instance.collection('plants');

  static String plantId = plantCollection.doc().id;

  static Future<bool> addPlant(PlantModel plant) async {
    try {
      await plantCollection.doc(plant.id).set(plant.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updatePlant(PlantModel plant) async {
    try {
      await plantCollection.doc(plant.id).update(plant.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deletePlant(String plantId) async {
    try {
      await plantCollection.doc(plantId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Stream<List<PlantModel>> getPlants() {
    return plantCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => PlantModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }

  static Future<PlantModel?> getPlantById(String id) async {
    try {
      var data = await plantCollection.doc(id).get();
      if (data.exists) {
        return PlantModel.fromMap(data.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (error) {
      print("Error $error");
      return null;
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:crop_clasifier/core/dummy_data.dart';
import 'package:crop_clasifier/features/plants/data/plant_model.dart';
import 'package:crop_clasifier/features/plants/services/plant_services.dart';

final dummyDataProvider = FutureProvider<void>((ref) async {
  // var plants = dummyCrops.toList();
  // for (var plant in plants) {
  //   var id = PlantServices.plantCollection.doc().id;
  //  var crop =PlantModel(
  //     id:id,
  //     createdAt: DateTime.now().millisecondsSinceEpoch,
  //     name: plant['title'],
  //     description: plant['description'],
  //     imageUrl: plant['imageUrl'],
  //     category: plant['category']??'',
  //   );
  //   await PlantServices.addPlant(crop);
  //}
});

final plantSreamProvider =
    StreamProvider.autoDispose<List<PlantModel>>((ref) async* {
  var plants = PlantServices.getPlants();
  await for (var plant in plants) {
    ref.read(plantsProvider.notifier).setPlants(plant);
    yield plant;
  }
});

class PlantsFilter {
  List<PlantModel> list;
  List<PlantModel> filter;
  PlantsFilter({
    required this.list,
    required this.filter,
  });

  PlantsFilter copyWith({
    List<PlantModel>? list,
    List<PlantModel>? filter,
  }) {
    return PlantsFilter(
      list: list ?? this.list,
      filter: filter ?? this.filter,
    );
  }
}


final plantsProvider = StateNotifierProvider<PlantsProvider, PlantsFilter>((ref) {
  return PlantsProvider();
});

class PlantsProvider extends StateNotifier<PlantsFilter> {
  PlantsProvider() : super(PlantsFilter(list: [], filter: []));

 void setPlants(List<PlantModel> plants) {
    state = state.copyWith(list: plants, filter: plants);
  }

  void filterPlants(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filter: state.list);
    } else {
      var filtered = state.list
          .where((element) =>
              element.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      state = state.copyWith(filter: filtered);
    }
  }
}
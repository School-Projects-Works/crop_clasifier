import 'dart:convert';

class PlantModel {
  String id;
  String name;
  String description;
  String imageUrl;
  String category;
  int createdAt;
  PlantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.createdAt,
  });

  PlantModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? category,
    int? createdAt,
  }) {
    return PlantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'description': description});
    result.addAll({'imageUrl': imageUrl});
    result.addAll({'category': category});
    result.addAll({'createdAt': createdAt});
  
    return result;
  }

  factory PlantModel.fromMap(Map<String, dynamic> map) {
    return PlantModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      createdAt: map['createdAt']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlantModel.fromJson(String source) => PlantModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlantModel(id: $id, name: $name, description: $description, imageUrl: $imageUrl, category: $category, CreatedAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PlantModel &&
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.imageUrl == imageUrl &&
      other.category == category &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      imageUrl.hashCode ^
      category.hashCode ^
      createdAt.hashCode;
  }
}







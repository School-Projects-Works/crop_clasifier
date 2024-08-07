import 'dart:convert';

class DiseaseModel {
  String id;
  String name;
  String description;
  String imageUrl;
  int createdAt;
  DiseaseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
  });

  DiseaseModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    int? createdAt,
  }) {
    return DiseaseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'description': description});
    result.addAll({'imageUrl': imageUrl});
    result.addAll({'createdAt': createdAt});
  
    return result;
  }

  factory DiseaseModel.fromMap(Map<String, dynamic> map) {
    return DiseaseModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdAt: map['createdAt']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DiseaseModel.fromJson(String source) => DiseaseModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DiseaseModel(id: $id, name: $name, description: $description, imageUrl: $imageUrl, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is DiseaseModel &&
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.imageUrl == imageUrl &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      imageUrl.hashCode ^
      createdAt.hashCode;
  }
}

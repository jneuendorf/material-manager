
class InspectionModel {
  final int? id;
  final int inspectorId; // references User.id
  final int materialId; // references Material.id
  DateTime date;
  InspectionType type;
  Comment comment;

  InspectionModel({
    required this.id,
    required this.inspectorId,
    required this.materialId,
    required this.date,
    required this.type,
    required this.comment,
  });

  factory InspectionModel.fromJson(Map<String, dynamic> json) => InspectionModel(
    id: json['id'],
    inspectorId: json['inspector_id'],
    materialId: json['material_id'],
    date: DateTime.parse(json['date']),
    type: InspectionType.values.byName(json['type']),
    comment: Comment.fromJson(json['comment']),
  );
}

enum InspectionType {
  psaInspection,
  sightInspection,
}

class Comment {
  final int? id;
  DateTime date;
  String text;
  String? imagePath;

  Comment({
    required this.id,
    required this.date,
    required this.text,
    this.imagePath,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json['id'],
    date: DateTime.parse(json['date']),
    text: json['text'],
    imagePath: json['image_path'],
  );
}

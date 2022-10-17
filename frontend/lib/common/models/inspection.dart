
class InspectionModel {
  final int id;
  final int inspectorId; // references User.id
  final int materialId; // references Material.id
  DateTime date;
  InspectionType type;
  List<Comment> comments;

  InspectionModel({
    required this.id,
    required this.inspectorId,
    required this.materialId,
    required this.date,
    required this.type,
    required this.comments,
  });

  factory InspectionModel.fromJson(Map<String, dynamic> json) => InspectionModel(
    id: json['id'],
    inspectorId: json['inspectorId'],
    materialId: json['materialId'],
    date: DateTime.parse(json['date']),
    type: InspectionType.values.byName(json['type']),
    comments: List<Comment>.from(json['comments'].map((x) => Comment.fromJson(x))),
  );
}

enum InspectionType {
  psaInspection,
  sightInspection,
}

class Comment {
  final int id;
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
    imagePath: json['imagePath'],
  );
}

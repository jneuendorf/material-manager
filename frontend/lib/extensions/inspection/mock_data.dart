import 'package:frontend/extensions/inspection/model.dart';


final Comment mockComment1 = Comment(
  id: 1,
  date: DateTime.now(),
  text: 'This is a comment',
  imagePath: 'https://picsum.photos/250?image=1',
);

final Comment mockComment2 = Comment(
  id: 2,
  date: DateTime.now(),
  text: 'This is another comment',
  imagePath: 'https://picsum.photos/250?image=1',
);

final Comment mockComment3 = Comment(
  id: 3,
  date: DateTime.now(),
  text: 'This is a third comment',
  imagePath: 'https://picsum.photos/250?image=1',
);

List<InspectionModel> mockInspections = [
  InspectionModel(
    id: 1,
    inspectorId: 3,
    materialId: 1,
    date: DateTime.now(),
    type: InspectionType.psaInspection,
    comment: mockComment1,
  ),
  InspectionModel(
    id: 2,
    inspectorId: 3,
    materialId: 1,
    date: DateTime.now(),
    type: InspectionType.sightInspection,
    comment: mockComment3,
  ),
  InspectionModel(
    id: 3,
    inspectorId: 3,
    materialId: 1,
    date: DateTime.now(),
    type: InspectionType.psaInspection,
    comment: mockComment2,
  ),
];

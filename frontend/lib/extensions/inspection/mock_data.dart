import 'package:frontend/extensions/inspection/inspection.dart';


final Comment mockComment1 = Comment(
  id: 1,
  date: DateTime.now(),
  text: 'This is a comment',
  imagePath: 'https://www.bfgcdn.com/1500_1500_90/324-0051-0111/stubai-minikarabiner-materialkarabiner.jpg',
);

final Comment mockComment2 = Comment(
  id: 2,
  date: DateTime.now(),
  text: 'This is another comment',
  imagePath: 'https://www.bfgcdn.com/1500_1500_90/324-0051-0111/stubai-minikarabiner-materialkarabiner.jpg',
);

final Comment mockComment3 = Comment(
  id: 3,
  date: DateTime.now(),
  text: 'This is a third comment',
  imagePath: 'https://www.bfgcdn.com/1500_1500_90/324-0051-0111/stubai-minikarabiner-materialkarabiner.jpg',
);

List<InspectionModel> mockInspections = [
  InspectionModel(
    id: 1,
    inspectorId: 3,
    materialId: 1,
    date: DateTime.now(),
    type: InspectionType.psaInspection,
    comments: [
      mockComment1, 
      mockComment2,
    ],
  ),
  InspectionModel(
    id: 2,
    inspectorId: 2,
    materialId: 1,
    date: DateTime.now(),
    type: InspectionType.sightInspection,
    comments: [
      mockComment3,
    ],
  ),
  InspectionModel(
    id: 3,
    inspectorId: 3,
    materialId: 1,
    date: DateTime.now(),
    type: InspectionType.psaInspection,
    comments: [
      mockComment1, 
      mockComment2, 
      mockComment3,
    ],
  ),
];

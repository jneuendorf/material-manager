
class Rental {
  final int id;
  final int customerId;  // references User.id
  final int lenderId;   // references User.id
  final int returnToId; // references User.id
  final List<int> materialIds; // references Material.id
  double cost;
  double deposit;
  RentalStatus status;
  DateTime createdAt;
  DateTime startDate;
  DateTime endDate;
  DateTime usageStartDate;
  DateTime usageEndDate;

  Rental({
    required this.id,
    required this.customerId,
    required this.lenderId,
    required this.returnToId,
    required this.materialIds,
    required this.cost,
    required this.deposit,
    required this.status,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
    required this.usageStartDate,
    required this.usageEndDate,
  });

  factory Rental.fromJson(Map<String, dynamic> json) => Rental(
    id: json['id'],
    customerId: json['customerId'],
    lenderId: json['lenderId'],
    returnToId: json['returnToId'],
    materialIds: List<int>.from(json['materialIds'].map((x) => x)),
    cost: json['cost'],
    deposit: json['deposit'],
    status: RentalStatus.fromJson(json['status']),
    createdAt: DateTime.parse(json['createdAt']),
    startDate: DateTime.parse(json['startDate']),
    endDate: DateTime.parse(json['endDate']),
    usageStartDate: DateTime.parse(json['usageStartDate']),
    usageEndDate: DateTime.parse(json['usageEndDate']),
  );
}

class RentalStatus {
  final int id;
  String name;

  RentalStatus({
    required this.id,
    required this.name,
  });

  factory RentalStatus.fromJson(Map<String, dynamic> json) => RentalStatus(
    id: json['id'],
    name: json['name'],
  );
}
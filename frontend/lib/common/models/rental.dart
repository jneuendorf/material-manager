
class RentalModel {
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

  RentalModel({
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

  factory RentalModel.fromJson(Map<String, dynamic> json) => RentalModel(
    id: json['id'],
    customerId: json['customer_id'],
    lenderId: json['lender_id'],
    returnToId: json['return_to_id'],
    materialIds: List<int>.from(json['material_ids'].map((x) => x)),
    cost: json['cost'],
    deposit: json['deposit'],
    status: RentalStatus.fromJson(json['status']),
    createdAt: DateTime.parse(json['created_at']),
    startDate: DateTime.parse(json['start_date']),
    endDate: DateTime.parse(json['end_date']),
    usageStartDate: DateTime.parse(json['usage_start_date']),
    usageEndDate: DateTime.parse(json['usage_end_date']),
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
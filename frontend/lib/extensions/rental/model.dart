
class RentalModel {
  final int? id;
  final int? customerId;  // references User.id
  final int? lenderId;   // references User.id
  final int? returnToId; // references User.id
  final List<int> materialIds; // references Material.id
  double cost;
  double? deposit;
  RentalStatus? status;
  DateTime createdAt;
  DateTime startDate;
  DateTime endDate;
  DateTime? usageStartDate;
  DateTime? usageEndDate;

  RentalModel({
    this.id,
    this.customerId,
    this.lenderId,
    this.returnToId,
    required this.materialIds,
    required this.cost,
    this.deposit,
    this.status,
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
    materialIds: List<int>.from(json['materials'].map((x) => x['id'])),
    cost: json['cost'],
    deposit: json['deposit'],
    status: RentalStatus.values.byName(json['rental_status'].toLowerCase()),
    // status: RentalStatus.fromJson(json['rental_status']),
    createdAt: DateTime.parse(json['created_at']),
    startDate: DateTime.parse(json['start_date']),
    endDate: DateTime.parse(json['end_date']),
    usageStartDate: DateTime.tryParse(json['usage_start_date'] ?? ''),
    usageEndDate: DateTime.tryParse(json['usage_end_date'] ?? ''),
  );
}

enum RentalStatus {
  lent,
  available,
  unavailable,
  returned,
}

// class RentalStatus {
//   final int id;
//   String name;

//   RentalStatus({
//     required this.id,
//     required this.name,
//   });

//   factory RentalStatus.fromJson(Map<String, dynamic> json) => RentalStatus(
//     id: json['id'],
//     name: json['name'],
//   );
// }
import 'package:frontend/extensions/rental/model.dart';


// final RentalStatus mockRentedRentalStatus = RentalStatus(
//   id: 1, 
//   name: 'rented',
// );

// final RentalStatus mockAvailibleRentalStatus = RentalStatus(
//   id: 2, 
//   name: 'availible',
// );

// final RentalStatus mockReturnedRentalStatus = RentalStatus(
//   id: 3, 
//   name: 'returned',
// );


final List<RentalModel> mockRentals = [
  RentalModel(
    id: 1, 
    customerId: 1, 
    lenderId: 2, 
    returnToId: 2, 
    materialIds: [1, 2, 3], 
    cost: 20, 
    deposit: 5, 
    status: RentalStatus.lent, 
    createdAt: DateTime(2022, 1, 1), 
    startDate: DateTime(2022, 2, 1), 
    endDate: DateTime(2022, 3, 1), 
    usageStartDate: DateTime(2022, 2, 2), 
    usageEndDate: DateTime(2022, 2, 27),
    ),
  RentalModel(
    id: 2, 
    customerId: 2, 
    lenderId: 2, 
    returnToId: 2, 
    materialIds: [1, 2, 3], 
    cost: 20, 
    deposit: 5, 
    status: RentalStatus.available, 
    createdAt: DateTime(2022, 1, 1), 
    startDate: DateTime(2022, 2, 1), 
    endDate: DateTime(2022, 3, 1), 
    usageStartDate: DateTime(2022, 2, 2), 
    usageEndDate: DateTime(2022, 2, 27),
  ),
  RentalModel(
    id: 3, 
    customerId: 3, 
    lenderId: 2, 
    returnToId: 2, 
    materialIds: [1, 2, 3], 
    cost: 20, 
    deposit: 5, 
    status: RentalStatus.returned, 
    createdAt: DateTime(2022, 1, 1), 
    startDate: DateTime(2022, 2, 1), 
    endDate: DateTime(2022, 3, 1), 
    usageStartDate: DateTime(2022, 2, 2), 
    usageEndDate: DateTime(2022, 2, 27),
  ),
];

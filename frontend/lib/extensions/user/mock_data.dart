import 'package:frontend/extensions/user/model.dart';


final Right mockAdministrationRight = Right(
  id: 1,
  name: 'Administration',
  description: 'Can access and edit the administration page',
);

final Right mockLenderRight = Right(
  id: 2,
  name: 'Lender',
  description: 'Can access the lender page adn lend material',
);

final Right mockInspectionRight = Right(
  id: 3,
  name: 'Inspection',
  description: 'Can do inspections',
);

final Right mockInventoryRight = Right(
  id: 4,
  name: 'Inventory',
  description: 'Can access and edit the inventory page',
);


final Role mockBasicRole = Role(
  id: 1,
  name: 'Basic',
  description: 'Basic user without any right',
  rights: [],
);

final Role mockInspectorRole = Role(
  id: 2,
  name: 'Inspector',
  description: 'Can do inspections',
  rights: [
    mockInspectionRight,
    mockInventoryRight,
  ],
);

final Role mockInstructorRole = Role(
  id: 3,
  name: 'Instructor',
  description: 'Can access everything besides inspections and administration',
  rights: [
    mockLenderRight,
    mockInventoryRight,
  ],
);

final Role mockAdministratiorRole = Role(
  id: 4,
  name: 'Administrator',
  description: 'Can manage User and Role administration',
  rights: [
    mockAdministrationRight,
  ],
);


final List<UserModel> mockUsers = [
  UserModel(
    id: 1,
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@gmail.com',
    phone: '+49123456789',
    membershipNumber: 123456,
    address: Address(
      street: 'Musterstraße',
      houseNumber: 1,
      city: 'Musterstadt',
      zip: '12345',
    ),
    roles: [
      mockBasicRole,
    ],
  ),
  UserModel(
    id: 2,
    firstName: 'Tim',
    lastName: 'Doe',
    email: 'tim.doe@gmail.com',
    phone: '+4914345569',
    membershipNumber: 1235432,
    address: Address(
      street: 'Musterweg',
      houseNumber: 12,
      city: 'Musterhausen',
      zip: '54321',
    ),
    roles: [
      mockInstructorRole,
    ],
  ),
  UserModel(
    id: 3,
    firstName: 'Sarah',
    lastName: 'Koe',
    email: 'sarah.koe@gmail.com',
    phone: '+4914341234229',
    membershipNumber: 998432,
    address: Address(
      street: 'Musterweg',
      houseNumber: 2,
      city: 'Musterhausen',
      zip: '54321',
    ),
    roles: [
      mockInspectorRole,
      mockAdministratiorRole,
    ],
  ),
  UserModel(
    id: 4,
    firstName: 'Klara',
    lastName: 'Koe',
    email: 'klara.koe@gmail.com',
    phone: '+4914333332129',
    membershipNumber: 091234,
    address: Address(
      street: 'Klosterstraße',
      houseNumber: 26,
      city: 'Musterhausen',
      zip: '54321',
    ),
    roles: [
      mockAdministratiorRole,
    ],
  ),
];

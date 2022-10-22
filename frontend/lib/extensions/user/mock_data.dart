import 'package:frontend/extensions/user/model.dart';


final Permission mockAdministrationPermission = Permission(
  id: 1,
  name: 'Administration',
  description: 'Can access and edit the administration page',
);

final Permission mockLenderPermission = Permission(
  id: 2,
  name: 'Lender',
  description: 'Can access the lender page adn lend material',
);

final Permission mockInspectionPermission = Permission(
  id: 3,
  name: 'Inspection',
  description: 'Can do inspections',
);

final Permission mockInventoryPermission = Permission(
  id: 4,
  name: 'Inventory',
  description: 'Can access and edit the inventory page',
);


final Role mockBasicRole = Role(
  id: 1,
  name: 'Basic',
  description: 'Basic user without any right',
  permissions: [],
);

final Role mockIncpectorRole = Role(
  id: 2,
  name: 'Inspector',
  description: 'Can do inspections',
  permissions: [
    mockInspectionPermission,
    mockInventoryPermission,
  ],
);

final Role mockInstructorRole = Role(
  id: 3,
  name: 'Instructor',
  description: 'Can access everything besides inspections and administration',
  permissions: [
    mockLenderPermission,
    mockInventoryPermission,
  ],
);

final Role mockAdministratiorRole = Role(
  id: 4,
  name: 'Administrator',
  description: 'Can manage User and Role administration',
  permissions: [
    mockAdministrationPermission,
  ],
);


final List<UserModel> mockUsers = [
  UserModel(
    id: 1,
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@gmail.com',
    phone: '+49123456789',
    membershipNumber: '123456',
    street: 'Musterstraße',
    houseNumber: '1',
    city: 'Musterstadt',
    zip: '12345',
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
    membershipNumber: '1235432',
    street: 'Musterweg',
    houseNumber: '12',
    city: 'Musterhausen',
    zip: '54321',
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
    membershipNumber: '998432',
    street: 'Musterweg',
    houseNumber: '2',
    city: 'Musterhausen',
    zip: '54321',
    roles: [
      mockIncpectorRole,
      mockAdministratiorRole,
    ],
  ),
  UserModel(
    id: 4,
    firstName: 'Klara',
    lastName: 'Koe',
    email: 'klara.koe@gmail.com',
    phone: '+4914333332129',
    membershipNumber: '091234',
    street: 'Klosterstraße',
    houseNumber: '26',
    city: 'Musterhausen',
    zip: '54321',
    roles: [
      mockAdministratiorRole,
    ],
  ),
];

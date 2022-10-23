import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:frontend/extensions/user/controller.dart';
import 'package:frontend/extensions/user/model.dart';


const administrationRoute = '/administration';
const administrationAccountDetailRoute = '/administration/accountDetail';

class AdministrationPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdministrationPageController>(() => AdministrationPageController());
  }
}

class AdministrationPageController extends GetxController with GetSingleTickerProviderStateMixin {
  final userController = Get.find<UserController>();

  final RxInt tabIndex = 0.obs;
  late TabController tabController;

  final RxList<UserModel> filteredUsers = <UserModel>[].obs;
  final RxMap<Role, String> filterOptions = <Role, String>{}.obs;

  final Rxn<Role> selectedFilter = Rxn<Role>();
  final RxString searchTerm = ''.obs;

  final Rxn<UserModel> selectedUser = Rxn<UserModel>();

  List<UserModel> availableUsers = [];
  List<Role> availableRoles = [];
  List<Right> availableRights = [];

  @override
  Future<void> onInit() async {
    super.onInit();

    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      tabIndex.value = tabController.index;
    });

    availableUsers = await userController.getAllUsers();
    filteredUsers.value = availableUsers;

    availableRoles = await userController.getAllRoles();

    for (Role role in availableRoles) {
      filterOptions[role] = role.name;
    }

    availableRights = await userController.getAllRights();
  }

  @override
  void onClose() {
    tabController.dispose();

    super.onClose();
  }

  /// Filters the [availableUsers] by the [searchTerm] and the [selectedFilter].
  void runFilter() {
    final String term = searchTerm.value.toLowerCase();
    filteredUsers.value = availableUsers.where((UserModel user) {
      bool roleFilterCondition() {
        if (selectedFilter.value == null) return true;          

        return user.roles.contains(selectedFilter.value);
      }

      bool roleNameCondition() {
        if (term.isEmpty) return true;

        return user.roles.any(
          (Role role) => role.name.toLowerCase().contains(term));
      }

      bool userNameCondition() {
        return user.firstName.toLowerCase().contains(term) || 
          user.lastName.toLowerCase().contains(term);
      }

      return roleFilterCondition() && 
        (roleNameCondition() || userNameCondition());
    }).toList();
  }

  /// Handles the selection of a [value] out of [filterOption].
  void onFilterSelected(String value) {
    // set selected filter
    if (value != 'all'.tr) {
      selectedFilter.value = filterOptions.entries.firstWhere(
        (MapEntry<Role, String> entry) => entry.value == value
      ).key;
    } else {
      selectedFilter.value = null;
    }

    runFilter();
  }

  Color getDataRowColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };

    if (states.any(interactiveStates.contains)) {
      return Get.theme.colorScheme.primary.withOpacity(0.12);
    }
    
    return Colors.transparent;
  }
}

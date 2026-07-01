

import 'package:apitor/analytics/data/user_details_dto.dart';
import 'package:flutter/foundation.dart';

class UserSession {
  UserSession._();
  static final UserSession instance = UserSession._();

  final ValueNotifier<UserDetailsDTO> notifier =
      ValueNotifier(UserDetailsDTO.defaultProfile);

  UserDetailsDTO get user => notifier.value;

  void setUser(UserDetailsDTO newUser) {
    notifier.value = newUser;
  }
}
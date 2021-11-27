import 'package:blather_app/models/user.dart';
import 'package:blather_app/service/firebase_methods.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  late UserDetails _user;
  final FirebaseMethods _authMethods = FirebaseMethods();

  UserDetails get getUser => _user;

  Future<void> refreshUser() async {
    UserDetails user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData extends ChangeNotifier {
  String? token;
  String? userId;
  String? firstName;
  String? middleName;
  String? lastName;
  String? phone;
  String? email;
  String? gender;

  Future<void> fetchUserData() async {
    final logindata = await SharedPreferences.getInstance();
    token = logindata.getString('token');
    userId = logindata.getString('userId');
    firstName = logindata.getString('firstName');
    middleName = logindata.getString('middleName');
    lastName = logindata.getString('lastName');
    phone = logindata.getString('phone');
    email = logindata.getString('email');
    gender = logindata.getString('gender');
    notifyListeners();
  }
}

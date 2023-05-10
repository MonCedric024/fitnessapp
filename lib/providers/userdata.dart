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
  String? line1;
  String? line2;
  String? city;
  String? state;
  String? postalCode;
  String? gender;
  String? age;
  String? height;
  String? weight;

  Future<void> fetchUserData() async {
    final logindata = await SharedPreferences.getInstance();
    token = logindata.getString('token');
    userId = logindata.getString('userId');
    firstName = logindata.getString('firstName');
    middleName = logindata.getString('middleName');
    lastName = logindata.getString('lastName');
    phone = logindata.getString('phone');
    email = logindata.getString('email');
    line1 = logindata.getString('line1');
    line2 = logindata.getString('line2');
    city = logindata.getString('city');
    state = logindata.getString('state');
    postalCode = logindata.getString('postalCode');
    gender = logindata.getString('gender');
    age = logindata.getString('age');
    height = logindata.getString('height');
    weight = logindata.getString('weight');
    notifyListeners();
  }
}

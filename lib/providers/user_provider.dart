import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String _token = '';
  int _id = 0;
  String _firstname = '';
  String _middlename = '';
  String _lastname = '';
  String _phonenumber = '';
  String _email = '';
  String _line1 = '';
  String _line2 = '';
  String _city = '';
  String _state = '';
  String _postalCode = '';
  String _gender = '';
  int _age = 0;
  int _height= 0;
  int _weight = 0;

  String get token => _token;
  int get id => _id;
  String get firstname => _firstname;
  String get middlename => _middlename;
  String get lastname => _lastname;
  String get phonenumber => _phonenumber;
  String get email => _email;
  String get line1 => _line1;
  String get line2 => _line2;
  String get city => _city;
  String get state => _state;
  String get postalCode => _postalCode;
  String get gender => _gender;
  int get age => _age;
  int get height => _height;
  int get weight => _weight;

  void storeProfile(String token, int id, String firstName, String? middleName, String lastName, String phoneNumber, String email, String line1,
      String line2, String city, String state, String postalCode, String gender, int age, int? weight, int? height) {

    _token = token;
    _id = id;
    _firstname = firstName;
    _middlename = middleName ?? '';
    _lastname = lastName;
    _phonenumber = phoneNumber;
    _email = email;
    _line1 = line1;
    _line2 = line2;
    _city = city;
    _state = state;
    _postalCode = postalCode;
    _gender = gender;
    _age = age;
    _height = height ?? 0; // set to 0 if null
    _weight = weight ?? 0; // set to 0 if null
  }
}
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fitnessapp/form_screen.dart';
import 'package:fitnessapp/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'bottomnavigation.dart';
import 'package:fitnessapp/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget{
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() => InitState();
}
const List<String> list = <String>['Male', 'Female'];

class InitState extends State<SignUpScreen> {
  String gender = list.first;
  String? emailError;
  final dio = Dio();
  bool isLoading = false;
  SharedPreferences? logindata;
  late bool newUser;
  bool isPasswordVisible = false;

  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      logindata = prefs;
    });
  }

  TextEditingController phonenumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController middlenameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController line1Controller = TextEditingController();
  TextEditingController line2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();

  void signup(String email, String firstname, String middlename, String lastname, String age, String phonenumber, String password, String line1, String line2, String city, String state, String postalCode, String gender) async {
    setState(() {
      isLoading = true;
    });

    try {
      final formData = FormData.fromMap({
        'email': email,
        'password': password,
        'firstName': firstname,
        'middleName': middlename ?? '',
        'lastName': lastname,
        'phone': '+63$phonenumber',
        'gender': gender,
        'age': age,
        'line1': line1,
        'line2': line2,
        'city': city,
        'state': state,
        'postalCode': postalCode
      });
      print(formData.fields);

      final response = await dio.post(
          'https://sbit3j-service.onrender.com/v1/client/auth/register',
          data: formData
      );

      if (response.statusCode == 201) {
        var data = response.data;
        logindata?.setBool('login', false);
        logindata?.setString('token', data['access']['token']);
        logindata?.setString('userId', data['data']['id'].toString());
        logindata?.setString('firstName', data['data']['firstName']);
        logindata?.setString('middleName', data['data']['middleName'] != null ? data['data']['middleName'].toString() : 'null');
        logindata?.setString('lastName', data['data']['lastName']);
        logindata?.setString('phone', data['data']['phone']);
        logindata?.setString('email', data['data']['email']);
        logindata?.setString('gender', data['data']['gender']);

        // ignore: use_build_context_synchronously
        context.read<User>().storeProfile(
          data['access']['token'],
          data['data']['id'],
          data['data']['firstName'],
          data['data']['middleName'],
          data['data']['lastName'],
          data['data']['phone'],
          data['data']['email'],
          data['data']['line1'],
          data['data']['line2'],
          data['data']['city'],
          data['data']['state'],
          data['data']['postalCode'],
          data['data']['gender'],
          data['data']['age'],
          data['data']['height'],
          data['data']['weight'],
        );

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registered Successfully")));
        // ignore: use_build_context_synchronously
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const FormScreen()));
      } else {}
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(
          "Invalid Credentials Check All Your Given Information")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 75,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(90)),
                gradient: LinearGradient(
                  colors: [(Color(0xff004AAD)), (Color(0xff004AAD))],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
                )
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 25, top: 30),
                      alignment: Alignment.bottomRight,
                      child: const Text(
                        "Registration",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white
                        )
                      ),
                    )
                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 20, top: 20),
              alignment: Alignment.bottomLeft,
              child: const Text(
                "Personal Information",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: Colors.black,
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[200],
              ),
              alignment: Alignment.center,
              child: TextFormField(
                controller: emailController,
                cursorColor: const Color(0xff004AAD),
                decoration: const InputDecoration(
                  icon: Icon(
                    Icons.email,
                    color: Color(0xff004AAD),
                  ),
                  hintText: "Enter Email",
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),

          Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 10, top: 20),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey[200],
                    ),
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: firstnameController,
                      cursorColor: const Color(0xff004AAD),
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.person,
                          color: Color(0xff004AAD),
                        ),
                        hintText: "Firstname",
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 20, top: 20),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey[200],
                    ),
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: middlenameController,
                      cursorColor: const Color(0xff004AAD),
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.person,
                          color: Color(0xff004AAD),
                        ),
                        hintText: "Middlename",
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 10, top: 20),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey[200],
                    ),
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: lastnameController,
                      cursorColor: const Color(0xff004AAD),
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.person,
                          color: Color(0xff004AAD),
                        ),
                        hintText: "Lastname",
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 20, top: 20),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey[200],
                    ),
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: ageController,
                      cursorColor: const Color(0xff004AAD),
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.dangerous_rounded,
                          color: Color(0xff004AAD),
                        ),
                        hintText: "Age",
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[200],
              ),
              alignment: Alignment.center,
              child: TextFormField(
                controller: phonenumberController,
                cursorColor: const Color(0xff004AAD),
                decoration: const InputDecoration(
                  icon: Icon(
                    Icons.phone,
                    color: Color(0xff004AAD),
                  ),
                  hintText: "Enter PhoneNumber",
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  prefixText: "+63",
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[200],
              ),
              alignment: Alignment.center,
              child: TextFormField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                cursorColor: const Color(0xff004AAD),
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.vpn_key,
                    color: Color(0xff004AAD),
                  ),
                  hintText: "Enter Password",
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xff004AAD),
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(top: 16, bottom: 16, right: 12),
                ),
                validator: (value) =>
                value!.isEmpty ? "Password field required" : null,
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 20, top: 20),
              alignment: Alignment.bottomLeft,
              child: const Text(
                "Address",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: Colors.black,
                ),
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 10, top: 15),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey[200],
                    ),
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: line1Controller,
                      cursorColor: const Color(0xff004AAD),
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.place,
                          color: Color(0xff004AAD),
                        ),
                        hintText: "Unit No./Street",
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 20, top: 15),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey[200],
                    ),
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: line2Controller,
                      cursorColor: const Color(0xff004AAD),
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.place,
                          color: Color(0xff004AAD),
                        ),
                        hintText: "Barangay",
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 10, top: 20),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey[200],
                    ),
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: cityController,
                      cursorColor: const Color(0xff004AAD),
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.place,
                          color: Color(0xff004AAD),
                        ),
                        hintText: "City",
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 20, top: 20),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey[200],
                    ),
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: stateController,
                      cursorColor: const Color(0xff004AAD),
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.place,
                          color: Color(0xff004AAD),
                        ),
                        hintText: "State/Region",
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 10, top: 20),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey[200],
                    ),
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: postalCodeController,
                      cursorColor: const Color(0xff004AAD),
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.place,
                          color: Color(0xff004AAD),
                        ),
                        hintText: "Postal Code",
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 20, top: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey[200],
                    ),
                    alignment: Alignment.center,
                    child: DropdownButton<String>(
                      value: gender,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                      underline: const SizedBox(),
                      onChanged: (String? newValue) {
                        setState(() {
                          gender = newValue!;
                        });
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: const Text(
                        'Gender',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            GestureDetector(
              onTap: () => {
                signup(emailController.text.toString(), firstnameController.text.toString(), middlenameController.text.toString(), lastnameController.text.toString(), ageController.text.toString(), phonenumberController.text.toString(), passwordController.text.toString(),
                    line1Controller.text.toString(), line2Controller.text.toString(), cityController.text.toString(), stateController.text.toString(), postalCodeController.text.toString(), gender
                )
              },

              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
                padding: const EdgeInsets.only(left: 20, right: 20),
                alignment: Alignment.center,
                height: 54,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [(Color(0xff004AAD)), (Color(0xff004AAD))],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: !isLoading
                    ? const Text("SIGN UP",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )
                    : const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(context, MaterialPageRoute(
                          builder:(context) => LoginScreen()
                      ))
                    },
                    child: const Text(
                      "Login here!",
                      style: TextStyle(
                          color: Color(0xff004AAD)
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
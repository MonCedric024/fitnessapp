import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fitnessapp/changepassword.dart';
import 'package:fitnessapp/login_screen.dart';
import 'package:fitnessapp/myprofile.dart';
import 'package:fitnessapp/providers/user_provider.dart';
import 'package:fitnessapp/providers/userdata.dart';
import 'package:fitnessapp/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitnessapp/bottomnavigation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final dio = Dio();
  SharedPreferences? logindata;

  @override
  void initState() {
    super.initState();
    Provider.of<UserData>(context, listen: false).fetchUserData();
  }

  void logout() async {
    try {
      final token = Provider.of<UserData>(context, listen: false).token;
      var response = await dio.post(
        'https://sbit3j-service.onrender.com/v1/client/auth/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout Successful')),
        );
        // Clear the login data from SharedPreferences
        logindata = await SharedPreferences.getInstance();
        await logindata!.clear(); // clear the login data
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()),);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout Failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An Error Occurred')),
      );
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    return Scaffold(
    body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04,
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xff004AAD),
                gradient: const LinearGradient(
                  colors: [Color(0xff004AAD), Color(0xff004AAD)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.03,
                    bottom: MediaQuery.of(context).size.height * 0.02,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.width * 0.25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        color: userData.gender == 'Male' ? Colors.blue : Colors.pink,
                      ),
                        child: Center(
                          child: Text(
                            '${userData.firstName?.characters.first ?? ''}${userData.lastName?.characters.first ?? ''}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.3,
                    bottom: MediaQuery.of(context).size.height * 0.09,
                    child: Text(
                      '${userData.firstName ?? ''} ${userData.lastName ?? ''}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.3,
                    bottom: MediaQuery.of(context).size.height * 0.06,
                    child: Text(
                      userData.phone ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.3,
                    bottom: MediaQuery.of(context).size.height * 0.03,
                    child: Text(
                      userData.email ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 20, top: 30, bottom: 10),
              alignment: Alignment.bottomLeft,
              child: const Text(
                "Main",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: Colors.black,
                ),
              ),
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9, // set the width to 90% of screen width
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xff004AAD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserProfileScreen(),
                    ),
                  );
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 20),
                    Flexible(
                      child: Text(
                        "My Account",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),


            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xff004AAD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                onPressed: () async {
                  launch('https://thegymstreet-payments.vercel.app/login?token=${context.read<UserData>().token}');
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.subscriptions,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Subscription",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xff004AAD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePassword(),
                    ),
                  );
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Change Password",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 20, top: 30, bottom: 10),
              alignment: Alignment.bottomLeft,
              child: const Text(
                "Others",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: Colors.black,
                ),
              ),
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xff004AAD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                onPressed: () {
                  logout();
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 20,),
                    Text(
                      "Log out",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    ),
    );
  }
}




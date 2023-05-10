import 'package:dio/dio.dart';
import 'package:fitnessapp/providers/userdata.dart';
import 'package:fitnessapp/update_myprofile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottomnavigation.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final dio = Dio();
  SharedPreferences? logindata;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    Provider.of<UserData>(context, listen: false).fetchUserData();
    fetchSessionData();
  }

  Future<void> fetchSessionData() async {
    try {
      final token = Provider.of<UserData>(context, listen: false).token;
      final userId = Provider.of<UserData>(context, listen: false).userId;
      final response = await Dio().get(
        'https://sbit3j-service.onrender.com/v1/client/clients/$userId',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          userData = response.data['data'];
        });
      } else {
        throw Exception('Failed to fetch data from API endpoint');
      }
    } catch (e) {
      throw Exception('Failed to fetch data from API endpoint: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        backgroundColor: const Color(0xff004AAD),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NavigationPage()),
              ),
            }
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const UpdateMyProfile()),
                );
              },
              icon: const Icon(
                Icons.edit,
                size: 24.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: userData == null
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Firstname',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                          ),
                          initialValue: '${userData!['firstName']}',
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Middlename',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                          ),
                          initialValue: '${userData!['middleName']}',
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Lastname',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                          ),
                          initialValue: '${userData!['lastName']}',
                          readOnly: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: 360,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                      ),
                      initialValue: '${userData!['email']}',
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: 360,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                      ),
                      initialValue: '${userData!['phone']}',
                      readOnly: true,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Address',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: 360,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Unit No. / Street',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                      ),
                      initialValue: '${userData!['line1']}',
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Barangay',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                          ),
                          initialValue: '${userData!['line2']}',
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Postal Code',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                          ),
                          initialValue: '${userData!['postalCode']}',
                          readOnly: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'City',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                          ),
                          initialValue: '${userData!['city']}',
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'State',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                          ),
                          initialValue: '${userData!['state']}',
                          readOnly: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Physical Information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Age',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                          ),
                          initialValue: userData!['age'].toString(),
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                          ),
                          initialValue: '${userData!['gender']}',
                          readOnly: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Height',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                          ),
                          initialValue: userData!['height'].toString(),
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Weight',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                          ),
                          initialValue: userData!['weight'].toString(),
                          readOnly: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
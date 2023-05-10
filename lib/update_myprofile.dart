import 'package:dio/dio.dart';
import 'package:fitnessapp/bottomnavigation.dart';
import 'package:fitnessapp/providers/user_provider.dart';
import 'package:fitnessapp/providers/userdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'myprofile.dart';

class UpdateMyProfile extends StatefulWidget {
  const UpdateMyProfile({Key? key}) : super(key: key);

  @override
  State<UpdateMyProfile> createState() => _UpdateMyProfileState();
}

class _UpdateMyProfileState extends State<UpdateMyProfile> {
  final dio = Dio();
  SharedPreferences? logindata;
  Map<String, dynamic>? userData;
  bool isLoading = false;

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
          firstnameController.text = '${userData!['firstName']}';
          middlenameController.text = '${userData!['middleName']}';
          lastnameController.text = '${userData!['lastName']}';
          ageController.text = userData!['age'].toString();
          line1Controller.text = '${userData!['line1']}';
          line2Controller.text = '${userData!['line2']}';
          cityController.text = '${userData!['city']}';
          stateController.text = '${userData!['state']}';
          postalCodeController.text = '${userData!['postalCode']}';
          genderController.text = '${userData!['gender']}';
        });
      } else {
        throw Exception('Failed to fetch data from API endpoint');
      }
    } catch (e) {
      throw Exception('Failed to fetch data from API endpoint: $e');
    }
  }

  TextEditingController firstnameController = TextEditingController();
  TextEditingController middlenameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController line1Controller = TextEditingController();
  TextEditingController line2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  void registerupdate(String firstname, middlename, lastname, age, line1, line2, city, state, postalCode, gender) async{
    setState(() {
      isLoading = true;
    });

    try{
      final formData = FormData.fromMap({
        'firstName' : firstname,
        'middleName' : middlename,
        'lastName' : lastname,
        'gender': gender,
        'age' : age,
        'line1' : line1,
        'line2' : line2,
        'city' : city,
        'state' : state,
        'postalCode' : postalCode,
        'gencer' : gender,
      });

      print(formData.fields);

      final token = Provider.of<UserData>(context, listen: false).token;
      final userId = Provider.of<UserData>(context, listen: false).userId;
      final response = await dio.put(
        'https://sbit3j-service.onrender.com/v1/client/clients/$userId',
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token"
          },
        ),
      );
      if(response.statusCode == 200) {
        var data = response.data;

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Updated Successfully")));
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(
            builder:(context) => const NavigationPage()
        ));
      }else{
      }
    }catch(e){
      print(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid Credentials")));
    }finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> _onWillPop() async {
    return false;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Update My Account'),
          backgroundColor: const Color(0xff004AAD),
          automaticallyImplyLeading: false,
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
                            controller: firstnameController,
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
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: TextFormField(
                            controller: middlenameController,
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
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: TextFormField(
                            controller: lastnameController,
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
                        controller: line1Controller,
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
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: line2Controller,
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
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: TextFormField(
                            controller: postalCodeController,
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
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: cityController,
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
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: TextFormField(
                            controller: stateController,
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
                            controller: ageController,
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
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: TextFormField(
                            controller: genderController,
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
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                registerupdate(firstnameController.text.toString(), middlenameController.text.toString(), lastnameController.text.toString(), ageController.text.toString(), line1Controller.text.toString(),
                                line2Controller.text.toString(), cityController.text.toString(), stateController.text.toString(), postalCodeController.text.toString(), genderController.text.toString());
                              },
                              icon: const Icon(Icons.update, size: 30),
                              style: ElevatedButton.styleFrom(
                                primary: const Color(0xff004AAD),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              label: isLoading
                                  ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                                  : const Text(
                                'Update',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const UserProfileScreen()),
                                );
                              },
                              icon: const Icon(Icons.cancel, size: 30),
                              label: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: const Color(0xff22763F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                            ),
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
      ),
    );
  }
}
import 'package:dio/dio.dart';
import 'package:fitnessapp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:fitnessapp/bottomnavigation.dart';
import 'package:provider/provider.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  _FormScreenState createState() => _FormScreenState();
}

const List<String> list = <String>['Beginner', 'Intermediate', 'Advanced'];
const List<String> lists = <String>['Male', 'Female'];
const List<String> listss = <String>['Core', 'Lower Body', 'Upper'];

class _FormScreenState extends State<FormScreen> {
  bool coaching = true;
  String coachinglevel = list.first;
  String coachgender = lists.first;
  String workoutpreference = listss.first;
  List<dynamic> daysSelected = [];
  final dio = Dio();
  bool isLoading = false;

  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController goalController = TextEditingController();

  void registerupdate(String weight, height, coaching, coachinglevel, coachgender, workoutpreference, goal, notes, daysSelected) async{
    setState(() {
      isLoading = true;
    });

    try{
      final formData = FormData.fromMap({
        'weight' : weight,
        'height' : height,
        'requiresCoaching' : coaching,
        'workoutLevel': coachinglevel,
        'coachGenderPreference' : coachgender,
        'workoutPreference' : workoutpreference,
        'goal' : goal,
        'notes' : notes,
        'availability' : daysSelected,
      });
      print(formData.fields);

      String token = Provider.of<User>(context, listen: false).token;
      int id = Provider.of<User>(context, listen: false).id;
      print(id);
      print(token);
      final response = await dio.put(
        'https://sbit3j-service.onrender.com/v1/client/clients/$id',
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token"
          },
        ),
      );
      if(response.statusCode == 200) {
        var data = response.data;

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registered Successfully")));
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
          title: const Text('Other Information'),
          backgroundColor: const Color(0xff004AAD),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 20, top: 15),
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey[200],
                      ),
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: weightController,
                        cursorColor: const Color(0xff004AAD),
                        decoration: const InputDecoration(
                          hintText: "Enter Weight (kg)",
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 5, top: 15),
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey[200],
                      ),
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: heightController,
                        cursorColor: const Color(0xff004AAD),
                        decoration: const InputDecoration(
                          hintText: "Enter Height (cm)",
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        const Text(
                          "Do you want coach?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 55),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey.shade200,
                          ),
                          child: DropdownButton<bool>(
                            value: coaching,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            underline: const SizedBox(),
                            onChanged: (bool? newValue) {
                              setState(() {
                                coaching = newValue ?? false; // Use null-aware operator to set the value to false if newValue is null.
                              });
                            },
                            items: const [    DropdownMenuItem<bool>(      value: true,      child: Text('Yes'),    ),    DropdownMenuItem<bool>(      value: false,      child: Text('No'),    ),  ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        const Text(
                          "Level of workouts",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey.shade200,
                          ),
                          child: DropdownButton<String>(
                            value: coachinglevel,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            underline: const SizedBox(),
                            onChanged: (String? newValue) {
                              setState(() {
                                coachinglevel = newValue!;
                              });
                            },
                            items: list.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          "Workout Preference",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                              color: Colors.grey.shade200,
                          ),
                          child: DropdownButton<String>(
                            value: workoutpreference,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            underline: const SizedBox(),
                            onChanged: (String? newValue) {
                              setState(() {
                                workoutpreference = newValue!;
                              });
                            },
                            items: listss.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          "Coach Gender",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 45),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                              color: Colors.grey.shade200,
                          ),
                          child: DropdownButton<String>(
                            value: coachgender,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            underline: const SizedBox(),
                            onChanged: (String? newValue) {
                              setState(() {
                                coachgender = newValue!;
                              });
                            },
                            items: lists.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  const SizedBox(height: 15),
                  MultiSelectFormField(
                    dataSource: const [
                      {"display": "Monday", "value": "Monday"},
                      {"display": "Tuesday", "value": "Tuesday"},
                      {"display": "Wednesday", "value": "Wednesday"},
                      {"display": "Thursday", "value": "Thursday"},
                      {"display": "Friday", "value": "Friday"},
                      {"display": "Saturday", "value": "Saturday"},
                      {"display": "Sunday", "value": "Sunday"},
                    ],
                    textField: 'display',
                    valueField: 'value',
                    okButtonLabel: 'OK',
                    cancelButtonLabel: 'CANCEL',
                    initialValue: daysSelected,
                    onSaved: (value) {
                      if (value == null) return;
                      setState(() {
                        daysSelected = value;
                      });
                    },
                    fillColor: Colors.grey.shade200,
                    title: const Text(
                      "Select Days",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: notesController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                        hintText: 'Enter your notes',
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: goalController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                        hintText: 'Enter your goal',
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () => {
                      registerupdate(weightController.text.toString(), heightController.text.toString(), coaching, coachinglevel, coachgender, workoutpreference, goalController.text.toString(), notesController.text.toString(), (daysSelected.join(","))
                      )
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xff004AAD), Color(0xff004AAD)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: !isLoading
                          ? const Text("SUBMIT",
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
                  const SizedBox(height: 15),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
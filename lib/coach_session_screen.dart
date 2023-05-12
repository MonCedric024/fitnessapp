import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fitnessapp/bottomnavigation.dart';
import 'package:fitnessapp/providers/userdata.dart';
import 'package:flutter/material.dart';
import 'package:linkable/constants.dart';
import 'package:provider/provider.dart';
import 'package:fitnessapp/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fitnessapp/home_screen.dart';


class CoachSession extends StatefulWidget {
  const CoachSession({Key? key}) : super(key: key);

  @override
  _CoachSessionState createState() => _CoachSessionState();
}

class _CoachSessionState extends State<CoachSession> {
  final dio = Dio();
  List<Map<String, dynamic>>? sessionData;
  SharedPreferences? logindata;
  Map<String, dynamic>? coachData;


  @override
  void initState() {
    super.initState();
    Provider.of<UserData>(context, listen: false).fetchUserData();
    fetchCoachData();
    fetchSessionData();
  }

  void fetchSessionData() async {
    try {
      final token = Provider.of<UserData>(context, listen: false).token;
      if (token == null) {
        throw Exception('Token is null');
      }
      final response = await Dio().get(
        'https://sbit3j-service.onrender.com/v1/client/sessions',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      if (response.statusCode == 200) {
        final sessions = List<Map<String, dynamic>>.from(response.data['data']);
        if (mounted) {
          setState(() {
            sessionData = sessions;
          });
        }
      } else {
        throw Exception('Failed to fetch data from API endpoint');
      }
    } catch (e) {
      throw Exception('Failed to fetch session data from API endpoint: $e');
    }
  }

  Future<void> fetchCoachData() async {
    try {
      final token = Provider.of<UserData>(context, listen: false).token;
      if (token == null) {
        throw Exception('Token is null');
      }
      final response = await Dio().get(
        'https://sbit3j-service.onrender.com/v1/client/coachings',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          coachData = response.data['data'][0]['coach'];
        });
      } else {
        throw Exception('Failed to fetch data from API endpoint');
      }
    } catch (e) {
      throw Exception('Failed to fetch coach data from API endpoint: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: coachData == null
                      ? const Center(
                    child: CircularProgressIndicator(),
                  )
                      : FractionallySizedBox(
                    widthFactor: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: screenWidth * 0.04,
                            right: screenWidth * 0.04,
                            top: screenHeight * 0.01,
                          ),
                          height: screenHeight * 0.30,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            color: Color(0xff004AAD),
                            gradient: LinearGradient(
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
                                    color: coachData!['gender'] == 'Male' ? Colors.blue : Colors.pink,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${coachData!['firstName']?.split('')[0] ?? ''}${coachData!['lastName']?.split('')[0] ?? ''}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: screenWidth * 0.3,
                                  bottom: screenHeight * 0.1,
                                ),
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  '${coachData!['firstName']} ${coachData!['lastName']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: screenWidth * 0.3,
                                  bottom: screenHeight * 0.02,
                                ),
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  '${coachData!['phone']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: screenWidth * 0.3,
                                  bottom: screenHeight * 0.06,
                                ),
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  '${coachData!['email']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10, top: 50),
                          alignment: Alignment.topLeft,
                          child: const Text('Session Workouts',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.black
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
             Divider(
            ),
          Expanded(
            child: sessionData == null
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : sessionData!.isEmpty
                ? const Center(
              child: Text("No session available. Please wait to your coach to create..."),
            )
                : SingleChildScrollView(
              child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: sessionData!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final session = sessionData![index];
                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.fromLTRB(16, 5, 16, 3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Session Title:',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  session['title'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'Session Description:',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  session['description'],
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Calories:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          session['calories'].toString(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Proteins:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          session['proteins'].toString(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Fats:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          session['fats'].toString(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 30),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AllWorkouts(session: session),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.fitness_center, size: 30),
                                        label: const Text(
                                          'All Workouts',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: const Color(0xff004AAD),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          elevation: 0,
                                          minimumSize: const Size(double.infinity, 40),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ]
              ),
            ), // second half of the screen widget
          ),
        ],
      ),
    );
  }
}

class AllWorkouts extends StatefulWidget {
  final Map<String, dynamic> session;

  const AllWorkouts({required this.session, Key? key}) : super(key: key);

  @override
  _AllWorkoutsState createState() => _AllWorkoutsState();
}

class _AllWorkoutsState extends State<AllWorkouts> {
  late Map<String, dynamic> session;
  final bool _showDialog = false;

  @override
  void initState() {
    super.initState();
    session = widget.session;
  }

  @override
  Widget build(BuildContext context) {
    final workouts = session['workouts'];
    if (workouts != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Workouts'),
          backgroundColor: const Color(0xff004AAD),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                onPressed: () async {
                  try {
                    late String token;
                    final Dio dio = Dio();
                    token = Provider.of<UserData>(context, listen: false).token!;
                    final int id = widget.session['id'];
                    print('$id');
                    print('$token');
                    final response = await dio.post(
                      'https://sbit3j-service.onrender.com/v1/client/sessions/$id/reset',
                      options: Options(headers: {
                        'Authorization': 'Bearer $token',
                      }),
                    );
                    // Check response status code
                    if (response.statusCode == 204) {
                      setState(() {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Reset Session Workout?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: const Text('Okay'),
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const NavigationPage()));
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Session workout reset successfully!')));
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      });
                    } else {
                      print('Failed to reset session');
                    }
                  } catch (e) {
                    print('Error resetting session: $e');
                  }
                },
                icon: const SizedBox(
                  width: 32,
                  height: 32,
                  child: Padding(
                    padding: EdgeInsets.all(2),
                    child: Icon(
                      Icons.settings_backup_restore,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        body: ListView.builder(
          itemCount: workouts.length,
          itemBuilder: (BuildContext context, int index) {
            final workout = workouts[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutDetails(workout: workout),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.all(5),
                elevation: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Image.network(
                        workout['imageUrl'] ??
                            'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              workout['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              workout['description'],
                              textAlign: TextAlign.justify,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 70),
                      child: ElevatedButton(
                        onPressed: () async {
                          // ... Same as before ...
                        },
                        style: ElevatedButton.styleFrom(
                          primary: workout['isDone'] ? Colors.green : Colors.grey,
                          shape: const CircleBorder(),
                          elevation: 2,
                          padding: const EdgeInsets.all(3), // Reduce the padding to 8 pixels
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    } else {
      return const Center(
        child: Text(
          'No workouts found',
          style: TextStyle(fontSize: 18),
        ),
      );
    }
  }
}

class WorkoutDetails extends StatefulWidget {
  final Map<String, dynamic> workout;

  const WorkoutDetails({required this.workout, Key? key}) : super(key: key);

  @override
  _WorkoutDetailsState createState() => _WorkoutDetailsState();
}

class _WorkoutDetailsState extends State<WorkoutDetails> {
  bool isDone = false;

  @override
  void initState() {
    super.initState();
    isDone = widget.workout['isDone'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout['title']),
        backgroundColor: const Color(0xff004AAD),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  widget.workout['imageUrl'] ??
                      'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg',
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                widget.workout['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(
                    Icons.repeat,
                    size: 16.0,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    '${widget.workout['reps']} reps',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Icon(
                    Icons.fitness_center,
                    size: 16.0,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    '${widget.workout['set']} sets',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Icon(
                    Icons.timer,
                    size: 16.0,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    '${widget.workout['time']} seconds',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  launch(widget.workout['youtubeUrl']);
                },
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.video_library,
                        size: 24.0,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Watch Video',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.workout['description'],
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: isDone ? null : () async {
                  late String token;
                  final Dio dio = Dio();
                  token = Provider.of<UserData>(context, listen: false).token!;
                  final int id = widget.workout['id'];
                  final formData = FormData.fromMap({
                    'isDone': !isDone, // toggle the value of isDone
                  });

                  try {
                    final response = await dio.put(
                      'https://sbit3j-service.onrender.com/v1/client/session-workouts/$id',
                      data: formData,
                      options: Options(headers: {
                        'Authorization': 'Bearer $token',
                      }),
                    );

                    // Check response status code
                    if (response.statusCode == 200) {
                      setState(() {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Mark as Done?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: const Text('Okay'),
                                  onPressed: () {
                                    isDone = !isDone;
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const NavigationPage()));
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mark as Done Successfully!')));
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      });
                    } else {
                      print('Failed to update IsDone value');
                    }
                  } catch (e) {
                    print('Error updating workout status: $e');
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: isDone ? Colors.green : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isDone ? Icons.check : Icons.circle,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isDone ? 'Done' : 'Mark as done',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


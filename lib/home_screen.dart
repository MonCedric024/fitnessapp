import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:fitnessapp/bottomnavigation.dart';
import 'package:fitnessapp/providers/userdata.dart';
import 'package:fitnessapp/workout_library_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitnessapp/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UserHome extends StatefulWidget{
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pricingOptions = [    {      'name': 'Basic',      'duration': '1 month',      'price': 999.00,    },    {      'name': 'Plus',      'duration': '6 months',      'price': 5499.00,    },    {      'name': 'Gold',      'duration': '1 year',      'price': 9999.00,    },  ];

  final List<DataModel> _data = [];
  SharedPreferences? logindata;

  final List<String> imagePaths = [
    'assets/images/cbg1.jpg',
    'assets/images/cbg2.png',
    'assets/images/cbg3.jpg',
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<UserData>(context, listen: false).fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
              alignment: Alignment.topLeft,
              child: Text('Hi! ${userData.firstName ?? ''}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black
                  )
              ),
            ),

            CarouselSlider.builder(
              itemCount: imagePaths.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                final imagePath = imagePaths[index];
                return Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                );
              },
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 14 / 9,
                viewportFraction: 0.9, // set to 0.8 to display one image at a time
                onPageChanged: (index, _) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 15, top: 15, bottom: 20),
              alignment: Alignment.topLeft,
              child: const Text('Discover Subscriptions',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black
                  )
              ),
            ),

            SizedBox(
              height: 280,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pricingOptions.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: InkWell(
                        onTap: () async {
                          launch('https://thegymstreet-payments.vercel.app/login?token=${context.read<UserData>().token}');
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _pricingOptions[index]['name'],
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              _pricingOptions[index]['duration'],
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              '${_pricingOptions[index]['price'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

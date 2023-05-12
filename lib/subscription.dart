import 'package:dio/dio.dart';
import 'package:fitnessapp/providers/user_provider.dart';
import 'package:fitnessapp/providers/userdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bottomnavigation.dart';

class Subscription extends StatefulWidget {
  const Subscription({Key? key}) : super(key: key);

  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  SharedPreferences? logindata;

  @override
  void initState() {
    super.initState();
    Provider.of<UserData>(context, listen: false).fetchUserData();
    loadsubscription();
  }

  final dio = Dio();
  void loadsubscription() async {
    final token = Provider.of<UserData>(context, listen: false).token;
    try {
      var response = await dio.get(
        'https://sbit3j-service.onrender.com/v1/client/subscriptions/current',
        options: Options(
          headers: {
            "Authorization": "Bearer $token"
          },
        ),
      );
      if (response.statusCode == 200) {
        var data = response.data['data'];
        if (data != null) {
          // ignore: use_build_context_synchronously
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => const NavigationPage()),
          );
        } else {
        }
      } else {
        print("response: $response");
        final token = Provider.of<UserData>(context, listen: false).token;
        await launch('https://thegymstreet-payments.vercel.app/login?token=$token');
      }
    } catch (e) {
      print("error: ${e.toString()}");
      final token = Provider.of<UserData>(context, listen: false).token;
      await launch('https://thegymstreet-payments.vercel.app/login?token=$token');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, right: 16),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  color: Colors.white,
                  onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NavigationPage()),
                      );
                  },
                ),
              ),
            ),
            // your subscription form widgets here
          ],
        ),
      ),
    );
  }
}

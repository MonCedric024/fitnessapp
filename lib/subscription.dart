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

  @override
  void initState() {
    super.initState();
    loadsubscription();
  }

  final dio = Dio();
  void loadsubscription() async {
    String? token = Provider.of<User>(context, listen: false).token;
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
        await launch('https://thegymstreet-payments.vercel.app/login?token=$token');
      }
    } catch (e) {
      print("error: ${e.toString()}");
      await launch('https://thegymstreet-payments.vercel.app/login?token=$token');
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
            title:  const Text('Subscription'),
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
        ),
      ),
    );
  }
}

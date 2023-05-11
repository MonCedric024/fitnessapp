import 'package:dio/dio.dart';
import 'package:fitnessapp/profile_screen.dart';
import 'package:fitnessapp/providers/user_provider.dart';
import 'package:fitnessapp/signup_screen.dart';
import 'package:fitnessapp/subscription.dart';
import 'package:flutter/material.dart';
import 'package:fitnessapp/bottomnavigation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:fitnessapp/form_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final dio = Dio();
  bool isPasswordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  SharedPreferences? logindata;
  late bool newUser;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      logindata = prefs;
      check_if_already_login();
    });
  }

  void login(String email, String password) async {
    setState(() {
      isLoading = true;
    });

    try {
      final formData = FormData.fromMap({
        'email': email,
        'password': password,
      });

      var response = await dio.post(
        'https://sbit3j-service.onrender.com/v1/client/auth/login',
        data: formData,
      );

      if (response.statusCode == 200) {
        var data = response.data;

        // Store user data in SharedPreferences
        logindata?.setBool('login', false);
        logindata?.setString('token', data['access']['token']);
        logindata?.setString('userId', data['data']['id'].toString());
        logindata?.setString('firstName', data['data']['firstName']);
        logindata?.setString('middleName', data['data']['middleName'] != null ? data['data']['middleName'].toString() : 'null');
        logindata?.setString('lastName', data['data']['lastName']);
        logindata?.setString('phone', data['data']['phone']);
        logindata?.setString('email', data['data']['email']);
        logindata?.setString('gender', data['data']['gender']);

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
        print(data['access']['token']);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login Successfully")));
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Subscription()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Invalid Credentials")));
      }
    } catch(e){
      print(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid Credentials")));
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
                height: 350,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(90)),
                    color: Color(0xff004AAD),
                    gradient: LinearGradient(
                      colors: [(Color(0xff004AAD)), (Color(0xff004AAD))],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                ),

                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 110),
                        height: 140,
                        width: 140,
                        child: Image.asset("assets/images/logo.jpg"),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 25, top: 30),
                        alignment: Alignment.bottomRight,
                        child: const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 70),
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
                  validator: (value) =>
                  value!.isEmpty ? "Email field required" : null,
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

              // Container(
              //   margin: const EdgeInsets.only(top: 20, right: 20),
              //   alignment: Alignment.centerRight,
              //   child: GestureDetector(
              //     child: const Text("Forget Password?"),
              //     onTap: () => {
              //     },
              //   ),
              // ),

              GestureDetector(
                onTap: () => login(emailController.text.toString(),
                    passwordController.text.toString()),
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 70),
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.center,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff004AAD), Color(0xff004AAD)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: !isLoading
                      ? const Text( "LOGIN",
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
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(context, MaterialPageRoute(
                            builder:(context) => const SignUpScreen()
                        ))
                      },
                      child: const Text(
                        "Register Here!",
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
        )
    );
  }

  Future<void> check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    newUser = (logindata!.getBool('login') ?? true)!;

    if (newUser == false) {
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const NavigationPage()),
      );
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

}

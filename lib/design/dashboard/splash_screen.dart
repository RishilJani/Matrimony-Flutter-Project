import 'package:flutter/material.dart';
import 'package:matrimony_application/design/dashboard/dashboard.dart';
import 'package:matrimony_application/design/dashboard/login_signup_page.dart';
import 'package:matrimony_application/utils/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<Color> bgColors = [
    const Color.fromARGB(255, 111, 208, 245),
    const Color.fromARGB(255, 250, 156, 188)
  ];

  @override
  void initState() {
    super.initState();
    navigateToDashboard();
  }

  Future<void> navigateToDashboard() async {
    await Future.delayed(const Duration(seconds: 2));
    if(mounted){
       Widget newPage = FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder:(context, snapshot) {
            if(snapshot.hasData && snapshot.data != null){
              String name = snapshot.data!.getString(userName)!;
              if(!(snapshot.data!.getBool(rememberMe) ?? false)){
                return const LoginSignupPage();
              }else{
                return Dashboard(name: name);
              }
            }
            else{
              return const CircularProgressIndicator();
            }
          },
      );

       Navigator.pushReplacement(context,
           MaterialPageRoute(
               builder: (context) {
                 return newPage;
               },
           )
       );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: bgColors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
          )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/two_rings_transparent.png",
                width: 250,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      )
      ,
    );
  }
}

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
    const Color.fromARGB(255, 255, 105, 180),
    const Color.fromARGB(255, 64, 224, 208)
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
              if(!(snapshot.data!.getBool(rememberMe) ?? false)){
                return const LoginSignupPage();
              }else{
                return const Dashboard();
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
          gradient: LinearGradient( colors: bgColors )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "assets/images/Two_Hearts_Transparent.png",
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 50,),
          ],
        ),
      )
      ,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:matrimony_application/design/dashboard/dashboard.dart';
import 'package:matrimony_application/utils/utils.dart';

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
    await Future.delayed(const Duration(seconds: 3));
    if(mounted){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: appBarGredient(bgColors),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              // begin: Alignment.topLeft,
              // end: Alignment.bottomRight,
              colors: bgColors
          )
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

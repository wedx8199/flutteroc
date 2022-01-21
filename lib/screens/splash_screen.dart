import 'package:flutter/material.dart';
import 'package:flutteroc/managers/user_manager.dart';
import 'package:flutteroc/screens/screens.dart';
import 'package:flutteroc/utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  static MaterialPageRoute screen() {
    return MaterialPageRoute(builder: (context) {
      return SplashScreen();
    });
  }

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  void _checkIfLoggedIn() async {
    final isLoggedIn = await UserManager().isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushReplacement(context, HomeScreen.screen());
    } else {
      Navigator.pushReplacement(context, LoginScreen.screen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.blue,
        body: Center(
          child: Image.asset(
            'assets/logo.png',
            width: 280,
            height: 280,
          ),
        ),
      ),
    );
  }
}

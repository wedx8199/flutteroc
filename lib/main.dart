import 'package:flutter/material.dart';
import 'package:flutteroc/sidebar.dart';
import 'package:intl/intl.dart';

import 'pickTable.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async {
    // check if token is there
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var us = localStorage.getString('user');
    String dateLogged = localStorage.getString('date').toString();
    DateTime dateToday = new DateTime.now();
    //String date = DateFormat.Hms().format(dateToday);
    String date = DateFormat('yMd').format(dateToday);
    if (us != null && dateLogged == date) {
      setState(() {
        _isLoggedIn = true;
      });
    } else if (us != null && dateLogged != date) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      await localStorage.clear();
      initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _isLoggedIn ? Tables() : Login(),
      ),
    );
  }
}

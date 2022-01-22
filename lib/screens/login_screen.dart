import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutteroc/managers/user_manager.dart';
import 'package:flutteroc/repositories/user_repository.dart';
import 'package:flutteroc/utils/app_colors.dart';
import 'package:flutteroc/utils/widget_utils.dart';

import 'screens.dart';

class LoginScreen extends StatefulWidget {
  static MaterialPageRoute screen() {
    return MaterialPageRoute(builder: (context) {
      return LoginScreen();
    });
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userRepository = UserRepositoryImpl();
  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            height: data.size.height,
            color: AppColors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 280,
                  height: 280,
                ),
                TextField(
                  controller: usernameController,
                  keyboardType: TextInputType.text,
                  decoration: buildTexFieldDecoration('Tên Đăng Nhập'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: buildTexFieldDecoration('Mật Khẩu'),
                ),
                SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  minWidth: double.infinity,
                  height: 50,
                  color: Colors.yellow,
                  onPressed: () {
                    WidgetUtils.unFocus(context);
                    login(context);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    'Đăng Nhập',
                    style: TextStyle(color: AppColors.blue, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration buildTexFieldDecoration(String hintText) {
    return InputDecoration(
      fillColor: Colors.white,
      filled: true,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.circular(6)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow, width: 1.0),
          borderRadius: BorderRadius.circular(6)),
      hintText: hintText,
      contentPadding: EdgeInsets.all(10.0),
    );
  }

  void login(context) async {
    WidgetUtils.showProgressDialog(context, 'Đang xử lý...');
    final response = await _userRepository.login(
        usernameController.text, passwordController.text);
    Navigator.of(context).pop();
    if (response.isSuccess()) {
      UserManager().saveUser(json.encode(response.data!['user']));
      Navigator.of(context).pushReplacement(HomeScreen.screen());
      WidgetUtils.showFlushBar(
          context: context,
          title: 'Đăng Nhập Thành Công',
          message: "Chào, " + response.data!['user']['name']);
    } else {
      WidgetUtils.showFlushBar(
          context: context,
          title: 'Lỗi Đăng Nhập',
          message: response.exception!.message);
    }
  }
}

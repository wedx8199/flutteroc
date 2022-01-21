import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutteroc/managers/user_manager.dart';
import 'package:flutteroc/network/response.dart';
import 'package:flutteroc/repositories/user_repository.dart';
import 'package:flutteroc/screens/splash_screen.dart';
import 'package:flutteroc/utils/app_colors.dart';
import 'package:flutteroc/utils/utils.dart';

class SlidingMenuScreen extends StatefulWidget {
  SlidingMenuScreen({Key? key}) : super(key: key);

  @override
  State<SlidingMenuScreen> createState() => _SlidingMenuScreenState();
}

class _SlidingMenuScreenState extends State<SlidingMenuScreen> {
  final _userRepository = UserRepositoryImpl();
  var _user;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  void _getUserInfo() async {
    final user = await UserManager().getUser();
    if (user != null) {
      setState(() {
        _user = json.decode(user);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.blue,
                ),
                accountName: Text(
                  _user != null ? '${_user['name']}' : '',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(''),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white10,
                  child: Image.asset(
                    'assets/logo.png',
                    width: 128,
                    height: 128,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            ListTile(
              leading:
                  Icon(Icons.library_books_outlined, color: AppColors.blue),
              title: Text(
                'Chính sách',
                style: TextStyle(color: AppColors.blue),
              ),
            ),
            Divider(color: AppColors.blue),
            ListTile(
              leading: Icon(Icons.call, color: AppColors.blue),
              title: Text('Hỗ trợ', style: TextStyle(color: AppColors.blue)),
            ),
            Divider(color: AppColors.blue),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: AppColors.blue),
              title: Text('Đăng xuất', style: TextStyle(color: AppColors.blue)),
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Text('Bạn có muốn đăng xuất?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Không'),
                      ),
                      TextButton(
                        onPressed: () {
                          logout(context);
                        },
                        child: const Text('Có'),
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
                child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: buildCopyright(),
            )),
          ],
        ),
      ),
    );
  }

  Widget buildCopyright() {
    final style = TextStyle(
        color: AppColors.blue, fontSize: 13, fontWeight: FontWeight.w400);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RichText(
          text: TextSpan(
            style: style,
            children: <TextSpan>[
              TextSpan(text: 'Ⓒ Copyright by '),
              TextSpan(
                  text: 'KNS Softworks',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  void logout(context) async {
    var response = await _userRepository.logout();
    if (response is Result) {
      UserManager().saveUser(null);
      Navigator.of(context).pushAndRemoveUntil(
          SplashScreen.screen(), (Route<dynamic> route) => false);
    }
  }
}

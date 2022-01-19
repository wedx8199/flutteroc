import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';
import 'pickTable.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPersonal extends StatefulWidget {
  @override
  _UserPersonalState createState() => _UserPersonalState();
}

class _UserPersonalState extends State<UserPersonal> {
  var userData;
  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson!);
    setState(() {
      userData = user;
    });
  }

  postData() async {
    return await http.get(
        Uri.parse("http://127.0.0.1/fluttertest/public/logoutapp"),
        headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  void logout(context) async {
    // logout from the server ...
    var res = await postData();
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => Login()),
      );
      Flushbar(
        title: "Đăng Xuất Thành Công",
        message: body['message'],
        duration: Duration(seconds: 3),
        isDismissible: true,
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      )..show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget name = new Container(
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text(
                userData != null ? '${userData['name']}' : '',
                style: new TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              new Text(
                'KNS Softworks @ 2021',
                style: new TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              new Text(
                'Email: knssoftworks@gmail.com',
                style: new TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              new Text(
                'Design by Kns',
                style: new TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          )),
        ],
      ),
    );

    Widget buttons(IconData icon, String btnname) {
      return new Column(
        children: <Widget>[
          new Icon(icon, color: Colors.blue),
          new Text(btnname),
        ],
      );
    }

    Widget fourbutton = new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            /*onTap: ()=>Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context)=>MyApp()),
            ),*/
            onTap: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text('Đăng Xuất?'),
                  content:
                      Text(userData != null ? '${userData['username']}' : ''),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Hủy'),
                      child: const Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () {
                        logout(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            child: buttons(Icons.logout, "Đăng Xuất"),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(userData != null ? '${userData['username']}' : 'Oc'),
      ),
      body: new ListView(
        children: <Widget>[
          name, //call widget
          fourbutton,
        ],
      ),
    );
  }
}

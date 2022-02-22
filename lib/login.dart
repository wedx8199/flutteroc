import 'dart:ui';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'pickTable.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController textname = new TextEditingController();
  TextEditingController textpass = new TextEditingController();

  postData() async {
    var data = {
      "username": textname.text,
      "pass": textpass.text,
    };

    return await http.post(
        Uri.parse("http://thunganoc377.knssoftworks.com/public/loginapp"),
        body: jsonEncode(data),
        headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  void logIN(context) async {
    var rep = await postData();
    var body = json.decode(rep.body);

    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('user', json.encode(body['user']));

      DateTime dateToday = new DateTime.now();
      //String date = DateFormat.Hms().format(dateToday);
      String date = DateFormat('yMd').format(dateToday);
      localStorage.setString('date', date);
      /*Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => Tables()));*/
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => Tables()),
      );
      Flushbar(
        title: "Đăng Nhập Thành Công",
        message: "Chào, " + body['user']['name'],
        duration: Duration(seconds: 3),
        isDismissible: true,
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      )..show(context);
    } else {
      Flushbar(
        title: "Đăng Nhập Thất Bại",
        message: body['message'],
        duration: Duration(seconds: 3),
        isDismissible: true,
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      )..show(context);
    }
  }

  bool _loadlogin = false;
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    final TextField textbox = new TextField(
      controller: textname,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow, width: 3.0)),
        hintText: 'Tên Đăng Nhập',
        contentPadding: EdgeInsets.all(10.0),
      ),
      onChanged: (text) {
        setState(() {
          //this.u.name = text;
        });
      },
    );
    final TextField textbox2 = new TextField(
      controller: textpass,
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow, width: 3.0)),
        hintText: 'Mật Khẩu',
        contentPadding: EdgeInsets.all(10.0),
      ),
      onChanged: (text) {
        setState(() {
          //this.u.price = text;
        });
      },
    );


    return _loadlogin? new Scaffold(
        body: SafeArea(
            child: Center(
                child: Container(
                  color: Colors.grey[300],
                  width: 70.0,
                  height: 70.0,
                  child: new Padding(padding: const EdgeInsets.all(5.0),child: new Center(child: new CircularProgressIndicator())),
                ),
            ),
        ),
    ): new Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: data.size.height,
            color: Color.fromRGBO(14, 28, 71, 1),
            child: Stack(
              children: [
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Container(
                      margin: new EdgeInsets.all(10.0),
                      child: new Image.asset(
                        'assets/logo.png',
                        width: 280,
                        height: 280,
                      ),
                    ),
                    new Container(
                      margin: new EdgeInsets.all(20.0),
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      ),
                      child: textbox,
                    ),
                    new Container(
                      width: data.size.width,
                      margin: new EdgeInsets.only(left: 20, right: 20),
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      ),
                      child: textbox2,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    new Container(
                      width: data.size.width,
                      margin: new EdgeInsets.only(left: 20, right: 20),
                      child: SizedBox(
                        height: 48,
                        width: MediaQuery.of(context).size.width,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            primary: Color.fromRGBO(14, 28, 71, 1),
                          ),
                          onPressed: () {
                            setState((){
                              _loadlogin=true;
                            });
                            logIN(context);
                          },
                          child: Text(
                            'Đăng Nhập',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }
}

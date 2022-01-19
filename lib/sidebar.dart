import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
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
        Uri.parse("http://thunganoc377.knssoftworks.com/public/logoutapp"),
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
    return Drawer(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(14, 28, 71, 1),
                ),
                accountName: Text(
                  userData != null ? '${userData['name']}' : '',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                accountEmail: Text('',
                    style: new TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
                currentAccountPicture: CircleAvatar(
                  child: CachedNetworkImage(
                    imageUrl: "https://crop-circle.imageonline.co/image.png",
                    width: 128,
                    height: 128,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.manage_accounts,
                  color: Color.fromRGBO(14, 28, 71, 1)),
              title: const Text(
                'Chính sách',
                style: TextStyle(color: Color.fromRGBO(14, 28, 71, 1)),
              ),
              onTap: () {},
            ),
            const Divider(color: Color.fromRGBO(14, 28, 71, 1)),
            ListTile(
              leading: const Icon(Icons.notifications,
                  color: Color.fromRGBO(14, 28, 71, 1)),
              title: const Text('Hỗ trợ',
                  style: TextStyle(color: Color.fromRGBO(14, 28, 71, 1))),
              onTap: () {},
            ),
            const Divider(color: Color.fromRGBO(14, 28, 71, 1)),
            ListTile(
              leading: const Icon(Icons.exit_to_app,
                  color: Color.fromRGBO(14, 28, 71, 1)),
              title: const Text('Đăng xuất',
                  style: TextStyle(color: Color.fromRGBO(14, 28, 71, 1))),
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
            ),
            Flexible(
              flex: 3,
              child: Container(),
            ),
            Flexible(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Center(
                        child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Column(
                              children: <Widget>[
                                Divider(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: ListTile(
                                      title: Text(
                                    'Bản quyền thuộc về ' + 'Knssoftwork',
                                    style: TextStyle(
                                        color: Color.fromRGBO(14, 28, 71, 1),
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(left: 80),
                                    child: ListTile(
                                        title: Text(
                                      'Version 1.0.0',
                                      style: TextStyle(
                                          color: Color.fromRGBO(14, 28, 71, 1)),
                                    ))),
                              ],
                            ))),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

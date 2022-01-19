import 'package:flutter/material.dart';
import 'package:flutteroc/sidebar.dart' show Sidebar;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'list/listTable.dart';
import 'userInfo.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Tables extends StatefulWidget {
  @override
  _TablesState createState() => _TablesState();
}

class _TablesState extends State<Tables> {
  void _f5() {
    setState(() {
      //You can also make changes to your state here.
    });
  }

  /*late Future<List> futureDataDB;ß

  @override
  void initState() {
    super.initState();
    futureDataDB = getDataDB();
  }*/

  Future<List> getDataDB() async {
    final rep = await http.get(
        Uri.parse("http://thunganoc377.knssoftworks.com/public/loadtable"));
    if (rep.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return jsonDecode(rep.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(14, 28, 71, 1),
        leading: IconButton(
          icon: Icon(Icons.list_rounded),
          onPressed: () {
            Sidebar();
          },
        ),
        title: Text('Ốc chill 377'),
        automaticallyImplyLeading: false, //bá dơ

        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              _f5();
            },
          ),
        ],
      ),
      body: StreamBuilder<List>(
          stream: Stream.periodic(Duration(seconds: 1))
              .asyncMap((i) => getDataDB())
              .asBroadcastStream(),
          builder: (context, snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[
                Expanded(child: Items(list: snapshot.data!)),
              ];
            } else if (snapshot.hasError) {
              children = <Widget>[
                Text('Error loz: ${snapshot.error}'),
              ];
            } else {
              children = const <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                )
              ];
            }

            return Center(
              child: Column(
                children: children,
              ),
            );
          }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutteroc/components/components.dart';

import '../screens.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutteroc/screens/screens.dart';

class FoodsScreen extends StatefulWidget {
  List list;
  int index;

  FoodsScreen({required this.list, required this.index});

  @override
  _FoodsScreenState createState() => _FoodsScreenState();
}

class _FoodsScreenState extends State<FoodsScreen> {
  @override
  _f5() {
    setState(() {
      //You can also make changes to your state here.
    });
  }

  _gohome() {
    setState(() {
      //You can also make changes to your state here.
      Navigator.pop(context);
    });
  }

  late Future<List> futureDataDB;

  @override
  void initState() {
    super.initState();
    futureDataDB = getDataDB();
  }

  Future<List> getDataDB() async {
    final rep = await http
        .get(Uri.parse("http://thunganoc377.knssoftworks.com/public/showfood"));
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

  Future<List> getDataOrder() async {
    String id = widget.list[widget.index]['id'].toString();
    final getb = await http.get(
        Uri.parse("http://thunganoc377.knssoftworks.com/public/getbill/" + id));
    if (getb.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return jsonDecode(getb.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(14, 28, 71, 1),
            leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back_ios)),
            title: Text(widget.list[widget.index]['name']),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Search',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) => SearchingFoodsScreen(
                          tableid: widget.list[widget.index]['id'])),
                ),
              ),
            ],
          ),
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              Container(
                //Tab1 Bàn

                child: FutureBuilder<List>(
                    future: futureDataDB,
                    builder: (context, snapshot) {
                      List<Widget> children;
                      if (snapshot.hasData) {
                        children = <Widget>[
                          Expanded(
                              child: FoodTile(
                                  list: snapshot.data!,
                                  tableid: widget.list[widget.index]['id'],
                                  refresh: _f5)),
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
              ),
              Container(
                //Tab2 Đơn

                child: StreamBuilder<List>(
                    stream: Stream.periodic(Duration(seconds: 1))
                        .asyncMap((i) => getDataOrder())
                        .asBroadcastStream(),
                    builder: (context, snapshot) {
                      List<Widget> children;
                      if (snapshot.hasData) {
                        children = <Widget>[
                          Expanded(
                              child: BillItems(
                                  list: snapshot.data!,
                                  tableid: widget.list[widget.index]['id'])),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget menu() {
    return Container(
      height: 55,
      color: Color.fromRGBO(14, 28, 71, 1),
      child: TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: Color.fromRGBO(14, 28, 71, 1),
        tabs: [
          Tab(
            text: "Menu",
            icon: Icon(Icons.menu_book),
          ),
          Tab(
            text: "Chi Tiết Đơn",
            icon: Icon(Icons.sticky_note_2_sharp),
          ),
        ],
      ),
    );
  }
}

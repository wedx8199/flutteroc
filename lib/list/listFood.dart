import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'imgfull.dart';
import 'package:flushbar/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class FoodItems extends StatefulWidget {
  List list;
  int tableid;
  final VoidCallback refresh;
  FoodItems({required this.list, required this.tableid, required this.refresh});
  @override
  _FoodItemsState createState() => _FoodItemsState();
}

class _FoodItemsState extends State<FoodItems> {
  final formatter = intl.NumberFormat.decimalPattern();
  final scrollController = GroupedItemScrollController();
  final _form = GlobalKey<FormState>(); //for storing form state.

  TextEditingController textquantity = new TextEditingController();
  TextEditingController textghichu = new TextEditingController();

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

  void _addOrder(context, idmon, namebar) async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      String id = widget.tableid.toString();
      String idfood = idmon.toString();
      String idnv = userData['id'].toString();
      String qqt = textquantity.text;
      final response = await http.post(
          Uri.parse(
              "http://thunganoc377.knssoftworks.com/public/addorder/" + id),
          body: {
            //"id":widget.list[widget.index]['id'],
            "id_user": idnv,
            "id_food": idfood,
            "quantity": textquantity.text,
            "note": textghichu.text,
          });

      if (response.statusCode == 200) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.

        //print(idmon);
        //print(textquantity.text);
        //print(tableid);
        Navigator.pop(context);
        textquantity.clear();
        textghichu.clear();
        Flushbar(
          title: "Đã thêm món: " + namebar,
          message: "Số lượng: " + qqt,
          duration: Duration(seconds: 35),
          isDismissible: true,
          dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        ).show(context);
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        throw Exception('Failed to POST.');
      }
    }
  }

  Future<List> getCat() async {
    final rep =
        await http.get(Uri.parse("http://thunganoc377.knssoftworks.com/public/first"));
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

  Future scrollToUp(value) async {
    var s1 = int.parse(value);
    int s2 = s1 - 1;
    scrollController.scrollTo(
        index: s2,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic);
  }
  /*
  Future scrollToDown() async {
    scrollController.scrollTo(
        index: 500,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic);
  }

   */

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      body: StickyGroupedListView<dynamic, String>(
        elements: widget.list,
        groupBy: (element) => element['cat_name'],

        groupSeparatorBuilder: (dynamic element) => Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Flexible(
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: GestureDetector(
                        child: Row(
                          children: [
                            Text(
                              element['cat_name'],
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const Divider(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List>(
                  future: getCat(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return PopupMenuButton<String>(
                          itemBuilder: (context) => snapshot.data!
                              .map((item) => PopupMenuItem<String>(
                                    value: item['id'].toString(),
                                    child: Text(
                                      item['cat_name'].toString(),
                                    ),
                                  ))
                              .toList(),
                          onSelected: (value) {
                            //print(value);
                            scrollToUp(value);
                          },
                          icon: SizedBox.fromSize(
                            size: Size.fromRadius(200),
                            child: FittedBox(
                              child: Icon(
                                Icons.list,
                                color: Color.fromRGBO(14, 28, 71, 1),
                              ),
                            ),

                            //child: Icon(Icons.menu, color: Colors.white), <-- You can give your icon here
                          ));
                    } else if (snapshot.hasError) {
                      return Text('Error loz: ${snapshot.error}');
                    }
                    return Text("Loading...");
                  }),
            ],
          ),
        ),

        //itemBuilder: (context, dynamic element) => Text(element['name']),
        itemBuilder: (context, dynamic element) {
          return InkWell(
            onTap: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => SingleChildScrollView(
                  child: AlertDialog(
                    title: Text('Chọn món: ' + element['name']),
                    //content: Text('Đơn giá: '+list[index]['price'].toString()+'đ'),

                    content: Container(
                      height: 360,
                      width: 400,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Form(
                          key: _form,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Đơn giá: ' +
                                  formatter
                                      .format(element['price'])
                                      .toString() +
                                  'đ'),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: textquantity,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Nhập số lượng';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Số lượng',
                                  icon: Icon(Icons.add_shopping_cart_rounded),
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                controller: textghichu,
                                decoration: InputDecoration(
                                  labelText: 'Ghi chú',
                                  icon: Icon(Icons.sticky_note_2_rounded),
                                ),
                              ),
                              GestureDetector(
                                child: Hero(
                                    tag: 'imageHero',
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 10.0),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                        "http://thunganoc377.knssoftworks.com/public/source/foodimg/" +
                                            element['img'].toString(),
                                        width: MediaQuery.of(context).size.width,
                                        height: 200,
                                        placeholder: (context, url) => Center(
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                child:
                                                new CircularProgressIndicator())),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                    ),
                                onTap: () {
                                  String imgname = element['img'].toString();
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return DetailScreen(name: imgname);
                                  }));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    actions: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Color.fromRGBO(14, 28, 71, 1),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              int idmon = element['id'];
                              String namebar = element['name'].toString();
                              _addOrder(context, idmon, namebar);
                              widget.refresh();
                              //làm flushbar
                            },
                            child: const Text('OK',
                                style: TextStyle(
                                    color: Color.fromRGBO(14, 28, 71, 1),
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(),
              child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 5,
                  margin: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            "http://thunganoc377.knssoftworks.com/public/source/foodimg/" +
                                element['img'].toString(),
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: ListTile(title: Text(element['name'])),
                          ),
                          Spacer(),
                          Expanded(
                            child: ListTile(
                              title: Text(formatter
                                      .format(element['price'])
                                      .toString() +
                                  ' đ'),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
          );
        },
        itemComparator: (item1, item2) =>
            item1['name'].compareTo(item2['name']), // optional
        itemScrollController: scrollController,
        floatingHeader: false, // optional
        order: StickyGroupedListOrder.ASC, // optional
      ),
    );
  }
}

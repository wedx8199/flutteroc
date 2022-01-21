import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'imgfull.dart';
import 'entity/food.dart';
import 'package:flushbar/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as intl;

class SearchItems extends StatefulWidget {
  int tableid;
  SearchItems({required this.tableid});
  @override
  _SearchItemsState createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {
  final formatter = intl.NumberFormat.decimalPattern();
  final _form = GlobalKey<FormState>(); //for storing form state.

  TextEditingController textsearch = new TextEditingController();
  TextEditingController textquantity = new TextEditingController();
  TextEditingController textghichu = new TextEditingController();

  List<Food> _fuds = List<Food>.empty(growable: true);
  List<Food> _fudsOnSearch = List<Food>.empty(growable: true);

  Future<List<Food>> getData() async {
    final rep = await http
        .get(Uri.parse("http://thunganoc377.knssoftworks.com/public/showfood"));
    var fuds = List<Food>.empty(growable: true);
    if (rep.statusCode == 200) {
      var notesJson = json.decode(rep.body);
      for (var noteJson in notesJson) {
        fuds.add(Food.fromJson(noteJson));
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
    return fuds;
  }

  var userData;
  @override
  void initState() {
    _getUserInfo();
    getData().then((value) {
      setState(() {
        _fuds.addAll(value);
        _fudsOnSearch = _fuds;
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(14, 28, 71, 1),
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back_ios)),
          automaticallyImplyLeading: false, //bá dơ
          title: Container(
            margin: const EdgeInsets.only(right: 1),
            padding: const EdgeInsets.only(left: 2),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Container(
                decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: TextField(
                  controller: textsearch,
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.white),
                  autofocus: true,
                  decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Tìm món',
                    hintStyle: TextStyle(color: Colors.white),
                    contentPadding: EdgeInsets.all(10.0),
                  ),
                  onChanged: (text) {
                    text = text.toLowerCase();
                    setState(() {
                      _fudsOnSearch = _fuds.where((food) {
                        var fTitle = food.name!.toLowerCase();
                        return fTitle.contains(text);
                      }).toList();
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          // Let the ListView know how many items it needs to build.
          itemCount: _fudsOnSearch == null
              ? 0
              : _fudsOnSearch.length, //if list null 0, else list.length
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: ListTile(
                title: Text(_fudsOnSearch[index].name.toString()),
                subtitle: Text(formatter
                        .format(_fudsOnSearch[index].price)
                        .toString() +
                    'đ'),
                onTap: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => SingleChildScrollView(
                      child: AlertDialog(
                        title: Text('Chọn món: ' + _fudsOnSearch[index].name.toString()),
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
                                          .format(_fudsOnSearch[index].price)
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
                                              _fudsOnSearch[index].img.toString(),
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
                                      String imgname = _fudsOnSearch[index].img.toString();
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
                                  int? idmon = _fudsOnSearch[index].id;
                                  String namebar = _fudsOnSearch[index].name.toString();
                                  _addOrder(context, idmon, namebar);
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






                       /*
                        SingleChildScrollView(
                      child: AlertDialog(
                        title: Text('Chọn món: ' +
                            _fudsOnSearch[index].name.toString()),
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
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text('Đơn giá: ' +
                                      _fudsOnSearch[index].price.toString() +
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
                                      icon:
                                          Icon(Icons.add_shopping_cart_rounded),
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
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "http://thunganoc377.knssoftworks.com/public/source/foodimg/" +
                                                  _fudsOnSearch[index]
                                                      .img
                                                      .toString(),
                                          width: 300,
                                          height: 200,
                                          placeholder: (context, url) => Center(
                                              child: Container(
                                                  width: 32,
                                                  height: 32,
                                                  child:
                                                      new CircularProgressIndicator())),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        )),
                                    onTap: () {
                                      String imgname =
                                          _fudsOnSearch[index].img.toString();
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
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel',
                                    style: TextStyle(
                                        color: Color.fromRGBO(14, 28, 71, 1),
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                              TextButton(
                                onPressed: () {
                                  int? idmon = _fudsOnSearch[index].id;
                                  String namebar =
                                      _fudsOnSearch[index].name.toString();
                                  _addOrder(context, idmon, namebar);
                                  //widget.refresh(); //diz shit

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
                    */







                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

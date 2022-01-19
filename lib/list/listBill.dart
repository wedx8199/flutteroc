import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutteroc/main.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flushbar/flushbar.dart';
import 'package:intl/intl.dart' as intl;
import '../pickTable.dart';

class BillItems extends StatefulWidget {
  List list;
  int tableid;
  BillItems({required this.list, required this.tableid});

  @override
  State<BillItems> createState() => _BillItemsState();
}

class _BillItemsState extends State<BillItems> {
  final formatter = intl.NumberFormat.decimalPattern();
  final _form = GlobalKey<FormState>();
  TextEditingController textquantity = new TextEditingController();
  TextEditingController textname = new TextEditingController();
  TextEditingController textsdt = new TextEditingController();

  void _editOrder(context, idinfo, namebar) {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    } else {
      String id = idinfo.toString();
      http.post(
          Uri.parse("http://thunganoc377.knssoftworks.com/public/update/" + id),
          body: {
            "quantity": textquantity.text,
          });

      //print(idinfo);
      //print(textquantity.text);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => Tables()),
      );
      Flushbar(
        title: "Đã sửa hóa đơn món: " +
            namebar +
            " (Bàn " +
            widget.tableid.toString() +
            ")",
        message: "Số lượng sửa: " + textquantity.text,
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  void _deleteFunction(context, idinfo) {
    String id = idinfo.toString();
    http.get(
        Uri.parse("http://thunganoc377.knssoftworks.com/public/delete/" + id));

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => Tables()),
    );

    Flushbar(
      title: "Đã xóa 1 món khỏi hóa đơn",
      message: "Bàn " + widget.tableid.toString(),
      duration: Duration(seconds: 3),
    )..show(context);
  }

  void _checkoutFunction(context, sum) {
    String id = widget.tableid.toString();
    String tong = sum.toString(); //da shit
    http.post(
        Uri.parse("http://thunganoc377.knssoftworks.com/public/checkout/" + id),
        body: {
          "total": tong,
          "khn": textname.text,
          "sophone": textsdt.text,
        });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => Tables()),
    );

    Flushbar(
      title: "Hoàn thành thanh toán hóa đơn",
      message: "Bàn " + widget.tableid.toString(),
      duration: Duration(seconds: 3),
    )..show(context);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(14, 28, 71, 1),
        onPressed: () {
          var totaljson = widget.list.map((e) => e['total']).toList();

          if (totaljson.length == 0) {
            //ban trong check shit
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => MyApp()),
            );

            Flushbar(
              title: "Không thể thanh toán bàn trống",
              message: "Bàn " + widget.tableid.toString(),
              duration: Duration(seconds: 3),
            )..show(context);
          } else {
            var sum = totaljson.reduce((a, b) => a + b); //tính sum

            Flushbar(
              title: formatter.format(sum).toString() + " VNĐ",
              message: "Tổng hóa đơn bàn " + widget.tableid.toString(),
              duration: Duration(seconds: 20),
              isDismissible: true,
              dismissDirection: FlushbarDismissDirection.HORIZONTAL,
              mainButton: TextButton(
                onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => SingleChildScrollView(
                      child: AlertDialog(
                        title: Text('Tính tiền hóa đơn: Bàn ' +
                            widget.tableid.toString() +
                            ' ?'),
                        content: Form(
                          key: _form,
                          child: Container(
                            child: SizedBox(
                              height: 200,
                              width: 400,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formatter.format(sum).toString() + ' VNĐ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromRGBO(14, 28, 71, 1),
                                    ),
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: textname,
                                    decoration: InputDecoration(
                                      labelText: 'Tên khách',
                                      icon: Icon(Icons
                                          .supervised_user_circle_outlined),
                                    ),
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: textsdt,
                                    decoration: InputDecoration(
                                      labelText: 'Điện thoại',
                                      icon: Icon(Icons.local_phone_outlined),
                                    ),
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
                                onPressed: () {
                                  Navigator.pop(context, 'Hủy');
                                },
                                child: const Text(
                                  'Hủy',
                                  style: TextStyle(
                                      color: Color.fromRGBO(14, 28, 71, 1),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  _checkoutFunction(context, sum);
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                      color: Color.fromRGBO(14, 28, 71, 1),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
                child: Text(
                  "Thanh Toán",
                  style: TextStyle(color: Colors.amber),
                ),
              ),
            )..show(context);
          }
        },
        child: Icon(Icons.monetization_on_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          // Let the ListView know how many items it needs to build.
          // ignore: unnecessary_null_comparison
          itemCount: widget.list == null
              ? 0
              : widget.list.length, //if list null 0, else list.length
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: ListTile(
                title: Text(widget.list[index]['name'] +
                    ' (Số lượng: ' +
                    widget.list[index]['quantity'].toString() +
                    ')'),
                subtitle: Text('Tổng: ' +
                    formatter.format(widget.list[index]['total']).toString() +
                    'đ'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 30.0,
                        color: Color.fromRGBO(14, 28, 71, 1),
                      ),
                      onPressed: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text(
                                'Chỉnh sửa: ' + widget.list[index]['name']),
                            //content: Text('Đơn giá: '+list[index]['price'].toString()+'đ'),

                            content: Form(
                              key: _form,
                              child: Container(
                                height: 300,
                                width: 200,
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Đơn giá: ' +
                                          formatter
                                              .format(
                                                  widget.list[index]['price'])
                                              .toString() +
                                          'đ'),
                                      Text('Số lượng: ' +
                                          widget.list[index]['quantity']
                                              .toString()),
                                      Text('Tổng: ' +
                                          formatter
                                              .format(
                                                  widget.list[index]['total'])
                                              .toString() +
                                          'đ'),
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: textquantity =
                                            TextEditingController(
                                                text: widget.list[index]
                                                        ['quantity']
                                                    .toString()),
                                        validator: (text) {
                                          if (text == null || text.isEmpty) {
                                            return 'Nhập số lượng';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Số lượng',
                                          icon: Icon(
                                              Icons.add_shopping_cart_rounded),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            actions: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Hủy'),
                                    child: const Text(
                                      'Hủy',
                                      style: TextStyle(
                                          color: Color.fromRGBO(14, 28, 71, 1),
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      int idinfo = widget.list[index]['id'];
                                      String namebar =
                                          widget.list[index]['name'].toString();
                                      _editOrder(context, idinfo, namebar);

                                      /*var totaljson = list.map((e) => e['total']).toList();
                                  var sum = totaljson.reduce((a, b) => a + b);

                                  print(sum);*/
                                    },
                                    child: const Text('OK',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(14, 28, 71, 1),
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        size: 30.0,
                        color: Color.fromRGBO(14, 28, 71, 1),
                      ),
                      onPressed: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Xóa món khỏi hóa đơn?'),
                            content: Text(widget.list[index]['name'] +
                                ' (Số lượng: ' +
                                widget.list[index]['quantity'].toString() +
                                ')'),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Hủy'),
                                    child: const Text(
                                      'Hủy',
                                      style: TextStyle(
                                          color: Color.fromRGBO(14, 28, 71, 1),
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      int idinfo = widget.list[index]['id'];
                                      _deleteFunction(context, idinfo);

                                      /*Flushbar(
                                    title:  "Đã xóa 1 món khỏi hóa đơn",
                                    duration:  Duration(seconds: 3),
                                  )..show(context);*/
                                    },
                                    child: const Text(
                                      'Xóa',
                                      style: TextStyle(
                                          color: Color.fromRGBO(14, 28, 71, 1),
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

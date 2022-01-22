import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutteroc/main.dart';
import 'package:flutteroc/repositories/order_repository.dart';
import 'package:flutteroc/resources/styles.dart';
import 'package:flutteroc/screens/screens.dart';
import 'package:flutteroc/utils/food_utils.dart';
import 'package:flutteroc/utils/utils.dart';
import 'package:intl/intl.dart' as intl;

class BillScreen extends StatefulWidget {
  List list;
  int tableId;

  BillScreen({required this.list, required this.tableId});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  final formatter = intl.NumberFormat.decimalPattern();
  final _form = GlobalKey<FormState>();
  TextEditingController textquantity = new TextEditingController();
  TextEditingController textname = new TextEditingController();
  TextEditingController textsdt = new TextEditingController();

  final _orderRepository = OrderRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return widget.list.isEmpty
        ? Center(child: Text('Chưa có món, vui lòng chọn món'))
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.blue,
              onPressed: () {
                var totaljson = widget.list.map((e) => e['total']).toList();
                if (totaljson.length == 0) {
                  //ban trong check shit
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (BuildContext context) => MyApp()),
                  );
                  Flushbar(
                    title: "Không thể thanh toán bàn trống",
                    message: "Bàn " + widget.tableId.toString(),
                    duration: Duration(seconds: 3),
                  )..show(context);
                } else {
                  var sum = totaljson.reduce((a, b) => a + b); //tính sum
                  Flushbar(
                    title: FoodUtils.formatPrice(sum, prefix: " VNĐ"),
                    message: "Tổng hóa đơn bàn " + widget.tableId.toString(),
                    duration: Duration(seconds: 20),
                    isDismissible: true,
                    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                    mainButton: TextButton(
                      onPressed: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) =>
                              SingleChildScrollView(
                            child: AlertDialog(
                              title: Text('Tính tiền hóa đơn: Bàn ' +
                                  widget.tableId.toString() +
                                  ' ?'),
                              content: Form(
                                key: _form,
                                child: Container(
                                  child: SizedBox(
                                    height: 200,
                                    width: 400,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          FoodUtils.formatPrice(sum,
                                              prefix: " VNĐ"),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.blue,
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
                                            icon: Icon(
                                                Icons.local_phone_outlined),
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
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Hủy',
                                        style: Styles.dialogActionButton,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _finishOrder(context, sum);
                                      },
                                      child: Text(
                                        'Đồng ý',
                                        style: Styles.dialogActionButton,
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: ListView.separated(
              separatorBuilder: (context, index) {
                if (index < widget.list.length - 1) {
                  return Divider(height: 1, color: Colors.grey);
                } else {
                  return Divider(
                    height: 0,
                  );
                }
              },
              itemCount: widget.list.length,
              itemBuilder: (context, index) {
                final data = widget.list[index];
                return ListTile(
                  title: Text(data['name'] +
                      ' (Số lượng: ' +
                      data['quantity'].toString() +
                      ')'),
                  subtitle:
                      Text('Tổng: ' + FoodUtils.formatPrice(data['total'])),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      buildEditButton(data),
                      buildDeleteButton(data),
                    ],
                  ),
                );
              },
            ),
          );
  }

  Widget buildEditButton(dynamic data) {
    return IconButton(
      icon: Icon(
        Icons.edit_outlined,
        size: 30.0,
        color: AppColors.blue,
      ),
      onPressed: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Chỉnh sửa: ' + data['name']),
            content: Form(
              key: _form,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 140.0, maxWidth: 200.0),
                child: Container(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Đơn giá: ' + FoodUtils.formatPrice(data['price'])),
                        Text('Số lượng: ' + data['quantity'].toString()),
                        Text('Tổng: ' + FoodUtils.formatPrice(data['total'])),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: textquantity = TextEditingController(
                              text: data['quantity'].toString()),
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Hủy',
                      style: Styles.dialogActionButton,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      int orderId = data['id'];
                      String foodName = data['name'].toString();
                      _editOrder(context, orderId, foodName);
                    },
                    child: Text('Đồng ý', style: Styles.dialogActionButton),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildDeleteButton(dynamic data) {
    return IconButton(
      icon: Icon(
        Icons.delete_outline,
        size: 30.0,
        color: AppColors.blue,
      ),
      onPressed: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Xóa món khỏi hóa đơn?'),
            content: Text(data['name'] +
                ' (Số lượng: ' +
                data['quantity'].toString() +
                ')'),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Hủy',
                      style: Styles.dialogActionButton,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      int orderId = data['id'];
                      _deleteOrder(context, orderId);
                    },
                    child: Text(
                      'Xóa',
                      style: Styles.dialogActionButton,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _editOrder(context, orderId, foodName) async {
    final isValid = _form.currentState!.validate();
    if (isValid) {
      final response = await _orderRepository.editOrder(orderId, {
        "quantity": textquantity.text,
      });
      if (response.isSuccess()) {
        Navigator.pop(context);
        WidgetUtils.showFlushBar(
            context: context,
            title: "Đã sửa hóa đơn món: " +
                foodName +
                " (Bàn " +
                widget.tableId.toString() +
                ")",
            message: "Số lượng sửa: " + textquantity.text);
      } else {
        WidgetUtils.showFlushBar(
            context: context,
            title: 'Lỗi Khi Cập Nhật Món',
            message: response.exception!.message);
      }
    }
  }

  void _deleteOrder(context, orderId) async {
    final response = await _orderRepository.deleteOrder(orderId);
    if (response.isSuccess()) {
      Navigator.pop(context);
      WidgetUtils.showFlushBar(
          context: context,
          title: 'Đã xóa 1 món khỏi hóa đơn',
          message: "Bàn " + widget.tableId.toString());
    } else {
      WidgetUtils.showFlushBar(
          context: context,
          title: 'Lỗi Khi Xóa Món',
          message: response.exception!.message);
    }
  }

  void _finishOrder(context, sum) async {
    final tableId = widget.tableId;
    final response = await _orderRepository.finishOrder(tableId, {
      "total": sum.toString(),
      "khn": textname.text,
      "sophone": textsdt.text,
    });
    if (response.isSuccess()) {
      Navigator.of(context).pushReplacement(HomeScreen.screen());
      WidgetUtils.showFlushBar(
          context: context,
          title: 'Hoàn thành thanh toán hóa đơn',
          message: 'Bàn ${widget.tableId.toString()}');
    } else {
      WidgetUtils.showFlushBar(
          context: context,
          title: 'Lỗi Khi Thanh Toán',
          message: response.exception!.message);
    }
  }
}

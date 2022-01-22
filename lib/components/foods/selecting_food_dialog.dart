import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutteroc/data/network/api_helper.dart';
import 'package:flutteroc/managers/user_manager.dart';
import 'package:flutteroc/models/food.dart';
import 'package:flutteroc/repositories/food_repository.dart';
import 'package:flutteroc/resources/styles.dart';
import 'package:flutteroc/screens/foods/food_image_full_screen.dart';
import 'package:flutteroc/utils/food_utils.dart';
import 'package:flutteroc/utils/utils.dart';

class SelectingFoodDialog extends StatefulWidget {
  final Food food;
  final int tableId;

  SelectingFoodDialog({Key? key, required this.food, required this.tableId})
      : super(key: key);

  @override
  State<SelectingFoodDialog> createState() => _SelectingFoodDialogState();
}

class _SelectingFoodDialogState extends State<SelectingFoodDialog> {
  final _form = GlobalKey<FormState>();
  final TextEditingController quantityTextController =
      new TextEditingController();
  final TextEditingController noteTextController = new TextEditingController();

  var _user;

  final FoodRepository _foodRepository = FoodRepositoryImpl();

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
    return AlertDialog(
      title: Text('Chọn món: ' + widget.food.name.toString()),
      content: Form(
        key: _form,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Đơn giá: ' + FoodUtils.formatPrice(widget.food.price!)),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: quantityTextController,
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
              controller: noteTextController,
              decoration: InputDecoration(
                labelText: 'Ghi chú',
                icon: Icon(Icons.sticky_note_2_rounded),
              ),
            ),
            SizedBox(height: 16,),
            GestureDetector(
              child: Hero(
                tag: 'imageHero',
                child: CachedNetworkImage(
                  imageUrl: "${ApiHelper.BASE_URL}/public/source/foodimg/" +
                      widget.food.img.toString(),
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                  placeholder: (context, url) => Center(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: new CircularProgressIndicator())),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              onTap: () {
                String imgname = widget.food.img.toString();
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return FoodImageFullScreen(name: imgname);
                }));
              },
            ),
          ],
        ),
      ),
      actions: [
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
                final isValid = _form.currentState!.validate();
                if (isValid) {
                  WidgetUtils.unFocus(context);
                  _addFood();
                }
              },
              child: Text('Đồng ý', style: Styles.dialogActionButton),
            ),
          ],
        )
      ],
    );
  }

  void _addFood() async {
    final food = widget.food;
    final quantity = int.parse(quantityTextController.text);
    final note = noteTextController.text;
    final response = await _foodRepository.addFood(
        -_user['id'], widget.tableId, food.id!, quantity, note);
    if (response.isSuccess()) {
      Navigator.pop(context);
      WidgetUtils.showFlushBar(
          context: context,
          title: 'Đã thêm món: ${food.name}',
          message: 'Số lượng: $quantity');
    } else {
      WidgetUtils.showFlushBar(
          context: context,
          title: 'Lỗi khi chọn món',
          message: response.exception!.message);
    }
  }
}

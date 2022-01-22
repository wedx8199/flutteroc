import 'package:flutter/material.dart';
import 'package:flutteroc/components/foods/selecting_food_dialog.dart';
import 'package:flutteroc/models/models.dart';
import 'package:flutteroc/repositories/food_repository.dart';
import 'package:flutteroc/utils/app_colors.dart';
import 'package:flutteroc/utils/food_utils.dart';
import 'package:flutteroc/utils/utils.dart';

class SearchingFoodsScreen extends StatefulWidget {
  int tableId;

  SearchingFoodsScreen({required this.tableId});

  @override
  _SearchingFoodsScreenState createState() => _SearchingFoodsScreenState();
}

class _SearchingFoodsScreenState extends State<SearchingFoodsScreen> {
  TextEditingController searchingFoodTextController =
      new TextEditingController();

  List<Food> _fuds = List<Food>.empty(growable: true);
  List<Food> _fudsOnSearch = List<Food>.empty(growable: true);

  final _foodRepository = FoodRepositoryImpl();

  Future<List<Food>> getData() async {
    final response = await _foodRepository.getFoods();
    var fuds = List<Food>.empty(growable: true);
    if (response.isSuccess()) {
      for (var noteJson in response.data!) {
        fuds.add(Food.fromJson(noteJson));
      }
    } else {
      WidgetUtils.showFlushBar(
          context: context,
          title: 'Lỗi Tìm Món',
          message: response.exception!.message);
    }
    return fuds;
  }

  @override
  void initState() {
    super.initState();
    getData().then((value) {
      setState(() {
        _fuds.addAll(value);
        _fudsOnSearch = _fuds;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.blue,
            leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back_ios)),
            automaticallyImplyLeading: false, //bá dơ
            title: Center(
                child: SizedBox(
              height: 42,
              child: TextField(
                controller: searchingFoodTextController,
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.white),
                autofocus: true,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: 'Tìm món',
                  hintStyle: TextStyle(color: Colors.white),
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
            )),
          ),
          body: ListView.separated(
              itemBuilder: (context, index) {
                final food = _fudsOnSearch[index];
                return ListTile(
                  title: Text(food.name.toString()),
                  subtitle: Text(FoodUtils.formatPrice(food.price!)),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => SingleChildScrollView(
                        child: SelectingFoodDialog(
                            food: food, tableId: widget.tableId),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                if (index < _fudsOnSearch.length - 1) {
                  return Divider(height: 1, color: Colors.grey);
                } else {
                  return Divider(
                    height: 0,
                  );
                }
              },
              itemCount: _fudsOnSearch.length)),
    );
  }
}

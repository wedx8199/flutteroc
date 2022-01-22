
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutteroc/components/foods/selecting_food_dialog.dart';
import 'package:flutteroc/data/data.dart';
import 'package:flutteroc/models/food.dart';
import 'package:flutteroc/repositories/food_repository.dart';
import 'package:flutteroc/utils/food_utils.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class FoodTile extends StatefulWidget {
  List list;
  int tableId;
  final VoidCallback refresh;

  FoodTile({required this.list, required this.tableId, required this.refresh});

  @override
  _FoodTileState createState() => _FoodTileState();
}

class _FoodTileState extends State<FoodTile> {
  final scrollController = GroupedItemScrollController();
  final _foodRepository = FoodRepositoryImpl();

  Future scrollToUp(value) async {
    var s1 = int.parse(value);
    int s2 = s1 - 1;
    scrollController.scrollTo(
        index: s2,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      body: StickyGroupedListView<dynamic, String>(
        key: PageStorageKey(widget.key),
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
              FutureBuilder<ApiResponse<List>>(
                  future: _foodRepository.getCategory(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return PopupMenuButton<String>(
                          itemBuilder: (context) => snapshot.data!.data!
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
                      return Text('Lỗi: ${snapshot.error}');
                    }
                    return Text("Loading...");
                  }),
            ],
          ),
        ),

        itemBuilder: (context, dynamic element) {
          return InkWell(
            onTap: () {
              Food food = Food.fromJson(element);
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => SingleChildScrollView(
                  child: SelectingFoodDialog(
                    food: food,
                    tableId: widget.tableId,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, right: 10),
              decoration: BoxDecoration(),
              child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 4,
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
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 16, bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              element['name'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )),
                            Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                    FoodUtils.formatPrice(element['price']),
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black87)))
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          );
        },
        itemComparator: (item1, item2) =>
            item1['name'].compareTo(item2['name']),
        // optional
        itemScrollController: scrollController,
        floatingHeader: false,
        // optional
        order: StickyGroupedListOrder.ASC, // optional
      ),
    );
  }
}

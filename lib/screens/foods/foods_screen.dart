
import 'package:flutter/material.dart';
import 'package:flutteroc/components/components.dart';
import 'package:flutteroc/components/loading_widget.dart';
import 'package:flutteroc/data/data.dart';
import 'package:flutteroc/repositories/food_repository.dart';
import 'package:flutteroc/repositories/order_repository.dart';
import 'package:flutteroc/screens/screens.dart';
import 'package:flutteroc/utils/app_colors.dart';

import '../screens.dart';

class FoodsScreen extends StatefulWidget {
  List list;
  int index;

  FoodsScreen({required this.list, required this.index});

  @override
  _FoodsScreenState createState() => _FoodsScreenState();
}

class _FoodsScreenState extends State<FoodsScreen>{
  final _foodRepository = FoodRepositoryImpl();
  final _orderRepository = OrderRepositoryImpl();

  @override
  _refreshFoods() {
    setState(() {
      //You can also make changes to your state here.
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.blue,
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
                          tableId: widget.list[widget.index]['id'])),
                ),
              ),
            ],
          ),
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              buildMenu(),
              buildOrderDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget menu() {
    return Container(
      height: 60,
      color: AppColors.blue,
      child: TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: AppColors.blue,
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

  Widget buildMenu() {
    return FutureBuilder<ApiResponse<List>>(
        future: _foodRepository.getFoods(),
        builder: (context, snapshot) {
          List<Widget> children;
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              children = [LoadingWidget()];
              break;
            default:
              if (snapshot.hasData) {
                children = <Widget>[
                  Expanded(
                      child: FoodTile(
                          list: snapshot.data!.data!,
                          tableId: widget.list[widget.index]['id'],
                          refresh: _refreshFoods)),
                ];
              } else {
                children = <Widget>[
                  Text('Lỗi: ${snapshot.error}'),
                ];
              }
              break;
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        });
  }

  Widget buildOrderDetails() {
    return FutureBuilder<ApiResponse<List>>(
        future: _orderRepository.getOrderDetails(widget.list[widget.index]['id']),
        builder: (context, snapshot) {
          List<Widget> children;
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              children = [LoadingWidget()];
              break;
            default:
              if (snapshot.hasData) {
                children = <Widget>[
                  Expanded(
                      child: BillScreen(
                          list: snapshot.data!.data!,
                          tableId: widget.list[widget.index]['id'])),
                ];
              } else {
                children = <Widget>[
                  Text('Lỗi: ${snapshot.error}'),
                ];
              }
              break;
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}

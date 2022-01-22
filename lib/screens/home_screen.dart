
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteroc/components/components.dart';
import 'package:flutteroc/components/loading_widget.dart';
import 'package:flutteroc/components/tables/table_tile.dart';
import 'package:flutteroc/data/data.dart';
import 'package:flutteroc/repositories/table_repository.dart';
import 'package:flutteroc/screens/screens.dart';
import 'package:flutteroc/utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  static MaterialPageRoute screen() {
    return MaterialPageRoute(builder: (context) {
      return HomeScreen();
    });
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();
  final TableRepository _tableRepository = TableRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _drawerKey,
        drawer: SlidingMenuScreen(),
        appBar: AppBar(
          backgroundColor: AppColors.blue,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _drawerKey.currentState!.openDrawer(),
          ),
          title: Text('Ốc Chill 377'),
          automaticallyImplyLeading: false,
          //bá dơ

          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: () {
                _refreshTables();
              },
            ),
          ],
        ),
        body: FutureBuilder<ApiResponse<List>>(
          future: _tableRepository.getTables(),
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
                    Expanded(child: TableTile(list: snapshot.data!.data!)),
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
          },
        ));
  }

  void _refreshTables() {
    setState(() {});
  }
}

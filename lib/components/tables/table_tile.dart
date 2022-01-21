
import 'package:flutter/material.dart';
import 'package:flutteroc/screens/screens.dart';

class TableTile extends StatelessWidget {
  List list;

  TableTile({required this.list});

  @override
  Widget build(BuildContext context) {
    Color _status(status) {
      if (status == "Trống") {
        return Colors.greenAccent;
      } else {
        return Colors.redAccent;
      }
    }

    Image _img(status) {
      if (status == "Trống") {
        return Image.asset('assets/png.png', height: 40, width: 40);
      } else {
        return Image.asset('assets/table2.png', height: 40, width: 40);
      }
    }

    return Column(children: [
      Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 9 / 9,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1),
            itemCount: list == null ? 0 : list.length,
            itemBuilder: (ctx, index) {
              return GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          FoodsScreen(list: list, index: index)),
                ),
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      color: _status(list[index]['status']),
                      child: Stack(
                        children: [
                          ListTile(
                            title: Text(list[index]['name']),
                            subtitle: Text(list[index]['status']),
                          ),
                          Positioned(
                              child: _img(list[index]['status']),
                              bottom: 10,
                              right: 20)
                        ],
                      ),
                    )),
              );
            },
          ),
          flex: 4),
    ]);
  }
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';


class DetailScreen extends StatefulWidget {
  String name;
  DetailScreen({required this.name});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  void dispose() {
    //SystemChrome.restoreSystemUIOverlays();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override

  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold (
        body: Center(
          child: Hero(
            tag: 'imageHero',
            child: CachedNetworkImage(
              imageUrl:
              "http://thunganoc377.knssoftworks.com/public/source/foodimg/" + widget.name,
              placeholder: (context, url) => Center(child: Container(width: 32, height: 32,child: new CircularProgressIndicator())),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

}

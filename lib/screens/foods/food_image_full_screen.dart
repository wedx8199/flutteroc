import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutteroc/data/network/api_helper.dart';

class FoodImageFullScreen extends StatefulWidget {
  String name;

  FoodImageFullScreen({required this.name});

  @override
  _FoodImageFullScreenState createState() => _FoodImageFullScreenState();
}

class _FoodImageFullScreenState extends State<FoodImageFullScreen> {
  @override
  initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        body: Center(
          child: Hero(
            tag: 'imageHero',
            child: CachedNetworkImage(
              imageUrl:
                  "${ApiHelper.BASE_URL}/public/source/foodimg/" + widget.name,
              placeholder: (context, url) => Center(
                  child: Container(
                      width: 32,
                      height: 32,
                      child: new CircularProgressIndicator())),
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

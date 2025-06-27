import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RecipeView extends StatefulWidget {
  final String postUrl;

  const RecipeView({super.key, required this.postUrl});

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  late String finalUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    finalUrl = widget.postUrl;
    if (widget.postUrl.contains('http://')) {
      finalUrl = widget.postUrl.replaceAll("http://", "https://");
      if (kDebugMode) {
        print("${finalUrl}this is final url");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: Platform.isIOS ? 60 : 30, right: 24, left: 24, bottom: 16),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff63d056), Color(0xffe6e7e1)],
                    begin: FractionalOffset.topRight,
                    end: FractionalOffset.bottomLeft)),
            child: Row(
              mainAxisAlignment:
                  kIsWeb ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: const <Widget>[
                Text(
                  "Edamam",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'Overpass'),
                ),
                Text(
                  "Recipes",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'Overpass'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

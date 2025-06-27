import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/recipe_model.dart';
import 'recipe_view.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<RecipeModel> recipes = [];
  late String ingredients;
  bool _loading = false;
  TextEditingController textEditingController = TextEditingController();

  List<String> filters = ["breakfast", "lunch", "teatime"];
  String? selectedFilter = "breakfast";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xff0e4b07),
                      Color(0xffb8ff47)
                    ],
                    begin: FractionalOffset.topRight,
                    end: FractionalOffset.bottomLeft)),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: !kIsWeb ? Platform.isIOS? 60: 30 : 30, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: kIsWeb
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
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
                            color: Colors.lightGreenAccent,
                            fontFamily: 'Overpass'),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  const Text(
                    "Search recipes",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Overpass'),
                  ),
                  const Text(
                    "on-demand",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'OverpassRegular'),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: textEditingController,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'Overpass'),
                          decoration: InputDecoration(
                            hintText: "Enter keyword...",
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.5),
                                fontFamily: 'Overpass'),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      DropdownButton<String>(
                          value: selectedFilter,
                          dropdownColor: Colors.lightGreen,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            size: 30,
                            color: Colors.white,
                          ),
                          items: filters
                              .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item, style: const TextStyle(fontSize: 16, color: Colors.white))))
                              .toList(growable: true),
                          onChanged: (item) => setState(() {
                            selectedFilter = item;
                          })),
                      const SizedBox(
                        width: 16,
                      ),
                      InkWell(
                          onTap: () async {
                            if (textEditingController.text.isNotEmpty) {
                              setState(() {
                                _loading = true;
                              });
                              recipes = [];
                              String url =
                                  "https://api.edamam.com/search?q=${textEditingController.text}&mealType=$selectedFilter&app_id=0f21d949&app_key=8bcdd93683d1186ba0555cb95e64ab26";
                              var response = await http.get(url);
                              if (kDebugMode) {
                                print(" $response this is response");
                              }
                              Map<String, dynamic> jsonData =
                              jsonDecode(response.body);
                              if (kDebugMode) {
                                print("this is json Data $jsonData");
                              }
                              jsonData["hits"].forEach((element) {
                                if (kDebugMode) {
                                  print(element.toString());
                                }
                                RecipeModel recipeModel = RecipeModel(image: '', url: '', label: '', source: '');
                                recipeModel =
                                    RecipeModel.fromMap(element['recipe']);
                                recipes.add(recipeModel);
                                if (kDebugMode) {
                                  print(recipeModel.url);
                                }
                              });
                              setState(() {
                                _loading = false;
                              });

                              if (kDebugMode) {
                                print("doing it");
                              }
                            } else {
                              if (kDebugMode) {
                                print("not doing it");
                              }
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: const LinearGradient(
                                    colors: [
                                      Color(0xffA2834D),
                                      Color(0xffBC9A5F)
                                    ],
                                    begin: FractionalOffset.topRight,
                                    end: FractionalOffset.bottomLeft)),
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const <Widget>[
                                Icon(
                                    Icons.search,
                                    size: 18,
                                    color: Colors.white
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GridView(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          mainAxisSpacing: 10.0, maxCrossAxisExtent: 200.0),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const ClampingScrollPhysics(),
                      children: List.generate(recipes.length, (index) {
                        return GridTile(
                            child: RecipeTile(
                              title: recipes[index].label,
                              imgUrl: recipes[index].image,
                              desc: recipes[index].source,
                              url: recipes[index].url,
                            ));
                      })),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RecipeTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  const RecipeTile({super.key, required this.title, required this.desc, required this.imgUrl, required this.url});

  @override
  _RecipeTileState createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  _launchURL(String url) async {
    if (kDebugMode) {
      print(url);
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (kIsWeb) {
              _launchURL(widget.url);
            } else {
              if (kDebugMode) {
                print("${widget.url} this is what we are going to see");
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeView(
                        postUrl: widget.url,
                      )));
            }
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                Image.network(
                  widget.imgUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontFamily: 'Overpass'),
                        ),
                        Text(
                          widget.desc,
                          style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                              fontFamily: 'OverpassRegular'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class GradientCard extends StatelessWidget {
  final Color topColor;
  final Color bottomColor;
  final String topColorCode;
  final String bottomColorCode;

  const GradientCard(
      {super.key, required this.topColor,
        required this.bottomColor,
        required this.topColorCode,
        required this.bottomColorCode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 160,
                width: 180,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [topColor, bottomColor],
                        begin: FractionalOffset.topLeft,
                        end: FractionalOffset.bottomRight)),
              ),
              Container(
                width: 180,
                alignment: Alignment.bottomLeft,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.white30, Colors.white],
                        begin: FractionalOffset.centerRight,
                        end: FractionalOffset.centerLeft)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        topColorCode,
                        style: const TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      Text(
                        bottomColorCode,
                        style: TextStyle(fontSize: 16, color: bottomColor),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
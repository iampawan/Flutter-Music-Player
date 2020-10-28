import 'package:flutter/material.dart';
import 'package:music_player/my_app.dart';
import 'package:music_player/utils/themes.dart';
// import 'package:flute_example/utils/themes.dar';

void main() => runApp(new MyMaterialApp());

class MyMaterialApp extends StatefulWidget {
  @override
  MyMaterialAppState createState() {
    return new MyMaterialAppState();
  }
}

class MyMaterialAppState extends State<MyMaterialApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      home: new MyApp(),
    );
  }
}

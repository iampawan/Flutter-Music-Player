import 'dart:io';
import 'package:flute_example/widgets/mp_inherited.dart';
import 'package:flutter/material.dart';
import 'package:flute_music_player/flute_music_player.dart';
class MPDrawer extends StatefulWidget {
  @override
  MPDrawerState createState() {
    return new MPDrawerState();
  }
}

class MPDrawerState extends State<MPDrawer> {
  bool dark;
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var rootIW = MPInheritedWidget.of(context).songData;
    var cI = rootIW.currentIndex;
    Song song =
        rootIW.songs[((cI == null) || (cI < 0)) ? 0 : rootIW.currentIndex];
    var f = song.albumArt == null
        ? null
        : new File.fromUri(Uri.parse(song.albumArt));
    return new Drawer(
        child: new ListView(
      children: <Widget>[
        new DrawerHeader(
          padding: EdgeInsets.zero,
          child: f != null
              ? new Image.file(
                  f,
                  fit: BoxFit.fill,
                  gaplessPlayback: true,
                )
              : new Image.asset(
                  "assets/music_record.jpeg",
                  fit: BoxFit.fill,
                  scale: 5.0,
                  gaplessPlayback: true,
                ),
        ),
        // new SwitchListTile(
        //   title: new Text("Dark Theme"),
        //   value: dark,
        //   onChanged: (bool value) {
        //     preferences.setBool("dark", value);
        //     Scaffold.of(context).showSnackBar(new SnackBar(
        //           content: new Text("Please restart to perform changes."),
        //         ));
        //     Navigator.pop(context);
        //   },
        // ),
      ],
    ));
  }
}

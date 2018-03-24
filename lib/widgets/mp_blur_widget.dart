import 'dart:io';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';

Widget blurWidget(Song song) {
  var f =
      song.albumArt == null ? null : new File.fromUri(Uri.parse(song.albumArt));
  return new Hero(
    tag: song.artist,
    child: new Container(
      child: f != null
          // ignore: conflicting_dart_import
          ? new Image.file(
              f,
              fit: BoxFit.cover,
              color: Colors.black54,
              colorBlendMode: BlendMode.darken,
            )
          : new Image(
              image: new AssetImage("assets/lady.jpeg"),
              color: Colors.black54,
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.darken,
            ),
    ),
  );
}

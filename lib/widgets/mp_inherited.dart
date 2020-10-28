import 'package:flutter/material.dart';
import 'package:music_player/data/song_data.dart';

class MPInheritedWidget extends InheritedWidget {
  final SongData songData;
  final bool isLoading;

  const MPInheritedWidget(this.songData, this.isLoading, child)
      : super(child: child);

  static MPInheritedWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(MPInheritedWidget oldWidget) =>
      // TOD: implement updateShouldNotify
      songData != oldWidget.songData || isLoading != oldWidget.isLoading;
}

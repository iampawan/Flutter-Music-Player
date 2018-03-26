import 'dart:async';
import 'dart:ui';
import 'package:flute_example/data/song_data.dart';
import 'package:flute_example/widgets/mp_album_ui.dart';
import 'package:flute_example/widgets/mp_blur_filter.dart';
import 'package:flute_example/widgets/mp_blur_widget.dart';
import 'package:flute_example/widgets/mp_control_button.dart';
import 'package:flutter/material.dart';
import 'package:flute_music_player/flute_music_player.dart';

enum PlayerState { stopped, playing, paused }

class NowPlaying extends StatefulWidget {
  final Song _song;
  final SongData songData;
  final bool nowPlayTap;
  NowPlaying(this.songData, this._song, {this.nowPlayTap});

  @override
  _NowPlayingState createState() => new _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  MusicFinder audioPlayer;
  Duration duration;
  Duration position;
  PlayerState playerState;
  Song song;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  @override
  initState() {
    super.initState();
    initPlayer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
    play(widget.songData.nextSong);
  }

  initPlayer() async {
    if (audioPlayer == null) {
      audioPlayer = widget.songData.audioPlayer;
    }
    setState(() {
      song = widget._song;
      if (widget.nowPlayTap == null || widget.nowPlayTap == false) {
        if (playerState != PlayerState.stopped) {
          stop();
        }
      }
      play(song);
      //  else {
      //   widget._song;
      //   playerState = PlayerState.playing;
      // }
    });
    audioPlayer.setDurationHandler((d) => setState(() {
          duration = d;
        }));

    audioPlayer.setPositionHandler((p) => setState(() {
          position = p;
        }));

    audioPlayer.setCompletionHandler(() {
      onComplete();
      setState(() {
        position = duration;
      });
    });

    audioPlayer.setErrorHandler((msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

  Future play(Song s) async {
    if (s != null) {
      final result = await audioPlayer.play(s.uri, isLocal: true);
      if (result == 1)
        setState(() {
          playerState = PlayerState.playing;
          song = s;
        });
    }
  }

  Future pause() async {
    final result = await audioPlayer.pause();
    if (result == 1) setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    final result = await audioPlayer.stop();
    if (result == 1)
      setState(() {
        playerState = PlayerState.stopped;
        position = new Duration();
      });
  }

  Future next(SongData s) async {
    stop();
    setState(() {
      play(s.nextSong);
    });
  }

  Future prev(SongData s) async {
    stop();
    play(s.prevSong);
  }

  Future mute(bool muted) async {
    final result = await audioPlayer.mute(muted);
    if (result == 1)
      setState(() {
        isMuted = muted;
      });
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildPlayer() => new Container(
        padding: new EdgeInsets.all(20.0),
        child: new Column(mainAxisSize: MainAxisSize.min, children: [
          new Column(
            children: <Widget>[
              new Text(
                song.title,
                style: Theme.of(context).textTheme.headline,
              ),
              new Text(
                song.artist,
                style: Theme.of(context).textTheme.caption,
              ),
              new Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
              )
            ],
          ),
          new Row(mainAxisSize: MainAxisSize.min, children: [
            new ControlButton(Icons.skip_previous, () => prev(widget.songData)),
            new ControlButton(isPlaying ? Icons.pause : Icons.play_arrow,
                isPlaying ? () => pause() : () => play(widget._song)),
            new ControlButton(Icons.skip_next, () => next(widget.songData)),
          ]),
          duration == null
              ? new Container()
              : new Slider(
                  value: position?.inMilliseconds?.toDouble() ?? 0,
                  onChanged: (double value) =>
                      audioPlayer.seek((value / 1000).roundToDouble()),
                  min: 0.0,
                  max: duration.inMilliseconds.toDouble()),
          new Row(mainAxisSize: MainAxisSize.min, children: [
            new Text(
                position != null
                    ? "${positionText ?? ''} / ${durationText ?? ''}"
                    : duration != null ? durationText : '',
                // ignore: conflicting_dart_import
                style: new TextStyle(fontSize: 24.0))
          ]),
          new Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new IconButton(
                  icon: isMuted
                      ? new Icon(
                          Icons.headset,
                          color: Theme.of(context).unselectedWidgetColor,
                        )
                      : new Icon(Icons.headset_off,
                          color: Theme.of(context).unselectedWidgetColor),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    mute(!isMuted);
                  }),
              // new IconButton(
              //     onPressed: () => mute(true),
              //     icon: new Icon(Icons.headset_off),
              //     color: Colors.cyan),
              // new IconButton(
              //     onPressed: () => mute(false),
              //     icon: new Icon(Icons.headset),
              //     color: Colors.cyan),
            ],
          ),
        ]));

    var playerUI = new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          new AlbumUI(song, duration, position),
          new Material(
            child: _buildPlayer(),
            color: Colors.transparent,
          ),
        ]);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Now Playing"),
        centerTitle: true,
      ),
      body: new Container(
        color: Theme.of(context).backgroundColor,
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[blurWidget(song), blurFilter(), playerUI],
        ),
      ),
    );
  }
}

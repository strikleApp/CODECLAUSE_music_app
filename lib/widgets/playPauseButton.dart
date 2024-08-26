import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:melody/function/audio_functions.dart';
import 'package:melody/function/music_player_streams.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PlayPauseButton extends StatefulWidget {
  const PlayPauseButton({super.key});

  @override
  PlayPauseButtonState createState() => PlayPauseButtonState();
}

class PlayPauseButtonState extends State<PlayPauseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProcessingState state =
        Provider.of<MusicPlayerStreams>(context).processingState ??
            ProcessingState.buffering;

    switch (state) {
      case ProcessingState.idle:
        _controller.reset();
        return playPauseButton(context);
      case ProcessingState.loading:
      case ProcessingState.buffering:
        return loadingIndicator(context);
      case ProcessingState.ready:
        return playPauseButton(context);
      case ProcessingState.completed:
        _controller.reset();
        return playPauseButton(context);
    }
  }

  Widget playPauseButton(BuildContext context) {
    bool isPlaying = Provider.of<MusicPlayerStreams>(context).isPlaying;
    isPlaying ? _controller.forward() : _controller.reverse();
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: IconButton(
        iconSize: 0.507.dp,
        icon: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: _controller,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        onPressed: () {
          if (isPlaying) {
            AudioFunctions.player.pause();
            // _controller.reverse();
          } else {
            AudioFunctions.player.play();
            // _controller.forward();
          }
        },
      ),
    );
  }

  Widget loadingIndicator(BuildContext context) {
    return Container(
      width: 0.565.dp,
      height: 0.565.dp,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: IconButton(
        icon: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () {},
      ),
    );
  }
}

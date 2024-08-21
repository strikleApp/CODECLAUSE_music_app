import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PlayPauseButton extends StatefulWidget {
  const PlayPauseButton({super.key});

  @override
  PlayPauseButtonState createState() => PlayPauseButtonState();
}

class PlayPauseButtonState extends State<PlayPauseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isPlaying = false;

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

  void _togglePlayPause() {
    setState(
      () {
        if (isPlaying) {
          _controller.reverse();
        } else {
          _controller.forward();
        }
        isPlaying = !isPlaying;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
        onPressed: _togglePlayPause,
      ),
    );
  }
}

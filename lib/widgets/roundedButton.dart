import 'package:flutter/material.dart';
import 'package:melody/function/audio_functions.dart';
import 'package:melody/function/music_player_streams.dart';
import 'package:provider/provider.dart';

class RoundButton extends StatelessWidget {
  final IconData icon;
  final void Function() function;
  final double size;

  const RoundButton({
    super.key,
    required this.icon,
    required this.function,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: function,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
        padding: const EdgeInsets.all(0),
      ),
      child: Icon(
        icon,
        size: size,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}

class ShuffleWidget extends StatelessWidget {
  const ShuffleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    bool isShuffleOn = Provider.of<MusicPlayerStreams>(context).isShuffleOn;
    return ElevatedButton(
      onPressed: () {
        isShuffleOn
            ? AudioFunctions.player.setShuffleModeEnabled(false)
            : AudioFunctions.player.setShuffleModeEnabled(true);
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: isShuffleOn
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
      ),
      child: Icon(
        Icons.shuffle,
        size: 25,
        color: !isShuffleOn
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }
}

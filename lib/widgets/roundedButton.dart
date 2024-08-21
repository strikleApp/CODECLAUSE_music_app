
import 'package:flutter/material.dart';

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
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
      ),
      child: const Icon(
        Icons.shuffle,
        size: 25,
      ),
    );
  }
}

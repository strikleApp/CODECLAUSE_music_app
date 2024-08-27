import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:melody/db/hive.dart';
import 'package:melody/function/audio_functions.dart';
import 'package:melody/function/music_player_streams.dart';
import 'package:melody/function/provider_function.dart';
import 'package:melody/widgets/playPauseButton.dart';
import 'package:melody/widgets/roundedButton.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  late Future getFuture;
  bool _isLoading = true;

  Future<void> getInitial() async {
    try {
      await Provider.of<ProviderFunction>(context, listen: false)
          .loadAllAudioPlaylist(context: context);
      if (mounted) {
        Provider.of<MusicPlayerStreams>(context, listen: false)
            .audioListStream();
      }
      setState(() {
        _isLoading = false;
      });
    } catch (_) {
      print(_);
    }
  }

  @override
  void initState() {
    getFuture = getInitial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Duration totalDuration =
        Provider.of<MusicPlayerStreams>(context).totalDuration;
    Duration currentDuration =
        Provider.of<MusicPlayerStreams>(context).currentDuration;
    List<IndexedAudioSource>? audioSources =
        Provider.of<MusicPlayerStreams>(context).audioSources;
    int currentIndex = Provider.of<MusicPlayerStreams>(context).currentIndex;
    return FutureBuilder(
        future: getFuture,
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            body: Skeletonizer(
              enabled: _isLoading,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: audioSources?.length ?? 0,
                      itemBuilder: (context, index) {
                        return MusicListWidget(
                          audioSource: audioSources![index],
                          currentIndex: currentIndex,
                          itemIndex: index,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                    width: 80.w,
                    child: Center(
                      child: AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          FlickerAnimatedText(
                              audioSources == null
                                  ? "Ready to play"
                                  : "Playing now",
                              textAlign: TextAlign.center),
                          FlickerAnimatedText(
                              audioSources == null
                                  ? "No song selected"
                                  : currentIndex < audioSources.length
                                      ? audioSources[currentIndex].tag.title
                                      : "No song selected",
                              textAlign: TextAlign.center,
                              textStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                  ),
                  totalDuration.inSeconds > 0
                      ? Slider(
                          inactiveColor:
                              Theme.of(context).colorScheme.secondary,
                          min: 0.0,
                          max: totalDuration.inSeconds.toDouble(),
                          value: currentDuration.inSeconds.toDouble(),
                          onChanged: (double value) {
                            AudioFunctions.player
                                .seek(Duration(seconds: value.toInt()));
                          },
                        )
                      : Slider(
                          inactiveColor:
                              Theme.of(context).colorScheme.secondary,
                          min: 0.0,
                          max: 1.0,
                          value: 0.0,
                          onChanged: null,
                        ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(currentDuration)),
                        Text(_formatDuration(totalDuration)),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ShuffleWidget(),
                      RoundButton(
                        size: 50,
                        icon: Icons.fast_rewind_rounded,
                        function: () async {
                          await AudioFunctions.player.seekToPrevious();
                        },
                      ),
                      const PlayPauseButton(),
                      RoundButton(
                        size: 50,
                        icon: Icons.fast_forward_rounded,
                        function: () async {
                          await AudioFunctions.player.seekToNext();
                        },
                      ),
                      RoundButton(
                        size: 25,
                        icon: Icons.replay,
                        function: () async {
                          AudioFunctions.player.stop();
                          setState(() {
                            _isLoading = true;
                          });
                          await Provider.of<ProviderFunction>(context,
                                  listen: false)
                              .loadAllAudioPlaylist(context: context)
                              .whenComplete(() => setState(() {
                                    _isLoading = false;
                                  }));
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class MusicListWidget extends StatefulWidget {
  final int currentIndex;

  final int itemIndex;

  final IndexedAudioSource audioSource;

  const MusicListWidget(
      {super.key,
      required this.currentIndex,
      required this.itemIndex,
      required this.audioSource});

  @override
  State<MusicListWidget> createState() => _MusicListWidgetState();
}

class _MusicListWidgetState extends State<MusicListWidget> {
  bool _isEditingEnabled = false;
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () async {
        setState(() {
          _isEditingEnabled = true;
        });
      },
      child: ListTile(
        onTap: () async {
          await AudioFunctions.player
              .seek(Duration.zero, index: widget.itemIndex);
          await AudioFunctions.player.play();
        },
        leading: Text(
          '${widget.itemIndex + 1}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: widget.currentIndex == widget.itemIndex
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary),
        ),
        title: TextField(
          controller: _editingController,
          autofocus: false,
          enabled: _isEditingEnabled,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: widget.audioSource.tag.title,
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: widget.currentIndex == widget.itemIndex
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.primary),
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        trailing: _isEditingEnabled
            ? IconButton(
                onPressed: () async {
                  setState(() {
                    _isEditingEnabled = false;
                  });
                  _editingController.text.replaceAll(" ", "").isEmpty
                      ? null
                      : await HiveDB.changeASongModelName(
                          id: widget.audioSource.tag.id,
                          changedName: _editingController.text);
                },
                icon: Icon(
                  Icons.done_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            : PopupMenuButton<String>(
                iconColor: Theme.of(context).colorScheme.primary,
                color: Theme.of(context).colorScheme.onPrimary,
                onSelected: (String value) {
                  _handleClick(
                      value: value,
                      videoId: widget.audioSource.tag.id,
                      context: context,
                      currentPlaying: widget.currentIndex,
                      index: widget.itemIndex);
                },
                itemBuilder: (context) {
                  return {
                    'Play next',
                    'Download Video',
                    'Rename',
                    'Remove from playlist',
                    'Delete file from device',
                    'Share'
                  }.map(
                    (String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    },
                  ).toList();
                },
              ),
      ),
    );
  }

  void _handleClick({
    required String value,
    required String videoId,
    required BuildContext context,
    required int currentPlaying,
    required int index,
  }) async {
    switch (value) {
      case 'Play next':
        await Provider.of<ProviderFunction>(context, listen: false)
            .playNextFunction(
          currentPlayingIndex: currentPlaying,
          selectedIndex: index,
        );
        break;
      case 'Rename':
        setState(() {
          _isEditingEnabled = true;
        });
        break;
      case 'Remove from playlist':
        await Provider.of<ProviderFunction>(context, listen: false)
            .removeASong(id: videoId, index: index);
        break;
      case 'Delete file from device':
        break;
      case 'Download Video':
        break;
      case 'Share':
        break;
      default:
        break;
    }
  }
}

String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');

  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  if (hours > 0) {
    return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
  } else {
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }
}

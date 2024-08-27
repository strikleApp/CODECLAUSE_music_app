import 'package:flutter/material.dart';
import 'package:melody/db/hive.dart';
import 'package:melody/function/audio_functions.dart';
import 'package:melody/function/provider_function.dart';
import 'package:melody/modals/songs_modal.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class ListWidget extends StatelessWidget {
  final Video videoDetails;

  const ListWidget({super.key, required this.videoDetails});

  Future<void> _downloadAudio({required BuildContext context}) async {
    await Provider.of<ProviderFunction>(context, listen: false).downloadAudio(
        videoID: videoDetails.id.toString(),
        title: videoDetails.title,
        context: context);
  }

  Future<void> _downloadVideo({required BuildContext context}) async {
    await Provider.of<ProviderFunction>(context, listen: false).downloadVideo(
        videoID: videoDetails.id.toString(),
        title: videoDetails.title,
        context: context);
  }

  Future<void> _streamAudio({required BuildContext context}) async {
    bool isAdded = await HiveDB.saveAudioSongModel(
      songModal:
          SongsModal(id: videoDetails.id.toString(), name: videoDetails.title),
    );
    if (isAdded) {
      if (context.mounted) {
        await AudioFunctions().addAudio(
            name: videoDetails.title,
            id: videoDetails.id.toString(),
            context: context);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Added to playlist!"),
              action: SnackBarAction(
                textColor: Theme.of(context).primaryColor,
                label: "Play Now",
                onPressed: () {
                  AudioFunctions()
                      .jumpToVideoId(videoId: videoDetails.id.toString());
                },
              ),
            ),
          );
        }
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Already in playlist!"),
            action: SnackBarAction(
              textColor: Theme.of(context).primaryColor,
              label: "Play Now",
              onPressed: () {
                AudioFunctions()
                    .jumpToVideoId(videoId: videoDetails.id.toString());
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Duration duration = videoDetails.duration ?? Duration.zero;
    return InkWell(
      onTap: () => _streamAudio(context: context),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              videoDetails.thumbnails.highResUrl,
              fit: BoxFit.fill,
            ),
          ),
          ListTile(
            tileColor: Theme.of(context).cardColor,
            title: Text(videoDetails.title),
            subtitle: Text(
                '${videoDetails.author} ･ ${_formatDuration(duration)} ･ ${_formatViewCount(videoDetails.engagement.viewCount)}'),
            trailing: PopupMenuButton(
              onSelected: (String value) {
                handleClick(value: value, context: context);
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) {
                return {
                  'Download Audio',
                  'Download Video',
                  'Share',
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          )
        ],
      ),
    );
  }

  void handleClick(
      {required String value, required BuildContext context}) async {
    switch (value) {
      case 'Download Video':
        break;
      case 'Download Audio':
        break;
      case 'Share':
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

String _formatViewCount(int count) {
  if (count >= 1000000000) {
    return '${(count / 1000000000).toStringAsFixed(1)}B'; // Billions
  } else if (count >= 1000000) {
    return '${(count / 1000000).toStringAsFixed(1)}M'; // Millions
  } else if (count >= 1000) {
    return '${(count / 1000).toStringAsFixed(1)}K'; // Thousands
  } else {
    return count.toString(); // Less than 1,000
  }
}

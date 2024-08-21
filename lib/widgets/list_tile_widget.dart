import 'package:flutter/material.dart';
import 'package:melody/db/hive.dart';
import 'package:melody/modals/songs_modal.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class ListWidget extends StatelessWidget {
  final Video videoDetails;

  const ListWidget({super.key, required this.videoDetails});

  @override
  Widget build(BuildContext context) {
    Duration duration = videoDetails.duration ?? Duration.zero;
    return InkWell(
      onTap: () {
        HiveDB.saveSongModel(
            songModal: SongsModal(
                id: videoDetails.id.toString(), name: videoDetails.title));
      },
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

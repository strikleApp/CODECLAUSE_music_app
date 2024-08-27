import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:melody/constants/constants.dart';
import 'package:melody/db/hive.dart';
import 'package:melody/function/provider_function.dart';
import 'package:melody/modals/songs_modal.dart';
import 'package:melody/modals/video_modal.dart';
import 'package:provider/provider.dart';

class VideoFunction {
  static Future<List<VideoFile>> getDownloadedVideos() async {
    List<VideoFile> videos = [];
    Directory audioPath = Directory(kVideoDownloadPath);
    List<FileSystemEntity> savedVideos = audioPath.listSync();
    for (FileSystemEntity file in savedVideos) {
      String? title;
      final String id = file.path
          .replaceFirst(file.parent.path, "")
          .replaceAll("/", "")
          .replaceAll(".mp4", "");

      final songModal = HiveDB.videoBox.values.toList();
      for (SongsModal song in songModal) {
        if (song.id == id) {
          title = song.name;
          break;
        }
      }
      if (title != null) {
        videos.add(VideoFile(id: id, title: title, filePath: file.path));
      }
    }
    return videos;
  }

  static Future<void> deleteAVideo(
      {required VideoFile videoFile, required BuildContext context}) async {
    try {
      File file = File(videoFile.filePath);
      await file.delete();
      if (context.mounted) {
        Provider.of<ProviderFunction>(context, listen: false)
            .removeAVideo(file: videoFile);
      }
    } catch (_) {}
  }
}

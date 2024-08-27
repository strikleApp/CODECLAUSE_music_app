import 'dart:io';
import 'package:hive_flutter/adapters.dart';
import 'package:melody/modals/DownloadClass.dart';
import 'package:melody/modals/songs_modal.dart';
import 'package:path_provider/path_provider.dart';

class HiveDB {
  static late Box audioBox;
  static late Box videoBox;
  static late Box downloadBox;

  static Future<void> initHive() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path;
    await Hive.initFlutter("$path/db/");
    Hive.registerAdapter(SongsModalAdapter());
    Hive.registerAdapter(DownloadClassAdapter());
    audioBox = await Hive.openBox("audio");
    videoBox = await Hive.openBox("video");
    downloadBox = await Hive.openBox("download");
  }

  static List<SongsModal> getAudioSongModals() {
    List<SongsModal> songModals = [];
    for (var key in audioBox.keys) {
      songModals.add(audioBox.get(key));
    }
    return songModals;
  }

  static Future<bool> saveAudioSongModel(
      {required SongsModal songModal}) async {
    for (var key in audioBox.keys) {
      SongsModal songsModal = audioBox.get(key);
      if (songsModal.id == songModal.id) {
        /// return false means already present.
        return false;
      }
    }
    await audioBox.add(songModal);

    /// return true means not present.
    return true;
  }

  static Future<bool> saveVideoSongModel(
      {required SongsModal songModal}) async {
    for (var key in videoBox.keys) {
      SongsModal songsModal = videoBox.get(key);
      if (songsModal.id == songModal.id) {
        /// return false means already present.
        return false;
      }
    }
    await videoBox.add(songModal);

    /// return true means not present.
    return true;
  }

  static Future<void> changeASongModelName(
      {required String id, required String changedName}) async {
    for (var key in audioBox.keys) {
      SongsModal songsModal = audioBox.get(key);
      if (songsModal.id == id) {
        SongsModal changedModel =
            SongsModal(id: songsModal.id, name: changedName);
        audioBox.put(key, changedModel);
        return;
      }
    }
  }

  static Future<void> removeASongModel({required String id}) async {
    for (var key in audioBox.keys) {
      SongsModal songsModal = audioBox.get(key);
      if (songsModal.id == id) {
        audioBox.delete(key);
        return;
      }
    }
  }

  static Future<int> addDownload(DownloadClass download) async {
    return downloadBox.add(download);
  }

  static Future<void> updateDownload(int downloadId, int progress) async {
    try {
      final download = downloadBox.get(downloadId);
      if (download != null) {
        download.progress = progress;
        downloadBox.put(downloadId, download);
      }
    } catch (_) {}
  }

  static Future<void> completeDownload(int downloadId) async {
    final download = downloadBox.get(downloadId);
    if (download != null) {
      download.progress = 100;
      downloadBox.put(downloadId, download);
    }
  }

  static Future<void> errorDownload(int downloadId) async {
    final download = downloadBox.get(downloadId);
    if (download != null) {
      download.progress = -1;
      downloadBox.put(downloadId, download);
    }
  }
}

import 'dart:io';
import 'package:hive_flutter/adapters.dart';
import 'package:melody/modals/songs_modal.dart';
import 'package:path_provider/path_provider.dart';

class HiveDB {
  static late Box audioBox;
  static late Box videoBox;

  static Future<void> initHive() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path;
    await Hive.initFlutter("$path/db/");
    Hive.registerAdapter(SongsModalAdapter());
    audioBox = await Hive.openBox("audio");
    videoBox = await Hive.openBox("video");
  }

  static List<SongsModal> getSongModals() {
    List<SongsModal> songModals = [];
    for (var key in audioBox.keys) {
      songModals.add(audioBox.get(key));
    }
    return songModals;
  }

  static Future<void> saveSongModel({required SongsModal songModal}) async {
    await audioBox.add(songModal);
  }
}

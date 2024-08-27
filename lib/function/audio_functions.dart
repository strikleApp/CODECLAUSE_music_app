import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:melody/db/hive.dart';
import 'package:melody/function/provider_function.dart';
import 'package:melody/function/yt_functions.dart';
import 'package:melody/modals/songs_modal.dart';
import 'package:provider/provider.dart';

class AudioFunctions {
  static final player = AudioPlayer();

  Future<void> getDownloadedAudio({required BuildContext context}) async {
    try {
      Directory audioPath = Directory(
          "/storage/emulated/0/Android/data/com.strikle.melody.melody/files/data/user/0/com.strikle.melody.melody/files/audios/");
      List<FileSystemEntity> audios = audioPath.listSync();
      for (var audio in audios) {
        final String id =
            audio.path.replaceFirst(audio.parent.path, "").replaceAll("/", "");
        final songs = HiveDB.audioBox.values.toList();
        SongsModal? songsModal;
        for (SongsModal item in songs) {
          if (item.id == id) {
            songsModal = item;
            break;
          }
        }
        if (songsModal != null) {
          AudioSource audioSource = AudioSource.file(
            audio.path,
            tag: MediaItem(id: id, title: songsModal.name),
          );
          if (context.mounted) {
            await Provider.of<ProviderFunction>(context, listen: false)
                .addAudioToPlaylist(audioSource: audioSource);
          }
        }
      }
    } catch (_) {}
  }

  Future<void> addAudio(
      {required String id,
      required String name,
      required BuildContext context}) async {
    Uri uri = await YtFunctions().getAudioUrl(id: id);
    AudioSource audioSource =
        AudioSource.uri(uri, tag: MediaItem(id: id, title: name));
    if (context.mounted) {
      Provider.of<ProviderFunction>(context, listen: false)
          .addAudioToPlaylist(audioSource: audioSource);
    }
  }

  Future<void> jumpToVideoId({required String videoId}) async {
    try {
      for (int i = 0; i < player.sequence!.length; i++) {
        if (player.sequence![i].tag.id == videoId) {
          return player.seek(Duration.zero, index: i);
        }
      }
    } catch (_) {
      print(_);
    }
  }
}

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:melody/constants/constants.dart';
import 'package:melody/db/hive.dart';
import 'package:melody/function/provider_function.dart';
import 'package:melody/function/yt_functions.dart';
import 'package:melody/modals/songs_modal.dart';
import 'package:provider/provider.dart';

class AudioFunctions {
  static final player = AudioPlayer();

  Future<void> getDownloadedAudio({required BuildContext context}) async {
    try {
      Directory audioPath = Directory(kAudioDownloadPath);
      List<FileSystemEntity> audios = audioPath.listSync();
      for (var audio in audios) {
        final String id = audio.path
            .replaceFirst(audio.parent.path, "")
            .replaceAll("/", "")
            .replaceAll(".mp3", "");
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
          AudioFunctions.player.play();
          return player.seek(Duration.zero, index: i);
        }
      }
    } catch (_) {}
  }

  Future<void> removeASong({required String songID}) async {
    File file = File("$kAudioDownloadPath/$songID.mp3");
    if (await file.exists()) {
      await file.delete();
    }
  }
}

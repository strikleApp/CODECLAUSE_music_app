import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:melody/function/provider_function.dart';
import 'package:melody/function/yt_functions.dart';
import 'package:melody/screens/download_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class AudioFunctions {
  static final player = AudioPlayer();

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

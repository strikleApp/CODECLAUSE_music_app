import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:melody/constants/constants.dart';
import 'package:melody/db/hive.dart';
import 'package:melody/function/audio_functions.dart';
import 'package:melody/function/video_function.dart';
import 'package:melody/function/yt_functions.dart';
import 'package:melody/modals/DownloadClass.dart';
import 'package:melody/modals/songs_modal.dart';
import 'package:melody/modals/video_modal.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class ProviderFunction with ChangeNotifier {
  List<AudioSource> audioPlaylist = [];
  ConcatenatingAudioSource? playlist;
  List<Video>? video;
  List<DownloadClass> downloads = [];
  List<VideoFile> videos = [];

  Future<void> getVideosFromYoutube(String? keyword) async {
    video = await YtFunctions()
        .getVideosFromYoutube(keyword: keyword ?? kInitialSearchKeyword);
    notifyListeners();
  }

  Future<void> addAudioToPlaylist({required AudioSource audioSource}) async {
    await playlist!.add(audioSource);
    notifyListeners();
  }

  Future<void> loadAllAudioPlaylist({required BuildContext context}) async {
    try {
      List<SongsModal> songModals = HiveDB.getAudioSongModals();
      audioPlaylist.clear();
      for (var songModal in songModals) {
        Uri uri = await YtFunctions().getAudioUrl(id: songModal.id);
        audioPlaylist.add(
          AudioSource.uri(
            uri,
            tag: MediaItem(id: songModal.id, title: songModal.name),
          ),
        );
      }
      playlist = ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: audioPlaylist,
      );
      await AudioFunctions.player.setAudioSource(playlist!);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> removeASong({required String id, required int index}) async {
    playlist!.removeAt(index);
    await HiveDB.removeASongModel(id: id);
    await AudioFunctions().removeASong(songID: id);
    notifyListeners();
  }

  Future<void> playNextFunction(
      {required int selectedIndex, required int currentPlayingIndex}) async {
    try {
      if (playlist != null && playlist!.sequence.isNotEmpty) {
        if (selectedIndex < currentPlayingIndex) {
          await playlist!.move(selectedIndex, currentPlayingIndex);
        } else {
          await playlist!.move(selectedIndex, (currentPlayingIndex + 1));
        }
      }
    } catch (_) {}
    notifyListeners();
  }

  Future<void> getAllDownloads() async {
    Box downloadsBox = HiveDB.downloadBox;
    downloads.clear();
    for (DownloadClass item in downloadsBox.values) {
      downloads.add(item);
    }
    notifyListeners();
  }

  Future<void> downloadAudio(
      {required String videoID,
      required String title,
      required BuildContext context}) async {
    try {
      if (context.mounted) {
        await AudioFunctions()
            .addAudio(name: title, id: videoID, context: context);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Download started."),
              action: SnackBarAction(
                textColor: Theme.of(context).primaryColor,
                label: "Play Now",
                onPressed: () {
                  AudioFunctions().jumpToVideoId(videoId: videoID);
                },
              ),
            ),
          );
        }
      }
      Uri uri = await YtFunctions().getAudioUrl(id: videoID);
      int? downloadID;
      int? savedDownloadKey;
      await FileDownloader.downloadFile(
          downloadDestination: DownloadDestinations.appFiles,
          subPath: "/audios/",
          url: uri.toString(),
          name: "$videoID.mp3",
          onDownloadRequestIdReceived: (int id) async {
            downloadID = id;
            DownloadClass download = DownloadClass(
                videoID: videoID, title: title, progress: 0, id: id);
            downloads.add(download);
            savedDownloadKey = await HiveDB.addDownload(download);
            notifyListeners();
          },
          onProgress: (String? fileName, double progress) {
            int index = downloads.indexWhere((d) => d.id == downloadID!);
            downloads[index].progress = progress.toInt();
            HiveDB.updateDownload(savedDownloadKey!, progress.toInt());
            notifyListeners();
          },
          onDownloadCompleted: (String path) {
            int index = downloads.indexWhere((d) => d.id == downloadID!);
            downloads[index].progress = 100;
            HiveDB.completeDownload(savedDownloadKey!);
            notifyListeners();
            HiveDB.saveAudioSongModel(
                songModal: SongsModal(id: videoID, name: title));
            //   download.progress = 100;
          },
          onDownloadError: (String error) {
            int index = downloads.indexWhere((d) => d.id == downloadID!);
            downloads[index].progress = -1;
            HiveDB.errorDownload(savedDownloadKey!);
            notifyListeners();
            //  download.progress = -1;
          },
          notificationType: NotificationType.all);
    } catch (_) {
      // download.progress = -1;
    }
  }

  ///////////////////////DOWNLOAD VIDEO////////////////////////////
  Future<void> downloadVideo(
      {required String videoID,
      required String title,
      required BuildContext context}) async {
    try {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Downloading Video."),
          ),
        );
      }
      Uri uri = await YtFunctions().getVideoUrl(id: videoID);
      int? downloadID;
      int? savedDownloadKey;
      await FileDownloader.downloadFile(
          downloadDestination: DownloadDestinations.appFiles,
          subPath: "/videos/",
          url: uri.toString(),
          name: "$videoID.mp4",
          onDownloadRequestIdReceived: (int id) async {
            downloadID = id;
            DownloadClass download = DownloadClass(
                videoID: videoID, title: title, progress: 0, id: id);
            downloads.add(download);
            savedDownloadKey = await HiveDB.addDownload(download);
            notifyListeners();
          },
          onProgress: (String? fileName, double progress) {
            int index = downloads.indexWhere((d) => d.id == downloadID!);
            downloads[index].progress = progress.toInt();
            HiveDB.updateDownload(savedDownloadKey!, progress.toInt());
            notifyListeners();
          },
          onDownloadCompleted: (String path) {
            int index = downloads.indexWhere((d) => d.id == downloadID!);
            downloads[index].progress = 100;
            HiveDB.completeDownload(savedDownloadKey!);
            HiveDB.saveVideoSongModel(
                songModal: SongsModal(id: videoID, name: title));
            addAVideo(
                videoId: videoID,
                title: title,
                filePath: "$kVideoDownloadPath/$videoID.mp4");
            notifyListeners();
            //   download.progress = 100;
          },
          onDownloadError: (String error) {
            int index = downloads.indexWhere((d) => d.id == downloadID!);
            downloads[index].progress = -1;
            HiveDB.errorDownload(savedDownloadKey!);
            notifyListeners();
            //  download.progress = -1;
          },
          notificationType: NotificationType.all);
    } catch (_) {
      // download.progress = -1;
    }
  }

  Future<void> getAllVideos() async {
    videos.addAll(await VideoFunction.getDownloadedVideos());
    notifyListeners();
  }

  Future<void> addAVideo(
      {required String videoId,
      required String title,
      required String filePath}) async {
    videos.add(VideoFile(id: videoId, title: title, filePath: filePath));
    notifyListeners();
  }

  void removeAVideo({required VideoFile file}) {
    videos.remove(file);
    notifyListeners();
  }
}

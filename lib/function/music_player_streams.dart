import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:melody/function/audio_functions.dart';

class MusicPlayerStreams with ChangeNotifier {
  List<IndexedAudioSource>? audioSources;
  int currentIndex = 0;
  Duration totalDuration = Duration.zero;
  Duration currentDuration = Duration.zero;
  bool isPlaying = false;
  bool isShuffleOn = false;
  ProcessingState? processingState;

  void audioListStream() {
    try {
      AudioFunctions.player.sequenceStream
          .listen((List<IndexedAudioSource>? audioSource) {
        audioSources = audioSource;
        notifyListeners();
      });
      AudioFunctions.player.currentIndexStream.listen((int? index) {
        currentIndex = index ?? 0;
        notifyListeners();
      });
      AudioFunctions.player.playbackEventStream
          .listen((PlaybackEvent playbackEvent) {
        totalDuration = playbackEvent.duration ?? Duration.zero;
        notifyListeners();
      });
      AudioFunctions.player.playingStream.listen((bool event) {
        isPlaying = event;
        notifyListeners();
      });
      AudioFunctions.player.positionStream.listen((Duration event) {
        currentDuration = event;
        notifyListeners();
      });
      AudioFunctions.player.shuffleModeEnabledStream.listen((bool event) {
        isShuffleOn = event;
        notifyListeners();
      });
      AudioFunctions.player.processingStateStream
          .listen((ProcessingState event) {
        processingState = event;
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }
}

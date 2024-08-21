import 'package:flutter/cupertino.dart';
import 'package:melody/constants/constants.dart';
import 'package:melody/function/yt_functions.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class ProviderFunction with ChangeNotifier {
  VideoSearchList? video;

  // void addVideo({required VideoSearchList video}) {
  //   this.video = video;
  //   notifyListeners();
  // }

  Future<void> getVideosFromYoutube() async {
    video = await YtFunctions()
        .getVideosFromYoutube(keyword: kInitialSearchKeyword);
    notifyListeners();
  }
}

import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YtFunctions {
  static YoutubeExplode yt = YoutubeExplode();

  Future<VideoSearchList> getVideosFromYoutube(
      {required String keyword}) async {
    VideoSearchList videoSearchList = await yt.search.search(keyword);
    videoSearchList.removeWhere((v) => v.isLive);
    return videoSearchList;
  }
}

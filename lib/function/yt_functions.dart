import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YtFunctions {
  static YoutubeExplode yt = YoutubeExplode();

  Future<List<Video>> getVideosFromYoutube({required String keyword}) async {
    try {
      Video video = await yt.videos.get(keyword);
      RelatedVideosList? relatedContent =
          await yt.videos.getRelatedVideos(video);
      relatedContent!.insert(0, video);
      relatedContent.removeWhere((v) => v.isLive);
      List<Video> videoList = [];
      for (var v in relatedContent) {
        videoList.add(v);
      }
      return videoList;
    } catch (_) {
      VideoSearchList videoSearchList = await yt.search.search(keyword);
      videoSearchList.removeWhere((v) => v.isLive);
      List<Video> videoList = [];
      for (Video v in videoSearchList) {
        videoList.add(v);
      }
      return videoList;
    }
  }

  Future<Uri> getAudioUrl({required String id}) async {
    StreamManifest manifest = await yt.videos.streamsClient.getManifest(id);
    AudioOnlyStreamInfo audioOnlyStreamInfo =
        manifest.audioOnly.withHighestBitrate();
    return audioOnlyStreamInfo.url;
  }

  Future<Uri> getVideoUrl({required String id}) async {
    StreamManifest manifest = await yt.videos.streamsClient.getManifest(id);
    VideoStreamInfo videoOnlyStreamInfo = manifest.muxed.withHighestBitrate();
    return videoOnlyStreamInfo.url;
  }
}

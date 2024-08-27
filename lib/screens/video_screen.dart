import 'package:flutter/material.dart';
import 'package:melody/function/provider_function.dart';
import 'package:melody/function/video_function.dart';
import 'package:melody/modals/video_modal.dart';
import 'package:melody/screens/video_player_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<VideoFile> videoFiles = Provider.of<ProviderFunction>(context).videos;
    return Scaffold(
      body: SafeArea(
        child: videoFiles.isEmpty
            ? const Center(
                child: Text("Download any video."),
              )
            : ListView.builder(
                itemCount: videoFiles.length,
                itemBuilder: (context, index) {
                  return VideoFileItem(videoFiles[index]);
                },
              ),
      ),
    );
  }
}

class VideoFileItem extends StatelessWidget {
  final VideoFile _videoFile;

  const VideoFileItem(this._videoFile, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  VideoPlayerScreen(videoFilePath: _videoFile.filePath),
            ),
          );
        },
        leading: Icon(Icons.video_camera_back_rounded,
            color: Theme.of(context).colorScheme.primary, size: 26.sp),
        title: Text(_videoFile.title),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete_rounded,
            color: Colors.red,
          ),
          onPressed: () async {
            await VideoFunction.deleteAVideo(
                videoFile: _videoFile, context: context);
          },
        ),
      ),
    );
  }
}

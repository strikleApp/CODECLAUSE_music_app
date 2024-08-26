
import 'package:hive/hive.dart';
part 'DownloadClass.g.dart';

@HiveType(typeId: 1)
class DownloadClass {
  @HiveField(0)
  String videoID;

  @HiveField(1)
  String title;

  @HiveField(2)
  int progress;

  @HiveField(3)
  int id;

  DownloadClass({required this.videoID, required this.title, required this.progress, required this.id});
}
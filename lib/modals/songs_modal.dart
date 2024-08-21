import 'package:hive/hive.dart';
part 'songs_modal.g.dart';


@HiveType(typeId: 0)
class SongsModal extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;

  SongsModal({required this.id, required this.name});
}


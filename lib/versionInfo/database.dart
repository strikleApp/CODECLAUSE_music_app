import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<VersionInfo> streamVersionInfo() {
    return _firebaseFirestore
        .collection('Version')
        .doc('Version Number')
        .snapshots(includeMetadataChanges: true)
        .map((event) => VersionInfo.fromFirestore(event));
  }
}

class VersionInfo {
  final String versionNumber;

  VersionInfo({required this.versionNumber});

  factory VersionInfo.fromFirestore(DocumentSnapshot doc) {
    return VersionInfo(versionNumber: doc['Version']);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tracker_app/app/home/models/job.dart';
import 'package:tracker_app/services/api_path.dart';
import 'package:tracker_app/services/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);

  Future<void> deleteJob(Job job);

  Stream<List<Job>> jobsStream();
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  final _firestoreService = FirestoreService.instance;
  final String uid;

  @override
  Future<void> setJob(Job job) async => await _firestoreService.setData(
        path: APIPath.job(uid, job.id),
        data: job.toMap(),
      );

  @override
  Future<void> deleteJob(Job job) async {
    final path = APIPath.job(uid, job.id);
    await _firestoreService.deleteData(path);
  }

  @override
  Stream<List<Job>> jobsStream() => _firestoreService.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );
}

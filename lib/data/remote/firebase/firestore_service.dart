import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateStats({
    required String uid,
    required double distanceKm,
    required int durationSeconds,
  }) async {
    final ref = _firestore.collection('users').doc(uid);
    await ref.set({
      'stats': {
        'totalTrips': FieldValue.increment(1),
        'totalDistanceKm': FieldValue.increment(distanceKm),
        'totalDurationSeconds': FieldValue.increment(durationSeconds),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    }, SetOptions(merge: true));
  }
}

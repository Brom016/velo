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

  Future<Map<String, double>?> getStats(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      final stats = doc.data()?['stats'] as Map<String, dynamic>?;
      if (stats == null) return null;
      return {
        'count': (stats['totalTrips'] as num?)?.toDouble() ?? 0,
        'totalDistance': (stats['totalDistanceKm'] as num?)?.toDouble() ?? 0,
        'totalDuration': (stats['totalDurationSeconds'] as num?)?.toDouble() ?? 0,
      };
    } catch (_) {
      return null;
    }
  }
}

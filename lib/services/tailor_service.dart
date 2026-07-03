import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tailor_model.dart';
import 'mock_data_service.dart';

/// Talks to the `tailors` collection in Firestore.
///
/// This exists so HomeProvider doesn't need to know anything about
/// Firestore directly — it just asks this service for a list of
/// TailorModel and gets one back, same shape as the old mock data.
class TailorService {
  TailorService._();

  static final _tailorsRef = FirebaseFirestore.instance.collection('tailors');

  /// Fetches all tailors, ordered by rating (best first) since that's
  /// a reasonable default for "Recommended Tailors".
  static Future<List<TailorModel>> fetchTailors() async {
    final snapshot = await _tailorsRef
        .orderBy('rating', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => TailorModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  /// One-time setup: pushes the existing mock tailors into Firestore.
  /// Uses the same IDs (t1, t2...) as the mock data, so calling this
  /// more than once overwrites the same documents instead of creating
  /// duplicates — safe to re-run if needed.
  ///
  /// Call this once from a debug button or a kDebugMode check in
  /// main.dart, confirm the `tailors` collection appears in the Firebase
  /// console, then remove the call.
  static Future<void> seedTailors() async {
    final batch = FirebaseFirestore.instance.batch();
    for (final tailor in MockDataService.getTailors()) {
      batch.set(_tailorsRef.doc(tailor.id), tailor.toMap());
    }
    await batch.commit();
  }
}

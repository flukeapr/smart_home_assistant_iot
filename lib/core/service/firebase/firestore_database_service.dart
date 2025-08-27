import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDatabaseService {
  final db = FirebaseFirestore.instance;

  Future<void> addData(String collection, Map<String, dynamic> data) async {
    try {
      await db.collection(collection).add(data);
    } catch (e) {
      print("Error adding data: $e");
    }
  }

  Future<void> updateData(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    try {
      await db.collection(collection).doc(docId).update(data);
    } catch (e) {
      print("Error updating data: $e");
    }
  }

  Future<void> deleteData(String collection, String docId) async {
    try {
      await db.collection(collection).doc(docId).delete();
    } catch (e) {
      print("Error deleting data: $e");
    }
  }

  Future<DocumentSnapshot> getData(String collection, String docId) async {
    try {
      return await db.collection(collection).doc(docId).get();
    } catch (e) {
      print("Error getting data: $e");
      rethrow;
    }
  }

  Stream<QuerySnapshot> getCollection(String collection) {
    try {
      return db.collection(collection).snapshots();
    } catch (e) {
      print("Error getting collection: $e");
      rethrow;
    }
  }
}

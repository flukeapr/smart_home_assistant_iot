import 'package:firebase_database/firebase_database.dart';

class RealtimeDatabaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<bool> getDeviceStatus(String device) async {
    final snapshot = await _dbRef.child("/$device").get();
    if (snapshot.exists) {
      return snapshot.value == 1 || snapshot.value == true;
    }
    return false;
  }

  Future<void> setDeviceStatus(String device, bool value) async {
    await _dbRef.child("/$device").set(value ? 1 : 0);
  }

  Stream<bool> streamDeviceStatus(String device) {
    return _dbRef.child("/$device").onValue.map((event) {
      final val = event.snapshot.value;
      return val == 1 || val == true;
    });
  }
}

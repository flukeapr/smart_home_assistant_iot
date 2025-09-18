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
    await _dbRef.child("/Devices/$device").set(value ? 1 : 0);
  }

  Stream<bool> streamDeviceStatus(String device) {
    return _dbRef.child("/Devices/$device").onValue.map((event) {
      final val = event.snapshot.value;
      return val == 1 || val == true;
    });
  }

  Stream<int> streamDeviceLevels(String device) {
    return _dbRef.child("/Levels/$device").onValue.map((event) {
      final val = event.snapshot.value;
      return val is int ? val : 0;
    });
  }

  Future<void> setDeviceLeves(String device, int value) async {
    await _dbRef.child("/Levels/$device").set(value);
  }

  Future<void> setBulkDeviceStatus(Map<String, bool> devices) async {
    final updates = devices.map(
      (key, value) => MapEntry('/Devices/$key', value ? 1 : 0),
    );
    await _dbRef.update(updates);
  }

  Stream<double> streamTemperature() {
    return _dbRef.child("/temp").onValue.map((event) {
      final val = event.snapshot.value;
      if (val is int) return val.toDouble();
      return val as double;
    });
  }

  Stream<double> streamTemperatureDeviceAuto() {
    return _dbRef.child("/tempset").onValue.map((event) {
      final val = event.snapshot.value;
      if (val is int) return val.toDouble();
      return val as double;
    });
  }

  Future<void> setTempDeviceAuto(double value) async {
    await _dbRef.child("/tempset").set(value);
  }

  Stream<double> streamMaxEnergy() {
    return _dbRef.child("/maxKWH").onValue.map((event) {
      final val = event.snapshot.value;
      if (val is int) return val.toDouble();
      return val as double;
    });
  }

  Future<void> setMaxEnergy(double value) async {
    await _dbRef.child("/maxKWH").set(value);
  }

  Stream<double> streamUsageEnergy() {
    final ref = FirebaseDatabase.instance.ref('energy_usage');

    return ref.onValue.map((event) {
      final val = event.snapshot.value;
      if (val is int) return val.toDouble();
      return val as double;
    });
  }
}

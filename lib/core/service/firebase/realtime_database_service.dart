import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

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

  Stream<double> streamMonthlyEnergy() {
    final ref = FirebaseDatabase.instance.ref('energy_usage');

    return ref.onValue.map((event) {
      double sum = 0;
      final snapshot = event.snapshot;

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final now = DateTime.now();
        final currentMonth = DateFormat('yyyy-MM').format(now);

        data.forEach((key, value) {
          if (key.startsWith(currentMonth)) {
            sum += (value is int) ? value.toDouble() : value as double;
          }
        });
      }

      return sum;
    });
  }

  Future<List<Map<String, dynamic>>> getWeeklyEnergy() async {
    final ref = FirebaseDatabase.instance.ref('energy_usage');
    final snapshot = await ref.get();

    // สร้าง Map เก็บค่า energy ต่อวัน
    Map<String, double> dailyEnergy = {};

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;

      data.forEach((key, value) {
        // key = '2025-09-10', value = 0.0495
        final date = DateTime.tryParse(key);
        if (date != null) {
          String weekday = DateFormat('E').format(date); // Mon, Tue, ...
          double energy = (value is int) ? value.toDouble() : value as double;
          dailyEnergy[weekday] = (dailyEnergy[weekday] ?? 0) + energy;
        }
      });
    }

    // สร้าง list 7 วัน (Mon-Sun)
    final List<String> weekdays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    return weekdays.map((day) {
      return {"label": day, "value": dailyEnergy[day] ?? 0.0};
    }).toList();
  }
}

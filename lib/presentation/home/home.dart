import 'package:flutter/material.dart';
import 'package:smart_home_assistant_iot/core/service/thingspeak.dart';
import 'package:smart_home_assistant_iot/presentation/home/widget/kilowatt_hour.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool turnOn = false;
  final Thingspeak thingspeak = Thingspeak();

  @override
  void initState() {
    super.initState();
    _getLedStatus();
  }

  Future<void> _toggleLed(bool isOn) async {
    try {
      final status = await thingspeak.toggleLed(isOn);
      setState(() {
        turnOn = status;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error toggling LED: $e')));
    }
  }

  Future<void> _getLedStatus() async {
    try {
      final status = await thingspeak.getLedStatus();
      setState(() {
        turnOn = status;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching LED status: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              // SwitchListTile(
              //   title: Text('LED Status : ${turnOn ? 'ON' : 'OFF'}'),
              //   value: turnOn,
              //   onChanged: _toggleLed,
              // ),
              Text(
                "Welcome back to Home",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              KilowattHour(),
            ],
          ),
        ),
      ),
    );
  }
}

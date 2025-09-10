import 'package:flutter/material.dart';
import 'package:smart_home_assistant_iot/presentation/devices/widget/manage_devices.dart';
import 'package:smart_home_assistant_iot/presentation/devices/widget/kilowatt_hour.dart';
import 'package:smart_home_assistant_iot/presentation/devices/widget/temperature.dart';
import 'package:smart_home_assistant_iot/presentation/devices/widget/voice_command_button.dart';

class Devices extends StatefulWidget {
  final VoidCallback onGoToStatistic;
  const Devices({super.key, required this.onGoToStatistic});

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20,
              children: [
                Text(
                  "Welcome back to Home",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                KilowattHour(onTap: () => widget.onGoToStatistic()),
                Temperature(),
                ManageDevices(),
                VoiceCommandButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:smart_home_assistant_iot/core/config/theme/app_color.dart';
import 'package:smart_home_assistant_iot/core/service/firebase/realtime_database_service.dart';

class Temperature extends StatefulWidget {
  const Temperature({super.key});

  @override
  State<Temperature> createState() => _TemperatureState();
}

class _TemperatureState extends State<Temperature> {
  final double _containerHeight = 100;
  final double _borderRadius = 12.0;
  final double _padding = 14.0;
  final RealtimeDatabaseService realtimeDatabaseService =
      RealtimeDatabaseService();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10,
      children: [_buildRealtimeTemp(), _buildTempDeviceAuto()],
    );
  }

  Widget _buildRealtimeTemp() {
    return StreamBuilder(
      stream: realtimeDatabaseService.streamTemperature(),
      builder: (context, asyncSnapshot) {
        final temperature = asyncSnapshot.data ?? 0.0;
        return Container(
          width: 160,
          height: _containerHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_borderRadius),
            border: Border.all(color: AppColor.lightGrey, width: 0.5),
          ),
          padding: EdgeInsets.all(_padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildTempIcon(temperature: temperature),
                  _buildTempInfo(temperature: temperature),
                ],
              ),
              Text(
                "Living Room",
                style: TextStyle(fontSize: 12, color: AppColor.darkGrey),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTempIcon({required double temperature}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      padding: EdgeInsets.all(6),
      child: Iconify(
        Carbon.temperature_celsius,
        color: temperature > 30 ? Colors.red.shade300 : AppColor.primary,
      ),
    );
  }

  Widget _buildTempInfo({required double temperature}) {
    return Row(
      textBaseline: TextBaseline.alphabetic,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: [
        Text(
          temperature.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AppColor.primary,
          ),
        ),
        Iconify(Carbon.temperature_celsius_alt, color: AppColor.primary),
      ],
    );
  }

  Widget _buildTempDeviceAuto() {
    Future<void> dialogChangeTemperature(
      BuildContext context,
      Stream<double> tempStream,
    ) async {
      await showDialog<double>(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: 120,
              padding: const EdgeInsets.all(12.0),
              child: StreamBuilder<double>(
                stream: tempStream,
                initialData: 24.0, // ค่าเริ่มต้น
                builder: (context, snapshot) {
                  final temp = snapshot.data ?? 0.0;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 4,
                    children: [
                      GestureDetector(
                        onTap: () {
                          realtimeDatabaseService.setTempDeviceAuto(temp + 1);
                        },
                        child: Container(
                          width: 40,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.lightGrey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            size: 32,
                            color: AppColor.darkGrey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                          child: Text(
                            "${temp.toInt()}°C",
                            key: ValueKey(temp.toInt()),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primary,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          realtimeDatabaseService.setTempDeviceAuto(temp - 1);
                        },
                        child: Container(
                          width: 40,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.lightGrey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            size: 32,
                            color: AppColor.darkGrey,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      );
    }

    return StreamBuilder(
      stream: realtimeDatabaseService.streamTemperatureDeviceAuto(),
      builder: (context, asyncSnapshot) {
        final temperature = asyncSnapshot.data ?? 0.0;
        return GestureDetector(
          onTap: () => dialogChangeTemperature(
            context,
            realtimeDatabaseService.streamTemperatureDeviceAuto(),
          ),
          child: Container(
            width: 160,
            height: _containerHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_borderRadius),
              border: Border.all(color: AppColor.lightGrey, width: 0.5),
            ),
            padding: EdgeInsets.all(_padding),
            child: Column(
              spacing: 6,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTempInfo(temperature: temperature),
                Text(
                  "Auto Devices ON",
                  style: TextStyle(fontSize: 12, color: AppColor.darkGrey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

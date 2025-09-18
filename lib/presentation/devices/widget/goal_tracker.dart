import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bxs.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:smart_home_assistant_iot/core/config/theme/app_color.dart';
import 'package:smart_home_assistant_iot/core/service/firebase/realtime_database_service.dart';

class GoalTracker extends StatefulWidget {
  const GoalTracker({super.key});

  @override
  State<GoalTracker> createState() => _GoalTrackerState();
}

class _GoalTrackerState extends State<GoalTracker> {
  final double _containerHeight = 80;
  final double _borderRadius = 15;
  final double _padding = 15;
  final double _iconSize = 20;

  final RealtimeDatabaseService _realtimeDatabaseService =
      RealtimeDatabaseService();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [_buildProgressContainer()],
    );
  }

  Widget _buildProgressContainer() {
    return StreamBuilder<double>(
      stream: _realtimeDatabaseService.streamUsageEnergy(),
      builder: (context, usageSnapshot) {
        return StreamBuilder<double>(
          stream: _realtimeDatabaseService.streamMaxEnergy(),
          builder: (context, maxSnapshot) {
            final usage = usageSnapshot.data ?? 0.0;
            final maximum = maxSnapshot.data ?? 1.0;
            if (usage > maximum) {
              _realtimeDatabaseService.setDeviceStatus("SavingMode", true);
            }
            return Container(
              width: double.infinity,
              height: _containerHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(_borderRadius),
                border: Border.all(color: AppColor.lightGrey, width: 0.5),
              ),
              padding: EdgeInsets.all(_padding),
              child: Center(
                child: Column(
                  spacing: 10,
                  children: [
                    Row(
                      children: [
                        Row(
                          spacing: 5,
                          children: [
                            _buildIcon(),
                            Text(
                              'Goal Progress: ${usage.toStringAsFixed(2)} / ${maximum.toStringAsFixed(1)} kWh',
                            ),
                          ],
                        ),
                        const Spacer(),
                        _buildEditButton(),
                      ],
                    ),
                    LinearProgressIndicator(
                      value: usage / maximum,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        usage >= maximum ? AppColor.red : AppColor.secondary,
                      ),
                      minHeight: 8,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildIcon() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColor.primary, AppColor.secondary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      width: _iconSize,
      height: _iconSize,
      padding: EdgeInsets.all(4),
      child: Iconify(Bxs.zap, color: Colors.white, size: 18),
    );
  }

  Widget _buildEditButton() {
    return GestureDetector(
      onTap: () {
        dialogChangeTemperature();
      },
      child: Iconify(Mdi.dots_vertical, color: AppColor.darkGrey),
    );
  }

  Future<void> dialogChangeTemperature() async {
    await showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: 120,
            padding: const EdgeInsets.all(18.0),
            child: StreamBuilder<double>(
              stream: _realtimeDatabaseService.streamMaxEnergy(),
              initialData: 24.0, // ค่าเริ่มต้น
              builder: (context, snapshot) {
                final value = snapshot.data ?? 1.0;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [
                    Text(
                      'Set Goal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.darkGrey,
                      ),
                    ),
                    Text(
                      '${value.toStringAsFixed(1)} kWh / 100 kWh',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColor.darkGrey,
                      ),
                    ),

                    Slider(
                      value: value,
                      min: 1,
                      max: 100,
                      thumbColor: AppColor.primary,
                      activeColor: AppColor.secondary,
                      onChanged: (newValue) {
                        _realtimeDatabaseService.setMaxEnergy(newValue);
                      },
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
}

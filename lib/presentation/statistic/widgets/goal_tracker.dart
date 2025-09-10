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
      children: [_buildTitle(), _buildProgressContainer()],
    );
  }

  Widget _buildTitle() {
    return Text("Goal Tracker", style: TextStyle(fontSize: 16));
  }

  Widget _buildProgressContainer() {
    return StreamBuilder<double>(
      stream: _realtimeDatabaseService.streamKilowattHour(),
      builder: (context, usageSnapshot) {
        return StreamBuilder<double>(
          stream: _realtimeDatabaseService.streamMaxKilowattHour(),
          builder: (context, maxSnapshot) {
            final usage = usageSnapshot.data ?? 0.0;
            final maximum = maxSnapshot.data ?? 1.0; // กันหาร 0

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
                              'Goal Progress: ${usage.toStringAsFixed(1)} / ${maximum.toStringAsFixed(1)} kWh',
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
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColor.secondary,
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
      onTap: () {},
      child: Iconify(Mdi.dots_vertical, color: AppColor.darkGrey),
    );
  }
}

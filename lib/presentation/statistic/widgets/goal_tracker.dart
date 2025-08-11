import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bxs.dart';
import 'package:smart_home_assistant_iot/core/config/theme/app_color.dart';

class GoalTracker extends StatefulWidget {
  const GoalTracker({super.key});

  @override
  State<GoalTracker> createState() => _GoalTrackerState();
}

class _GoalTrackerState extends State<GoalTracker> {
  final double _containerHeight = 70;
  final double _borderRadius = 15;
  final double _padding = 15;
  final double _iconSize = 20;

  final double _usageValue = 50.2;
  final double _maximumValue = 80;

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
    return Container(
      width: double.infinity,
      height: _containerHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(color: AppColor.lightGrey, width: 0.5),
      ),
      padding: EdgeInsets.all(_padding),
      child: Column(
        spacing: 10,
        children: [_buildProgressInfo(), _buildProgressBar()],
      ),
    );
  }

  Widget _buildProgressInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 5,
      children: [_buildIcon(), __buildProgressText()],
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

  Widget __buildProgressText() {
    return Text(
      'Goal Progress: ${_usageValue.toStringAsFixed(1)} / ${_maximumValue.toStringAsFixed(1)} kWh',
    );
  }

  Widget _buildProgressBar() {
    return LinearProgressIndicator(
      value: _usageValue / _maximumValue,
      backgroundColor: Colors.grey[300],
      valueColor: AlwaysStoppedAnimation<Color>(AppColor.secondary),
      minHeight: 8,
      borderRadius: BorderRadius.all(Radius.circular(10)),
    );
  }
}

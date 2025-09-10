import 'package:flutter/material.dart';
import 'package:smart_home_assistant_iot/presentation/statistic/widgets/chart_widget.dart';
import 'package:smart_home_assistant_iot/presentation/statistic/widgets/goal_tracker.dart';
import 'package:smart_home_assistant_iot/presentation/statistic/widgets/saving_mode.dart';
import 'package:smart_home_assistant_iot/presentation/statistic/widgets/security_mode.dart';

class Statistic extends StatefulWidget {
  const Statistic({super.key});

  @override
  State<Statistic> createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20,
              children: [
                GoalTracker(),
                SavingMode(),
                SecurityMode(),
                ChartWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

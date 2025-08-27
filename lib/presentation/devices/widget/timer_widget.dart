import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_home_assistant_iot/core/config/theme/app_color.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  static const Duration countdownDuration = Duration(minutes: 10, seconds: 10);
  final ValueNotifier<Duration> durationNotifier = ValueNotifier<Duration>(
    countdownDuration,
  );
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    final seconds = durationNotifier.value.inSeconds - 1;
    if (seconds < 0) {
      timer?.cancel();
    } else {
      durationNotifier.value = Duration(seconds: seconds);
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    durationNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Duration>(
      valueListenable: durationNotifier,
      builder: (context, duration, child) {
        return buildTime(duration);
      },
    );
  }

  Widget buildTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        buildTimeColumn(hours, "Hrs"),
        buildTimeColumn(minutes, "Mins"),
        buildTimeColumn(seconds, "Secs", isLast: true),
      ],
    );
  }

  Widget buildTimeColumn(String time, String label, {bool isLast = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            buildDigit(time[0]),
            buildDigit(time[1]),
            if (!isLast) buildTimeSeparator(),
          ],
        ),
        buildLabel(label),
      ],
    );
  }

  Widget buildDigit(String digit) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      child: Text(
        digit,
        key: ValueKey<String>(digit),
        style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColor.secondary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildTimeSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      child: Text(":", style: TextStyle(color: AppColor.primary, fontSize: 50)),
    );
  }
}

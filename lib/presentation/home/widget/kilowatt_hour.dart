import 'package:flutter/material.dart';
import 'package:smart_home_assistant_iot/core/config/theme/app_color.dart';

class KilowattHour extends StatefulWidget {
  const KilowattHour({super.key});

  @override
  State<KilowattHour> createState() => _KilowattHourState();
}

class _KilowattHourState extends State<KilowattHour> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColor.primary, AppColor.secondary],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            width: 40,
            height: 40,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smart_home_assistant_iot/core/config/theme/app_color.dart';

class Devices extends StatefulWidget {
  const Devices({super.key});

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          _buildTitle(),
          _buildDeviceCard("Light", "Living Room", Icons.lightbulb, true),
          _buildDeviceCard("Fan", "Living Room", Icons.lightbulb, true),
          _buildDeviceCard("Door", "Living Room", Icons.lightbulb, true),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Manage your devices",
      style: TextStyle(fontSize: 16, color: AppColor.darkGrey),
    );
  }

  Widget _buildDeviceCard(
    String name,
    String location,
    IconData icon,
    bool isOn,
  ) {
    return Container(
      width: 155,
      height: 155,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        border: isOn ? null : Border.all(color: AppColor.lightGrey, width: 1),
        gradient: isOn
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColor.primary, AppColor.secondary],
              )
            : null,
      ),
      child: Container(
        // inner container สำหรับ content
        margin: EdgeInsets.all(1), // ระยะห่างจาก border
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildDeviceIcon(icon, isOn)],
        ),
      ),
    );
  }

  Widget _buildDeviceIcon(IconData icon, bool isOn) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOn ? Colors.white : AppColor.primary,
        boxShadow: isOn
            ? [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ]
            : [],
      ),
      child: Icon(
        icon,
        size: 28,
        color: isOn ? AppColor.primary : Colors.white,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter/icons/wpf.dart';
import 'package:smart_home_assistant_iot/core/config/theme/app_color.dart';
import 'package:smart_home_assistant_iot/core/service/thingspeak.dart';

class Devices extends StatefulWidget {
  const Devices({super.key});

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  Thingspeak thingspeak = Thingspeak();
  bool lightStatus = false;
  bool fanStatus = false;
  bool doorStatus = false;

  Future<void> _toggleDeviceStatus(String device) async {
    bool currentStatus;
    int field;

    switch (device) {
      case "Light":
        field = Thingspeak.ledField;
        currentStatus = lightStatus;
        break;
      case "Fan":
        field = Thingspeak.fanField;
        currentStatus = fanStatus;
        break;
      case "Door":
        field = Thingspeak.doorField;
        currentStatus = doorStatus;
        break;
      default:
        return; // Invalid device
    }

    try {
      bool newStatus = await thingspeak.toggleField(field, !currentStatus);
      setState(() {
        switch (device) {
          case "Light":
            lightStatus = newStatus;
            break;
          case "Fan":
            fanStatus = newStatus;
            break;
          case "Door":
            doorStatus = newStatus;
            break;
        }
      });
    } catch (e) {
      // Handle error
      print("Error toggling $device: $e");
    }
  }

  Future<void> _getStatus() async {
    lightStatus = await thingspeak.getFieldStatus(Thingspeak.ledField);
    fanStatus = await thingspeak.getFieldStatus(Thingspeak.fanField);
    doorStatus = await thingspeak.getFieldStatus(Thingspeak.doorField);
    setState(() {
      lightStatus = lightStatus;
      fanStatus = fanStatus;
      doorStatus = doorStatus;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          _buildTitle(),
          GridView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 1.0,
            ),
            children: [
              _buildDeviceCard(
                name: "Light",
                location: "Living Room",
                icon: Ph.lightbulb,
                isOn: lightStatus,
              ),
              _buildDeviceCard(
                name: "Fan",
                location: "Living Room",
                icon: Wpf.fan,
                isOn: fanStatus,
              ),
              _buildDeviceCard(
                name: "Door",
                location: "Living Room",
                icon: MaterialSymbols.door_open_rounded,
                isOn: doorStatus,
              ),
              _buildDeviceCard(
                name: "Air Conditioner",
                location: "Living Room",
                icon: Ph.wind_bold,
                isOn: false,
              ),
            ],
          ),
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

  Widget _buildDeviceCard({
    required String name,
    required String location,
    required String icon,
    required bool isOn,
  }) {
    return Container(
      width: 155,
      height: 155,
      decoration: BoxDecoration(
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
        width: double.infinity,
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            _buildDeviceIcon(icon: icon, isOn: isOn),
            _buildDeviceInfo(name: name, location: location, isOn: isOn),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceIcon({required String icon, required bool isOn}) {
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
      padding: EdgeInsets.all(6),
      child: Iconify(icon, color: isOn ? AppColor.primary : Colors.white),
    );
  }

  Widget _buildDeviceInfo({
    required String name,
    required String location,
    required bool isOn,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          location,
          style: TextStyle(fontSize: 12, color: AppColor.darkGrey),
        ),
        Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _buildDeviceStatus(isOn: isOn, device: name),
        ),
      ],
    );
  }

  Widget _buildDeviceStatus({required bool isOn, required String device}) {
    return Row(
      children: [
        FlutterSwitch(
          width: 47.0,
          height: 23.0,
          toggleSize: 18.0,
          value: isOn,
          activeColor: AppColor.primary,
          inactiveColor: AppColor.lightGrey,
          borderRadius: 20.0,
          padding: 2.0,
          onToggle: (val) {
            _toggleDeviceStatus(device);
          },
        ),
        Spacer(),
      ],
    );
  }
}

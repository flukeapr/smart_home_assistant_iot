import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter/icons/wpf.dart';
import 'package:smart_home_assistant_iot/core/config/theme/app_color.dart';
import 'package:smart_home_assistant_iot/core/service/firebase/realtime_database_service.dart';

class ManageDevices extends StatefulWidget {
  const ManageDevices({super.key});

  @override
  State<ManageDevices> createState() => _ManageDevicesState();
}

class _ManageDevicesState extends State<ManageDevices> {
  final RealtimeDatabaseService realtimeService = RealtimeDatabaseService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            _buildDeviceCardRealtime(device: "Light", icon: Ph.lightbulb),
            _buildDeviceCardRealtime(device: "Fan", icon: Wpf.fan),
            _buildDeviceCardRealtime(
              device: "Door",
              icon: MaterialSymbols.door_open_rounded,
            ),
            _buildDeviceCardRealtime(
              device: "Air Conditioner",
              icon: Ph.wind_bold,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDeviceCardRealtime({
    required String device,
    required String icon,
  }) {
    return StreamBuilder<bool>(
      stream: realtimeService.streamDeviceStatus(device),
      initialData: false,
      builder: (context, snapshot) {
        final isOn = snapshot.data ?? false;

        return _buildDeviceCard(
          name: device,
          location: "Living Room",
          icon: icon,
          isOn: isOn,
          onToggle: () {
            realtimeService.setDeviceStatus(device, !isOn);
          },
        );
      },
    );
  }

  Widget _buildTitle() {
    return Text(
      "Manage your ManageDevices",
      style: TextStyle(fontSize: 16, color: AppColor.darkGrey),
    );
  }

  Widget _buildDeviceCard({
    required String name,
    required String location,
    required String icon,
    required bool isOn,
    VoidCallback? onToggle,
  }) {
    return Container(
      width: 155,
      height: 155,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: isOn ? null : Border.all(color: AppColor.lightGrey, width: 0.5),
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
            _buildDeviceInfo(
              name: name,
              location: location,
              isOn: isOn,
              onToggle: onToggle,
            ),
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
    VoidCallback? onToggle,
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
          child: _buildManageDevicestatus(
            isOn: isOn,
            device: name,
            onToggle: onToggle,
          ),
        ),
      ],
    );
  }

  Widget _buildManageDevicestatus({
    required bool isOn,
    required String device,
    VoidCallback? onToggle,
  }) {
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
            onToggle?.call();
          },
        ),
        Spacer(),
      ],
    );
  }
}

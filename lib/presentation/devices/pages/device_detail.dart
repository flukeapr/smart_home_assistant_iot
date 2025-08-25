import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter/icons/wpf.dart';
import 'package:smart_home_assistant_iot/core/config/theme/app_color.dart';
import 'package:smart_home_assistant_iot/core/service/firebase/realtime_database_service.dart';

class DeviceDetail extends StatefulWidget {
  final String deviceName;
  const DeviceDetail({super.key, required this.deviceName});

  @override
  State<DeviceDetail> createState() => _DeviceDetailState();
}

class _DeviceDetailState extends State<DeviceDetail> {
  final RealtimeDatabaseService realtimeService = RealtimeDatabaseService();
  late Future<bool> statusDevice;

  @override
  void initState() {
    super.initState();
    statusDevice = realtimeService.getDeviceStatus(widget.deviceName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.deviceName), centerTitle: true),
      body: SafeArea(
        child: StreamBuilder(
          stream: realtimeService.streamDeviceStatus(widget.deviceName),
          builder: (context, asyncSnapshot) {
            final isOn = asyncSnapshot.data ?? false;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: Column(
                  children: [
                    Text('Device Name: ${widget.deviceName}'),
                    // Add more device details here
                    _buildDeviceIcon(),
                    _buildLevelsDevice(isOn: isOn),
                    Spacer(),
                    _buildStateDevice(isOn: isOn),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDeviceIcon() {
    String getIconByName() {
      switch (widget.deviceName) {
        case 'Light':
          return Ph.lightbulb;
        case 'Fan':
          return Wpf.fan;
        case 'Door':
          return MaterialSymbols.door_open_rounded;
        default:
          return Ph.lightbulb;
      }
    }

    return Iconify(getIconByName(), size: 100, color: AppColor.primary);
  }

  Widget _buildLevelsDevice({required bool isOn}) {
    return StreamBuilder(
      stream: realtimeService.streamDeviceLevels(widget.deviceName),
      builder: (context, asyncSnapshot) {
        final int level = asyncSnapshot.data ?? 1;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            ...List.generate(3, (index) {
              final bool selectLevel = level == index + 1;
              return AbsorbPointer(
                absorbing: !isOn,
                child: GestureDetector(
                  onTap: () {
                    realtimeService.setDeviceLeves(
                      widget.deviceName,
                      index + 1,
                    );
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: !selectLevel
                            ? AppColor.primary
                            : Colors.transparent,
                      ),
                      shape: BoxShape.circle,
                      color: selectLevel ? AppColor.primary : null,
                    ),
                    child: Center(
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          color: selectLevel ? Colors.white : AppColor.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildStateDevice({required bool isOn}) {
    return GestureDetector(
      onTap: () {
        realtimeService.setDeviceStatus(widget.deviceName, !isOn);
      },
      child: Container(
        width: 80,
        height: 80,
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isOn
              ? LinearGradient(
                  colors: [AppColor.primary, AppColor.secondary],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
          color: isOn ? null : Colors.white,
          shape: BoxShape.circle,
          boxShadow: !isOn
              ? [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Iconify(
            MaterialSymbols.power_rounded,
            size: 48,
            color: isOn ? Colors.white : AppColor.primary,
          ),
        ),
      ),
    );
  }
}

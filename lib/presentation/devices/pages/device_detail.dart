import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter/icons/wpf.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Living Room'),
                        Iconify(
                          MaterialSymbols.keyboard_arrow_down,
                          size: 20,
                          color: AppColor.darkGrey,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildBody(isOn: isOn),
                          if (widget.deviceName != "Door")
                            _buildLevelsDevice(isOn: isOn),
                          _buildStateDevice(isOn: isOn),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody({required bool isOn}) {
    return StreamBuilder(
      stream: realtimeService.streamDeviceLevels(widget.deviceName),
      builder: (context, asyncSnapshot) {
        final int level = asyncSnapshot.data ?? 1;
        return Column(
          children: [_buildDeviceIcon(level: level, isOn: isOn)],
        );
      },
    );
  }

  Widget _buildDeviceIcon({required int level, required bool isOn}) {
    String getIconByName() {
      switch (widget.deviceName) {
        case 'Light':
          if (level == 1) {
            return Ph.lightbulb_filament;
          } else if (level == 2) {
            return Ph.lightbulb_filament_duotone;
          } else if (level == 3) {
            return Ph.lightbulb_filament_fill;
          }
          return Ph.lightbulb;
        case 'Fan':
          return Wpf.fan;
        case 'Door':
          return MaterialSymbols.door_open_rounded;
        default:
          return Ph.lightbulb;
      }
    }

    return AbsorbPointer(
      absorbing: !isOn,
      child: SleekCircularSlider(
        min: 1,
        max: 3,
        initialValue: level.toDouble(),
        appearance: CircularSliderAppearance(
          size: 250, // ขนาดวงกลม
          startAngle: 180, // เริ่มครึ่งวงกลมด้านบน
          angleRange: 180, // โชว์แค่ครึ่งวงกลม
          customWidths: CustomSliderWidths(
            trackWidth: 8,
            progressBarWidth: 8,
            handlerSize: 12,
          ),
          customColors: CustomSliderColors(
            trackColor: AppColor.lightGrey,
            progressBarColor: AppColor.primary,
            dotColor: AppColor.secondary,
          ),
        ),
        onChangeEnd: (double value) {
          int newLevel = value.round();
          if (isOn) {
            realtimeService.setDeviceLeves(widget.deviceName, newLevel);
          }
        },
        innerWidget: (_) => Padding(
          padding: const EdgeInsets.all(50),
          child: Iconify(getIconByName(), size: 10, color: AppColor.primary),
        ),
      ),
    );
  }

  Widget _buildLevelsDevice({required bool isOn}) {
    return StreamBuilder(
      stream: realtimeService.streamDeviceLevels(widget.deviceName),
      builder: (context, asyncSnapshot) {
        final int level = asyncSnapshot.data ?? 1;
        return Column(
          spacing: 10,
          children: [
            if (widget.deviceName != "Door")
              Text(
                (widget.deviceName == "Fan"
                        ? "Speed Level"
                        : "Brightness Level")
                    .toUpperCase(),
                style: TextStyle(fontSize: 16, color: AppColor.darkGrey),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
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
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: selectLevel
                              ? LinearGradient(
                                  colors: [
                                    AppColor.primary,
                                    AppColor.secondary,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                )
                              : null,
                          color: selectLevel ? null : Colors.white,
                          boxShadow: !selectLevel
                              ? [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ]
                              : [],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(index + 1, (barIndex) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                width: 10,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: selectLevel
                                      ? Colors.white
                                      : AppColor.lightGrey,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
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
        margin: EdgeInsets.symmetric(vertical: 24),
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

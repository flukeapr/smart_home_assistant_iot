import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:smart_home_assistant_iot/core/config/theme/app_color.dart';
import 'package:smart_home_assistant_iot/core/service/firebase/realtime_database_service.dart';

class SecurityMode extends StatefulWidget {
  const SecurityMode({super.key});

  @override
  State<SecurityMode> createState() => _SecurityModeState();
}

class _SecurityModeState extends State<SecurityMode> {
  static const double _containerHeight = 82;
  static const double _borderRadius = 15;
  static const double _padding = 16;

  final RealtimeDatabaseService realtimeService = RealtimeDatabaseService();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _containerHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(color: AppColor.lightGrey, width: 0.5),
      ),
      padding: EdgeInsets.all(_padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_buildSecurityInfo(), _buildToggleSwitch()],
      ),
    );
  }

  Widget _buildSecurityInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10,
      children: [_buildIconShield(), _buildSecurityText()],
    );
  }

  Widget _buildIconShield() {
    return const Iconify(
      MaterialSymbols.security_rounded,
      size: 32,
      color: AppColor.primary,
    );
  }

  Widget _buildSecurityText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Security Mode',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColor.darkGrey,
          ),
        ),
        const Text(
          'Turn off all devices for safety',
          style: TextStyle(fontSize: 12, color: AppColor.darkGrey),
        ),
      ],
    );
  }

  Future<void> _toggleSecurityMode(bool value) async {
    try {
      await realtimeService.setDeviceStatus('securityMode', value);

      if (value) {
        final devices = ['Light', 'Fan', 'Door', 'Air Conditioner'];
        for (var device in devices) {
          await realtimeService.setDeviceStatus(device, false);
        }
      }

      setState(() {});
    } catch (e) {
      print("Error toggling Security Mode: $e");
    }
  }

  Widget _buildToggleSwitch() {
    return StreamBuilder<bool>(
      stream: realtimeService.streamDeviceStatus('securityMode'),
      builder: (context, snapshot) {
        final securityOn = snapshot.data ?? false;
        return FlutterSwitch(
          width: 47.0,
          height: 23.0,
          toggleSize: 18.0,
          value: securityOn,
          activeColor: AppColor.primary,
          inactiveColor: AppColor.lightGrey,
          borderRadius: 20.0,
          padding: 2.0,
          onToggle: _toggleSecurityMode,
        );
      },
    );
  }
}

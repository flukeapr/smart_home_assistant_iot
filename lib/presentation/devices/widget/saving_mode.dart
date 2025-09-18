import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:smart_home_assistant_iot/core/config/theme/app_color.dart';
import 'package:smart_home_assistant_iot/core/service/firebase/realtime_database_service.dart';

class SavingMode extends StatefulWidget {
  const SavingMode({super.key});

  @override
  State<SavingMode> createState() => _SavingModeState();
}

class _SavingModeState extends State<SavingMode> {
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
      children: [_buildIconSaving(), _buildSavingText()],
    );
  }

  Widget _buildIconSaving() {
    return const Iconify(
      MaterialSymbols.energy_savings_leaf_outline,
      size: 32,
      color: AppColor.green,
    );
  }

  Widget _buildSavingText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saving Mode',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColor.darkGrey,
          ),
        ),
        const Text(
          'Turn off all devices Automatically',
          style: TextStyle(fontSize: 12, color: AppColor.darkGrey),
        ),
      ],
    );
  }

  Future<void> _toggleSavingMode(bool value) async {
    try {
      await realtimeService.setDeviceStatus('SavingMode', value);
      setState(() {});
    } catch (e) {
      print("Error toggling Security Mode: $e");
    }
  }

  Widget _buildToggleSwitch() {
    return StreamBuilder<bool>(
      stream: realtimeService.streamDeviceStatus('SavingMode'),
      builder: (context, savingSnapshot) {
        final savingOn = savingSnapshot.data ?? false;
        return StreamBuilder(
          stream: realtimeService.streamMaxEnergy(),
          builder: (context, maxSnapshot) {
            final maximum = maxSnapshot.data ?? 1.0;
            return StreamBuilder(
              stream: realtimeService.streamUsageEnergy(),
              builder: (context, usageSnapshot) {
                final usage = usageSnapshot.data ?? 0.0;
                return FlutterSwitch(
                  disabled: usage >= maximum,
                  width: 47.0,
                  height: 23.0,
                  toggleSize: 18.0,
                  value: savingOn,
                  activeColor: AppColor.primary,
                  inactiveColor: AppColor.lightGrey,
                  borderRadius: 20.0,
                  padding: 2.0,
                  onToggle: _toggleSavingMode,
                );
              },
            );
          },
        );
      },
    );
  }
}

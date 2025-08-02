import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smart_home_assistant_iot/core/config/theme/app_color.dart';

class SecurityMode extends StatefulWidget {
  const SecurityMode({super.key});

  @override
  State<SecurityMode> createState() => _SecurityModeState();
}

class _SecurityModeState extends State<SecurityMode> {
  static const double _containerHeight = 82;
  static const double _borderRadius = 15;
  static const double _padding = 16;
  bool isOn = false;
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
    return const Icon(Iconsax.shield_tick5, size: 32, color: AppColor.primary);
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
    setState(() {
      isOn = value;
    });
  }

  Widget _buildToggleSwitch() {
    return Switch(value: isOn, onChanged: _toggleSecurityMode);
  }
}

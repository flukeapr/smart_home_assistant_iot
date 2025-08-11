import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bxs.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smart_home_assistant_iot/core/config/theme/app_color.dart';

class KilowattHour extends StatefulWidget {
  const KilowattHour({super.key});

  @override
  State<KilowattHour> createState() => _KilowattHourState();
}

class _KilowattHourState extends State<KilowattHour> {
  static const double _iconSize = 40;
  static const double _borderRadius = 15;
  static const double _padding = 16;
  static const double _containerHeight = 82;
  double kWh = 0.0;
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
        children: [_buildUsageInfo(), _buildNavigationButton()],
      ),
    );
  }

  Widget _buildUsageInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10,
      children: [_buildGradientIcon(), _buildUsageText()],
    );
  }

  Widget _buildGradientIcon() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColor.primary, AppColor.secondary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      width: _iconSize,
      height: _iconSize,
      padding: EdgeInsets.all(8),
      child: Iconify(Bxs.zap, color: Colors.white, size: 18),
    );
  }

  Widget _buildUsageText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$kWh kWh',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColor.darkGrey,
          ),
        ),
        const Text(
          'Electricity usage this month',
          style: TextStyle(fontSize: 12, color: AppColor.darkGrey),
        ),
      ],
    );
  }

  Widget _buildNavigationButton() {
    return SizedBox(
      width: _iconSize,
      height: _iconSize,
      child: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: AppColor.grey.withAlpha((0.25 * 255).round()),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {},
        icon: const Icon(Iconsax.arrow_right_1, color: Colors.white, size: 20),
      ),
    );
  }
}

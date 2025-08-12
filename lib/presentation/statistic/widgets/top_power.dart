import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter/icons/wpf.dart';
import 'package:smart_home_assistant_iot/core/config/theme/app_color.dart';

class TopPower extends StatefulWidget {
  const TopPower({super.key});

  @override
  State<TopPower> createState() => _TopPowerState();
}

class _TopPowerState extends State<TopPower> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        _buildTitle(),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 10,
            children: [
              _buildDeviceCard(
                icon: Ph.wind_bold,
                name: "Air Conditioner",
                location: "Living Room",
                percentage: 70,
              ),
              _buildDeviceCard(
                icon: Wpf.fan,
                name: "Fan",
                location: "Living Room",
                percentage: 20,
              ),
              _buildDeviceCard(
                icon: Ph.lightbulb_fill,
                name: "Light",
                location: "Living Room",
                percentage: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text("Top Power-Consuming Devices", style: TextStyle(fontSize: 16));
  }

  Widget _buildDeviceCard({
    required String name,
    required String location,
    required String icon,
    required int percentage,
  }) {
    return Container(
      width: 155,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColor.lightGrey, width: 0.5),
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
            _buildDeviceHeader(icon: icon, percentage: percentage),
            _buildDeviceInfo(name: name, location: location),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceHeader({required String icon, required int percentage}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDeviceIcon(icon: icon),
        Text(
          "$percentage%",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildDeviceIcon({required String icon}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColor.primary,
      ),
      padding: EdgeInsets.all(6),
      child: Iconify(icon, color: Colors.white),
    );
  }

  Widget _buildDeviceInfo({required String name, required String location}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          location,
          style: TextStyle(fontSize: 10, color: AppColor.darkGrey),
        ),
        Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

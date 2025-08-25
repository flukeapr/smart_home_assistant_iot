import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:smart_home_assistant_iot/core/config/theme/app_color.dart';
import 'package:smart_home_assistant_iot/presentation/devices/devices.dart';
import 'package:smart_home_assistant_iot/presentation/statistic/statistic.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [Devices(), Statistic()];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Container(
          height: 70,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: AppColor.lightGrey, width: 0.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                label: "Devices",
                icon: Ph.lightbulb,
                isSelected: _currentIndex == 0,
                onTap: () => _onTabTapped(0),
              ),
              _buildNavItem(
                label: "Statistics",
                icon: Ph.activity,
                isSelected: _currentIndex == 1,
                onTap: () => _onTabTapped(1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String label,
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: isSelected
              ? LinearGradient(
                  begin: label == "Devices"
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  end: label == "Devices"
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  colors: [AppColor.primary, AppColor.secondary],
                )
              : null,
          color: isSelected ? null : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Iconify(icon, color: isSelected ? Colors.white : AppColor.darkGrey),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColor.darkGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

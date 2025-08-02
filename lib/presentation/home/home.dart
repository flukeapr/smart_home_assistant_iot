import 'package:flutter/material.dart';
import 'package:smart_home_assistant_iot/presentation/home/widget/kilowatt_hour.dart';
import 'package:smart_home_assistant_iot/presentation/home/widget/security_mode.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              Text(
                "Welcome back to Home",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              KilowattHour(),
              SecurityMode(),
            ],
          ),
        ),
      ),
    );
  }
}

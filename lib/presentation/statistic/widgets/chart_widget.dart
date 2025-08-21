import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bxs.dart';
import 'package:smart_home_assistant_iot/core/config/theme/app_color.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  final double usage = 50.2;
  final List<Map<String, dynamic>> chartLabels = [
    {"label": "Mon", "value": 124.0},
    {"label": "Tue", "value": 110.0},
    {"label": "Wed", "value": 90.0},
    {"label": "Thu", "value": 80.0},
    {"label": "Fri", "value": 150.0},
    {"label": "Sat", "value": 134.0},
    {"label": "Sun", "value": 170.0},
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [_buildTitle(), _buildChart()],
    );
  }

  Widget _buildTitle() {
    return Text("Electricity Usage Statistics", style: TextStyle(fontSize: 16));
  }

  Widget _buildChart() {
    double minValue = chartLabels
        .map((e) => e["value"] as double)
        .reduce((a, b) => a < b ? a : b);
    double maxValue = chartLabels
        .map((e) => e["value"] as double)
        .reduce((a, b) => a > b ? a : b);

    return Container(
      width: double.infinity,
      height: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColor.lightGrey, width: 0.5),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildChartInfo(),
          Spacer(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 15,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: chartLabels.map((item) {
                double val = item["value"];
                return _buildBarChart(
                  value: val,
                  label: item["label"],
                  min: val == minValue,
                  max: val == maxValue,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              usage.toString(),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: AppColor.primary,
              ),
            ),
            Text(
              ' kWh',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColor.darkGrey,
              ),
            ),
          ],
        ),
        Row(
          spacing: 4,
          children: [
            Text("Less than last week", style: TextStyle(fontSize: 14)),
            Container(
              width: 30,
              height: 20,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.primary, AppColor.secondary],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  "5%",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBarChart({
    required double value,
    required String label,
    bool min = false,
    bool max = false,
  }) {
    return Column(
      spacing: 4,
      children: [
        Container(
          width: 32,
          height: value,
          decoration: BoxDecoration(
            gradient: min || max
                ? LinearGradient(
                    colors: [
                      Colors.grey.shade300,
                      min ? AppColor.green : AppColor.orange,
                    ],
                    stops: [0.1, 1],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : null,
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: min ? Iconify(Bxs.zap, color: Colors.white, size: 24) : null,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: AppColor.darkGrey)),
      ],
    );
  }
}

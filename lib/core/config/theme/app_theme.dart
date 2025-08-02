import 'package:flutter/material.dart';
import 'package:smart_home_assistant_iot/core/config/theme/app_color.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: AppColor.darkGrey),
      titleTextStyle: TextTheme().headlineSmall,
    ),
    primaryColor: AppColor.primary,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.white54;
        }
        return Colors.white;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return AppColor.grey.withAlpha((0.25 * 255).round());
        }
        return AppColor.grey.withAlpha((0.25 * 255).round());
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.transparent;
        }
        return Colors.transparent;
      }),
    ),
  );
}

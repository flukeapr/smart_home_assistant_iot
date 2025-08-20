import 'package:flutter/material.dart';
import 'package:smart_home_assistant_iot/core/config/theme/app_color.dart';
import 'package:smart_home_assistant_iot/core/service/voice/voice_command_service.dart';
import 'dart:math';

class VoiceCommandButton extends StatefulWidget {
  const VoiceCommandButton({super.key});

  @override
  State<VoiceCommandButton> createState() => _VoiceCommandButtonState();
}

class _VoiceCommandButtonState extends State<VoiceCommandButton>
    with SingleTickerProviderStateMixin {
  final VoiceCommandService _voiceService = VoiceCommandService();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _voiceService.initialize();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (_voiceService.isListening) {
      await _voiceService.stopListening();
    } else {
      await _voiceService.startListening();
    }
    setState(() {});
  }

  Widget _buildWave(double offset, Color color) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = _voiceService.isListening
            ? 1 + sin((_controller.value * 2 * pi) + offset) * 0.3
            : 1;
        return Transform.scale(
          scale: scale.toDouble(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 10,
            height: 40,
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildWave(0, Colors.blueAccent),
              _buildWave(1, Colors.lightBlue),
              _buildWave(2, Colors.cyan),
              const SizedBox(width: 60),
              _buildWave(2, Colors.cyan),
              _buildWave(1, Colors.lightBlue),
              _buildWave(0, Colors.blueAccent),
            ],
          ),

          GestureDetector(
            onTap: _toggleListening,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColor.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _voiceService.isListening ? Icons.mic : Icons.mic_off,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

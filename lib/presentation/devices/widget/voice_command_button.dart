import 'package:flutter/material.dart';
import 'package:smart_home_assistant_iot/core/service/voice/voice_command_service.dart';

class VoiceCommandButton extends StatefulWidget {
  const VoiceCommandButton({super.key});

  @override
  State<VoiceCommandButton> createState() => _VoiceCommandButtonState();
}

class _VoiceCommandButtonState extends State<VoiceCommandButton> {
  final VoiceCommandService _voiceCommandService = VoiceCommandService();

  @override
  void initState() {
    super.initState();
    _voiceCommandService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _voiceCommandService.isListening
          ? _voiceCommandService.stopListening
          : _voiceCommandService.startListening,
      tooltip: 'Listen',
      child: Icon(_voiceCommandService.isListening ? Icons.mic_off : Icons.mic),
    );
  }
}

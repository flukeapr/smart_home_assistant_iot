import 'package:smart_home_assistant_iot/core/service/firebase/realtime_database_service.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceCommandService {
  final SpeechToText _speechToText = SpeechToText();
  final RealtimeDatabaseService _realtimeDatabaseService =
      RealtimeDatabaseService();
  List<LocaleName> _locales = [];
  LocaleName? _selectedLocale;
  Future<void> initialize() async {
    await _speechToText.initialize();
    _locales = await _speechToText.locales();
    var systemLocale = await _speechToText.systemLocale();

    _selectedLocale = systemLocale ?? _locales.first;
  }

  Future<void> startListening() async {
    await _speechToText.listen(
      onResult: _handleSpeechResult,
      localeId: _selectedLocale?.localeId,
    );
  }

  void stopListening() {
    _speechToText.stop();
  }

  void _handleSpeechResult(SpeechRecognitionResult result) {
    if (result.finalResult) {
      String text = result.recognizedWords.toLowerCase();
      if (text.contains("smart home")) {
        if (text.contains('เปิดไฟ')) {
          _realtimeDatabaseService.setDeviceStatus("Light", true);
        } else if (text.contains('ปิดไฟ')) {
          _realtimeDatabaseService.setDeviceStatus("Light", false);
        }
      }
    }
  }

  bool get isListening => _speechToText.isListening;
}

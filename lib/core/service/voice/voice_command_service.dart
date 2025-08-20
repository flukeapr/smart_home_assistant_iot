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

  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  void _handleSpeechResult(SpeechRecognitionResult result) {
    if (result.finalResult) {
      String text = result.recognizedWords.toLowerCase();
      if (text.contains("smart home")) {
        if (text.contains('เปิดไฟ')) {
          _realtimeDatabaseService.setDeviceStatus("Light", true);
        } else if (text.contains('ปิดไฟ')) {
          _realtimeDatabaseService.setDeviceStatus("Light", false);
        } else if (text.contains('เปิดพัดลม')) {
          _realtimeDatabaseService.setDeviceStatus("Fan", true);
        } else if (text.contains('ปิดพัดลม')) {
          _realtimeDatabaseService.setDeviceStatus("Fan", false);
        } else if (text.contains('เปิดประตู')) {
          _realtimeDatabaseService.setDeviceStatus("Door", true);
        } else if (text.contains('ปิดประตู')) {
          _realtimeDatabaseService.setDeviceStatus("Door", false);
        }
      }
    }
  }

  bool get isListening => _speechToText.isListening;
}

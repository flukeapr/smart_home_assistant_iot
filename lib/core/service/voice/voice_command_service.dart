import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VoiceCommandService {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  List<LocaleName> _locales = [];
  LocaleName? _selectedLocale;
  bool isListening = false;
  String lastWords = "";

  Future<void> initialize() async {
    final available = await _speechToText.initialize();
    if (!available) {
      print("Speech recognition not available");
      return;
    }
    _locales = await _speechToText.locales();
    var systemLocale = await _speechToText.systemLocale();

    _selectedLocale = systemLocale ?? _locales.first;
    await _tts.awaitSpeakCompletion(true);

    // ตั้งค่าเป็นภาษาไทย
    await _tts.setLanguage("th-TH");
    await _tts.setSpeechRate(0.5);
    await _tts.setPitch(1.0);
  }

  Future<void> startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: _selectedLocale?.localeId,
    );
    isListening = true;
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
    isListening = false;
  }

  void _onSpeechResult(SpeechRecognitionResult result) async {
    lastWords = result.recognizedWords;
    if (result.finalResult && lastWords.isNotEmpty) {
      await stopListening();
      print(lastWords);

      // เรียก TTS หลัง stop เสร็จ
      final responseText = await _sendToN8nWebhook(lastWords);
      if (responseText.isNotEmpty) {
        Future.microtask(() async {
          await _tts.stop();
          await _tts.speak(responseText);
        });
      }
    }
  }

  Future<String> _sendToN8nWebhook(String message) async {
    try {
      final url = Uri.parse(
        "https://supachai6.app.n8n.cloud/webhook/assistant",
      );

      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: jsonEncode({"input": message}),
      );

      print("Response body: ${res.body}");

      if (res.statusCode == 200) {
        return res.body.toString();
      } else {
        return "ไม่สามารถส่งคำสั่งได้";
      }
    } catch (e) {
      print("Error sending to n8n webhook: $e");
      return "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้";
    }
  }
}

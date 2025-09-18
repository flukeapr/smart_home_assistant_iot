import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:smart_home_assistant_iot/core/service/firebase/realtime_database_service.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceCommandService {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  List<LocaleName> _locales = [];
  LocaleName? _selectedLocale;
  final RealtimeDatabaseService _realtimeDatabaseService =
      RealtimeDatabaseService();
  bool isListening = false;
  String lastWords = "";

  final dio = Dio();

  Future<void> initialize() async {
    await _speechToText.initialize();
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
      // เมื่อพูดเสร็จ → ส่งข้อความไปยัง webhook
      final responseText = await _sendToN8nWebhook(lastWords);

      // ให้ TTS อ่านคำตอบกลับ
      if (responseText.isNotEmpty) {
        await _tts.stop();
        await _tts.speak(responseText);
      }
    }
  }

  Future<String> _sendToN8nWebhook(String message) async {
    try {
      final url = "https://supachai6.app.n8n.cloud/webhook/assistant";

      final res = await dio.post(
        url,
        options: Options(
          headers: {"Content-Type": "application/json; charset=UTF-8"},
        ),
        data: jsonEncode({"input": message}),
      );

      print("📥 Response body: ${res.data}"); // 👈 Debug log

      if (res.statusCode == 200) {
        // ✅ ส่งกลับทั้ง body เลย
        return res.data;
      } else {
        return "Webhook error: ${res.statusCode}";
      }
    } catch (e) {
      print("❌ Error sending to n8n webhook: $e");
      return "$e";
    }
  }

  Future<String> _sendFirebase(String message) async {
    try {
      final text = message.toLowerCase().trim();
      if (text.contains("smart home")) {
        if (text.contains('เปิดไฟ')) {
          if (text.contains('นอกบ้าน')) {
            _realtimeDatabaseService.setDeviceStatus("Light2", true);
            return "เปิดไฟนอกบ้านแล้วครับ";
          }
          _realtimeDatabaseService.setDeviceStatus("Light", true);
          return "เปิดไฟในบ้านแล้วครับ";
        } else if (text.contains('ปิดไฟ')) {
          if (text.contains('นอกบ้าน')) {
            _realtimeDatabaseService.setDeviceStatus("Light2", false);
            return "ปิดไฟนอกบ้านแล้วครับ";
          }
          _realtimeDatabaseService.setDeviceStatus("Light", false);
          return "ปิดไฟในบ้านแล้วครับ";
        } else if (text.contains('เปิดพัดลม')) {
          _realtimeDatabaseService.setDeviceStatus("Fan", true);
          return "เปิดพัดลมแล้วครับ";
        } else if (text.contains('ปิดพัดลม')) {
          _realtimeDatabaseService.setDeviceStatus("Fan", false);
          return "ปิดพัดลมแล้วครับ";
        } else if (text.contains('เปิดประตู')) {
          _realtimeDatabaseService.setDeviceStatus("Door", true);
          return "เปิดประตูแล้วครับ";
        } else if (text.contains('ปิดประตู')) {
          _realtimeDatabaseService.setDeviceStatus("Door", false);
          return "ปิดประตูแล้วครับ";
        } else {
          return "คำสั่งไม่ถูกต้อง กรุณาลองใหม่อีกครั้งครับ";
        }
      } else {
        // return await _sendToN8nWebhook(text);
        return "คําสั่งไม่ถูกต้อง กรุณาลองใหม่อีกครั้งครับ";
      }
    } catch (e) {
      print("❌ Error sending to Firebase: $e");
      return "$e";
    }
  }
}

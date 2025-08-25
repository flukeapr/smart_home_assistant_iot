import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceCommandService {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _tts = FlutterTts();

  bool isListening = false;
  String lastWords = "";

  Future<void> initialize() async {
    await _speechToText.initialize();
    await _tts.awaitSpeakCompletion(true);

    // ตั้งค่าเป็นภาษาไทย
    await _tts.setLanguage("th-TH");
    await _tts.setSpeechRate(0.5);
    await _tts.setPitch(1.0);
  }

  Future<void> startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: "th-TH", // ฟังภาษาไทย
      listenMode: ListenMode.confirmation,
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
    final url = Uri.parse("https://7ff8550da0df.ngrok-free.app/webhook-test/assistant");

    final res = await http.post(
      url,
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode({"input": message}),
    );

    print("📥 Response body: ${res.body}"); // 👈 Debug log

    if (res.statusCode == 200) {
      // ✅ ส่งกลับทั้ง body เลย
      return res.body;
    } else {
      return "Webhook error: ${res.statusCode}";
    }
  } catch (e) {
    print("❌ Error sending to n8n webhook: $e");
    return "$e";
  }
}
}
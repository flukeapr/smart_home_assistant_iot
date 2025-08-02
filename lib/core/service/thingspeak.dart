import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Thingspeak {
  final String readapiKey = dotenv.env['READ_API_KEY']!;
  final String writeapiKey = dotenv.env['WRITE_API_KEY']!;
  final String channelId = dotenv.env['CHANNEL_ID']!;
  final dio = Dio();

  static final int ledField = 1;
  static final int fanField = 2;
  static final int doorField = 3;
  static final int securityModeField = 4;
  Future<bool> toggleField(int field, bool isOn) async {
    final String url =
        'https://api.thingspeak.com/update?api_key=$writeapiKey&field$field=${isOn ? 1 : 0}';
    final response = await dio.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to toggle field $field');
    }
    return isOn;
  }

  Future<bool> getFieldStatus(int field) async {
    final String url =
        'https://api.thingspeak.com/channels/$channelId/fields/$field/last.txt?api_key=$readapiKey';
    final response = await dio.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to get field $field status');
    }
    return response.data == '1';
  }
}

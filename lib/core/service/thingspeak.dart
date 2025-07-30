import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Thingspeak {
  final String readapiKey = dotenv.env['READ_API_KEY']!;
  final String writeapiKey = dotenv.env['WRITE_API_KEY']!;
  final String channelId = dotenv.env['CHANNEL_ID']!;
  final dio = Dio();
  Future<bool> toggleLed(bool isOn) async {
    final String url =
        'https://api.thingspeak.com/update?api_key=$writeapiKey&field1=${isOn ? 1 : 0}';
    final response = await dio.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to toggle LED');
    }
    return isOn;
  }

  Future<bool> getLedStatus() async {
    final String url =
        'https://api.thingspeak.com/channels/$channelId/fields/1/last.json?api_key=$readapiKey';
    final response = await dio.get(url);
    if (response.statusCode == 200) {
      final data = response.data;
      final value = data['field1'];
      return value == '1';
    } else {
      throw Exception('Failed to fetch LED status');
    }
  }
}

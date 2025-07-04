import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WhisperService {
  final Dio _dio = Dio();

  WhisperService() {
    _dio.options.baseUrl = 'https://api.openai.com/v1';
    _dio.options.headers['Authorization'] = 'Bearer ${dotenv.env['OPENAI_API_KEY']}';
  }

  Future<String> transcribeAudio(File audioFile) async {
    try {
      String fileName = audioFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(audioFile.path, filename: fileName),
        'model': 'whisper-1',
      });

      Response response = await _dio.post('/audio/transcriptions', data: formData);

      if (response.statusCode == 200) {
        return response.data['text'];
      } else {
        throw Exception('Failed to transcribe audio: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during transcription: $e');
    }
  }
}

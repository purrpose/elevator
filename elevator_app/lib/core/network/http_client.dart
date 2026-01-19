import 'package:dio/dio.dart';

class HttpClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://9c35747b31f6.ngrok-free.app',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );
}

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://mkrypto-backend.onrender.com/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  ApiService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('━━━━━━━━ MKrypto API REQUEST ━━━━━━━━');
          debugPrint('${options.method} ${options.uri}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('━━━━━━━━ MKrypto API RESPONSE ━━━━━━━');
          debugPrint('Status: ${response.statusCode}');
          debugPrint('URL: ${response.requestOptions.uri}');
          handler.next(response);
        },
        onError: (error, handler) {
          debugPrint('━━━━━━━━ MKrypto API ERROR ━━━━━━━━━');
          debugPrint('Status: ${error.response?.statusCode}');
          debugPrint('URL: ${error.requestOptions.uri}');
          debugPrint('Message: ${error.message}');
          handler.next(error);
        },
      ),
    );
  }

  Future<List<dynamic>> getCoins() async {
    final response = await _dio.get('/coins');

    return response.data;
  }

  Future<Map<String, dynamic>> getCoinDetails(String coinId) async {
    final response = await _dio.get('/coins/$coinId');

    return response.data;
  }

  Future<Map<String, dynamic>> getCoinChart(
    String coinId, {
    int days = 7,
  }) async {
    final response = await _dio.get(
      '/coins/$coinId/chart',
      queryParameters: {'days': days},
    );

    return response.data;
  }

  Future<Map<String, dynamic>> getMarketStats() async {
    final response = await _dio.get('/market');

    return response.data;
  }
}

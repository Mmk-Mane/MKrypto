import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:3000/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<dynamic>> getCoins() async {
    final response = await _dio.get('/coins');

    return response.data;
  }

  Future<Map<String, dynamic>> getCoinDetails(String coinId) async {
    final response = await _dio.get('/coins/$coinId');

    return response.data;
  }

  Future<Map<String, dynamic>> getCoinChart(String coinId) async {
    final response = await _dio.get('/coins/$coinId/chart');

    return response.data;
  }

  Future<Map<String, dynamic>> getMarketStats() async {
    final response = await _dio.get('/market');

    return response.data;
  }
}

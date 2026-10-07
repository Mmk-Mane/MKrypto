import 'package:flutter/foundation.dart';
import 'package:mkrypto/models/coin_details_model.dart';
import 'package:mkrypto/services/api_service.dart';

class CoinDetailsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  CoinDetailsModel? coinDetails;
  List<List<double>> chartData = [];

  bool isLoading = false;
  bool isChartLoading = false;
  String? errorMessage;
  String? chartErrorMessage;

  Future<void> fetchCoinDetails(String coinId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _apiService.getCoinDetails(coinId);

      coinDetails = CoinDetailsModel.fromJson(data);
    } catch (e) {
      debugPrint('Coin Details API Error: $e');
      errorMessage = 'Failed to load coin details';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCoinChart(String coinId, {int days = 7}) async {
    isChartLoading = true;
    chartErrorMessage = null;
    notifyListeners();

    try {
      final data = await _apiService.getCoinChart(coinId, days: days);

      final prices = data['prices'] as List<dynamic>? ?? [];
      debugPrint('Chart days=$days points=${prices.length}');

      chartData =
          prices
              .map(
                (point) => [
                  (point[0] as num).toDouble(),
                  (point[1] as num).toDouble(),
                ],
              )
              .toList();
    } catch (e) {
      debugPrint('Coin Chart API Error: $e');
      chartErrorMessage = 'Failed to load chart data';
    }

    isChartLoading = false;
    notifyListeners();
  }

  Future<void> fetchCoinData(String coinId) async {
    await Future.wait([fetchCoinDetails(coinId), fetchCoinChart(coinId)]);
  }

  void clear() {
    coinDetails = null;
    chartData = [];
    isLoading = false;
    isChartLoading = false;
    errorMessage = null;
    chartErrorMessage = null;
    notifyListeners();
  }
}

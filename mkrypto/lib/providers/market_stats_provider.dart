import 'package:flutter/foundation.dart';

import 'package:mkrypto/models/market_stats_model.dart';
import 'package:mkrypto/services/api_service.dart';

class MarketStatsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  MarketStatsModel? marketStats;

  bool isLoading = false;

  String? errorMessage;

  Future<void> fetchMarketStats() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _apiService.getMarketStats();
      marketStats = MarketStatsModel.fromJson(data);
    } catch (e) {
      debugPrint('Market Stats API Error: $e');
      errorMessage = 'Failed to load market statistics';
    }

    isLoading = false;
    notifyListeners();
  }
}

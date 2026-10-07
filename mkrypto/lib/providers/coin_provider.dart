import 'package:flutter/foundation.dart';
import 'package:mkrypto/models/coin_model.dart';
import 'package:mkrypto/services/api_service.dart';

class CoinProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<CoinModel> coins = [];
  List<CoinModel> displayedCoins = [];
  final Set<String> watchlistIds = {};
  String selectedFilter = 'all';
  bool isMarketCapDescending = true;

  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchCoins() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _apiService.getCoins();

      coins = data.map((json) => CoinModel.fromJson(json)).toList();
      displayedCoins = List.from(coins);
    } catch (e) {
      errorMessage = 'Failed to load coin data';
    }

    isLoading = false;
    notifyListeners();
  }

  void searchCoins(String query) {
    final searchQuery = query.trim().toLowerCase();

    if (searchQuery.isEmpty) {
      displayedCoins = List.from(coins);
    } else {
      displayedCoins =
          coins.where((coin) {
            return coin.name.toLowerCase().contains(searchQuery) ||
                coin.symbol.toLowerCase().contains(searchQuery);
          }).toList();
    }

    notifyListeners();
  }

  void filterCoins(String filter) {
    selectedFilter = filter;

    switch (filter) {
      case 'gainers':
        displayedCoins =
            coins.where((coin) => coin.priceChangePercentage24h > 0).toList();
        break;

      case 'losers':
        displayedCoins =
            coins.where((coin) => coin.priceChangePercentage24h < 0).toList();
        break;

      default:
        displayedCoins = List.from(coins);
    }

    notifyListeners();
  }

  void sortByMarketCap() {
    isMarketCapDescending = !isMarketCapDescending;

    displayedCoins.sort((a, b) {
      if (isMarketCapDescending) {
        return b.marketCap.compareTo(a.marketCap);
      }

      return a.marketCap.compareTo(b.marketCap);
    });

    notifyListeners();
  }

  void toggleWatchlist(String coinId) {
    if (watchlistIds.contains(coinId)) {
      watchlistIds.remove(coinId);
    } else {
      watchlistIds.add(coinId);
    }

    notifyListeners();
  }

  bool isWatchlisted(String coinId) {
    return watchlistIds.contains(coinId);
  }

  List<CoinModel> get topGainers {
    final result = [...coins];

    result.sort(
      (a, b) =>
          b.priceChangePercentage24h.compareTo(a.priceChangePercentage24h),
    );

    return result.take(10).toList();
  }

  List<CoinModel> get topLosers {
    final result = [...coins];

    result.sort(
      (a, b) =>
          a.priceChangePercentage24h.compareTo(b.priceChangePercentage24h),
    );

    return result.take(10).toList();
  }
}

class MarketStatsModel {
  final double totalMarketCap;
  final double totalVolume;
  final double marketCapChangePercentage24h;
  final double bitcoinDominance;
  final double ethereumDominance;

  const MarketStatsModel({
    required this.totalMarketCap,
    required this.totalVolume,
    required this.marketCapChangePercentage24h,
    required this.bitcoinDominance,
    required this.ethereumDominance,
  });

  factory MarketStatsModel.fromJson(Map<String, dynamic> json) {
    final marketCapPercentage =
        json['market_cap_percentage'] as Map<String, dynamic>?;

    return MarketStatsModel(
      totalMarketCap: (json['total_market_cap']?['usd'] ?? 0).toDouble(),
      totalVolume: (json['total_volume']?['usd'] ?? 0).toDouble(),
      marketCapChangePercentage24h:
          (json['market_cap_change_percentage_24h_usd'] ?? 0).toDouble(),
      bitcoinDominance: (marketCapPercentage?['btc'] ?? 0).toDouble(),
      ethereumDominance: (marketCapPercentage?['eth'] ?? 0).toDouble(),
    );
  }
}

class CoinDetailsModel {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double priceChangePercentage24h;
  final double marketCap;
  final double marketCapChangePercentage24h;
  final double totalVolume;
  final double circulatingSupply;
  final double? totalSupply;
  final double? maxSupply;
  final double? ath;
  final double? atl;
  final int? marketCapRank;

  const CoinDetailsModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.marketCap,
    required this.marketCapChangePercentage24h,
    required this.totalVolume,
    required this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    this.ath,
    this.atl,
    this.marketCapRank,
  });

  factory CoinDetailsModel.fromJson(Map<String, dynamic> json) {
    final marketData = json['market_data'] as Map<String, dynamic>? ?? {};

    return CoinDetailsModel(
      id: json['id'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      image: json['image']?['large'] ?? json['image']?['small'] ?? '',
      currentPrice: (marketData['current_price']?['usd'] ?? 0).toDouble(),
      priceChangePercentage24h:
          (marketData['price_change_percentage_24h'] ?? 0).toDouble(),
      marketCap: (marketData['market_cap']?['usd'] ?? 0).toDouble(),
      marketCapChangePercentage24h:
          (marketData['market_cap_change_percentage_24h'] ?? 0).toDouble(),
      totalVolume: (marketData['total_volume']?['usd'] ?? 0).toDouble(),
      circulatingSupply: (marketData['circulating_supply'] ?? 0).toDouble(),
      totalSupply: marketData['total_supply']?.toDouble(),
      maxSupply: marketData['max_supply']?.toDouble(),
      ath: (marketData['ath']?['usd'])?.toDouble(),
      atl: (marketData['atl']?['usd'])?.toDouble(),
      marketCapRank: (json['market_cap_rank'] as num?)?.toInt(),
    );
  }
}

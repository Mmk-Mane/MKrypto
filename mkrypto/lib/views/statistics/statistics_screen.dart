import 'package:flutter/material.dart';
import 'package:mkrypto/models/coin_model.dart';
import 'package:mkrypto/models/market_stats_model.dart';
import 'package:mkrypto/providers/coin_provider.dart';
import 'package:mkrypto/providers/market_stats_provider.dart';
import 'package:mkrypto/views/details/coin_details_screen.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _selectedTab = 0;
  int _selectedTrendTab = 0;

  static const backgroundColor = Color(0xFF060D16);
  static const cardColor = Color(0xFF111C2B);
  static const borderColor = Color(0xFF29384D);
  static const primaryColor = Color(0xFF5B4BFF);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketStatsProvider>().fetchMarketStats();
      context.read<CoinProvider>().fetchCoins();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text(
          'Market Statistics',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Consumer2<MarketStatsProvider, CoinProvider>(
        builder: (context, marketProvider, coinProvider, child) {
          if (marketProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (marketProvider.errorMessage != null ||
              marketProvider.marketStats == null) {
            return _buildErrorState(marketProvider);
          }

          final stats = marketProvider.marketStats!;

          return RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                marketProvider.fetchMarketStats(),
                coinProvider.fetchCoins(),
              ]);
            },
            color: primaryColor,
            backgroundColor: cardColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTabs(),

                  const SizedBox(height: 20),

                  if (_selectedTab == 0)
                    _buildGlobalContent(stats, coinProvider)
                  else if (_selectedTab == 1)
                    _buildCoinList(
                      title: 'Top Gainers',
                      coins: coinProvider.topGainers,
                    )
                  else
                    _buildCoinList(
                      title: 'Top Losers',
                      coins: coinProvider.topLosers,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // GLOBAL CONTENT
  // ---------------------------------------------------------------------------

  Widget _buildGlobalContent(
    MarketStatsModel stats,
    CoinProvider coinProvider,
  ) {
    final trendCoins =
        _selectedTrendTab == 0
            ? coinProvider.topGainers
            : coinProvider.topLosers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Global Market',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 12),

        _buildGlobalMarketCard(
          marketCap: stats.totalMarketCap,
          change: stats.marketCapChangePercentage24h,
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildSmallStatCard(
                title: '24h Volume',
                value: _formatLargeNumber(stats.totalVolume),
                icon: Icons.bar_chart_rounded,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _buildSmallStatCard(
                title: 'BTC Dominance',
                value: '${stats.bitcoinDominance.toStringAsFixed(1)}%',
                icon: Icons.pie_chart_rounded,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        const Text(
          'Market Trends',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 12),

        _buildMarketTrendTabs(),

        const SizedBox(height: 12),

        _buildTrendCoinList(trendCoins),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // MARKET TREND TABS
  // ---------------------------------------------------------------------------

  Widget _buildMarketTrendTabs() {
    return Container(
      height: 38,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTrendTab = 0;
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      _selectedTrendTab == 0
                          ? primaryColor
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Top Gainers',
                  style: TextStyle(
                    color:
                        _selectedTrendTab == 0 ? Colors.white : Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTrendTab = 1;
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      _selectedTrendTab == 1
                          ? primaryColor
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Top Losers',
                  style: TextStyle(
                    color:
                        _selectedTrendTab == 1 ? Colors.white : Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // GLOBAL MARKET CARD
  // ---------------------------------------------------------------------------

  Widget _buildGlobalMarketCard({
    required double marketCap,
    required double change,
  }) {
    final isPositive = change >= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1D4ED8).withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.public_rounded,
              color: Color(0xFF4F8CFF),
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Market Cap',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),

                const SizedBox(height: 5),

                Text(
                  _formatLargeNumber(marketCap),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Icon(
                      isPositive
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 13,
                      color: isPositive ? Colors.greenAccent : Colors.redAccent,
                    ),

                    const SizedBox(width: 2),

                    Text(
                      '${change >= 0 ? '+' : ''}'
                      '${change.toStringAsFixed(2)}% (24h)',
                      style: TextStyle(
                        color:
                            isPositive ? Colors.greenAccent : Colors.redAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          SizedBox(
            width: 105,
            height: 65,
            child: CustomPaint(painter: const _MiniChartPainter()),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SMALL STAT CARD
  // ---------------------------------------------------------------------------

  Widget _buildSmallStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      height: 86,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ),

              Icon(icon, color: const Color(0xFF8B7CFF), size: 17),
            ],
          ),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TREND COIN LIST
  // ---------------------------------------------------------------------------

  Widget _buildTrendCoinList(List<CoinModel> coins) {
    if (coins.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            'No coin data available',
            style: TextStyle(color: Colors.white54),
          ),
        ),
      );
    }

    return Column(
      children: [
        ...coins.take(4).toList().asMap().entries.map((entry) {
          final index = entry.key;
          final coin = entry.value;

          return _buildTrendCoinTile(rank: index + 1, coin: coin);
        }),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TREND COIN TILE
  // ---------------------------------------------------------------------------

  Widget _buildTrendCoinTile({required int rank, required CoinModel coin}) {
    final isPositive = coin.priceChangePercentage24h >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CoinDetailsScreen(coinId: coin.id),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                SizedBox(
                  width: 22,
                  child: Text(
                    '$rank',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white10,
                  backgroundImage: NetworkImage(coin.image),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coin.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        coin.symbol.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatCoinPrice(coin.currentPrice),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          size: 10,
                          color:
                              isPositive
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                        ),

                        const SizedBox(width: 1),

                        Text(
                          '${isPositive ? '+' : ''}'
                          '${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
                          style: TextStyle(
                            color:
                                isPositive
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(width: 6),

                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white30,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // GAINERS / LOSERS FULL LIST
  // ---------------------------------------------------------------------------

  Widget _buildCoinList({
    required String title,
    required List<CoinModel> coins,
  }) {
    if (coins.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Text(
            'No coin data available',
            style: TextStyle(color: Colors.white54),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 12),

        ...coins.map((coin) {
          final isPositive = coin.priceChangePercentage24h >= 0;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CoinDetailsScreen(coinId: coin.id),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white10,
                        backgroundImage: NetworkImage(coin.image),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coin.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              coin.symbol.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _formatCoinPrice(coin.currentPrice),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            '${isPositive ? '+' : ''}'
                            '${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
                            style: TextStyle(
                              color:
                                  isPositive
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 6),

                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white30,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TOP TABS
  // ---------------------------------------------------------------------------

  Widget _buildTabs() {
    return Container(
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          _buildTab('Global', 0),
          _buildTab('Gainers', 1),
          _buildTab('Losers', 2),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final selected = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white54,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ERROR STATE
  // ---------------------------------------------------------------------------

  Widget _buildErrorState(MarketStatsProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white54,
              size: 40,
            ),

            const SizedBox(height: 12),

            const Text(
              'Failed to load market statistics',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: provider.fetchMarketStats,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FORMATTING
  // ---------------------------------------------------------------------------

  String _formatLargeNumber(double value) {
    if (value >= 1e12) {
      return '\$${(value / 1e12).toStringAsFixed(2)}T';
    }

    if (value >= 1e9) {
      return '\$${(value / 1e9).toStringAsFixed(2)}B';
    }

    if (value >= 1e6) {
      return '\$${(value / 1e6).toStringAsFixed(2)}M';
    }

    if (value >= 1e3) {
      return '\$${(value / 1e3).toStringAsFixed(2)}K';
    }

    return '\$${value.toStringAsFixed(2)}';
  }

  String _formatCoinPrice(double value) {
    if (value >= 1000) {
      return '\$${value.toStringAsFixed(2)}';
    }

    if (value >= 1) {
      return '\$${value.toStringAsFixed(2)}';
    }

    if (value >= 0.01) {
      return '\$${value.toStringAsFixed(2)}';
    }

    return '\$${value.toStringAsFixed(6)}';
  }
}

// -----------------------------------------------------------------------------
// MINI MARKET CHART
// -----------------------------------------------------------------------------

class _MiniChartPainter extends CustomPainter {
  const _MiniChartPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint =
        Paint()
          ..color = Colors.greenAccent.shade400
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final areaPaint =
        Paint()
          ..color = Colors.greenAccent.withValues(alpha: 0.08)
          ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, size.height * 0.72);
    path.lineTo(size.width * 0.12, size.height * 0.62);
    path.lineTo(size.width * 0.23, size.height * 0.68);
    path.lineTo(size.width * 0.35, size.height * 0.42);
    path.lineTo(size.width * 0.47, size.height * 0.52);
    path.lineTo(size.width * 0.60, size.height * 0.30);
    path.lineTo(size.width * 0.72, size.height * 0.38);
    path.lineTo(size.width * 0.84, size.height * 0.18);
    path.lineTo(size.width, size.height * 0.25);

    final areaPath =
        Path.from(path)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();

    canvas.drawPath(areaPath, areaPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mkrypto/providers/coin_details_provider.dart';
import 'package:mkrypto/providers/coin_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class CoinDetailsScreen extends StatefulWidget {
  final String coinId;

  const CoinDetailsScreen({super.key, required this.coinId});

  @override
  State<CoinDetailsScreen> createState() => _CoinDetailsScreenState();
}

class _CoinDetailsScreenState extends State<CoinDetailsScreen> {
  String _selectedRange = '7D';

  int _getDaysForRange(String range) {
    switch (range) {
      case '1H':
        return 1;
      case '1D':
        return 1;
      case '7D':
        return 7;
      case '30D':
        return 30;
      case '1Y':
        return 365;
      default:
        return 7;
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoinDetailsProvider>().fetchCoinData(widget.coinId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF060D16),
        appBar: AppBar(
          backgroundColor: const Color(0xFF060D16),
          elevation: 0,
          leading: const BackButton(color: Colors.white),
          actions: [
            Consumer<CoinProvider>(
              builder: (context, coinProvider, child) {
                final isWatchlisted = coinProvider.isWatchlisted(widget.coinId);

                return IconButton(
                  onPressed: () {
                    coinProvider.toggleWatchlist(widget.coinId);
                  },
                  icon: Icon(
                    isWatchlisted
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color:
                        isWatchlisted ? const Color(0xFFFFC83D) : Colors.white,
                  ),
                );
              },
            ),

            IconButton(
              onPressed: () {
                final coin = context.read<CoinDetailsProvider>().coinDetails;

                if (coin == null) return;

                SharePlus.instance.share(
                  ShareParams(
                    text:
                        '${coin.name} (${coin.symbol.toUpperCase()})\n'
                        'Current Price: \$${coin.currentPrice.toStringAsFixed(2)}\n'
                        'Check it out on MKrypto.',
                  ),
                );
              },
              icon: const Icon(Icons.share_rounded, color: Colors.white),
            ),

            const SizedBox(width: 8),
          ],
        ),
        body: Consumer<CoinDetailsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage != null || provider.coinDetails == null) {
              return const Center(
                child: Text(
                  'Failed to load coin details',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            final coin = provider.coinDetails!;
            final isPositive = coin.priceChangePercentage24h >= 0;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFF111C2B),
                        backgroundImage: NetworkImage(coin.image),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coin.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                Text(
                                  coin.symbol.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (coin.marketCapRank != null) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF29384D),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      '#${coin.marketCapRank}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _formatPrice(coin.currentPrice),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        isPositive
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded,
                        size: 15,
                        color:
                            isPositive
                                ? Colors.greenAccent.shade400
                                : Colors.redAccent,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${coin.priceChangePercentage24h.abs().toStringAsFixed(2)}% (24h)',
                        style: TextStyle(
                          color:
                              isPositive
                                  ? Colors.greenAccent.shade400
                                  : Colors.redAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _ChartRangeSelector(
                    selectedRange: _selectedRange,
                    onRangeSelected: (range) {
                      setState(() {
                        _selectedRange = range;
                      });

                      context.read<CoinDetailsProvider>().fetchCoinChart(
                        widget.coinId,
                        days: _getDaysForRange(range),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  _ChartCard(
                    chartData: provider.chartData,
                    isLoading: provider.isChartLoading,
                    errorMessage: provider.chartErrorMessage,
                  ),

                  const SizedBox(height: 20),
                  _MarketDataCard(
                    marketCap: coin.marketCap,
                    marketCapChangePercentage24h:
                        coin.marketCapChangePercentage24h,
                    volume: coin.totalVolume,
                    circulatingSupply: coin.circulatingSupply,
                    totalSupply: coin.totalSupply,
                    maxSupply: coin.maxSupply,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
      return '\$${price.toStringAsFixed(2)}';
    }

    if (price >= 1) {
      return '\$${price.toStringAsFixed(2)}';
    }

    return '\$${price.toStringAsFixed(4)}';
  }
}

class _ChartRangeSelector extends StatelessWidget {
  final String selectedRange;
  final ValueChanged<String> onRangeSelected;

  const _ChartRangeSelector({
    required this.selectedRange,
    required this.onRangeSelected,
  });

  static const ranges = ['1H', '1D', '7D', '30D', '1Y'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF111C2B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF29384D)),
      ),
      child: Row(
        children:
            ranges.map((range) {
              return _RangeItem(
                label: range,
                isSelected: selectedRange == range,
                onTap: () => onRangeSelected(range),
              );
            }).toList(),
      ),
    );
  }
}

class _RangeItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RangeItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF5B4BFF) : Colors.transparent,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final List<List<double>> chartData;
  final bool isLoading;
  final String? errorMessage;

  const _ChartCard({
    required this.chartData,
    required this.isLoading,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 270,
      padding: const EdgeInsets.fromLTRB(12, 12, 8, 8),
      decoration: BoxDecoration(
        color: const Color(0xFF111C2B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF29384D)),
      ),
      child: _buildChart(),
    );
  }

  Widget _buildChart() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null || chartData.isEmpty) {
      return const Center(
        child: Text(
          'Chart data unavailable',
          style: TextStyle(color: Colors.white54, fontSize: 13),
        ),
      );
    }
    final spots =
        chartData.map((point) {
          return FlSpot(point[0], point[1]);
        }).toList();
    final prices = chartData.map((point) => point[1]).toList();

    final minPrice = prices.reduce((a, b) => a < b ? a : b);

    final maxPrice = prices.reduce((a, b) => a > b ? a : b);

    final range = maxPrice - minPrice;
    final padding = range == 0 ? maxPrice * 0.01 : range * 0.08;

    return LineChart(
      LineChartData(
        minY: minPrice - padding,
        maxY: maxPrice + padding,

        // Grid
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          verticalInterval: _getXAxisTimeInterval(),
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.white.withValues(alpha: 0.05),
              strokeWidth: 1,
            );
          },
          horizontalInterval: range == 0 ? null : range / 4,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.white.withValues(alpha: 0.08),
              strokeWidth: 1,
            );
          },
        ),

        borderData: FlBorderData(show: false),

        // X and Y axis labels
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),

          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              interval: range == 0 ? null : range / 4,
              getTitlesWidget: (value, meta) {
                return Text(
                  _formatChartPrice(value),
                  style: const TextStyle(color: Colors.white54, fontSize: 10),
                );
              },
            ),
          ),

          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),

          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: _getXAxisTimeInterval(),
              minIncluded: true,
              maxIncluded: false,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _formatChartDate(value),
                    style: const TextStyle(color: Colors.white54, fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),

        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final timestamp = spot.x;

                return LineTooltipItem(
                  '${_formatChartDateTime(timestamp)}\n'
                  '${_formatChartPrice(spot.y)}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),

        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withValues(alpha: 0.08),
            ),
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  double _getXAxisTimeInterval() {
    if (chartData.length < 2) {
      return 1;
    }

    final start = chartData.first[0];
    final end = chartData.last[0];
    final duration = end - start;

    return duration / 4;
  }

  String _formatChartPrice(double price) {
    if (price >= 1000000) {
      return '\$${(price / 1000000).toStringAsFixed(1)}M';
    }

    if (price >= 1000) {
      return '\$${(price / 1000).toStringAsFixed(1)}K';
    }

    return '\$${price.toStringAsFixed(2)}';
  }

  String _formatChartDate(double timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp.toInt());

    return '${date.day}/${date.month}';
  }

  String _formatChartDateTime(double timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp.toInt());

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '${date.day}/${date.month} $hour:$minute';
  }
}

class _MarketDataCard extends StatelessWidget {
  final double marketCap;
  final double volume;
  final double circulatingSupply;
  final double? totalSupply;
  final double? maxSupply;
  final double marketCapChangePercentage24h;

  const _MarketDataCard({
    required this.marketCap,
    required this.marketCapChangePercentage24h,
    required this.volume,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.maxSupply,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Market Statistics',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _StatisticBox(
                label: 'Market Cap',
                value: _formatLargeNumber(marketCap),
                changePercentage: marketCapChangePercentage24h,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatisticBox(
                label: '24h Volume',
                value: _formatLargeNumber(volume),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF111C2B),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF29384D)),
          ),
          child: Column(
            children: [
              _DataRow(
                label: 'Circulating Supply',
                value: _formatSupply(circulatingSupply),
              ),
              const SizedBox(height: 14),
              _DataRow(
                label: 'Total Supply',
                value:
                    totalSupply == null ? 'N/A' : _formatSupply(totalSupply!),
              ),
              const SizedBox(height: 14),
              _DataRow(
                label: 'Max Supply',
                value: maxSupply == null ? 'N/A' : _formatSupply(maxSupply!),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatLargeNumber(double value) {
    if (value >= 1e12) {
      return '${(value / 1e12).toStringAsFixed(2)}T';
    }

    if (value >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(2)}B';
    }

    if (value >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(2)}M';
    }

    if (value >= 1e3) {
      return '${(value / 1e3).toStringAsFixed(2)}K';
    }

    return value.toStringAsFixed(2);
  }

  String _formatSupply(double value) {
    if (value >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(2)}B';
    }

    if (value >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(2)}M';
    }

    if (value >= 1e3) {
      return '${(value / 1e3).toStringAsFixed(2)}K';
    }

    return value.toStringAsFixed(2);
  }
}

class _StatisticBox extends StatelessWidget {
  final String label;
  final String value;
  final double? changePercentage;

  const _StatisticBox({
    required this.label,
    required this.value,
    this.changePercentage,
  });

  @override
  Widget build(BuildContext context) {
    final hasChange = changePercentage != null;
    final change = changePercentage ?? 0;
    final isPositive = change >= 0;

    return Container(
      height: 90,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF111C2B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF29384D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (hasChange) ...[
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(
                  isPositive
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  size: 12,
                  color:
                      isPositive
                          ? Colors.greenAccent.shade400
                          : Colors.redAccent,
                ),
                const SizedBox(width: 2),
                Text(
                  '${change.abs().toStringAsFixed(2)}%',
                  style: TextStyle(
                    color:
                        isPositive
                            ? Colors.greenAccent.shade400
                            : Colors.redAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 3),
                const Text(
                  '(24h)',
                  style: TextStyle(color: Colors.white38, fontSize: 10),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final String label;
  final String value;

  const _DataRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

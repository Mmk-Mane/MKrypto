import 'package:flutter/material.dart';
import 'package:mkrypto/providers/market_stats_provider.dart';
import 'package:provider/provider.dart';

class MarketSummaryCard extends StatelessWidget {
  const MarketSummaryCard({super.key});

  static const cardColor = Color(0xFF111C2B);
  static const borderColor = Color(0xFF29384D);
  static const primaryColor = Color(0xFF5B4BFF);

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketStatsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const _LoadingCard();
        }

        if (provider.errorMessage != null || provider.marketStats == null) {
          return const _ErrorCard();
        }

        final stats = provider.marketStats!;
        final isPositive = stats.marketCapChangePercentage24h >= 0;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.public_rounded,
                      color: Color(0xFF8B7CFF),
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 10),

                  const Expanded(
                    child: Text(
                      'Global Market',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isPositive
                              ? Colors.greenAccent.withValues(alpha: 0.10)
                              : Colors.redAccent.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      '24h',
                      style: TextStyle(
                        color:
                            isPositive
                                ? Colors.greenAccent.shade400
                                : Colors.redAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Market Cap',
                          style: TextStyle(color: Colors.white54, fontSize: 11),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          _formatMarketCap(stats.totalMarketCap),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Change',
                        style: TextStyle(color: Colors.white54, fontSize: 11),
                      ),

                      const SizedBox(height: 5),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPositive
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            color:
                                isPositive
                                    ? Colors.greenAccent.shade400
                                    : Colors.redAccent,
                            size: 15,
                          ),

                          const SizedBox(width: 3),

                          Text(
                            '${isPositive ? '+' : ''}'
                            '${stats.marketCapChangePercentage24h.toStringAsFixed(2)}%',
                            style: TextStyle(
                              color:
                                  isPositive
                                      ? Colors.greenAccent.shade400
                                      : Colors.redAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Container(height: 1, color: borderColor.withValues(alpha: 0.6)),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    color: Colors.white54,
                    size: 16,
                  ),

                  const SizedBox(width: 6),

                  const Text(
                    'Market overview',
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),

                  const Spacer(),

                  Text(
                    isPositive ? 'Market is up' : 'Market is down',
                    style: TextStyle(
                      color:
                          isPositive
                              ? Colors.greenAccent.shade400
                              : Colors.redAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatMarketCap(double value) {
    if (value >= 1e12) {
      return '\$${(value / 1e12).toStringAsFixed(2)}T';
    }

    if (value >= 1e9) {
      return '\$${(value / 1e9).toStringAsFixed(2)}B';
    }

    if (value >= 1e6) {
      return '\$${(value / 1e6).toStringAsFixed(2)}M';
    }

    return '\$${value.toStringAsFixed(0)}';
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: const Color(0xFF111C2B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF29384D)),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: const Color(0xFF111C2B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF29384D)),
      ),
      child: const Center(
        child: Text(
          'Market data unavailable',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ),
    );
  }
}

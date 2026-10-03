import 'package:flutter/material.dart';
import 'package:mkrypto/providers/coin_provider.dart';
import 'package:provider/provider.dart';

class MarketFilterSection extends StatelessWidget {
  const MarketFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CoinProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _FilterButton(
                    title: 'All',
                    isSelected: provider.selectedFilter == 'all',
                    onTap: () {
                      provider.filterCoins('all');
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _FilterButton(
                    title: 'Gainers',
                    isSelected: provider.selectedFilter == 'gainers',
                    onTap: () {
                      provider.filterCoins('gainers');
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _FilterButton(
                    title: 'Losers',
                    isSelected: provider.selectedFilter == 'losers',
                    onTap: () {
                      provider.filterCoins('losers');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Top Coins',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    provider.sortByMarketCap();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111C2B),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF29384D)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Market Cap',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          provider.isMarketCapDescending
                              ? Icons.keyboard_arrow_down_rounded
                              : Icons.keyboard_arrow_up_rounded,
                          color: Colors.white70,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterButton({
    required this.title,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5B50F5) : const Color(0xFF111C2B),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF746BFF) : const Color(0xFF1D2A3B),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

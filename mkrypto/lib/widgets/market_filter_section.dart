import 'package:flutter/material.dart';
import 'package:mkrypto/providers/coin_provider.dart';
import 'package:provider/provider.dart';

class MarketFilterSection extends StatelessWidget {
  const MarketFilterSection({super.key});

  static const cardColor = Color(0xFF111C2B);
  static const borderColor = Color(0xFF29384D);
  static const primaryColor = Color(0xFF5B4BFF);

  @override
  Widget build(BuildContext context) {
    return Consumer<CoinProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            // ---------------------------------------------------------------
            // FILTER TABS
            // ---------------------------------------------------------------
            Container(
              height: 42,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Row(
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

                  Expanded(
                    child: _FilterButton(
                      title: 'Gainers',
                      isSelected: provider.selectedFilter == 'gainers',
                      onTap: () {
                        provider.filterCoins('gainers');
                      },
                    ),
                  ),

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
            ),

            const SizedBox(height: 18),

            // ---------------------------------------------------------------
            // SECTION TITLE + SORT
            // ---------------------------------------------------------------
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Top Coins',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(9),
                    onTap: () {
                      provider.sortByMarketCap();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.sort_rounded,
                            color: Colors.white60,
                            size: 16,
                          ),

                          const SizedBox(width: 5),

                          const Text(
                            'Market Cap',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(width: 2),

                          Icon(
                            provider.isMarketCapDescending
                                ? Icons.keyboard_arrow_down_rounded
                                : Icons.keyboard_arrow_up_rounded,
                            color: Colors.white70,
                            size: 17,
                          ),
                        ],
                      ),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.all(2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5B4BFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white54,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

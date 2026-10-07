import 'package:flutter/material.dart';
import 'package:mkrypto/providers/coin_provider.dart';
import 'package:mkrypto/views/details/coin_details_screen.dart';
import 'package:mkrypto/widgets/coin_list_tile.dart';
import 'package:provider/provider.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CoinProvider>();

      if (provider.coins.isEmpty) {
        provider.fetchCoins();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060D16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF060D16),
        elevation: 0,
        title: const Text(
          'Watchlist',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Consumer<CoinProvider>(
        builder: (context, provider, child) {
          final watchlistedCoins =
              provider.coins
                  .where((coin) => provider.watchlistIds.contains(coin.id))
                  .toList();

          if (watchlistedCoins.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5B4BFF).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.star_rounded,
                        color: Color(0xFF8B7CFF),
                        size: 42,
                      ),
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      'Your watchlist is empty',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Save your favorite coins here to quickly track their price and market performance.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 22),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111C2B),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF29384D)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_border_rounded,
                            color: Color(0xFFFFC83D),
                            size: 17,
                          ),
                          SizedBox(width: 7),
                          Text(
                            'Tap the star to save a coin',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: watchlistedCoins.length,
            itemBuilder: (context, index) {
              final coin = watchlistedCoins[index];

              return CoinListTile(
                coin: coin,
                rank: index + 1,
                isWatchlisted: true,
                onWatchlistTap: () {
                  provider.toggleWatchlist(coin.id);
                },
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CoinDetailsScreen(coinId: coin.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

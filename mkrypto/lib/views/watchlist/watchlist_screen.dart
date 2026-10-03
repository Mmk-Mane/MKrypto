import 'package:flutter/material.dart';
import 'package:mkrypto/providers/coin_provider.dart';
import 'package:mkrypto/widgets/coin_list_tile.dart';
import 'package:provider/provider.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

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
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star_border_rounded,
                      color: Colors.white38,
                      size: 56,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Your watchlist is empty',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap the star on a coin to add it to your watchlist.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54, fontSize: 13),
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
              );
            },
          );
        },
      ),
    );
  }
}

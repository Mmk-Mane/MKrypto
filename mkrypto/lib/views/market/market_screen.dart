import 'package:flutter/material.dart';
import 'package:mkrypto/providers/coin_provider.dart';
import 'package:mkrypto/providers/market_stats_provider.dart';
import 'package:mkrypto/views/details/coin_details_screen.dart';
import 'package:mkrypto/widgets/coin_list_tile.dart';
import 'package:mkrypto/widgets/market_filter_section.dart';
import 'package:mkrypto/widgets/market_header.dart';
import 'package:mkrypto/widgets/market_search_bar.dart';
import 'package:mkrypto/widgets/market_summary_card.dart';
import 'package:provider/provider.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMarketData();
    });
  }

  Future<void> _loadMarketData() async {
    await Future.wait([
      context.read<CoinProvider>().fetchCoins(),
      context.read<MarketStatsProvider>().fetchMarketStats(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060D16),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF7C72FF),
          backgroundColor: const Color(0xFF111C2B),
          onRefresh: _loadMarketData,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MarketHeader(),

                const SizedBox(height: 18),

                const MarketSearchBar(),

                const SizedBox(height: 14),

                const MarketSummaryCard(),

                const SizedBox(height: 18),

                const MarketFilterSection(),

                const SizedBox(height: 12),

                const Expanded(child: _CoinListSection()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CoinListSection extends StatelessWidget {
  const _CoinListSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<CoinProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.coins.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF7C72FF)),
          );
        }

        if (provider.errorMessage != null && provider.coins.isEmpty) {
          return Center(
            child: _MarketErrorState(
              message: provider.errorMessage!,
              onRetry: provider.fetchCoins,
            ),
          );
        }

        if (provider.coins.isEmpty) {
          return const Center(
            child: Text(
              'No coins available',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
          );
        }

        if (provider.displayedCoins.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_off_rounded, color: Colors.white38, size: 42),
                SizedBox(height: 12),
                Text(
                  'No matching coins',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Try a different search or filter.',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 20),
          itemCount: provider.displayedCoins.length,
          itemBuilder: (context, index) {
            final coin = provider.displayedCoins[index];

            return CoinListTile(
              coin: coin,
              rank: index + 1,
              isWatchlisted: provider.isWatchlisted(coin.id),
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
    );
  }
}

class _MarketErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _MarketErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_rounded, color: Colors.white38, size: 44),

          const SizedBox(height: 12),

          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B4BFF),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

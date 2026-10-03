import 'package:flutter/material.dart';
import 'package:mkrypto/providers/coin_provider.dart';
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
      context.read<CoinProvider>().fetchCoins();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060D16),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MarketHeader(),

              const SizedBox(height: 20),

              const MarketSearchBar(),
              const SizedBox(height: 14),

              const MarketSummaryCard(),
              const SizedBox(height: 18),

              const MarketFilterSection(),
              const SizedBox(height: 14),
              const Expanded(child: _CoinListSection()),
            ],
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
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null) {
          return Center(
            child: Text(
              provider.errorMessage!,
              style: const TextStyle(color: Colors.white70),
            ),
          );
        }

        if (provider.coins.isEmpty) {
          return const Center(
            child: Text(
              'No coins available',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.builder(
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
            );
          },
        );
      },
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mkrypto/models/coin_model.dart';

class CoinListTile extends StatelessWidget {
  final CoinModel coin;
  final int rank;
  final bool isWatchlisted;
  final VoidCallback onWatchlistTap;

  const CoinListTile({
    super.key,
    required this.coin,
    required this.rank,
    required this.isWatchlisted,
    required this.onWatchlistTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = coin.priceChangePercentage24h >= 0;

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF1D2938))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$rank',
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),

          CachedNetworkImage(
            imageUrl: coin.image,
            width: 36,
            height: 36,
            placeholder:
                (context, url) => const SizedBox(
                  width: 36,
                  height: 36,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
            errorWidget:
                (context, url, error) => const Icon(
                  Icons.currency_bitcoin,
                  size: 30,
                  color: Colors.orange,
                ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatPrice(coin.currentPrice),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${isPositive ? '▲' : '▼'} ${coin.priceChangePercentage24h.abs().toStringAsFixed(2)}%',
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

          const SizedBox(width: 8),

          IconButton(
            onPressed: onWatchlistTap,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            icon: Icon(
              isWatchlisted ? Icons.star_rounded : Icons.star_border_rounded,
              color: isWatchlisted ? const Color(0xFFFFC83D) : Colors.white54,
              size: 23,
            ),
          ),
        ],
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

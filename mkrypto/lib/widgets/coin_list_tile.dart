import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mkrypto/models/coin_model.dart';

class CoinListTile extends StatelessWidget {
  final CoinModel coin;
  final int rank;
  final bool isWatchlisted;
  final VoidCallback onWatchlistTap;
  final VoidCallback? onTap;

  const CoinListTile({
    super.key,
    required this.coin,
    required this.rank,
    required this.isWatchlisted,
    required this.onWatchlistTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = coin.priceChangePercentage24h >= 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 76,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF0B1420),
            border: const Border(bottom: BorderSide(color: Color(0xFF1D2938))),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 26,
                child: Text(
                  '$rank',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(width: 6),

              CachedNetworkImage(
                imageUrl: coin.image,
                width: 38,
                height: 38,
                placeholder: (context, url) {
                  return const SizedBox(
                    width: 38,
                    height: 38,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return const Icon(
                    Icons.currency_bitcoin,
                    size: 30,
                    color: Colors.orange,
                  );
                },
              ),

              const SizedBox(width: 11),

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

                    const SizedBox(height: 4),

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
                                ? Colors.greenAccent.shade400
                                : Colors.redAccent,
                      ),

                      const SizedBox(width: 2),

                      Text(
                        '${coin.priceChangePercentage24h.abs().toStringAsFixed(2)}%',
                        style: TextStyle(
                          color:
                              isPositive
                                  ? Colors.greenAccent.shade400
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

              if (onTap != null)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white30,
                  size: 19,
                ),

              const SizedBox(width: 1),

              IconButton(
                onPressed: onWatchlistTap,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                icon: Icon(
                  isWatchlisted
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  color:
                      isWatchlisted ? const Color(0xFFFFC83D) : Colors.white54,
                  size: 22,
                ),
              ),
            ],
          ),
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

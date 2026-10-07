import 'package:flutter/material.dart';
import 'package:mkrypto/providers/coin_provider.dart';
import 'package:provider/provider.dart';

class MarketSearchBar extends StatefulWidget {
  const MarketSearchBar({super.key});

  @override
  State<MarketSearchBar> createState() => _MarketSearchBarState();
}

class _MarketSearchBarState extends State<MarketSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
 @override
Widget build(BuildContext context) {
  final hasText = _searchController.text.isNotEmpty;

  return Container(
    height: 50,
    decoration: BoxDecoration(
      color: const Color(0xFF111C2B),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: hasText
            ? const Color(0xFF5B4BFF)
            : const Color(0xFF29384D),
      ),
    ),
    child: TextField(
      controller: _searchController,

      onChanged: (value) {
        context.read<CoinProvider>().searchCoins(value);
        setState(() {});
      },

      textInputAction: TextInputAction.search,

      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),

      decoration: InputDecoration(
        hintText: 'Search coins or symbols...',
        hintStyle: const TextStyle(
          color: Colors.white38,
          fontSize: 13,
        ),

        prefixIcon: const Icon(
          Icons.search_rounded,
          color: Colors.white60,
          size: 21,
        ),

        suffixIcon: hasText
            ? IconButton(
                tooltip: 'Clear search',
                onPressed: () {
                  _searchController.clear();
                  context.read<CoinProvider>().searchCoins('');
                  setState(() {});
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white54,
                  size: 19,
                ),
              )
            : null,

        border: InputBorder.none,

        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 4,
        ),
      ),
    ),
  );
}
}

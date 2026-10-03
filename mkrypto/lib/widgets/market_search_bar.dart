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
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF111C2B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF29384D)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          context.read<CoinProvider>().searchCoins(value);
          setState(() {});
        },
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search coins (e.g. Bitcoin, ETH)',
          hintStyle: const TextStyle(color: Colors.white54, fontSize: 13),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Colors.white70,
            size: 21,
          ),
          suffixIcon:
              _searchController.text.isNotEmpty
                  ? IconButton(
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
            vertical: 14,
            horizontal: 4,
          ),
        ),
      ),
    );
  }
}

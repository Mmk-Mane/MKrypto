import 'package:flutter/material.dart';
import 'package:mkrypto/providers/coin_details_provider.dart';
import 'package:mkrypto/providers/coin_provider.dart';
import 'package:mkrypto/providers/market_stats_provider.dart';
import 'package:mkrypto/views/home/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CoinProvider()),
        ChangeNotifierProvider(create: (_) => MarketStatsProvider()),
        ChangeNotifierProvider(create: (_) => CoinDetailsProvider()),
      ],

      child: MaterialApp(
        title: 'MMK MKrypto App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: HomeScreen(),
      ),
    );
  }
}

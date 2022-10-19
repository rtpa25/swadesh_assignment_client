import 'package:client/store/user_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/transaction_screen.dart';
import 'store/transaction_data.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => TransactionsData()),
      ChangeNotifierProvider(create: (context) => UserData()),
    ],
    child: const SwadeshAssignment(),
  ));
}

class SwadeshAssignment extends StatelessWidget {
  const SwadeshAssignment({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        primaryColor: const Color(0xFF0A0E21),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFFEB1555),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const TransactionsScreen(),
    );
  }
}

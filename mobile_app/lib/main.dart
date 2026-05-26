import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'presentation/dashboard/dashboard_screen.dart';

void main() {
  // RiverpodのProviderScopeでアプリ全体を囲む
  runApp(const ProviderScope(child: FinOpsApp()));
}

class FinOpsApp extends StatelessWidget {
  const FinOpsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinOps Asset Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

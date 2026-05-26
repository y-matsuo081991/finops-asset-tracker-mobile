import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

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

// ====== ドメインモデル ======
class EdgeNode {
  final String id;
  final String name;
  final String region;
  final String status;
  final double monthlyCostUsd;
  final double bookValueUsd;

  EdgeNode({
    required this.id,
    required this.name,
    required this.region,
    required this.status,
    required this.monthlyCostUsd,
    required this.bookValueUsd,
  });

  factory EdgeNode.fromJson(Map<String, dynamic> json) {
    return EdgeNode(
      id: json['id'],
      name: json['name'],
      region: json['region'],
      status: json['status'],
      // FastAPIからfloatで来る数値を安全にパース
      monthlyCostUsd: (json['monthly_cost_usd'] as num).toDouble(),
      bookValueUsd: (json['book_value_usd'] as num).toDouble(),
    );
  }
}

// ====== 状態管理 (Riverpod) ======
// FastAPIからデータを取得するFutureProvider
final nodesProvider = FutureProvider<List<EdgeNode>>((ref) async {
  // localhost (127.0.0.1) の FastAPI エンドポイントへアクセス
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/v1/nodes?limit=50&offset=0'));

  if (response.statusCode == 200) {
    final data = json.decode(utf8.decode(response.bodyBytes));
    final List<dynamic> nodesJson = data['nodes'];
    return nodesJson.map((json) => EdgeNode.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load nodes from API (Status: ${response.statusCode})');
  }
});

// ====== UI画面 ======
class DashboardScreen extends HookConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // APIからデータを非同期で取得 (Riverpod)
    final nodesAsyncValue = ref.watch(nodesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('☁️ FinOps Cloud Asset Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(nodesProvider), // 手動リロード (最新のRiverpod構文)
          ),
        ],
      ),
      body: nodesAsyncValue.when(
        data: (nodes) => ListView.builder(
          itemCount: nodes.length,
          itemBuilder: (context, index) {
            final node = nodes[index];
            final isRunning = node.status == 'running';
            
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 4,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isRunning ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                  child: Icon(
                    isRunning ? Icons.cloud_done : Icons.cloud_off,
                    color: isRunning ? Colors.greenAccent : Colors.redAccent,
                  ),
                ),
                title: Text(node.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Region: ${node.region} | Status: ${node.status.toUpperCase()}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('\$${node.monthlyCostUsd.toStringAsFixed(2)} / mo', 
                      style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Book Val: \$${node.bookValueUsd.toStringAsFixed(0)}', 
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('API Error: $error\n\n(FastAPIが 127.0.0.1:8000 で起動しているか確認してください)', 
              style: const TextStyle(color: Colors.redAccent, fontSize: 16), textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:finops_api/api.dart';
import '../../providers/node_provider.dart';

class DashboardScreen extends HookConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // APIからデータを非同期で取得 (Riverpod AsyncNotifier)
    final nodesAsyncValue = ref.watch(nodeNotifierProvider);
    final scrollController = useScrollController();

    // スクロール検知による無限スクロールのトリガー
    useEffect(() {
      void onScroll() {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
          // 下端に近づいたら次のページをフェッチ
          ref.read(nodeNotifierProvider.notifier).fetchNextPage();
        }
      }
      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('☁️ FinOps Cloud Asset Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(nodeNotifierProvider),
          ),
        ],
      ),
      body: nodesAsyncValue.when(
        // 初回ローディング
        loading: () => const Center(child: CircularProgressIndicator()),
        
        // エラーハンドリング
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('API Error: $error\n\n(FastAPIが起動しているか確認してください)', 
              style: const TextStyle(color: Colors.redAccent, fontSize: 16), textAlign: TextAlign.center),
          ),
        ),
        
        // データ表示 (ローディング中も前回データを表示し続ける)
        data: (paginationState) {
          final nodes = paginationState.nodes;
          return ListView.builder(
            controller: scrollController,
            itemCount: nodes.length + (paginationState.hasNext ? 1 : 0),
            itemBuilder: (context, index) {
              // 最後のアイテムとしてローディングインジケーターを表示
              if (index == nodes.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final node = nodes[index];
              // node.status は Enum になっている
              final isRunning = node.status == NodeStatus.running;
              
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
                  subtitle: Text('Region: ${node.region} | Status: ${node.status?.value.toUpperCase()}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('\$${node.monthlyCostUsd?.toStringAsFixed(2)} / mo', 
                        style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Book Val: \$${node.bookValueUsd?.toStringAsFixed(0)}', 
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

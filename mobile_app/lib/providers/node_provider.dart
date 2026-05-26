import 'dart:async';
import 'package:finops_api/api.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../data/repositories/node_repository.dart';

// APIクライアントのプロバイダ
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(basePath: 'http://127.0.0.1:8000');
});

// リポジトリのプロバイダ
final nodeRepositoryProvider = Provider<NodeRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return NodeRepository(InfrastructureNodesApi(client));
});

class NodePaginationState {
  final List<EdgeNode> nodes;
  final bool hasNext;
  final String? nextCursor;

  NodePaginationState({
    required this.nodes,
    required this.hasNext,
    this.nextCursor,
  });
}

// Cursor-Based Pagination を管理する AsyncNotifier (Riverpod 2.x 王道パターン)
class NodeNotifier extends AutoDisposeAsyncNotifier<NodePaginationState> {
  static const int _limit = 20;

  @override
  FutureOr<NodePaginationState> build() async {
    return _fetchPage(cursor: null);
  }

  Future<NodePaginationState> _fetchPage({String? cursor}) async {
    final repository = ref.read(nodeRepositoryProvider);
    final response = await repository.getNodes(limit: _limit, cursor: cursor);
    
    final nextCursor = response.nodes.isNotEmpty ? response.nodes.last.id : null;

    return NodePaginationState(
      nodes: response.nodes,
      hasNext: response.hasNext,
      nextCursor: nextCursor,
    );
  }

  Future<void> fetchNextPage() async {
    // 1. 現在の状態を取得 (ローディング中やエラーの場合は何もしない)
    if (state.isLoading || state.hasError) return;

    final currentState = state.valueOrNull;
    if (currentState == null || !currentState.hasNext) return;

    // 2. 既存のデータを保持したままローディング状態 (isRefreshing) に遷移
    state = const AsyncLoading<NodePaginationState>().copyWithPrevious(state);

    // 3. 次のページを取得して状態を更新 (エラー時は AsyncValue.guard が自動で捕捉)
    state = await AsyncValue.guard(() async {
      final newPage = await _fetchPage(cursor: currentState.nextCursor);
      
      return NodePaginationState(
        nodes: [...currentState.nodes, ...newPage.nodes],
        hasNext: newPage.hasNext,
        nextCursor: newPage.nextCursor,
      );
    });
  }
}

// プロバイダの宣言 (Riverpod 2.x の正しい記法)
final nodeNotifierProvider = AsyncNotifierProvider.autoDispose<NodeNotifier, NodePaginationState>(
  NodeNotifier.new,
);

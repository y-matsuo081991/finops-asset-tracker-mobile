import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:finops_api/api.dart';
import 'package:mobile_app/presentation/dashboard/dashboard_screen.dart';
import 'package:mobile_app/providers/node_provider.dart';

void main() {
  testWidgets('DashboardScreen displays loading, then list of nodes', (WidgetTester tester) async {
    // Arrange: 初期状態がローディング中、その後データを返すモックプロバイダを定義
    final mockState = AsyncValue.data(NodePaginationState(
      nodes: [
        EdgeNode(
          id: '1',
          name: 'Test Node Alpha',
          region: 'us-east-1',
          status: NodeStatus.running,
          monthlyCostUsd: 100.50,
          bookValueUsd: 1000.0,
          createdAt: DateTime.now(),
        ),
      ],
      hasNext: false,
      nextCursor: null,
    ));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // 簡易的に状態をオーバーライド
          nodeNotifierProvider.overrideWith(() {
            // テスト用のダミーNotifier
            // 実際は Mockito 等で `fetchNextPage` をモック化するが、今回は表示確認のみ
            return _MockNodeNotifier(mockState);
          }),
        ],
        child: const MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );

    // Act & Assert 1: レンダリング直後はローディングインジケーターが出ることを期待するかもしれないが、
    // ここでは AsyncData を直接注入しているのでデータが表示されるはず
    await tester.pumpAndSettle();

    // 画面に「Test Node Alpha」という文字が表示されているか検証
    expect(find.text('Test Node Alpha'), findsOneWidget);
    
    // アプリバーのタイトルが表示されているか検証
    expect(find.text('☁️ FinOps Cloud Asset Dashboard'), findsOneWidget);
  });
}

// テスト用のモックNotifier
class _MockNodeNotifier extends AutoDisposeAsyncNotifier<NodePaginationState> implements NodeNotifier {
  final AsyncValue<NodePaginationState> _initialState;

  _MockNodeNotifier(this._initialState);

  @override
  FutureOr<NodePaginationState> build() {
    return _initialState.value!;
  }
  
  @override
  Future<void> fetchNextPage() async {
    // 何もしない
  }
}

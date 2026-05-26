import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_app/providers/node_provider.dart';
import 'package:mobile_app/data/repositories/node_repository.dart';
import 'package:finops_api/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MockNodeRepository implements NodeRepository {
  @override
  Future<NodeListResponse> getNodes({required int limit, String? cursor}) async {
    return NodeListResponse(
      totalCount: 2,
      nodes: [
        EdgeNode(
            id: '1',
            name: 'mock-1',
            region: 'us-east-1',
            status: NodeStatus.running,
            monthlyCostUsd: 100,
            bookValueUsd: 1000,
            createdAt: DateTime.now())
      ],
      hasNext: true,
    );
  }
}

void main() {
  setUpAll(() async {
    // テスト用にダミーの環境変数をロード
    dotenv.testLoad(fileInput: '''API_BASE_URL=http://localhost:8000''');
  });

  test('NodeNotifier initializes with AsyncData containing the first page', () async {
    // Arrange
    final container = ProviderContainer(
      overrides: [
        nodeRepositoryProvider.overrideWithValue(MockNodeRepository()),
      ],
    );
    addTearDown(container.dispose);

    // Act
    // FutureProviderやAsyncNotifierは読み込み完了まで待つ必要がある
    final state = await container.read(nodeNotifierProvider.future);

    // Assert
    expect(state.nodes.length, 1);
    expect(state.hasNext, true);
    expect(state.nextCursor, '1');
  });
}

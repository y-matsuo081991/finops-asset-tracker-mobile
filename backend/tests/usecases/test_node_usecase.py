import pytest
from typing import List, Tuple
from app.usecases.node_usecase import NodeUseCase
from app.domain.models import NodeListResponse, EdgeNode, NodeStatus
from datetime import datetime


class MockNodeRepository:
    """
    ユースケース層のテストのためのモックリポジトリ（DBやFakerを介さない）
    """

    async def get_nodes(self, limit: int, offset: int) -> Tuple[List[EdgeNode], int]:
        # テスト用のダミーデータ（2件）
        dummy_nodes = [
            EdgeNode(
                id="test-id-1",
                name="test-node-1",
                region="us-east-1",
                status=NodeStatus.RUNNING,
                monthly_cost_usd=100.0,
                book_value_usd=1000.0,
                created_at=datetime.now(),
            ),
            EdgeNode(
                id="test-id-2",
                name="test-node-2",
                region="us-east-1",
                status=NodeStatus.STOPPED,
                monthly_cost_usd=50.0,
                book_value_usd=500.0,
                created_at=datetime.now(),
            ),
        ]
        # offsetが0なら2件返す、それ以外は空を返す（簡易シミュレーション）
        if offset == 0:
            return dummy_nodes[:limit], 2
        return [], 2


@pytest.mark.asyncio
async def test_get_nodes_pagination_usecase():
    """
    [GREEN] ユースケースがモックリポジトリと連携し、
    正しく NodeListResponse を生成・返却することを検証する。
    """
    # Arrange: 依存性の注入 (Mock Repository)
    mock_repo = MockNodeRepository()
    usecase = NodeUseCase(node_repository=mock_repo)

    # Act: limit=1, offset=0 で取得
    result = await usecase.get_nodes(limit=1, offset=0)

    # Assert
    assert isinstance(result, NodeListResponse)
    assert result.total_count == 2
    assert len(result.nodes) == 1
    assert result.nodes[0].name == "test-node-1"
    assert result.has_next is True  # 1件取得で全2件なので次があるはず


@pytest.mark.asyncio
async def test_get_nodes_pagination_no_next():
    """
    [GREEN] 最後のページまで取得した場合、has_next が False になることを検証。
    """
    mock_repo = MockNodeRepository()
    usecase = NodeUseCase(node_repository=mock_repo)

    # limit=5, offset=0 で2件すべて取得
    result = await usecase.get_nodes(limit=5, offset=0)

    assert result.total_count == 2
    assert len(result.nodes) == 2
    assert result.has_next is False

import pytest
from typing import List, Tuple
from app.usecases.node_usecase import NodeUseCase
from app.domain.models import NodeListResponse, EdgeNode, NodeStatus
from datetime import datetime
from typing import List, Tuple, Optional


class MockNodeRepository:
    """
    ユースケース層のテストのためのモックリポジトリ（DBやFakerを介さない）
    """

    async def get_nodes(
        self, limit: int, cursor: Optional[str] = None
    ) -> Tuple[List[EdgeNode], int]:
        # テスト用のダミーデータ（3件）
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
            EdgeNode(
                id="test-id-3",
                name="test-node-3",
                region="us-east-1",
                status=NodeStatus.RUNNING,
                monthly_cost_usd=10.0,
                book_value_usd=100.0,
                created_at=datetime.now(),
            ),
        ]

        start_idx = 0
        if cursor:
            # カーソル（ID）に一致する要素の次のインデックスを見つける
            for i, node in enumerate(dummy_nodes):
                if node.id == cursor:
                    start_idx = i + 1
                    break

        return dummy_nodes[start_idx : start_idx + limit], 3


@pytest.mark.asyncio
async def test_get_nodes_pagination_usecase():
    """
    [GREEN] ユースケースがモックリポジトリと連携し、
    正しく NodeListResponse を生成・返却することを検証する。
    """
    mock_repo = MockNodeRepository()
    usecase = NodeUseCase(node_repository=mock_repo)

    # Act: 初回リクエスト (cursorなし) で2件取得
    result = await usecase.get_nodes(limit=2, cursor=None)

    # Assert
    assert isinstance(result, NodeListResponse)
    assert result.total_count == 3
    assert len(result.nodes) == 2
    assert result.nodes[0].name == "test-node-1"
    assert result.has_next is True

    # Act: 2回目のリクエスト (cursorあり) で残り1件を取得
    next_cursor = result.nodes[-1].id  # 最後の要素のIDをカーソルにする
    result_page2 = await usecase.get_nodes(limit=2, cursor=next_cursor)

    assert len(result_page2.nodes) == 1
    assert result_page2.nodes[0].name == "test-node-3"
    assert result_page2.has_next is False


@pytest.mark.asyncio
async def test_get_nodes_pagination_no_next():
    """
    [GREEN] 最後のページまで取得した場合、has_next が False になることを検証。
    """
    mock_repo = MockNodeRepository()
    usecase = NodeUseCase(node_repository=mock_repo)

    # limit=5 で3件すべてを一度に取得
    result = await usecase.get_nodes(limit=5, cursor=None)

    assert result.total_count == 3
    assert len(result.nodes) == 3
    assert result.has_next is False

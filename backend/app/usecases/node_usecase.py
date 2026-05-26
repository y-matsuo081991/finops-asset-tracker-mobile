from typing import Optional
from app.domain.models import NodeListResponse
from app.interfaces.repositories.node_repository import NodeRepository


class NodeUseCase:
    """
    アプリケーション固有のビジネスルール（ユースケース）をカプセル化する層。
    ドメイン層（models.py）に依存し、インフラ層からは独立する。
    """

    def __init__(self, node_repository: NodeRepository):
        self._repo = node_repository

    async def get_nodes(self, limit: int, offset: int) -> NodeListResponse:
        """
        ページネーションに基づいてノード一覧を取得し、レスポンスモデルに変換して返す。
        """
        nodes, total_count = await self._repo.get_nodes(limit=limit, offset=offset)

        # ページネーションのロジック（has_nextの計算等）はユースケース層の責任
        has_next = (offset + limit) < total_count

        return NodeListResponse(total_count=total_count, nodes=nodes, has_next=has_next)

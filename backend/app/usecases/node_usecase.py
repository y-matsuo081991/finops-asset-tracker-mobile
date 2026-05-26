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

    async def get_nodes(
        self, limit: int, cursor: Optional[str] = None
    ) -> NodeListResponse:
        """
        ページネーションに基づいてノード一覧を取得し、レスポンスモデルに変換して返す。
        カーソルベースのページネーションを使用。
        """
        nodes, total_count = await self._repo.get_nodes(limit=limit, cursor=cursor)

        # カーソルベースの場合、要求したlimit件数と等しいデータが取得できた場合は
        # おそらく次のページがあると判定する（厳密には DB 側で limit+1 件取得して判定するのがベスト）
        has_next = len(nodes) == limit

        return NodeListResponse(total_count=total_count, nodes=nodes, has_next=has_next)

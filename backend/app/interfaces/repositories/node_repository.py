from typing import Protocol, List, Tuple, Optional
from app.domain.models import EdgeNode


class NodeRepository(Protocol):
    """
    データアクセス層（インフラストラクチャ）との境界を定義するインターフェース。
    Clean Architecture の Dependency Inversion Principle (DIP) を実現する。
    """

    async def get_nodes(
        self, limit: int, cursor: Optional[str] = None
    ) -> Tuple[List[EdgeNode], int]:
        """
        ノードのリストと、ページネーション用の全体件数を返す。
        戻り値: (ノードのリスト, 全体件数)
        """
        ...

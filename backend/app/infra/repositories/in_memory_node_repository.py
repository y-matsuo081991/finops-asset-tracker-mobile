from typing import List, Tuple
from app.domain.models import EdgeNode
from app.interfaces.repositories.node_repository import NodeRepository
from app.infra.generators.mock_data import generate_mock_nodes

# アプリケーション起動時に一度だけ生成してメモリに保持する
_IN_MEMORY_DB = generate_mock_nodes(count=105)


class InMemoryNodeRepository:
    """
    インフラストラクチャ層の実装。
    データベースの代わりにインメモリのモックデータ（Faker）を使用する。
    NodeRepository プロトコルを満たす。
    """

    async def get_nodes(self, limit: int, offset: int) -> Tuple[List[EdgeNode], int]:
        total = len(_IN_MEMORY_DB)
        paginated_nodes = _IN_MEMORY_DB[offset : offset + limit]
        return paginated_nodes, total


def get_node_repository() -> NodeRepository:
    """
    Dependency Injection 用のプロバイダ関数。
    後日DBに変更する際は、この関数の戻り値を SQLNodeRepository() 等に変更するだけで済む。
    """
    return InMemoryNodeRepository()

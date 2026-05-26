from fastapi import APIRouter, Query
from app.domain.models import NodeListResponse
from app.infra.generators.mock_data import generate_mock_nodes

router = APIRouter(prefix="/nodes", tags=["Infrastructure Nodes"])

# 初期化時にダミーデータをメモリに保持（モックデータベースの代わり）
MOCK_DB = generate_mock_nodes(count=105)

@router.get("", response_model=NodeListResponse, summary="インフラノード一覧の取得 (ページネーション対応)")
async def get_nodes(
    limit: int = Query(20, ge=1, le=50, description="取得件数"),
    offset: int = Query(0, ge=0, description="取得開始位置")
):
    """
    架空のクラウドサーバー（EdgeNode）のリストとコスト情報を取得します。
    パフォーマンス要件（スケーラビリティ）を満たすため、ページネーションを実装しています。
    """
    total = len(MOCK_DB)
    paginated_nodes = MOCK_DB[offset : offset + limit]
    
    return NodeListResponse(
        total_count=total,
        nodes=paginated_nodes,
        has_next=(offset + limit) < total
    )

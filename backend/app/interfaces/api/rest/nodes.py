from fastapi import APIRouter, Query, Depends
from app.domain.models import NodeListResponse
from app.usecases.node_usecase import NodeUseCase
from app.infra.repositories.in_memory_node_repository import get_node_repository
from app.interfaces.repositories.node_repository import NodeRepository

router = APIRouter(prefix="/nodes", tags=["Infrastructure Nodes"])


def get_node_usecase(
    repo: NodeRepository = Depends(get_node_repository),
) -> NodeUseCase:
    """
    Dependency Injection 用のプロバイダ。
    FastAPI の Depends を用いて UseCase インスタンスを生成する。
    """
    return NodeUseCase(node_repository=repo)


@router.get(
    "",
    response_model=NodeListResponse,
    summary="インフラノード一覧の取得 (ページネーション対応)",
)
async def get_nodes(
    limit: int = Query(20, ge=1, le=50, description="取得件数"),
    offset: int = Query(0, ge=0, description="取得開始位置"),
    usecase: NodeUseCase = Depends(get_node_usecase),
):
    """
    架空のクラウドサーバー（EdgeNode）のリストとコスト情報を取得します。
    Clean Architecture に基づき、UseCase 層に移譲しています。
    """
    return await usecase.get_nodes(limit=limit, offset=offset)

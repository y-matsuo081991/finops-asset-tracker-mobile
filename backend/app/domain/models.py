from datetime import datetime
from enum import Enum
from pydantic import BaseModel, Field

class NodeStatus(str, Enum):
    RUNNING = "running"
    STOPPED = "stopped"
    MAINTENANCE = "maintenance"

class EdgeNode(BaseModel):
    """
    クラウドインフラやエッジデバイスを表すドメインモデル（NDA遵守のため抽象化）
    """
    id: str = Field(..., description="一意のノードID")
    name: str = Field(..., description="ノード（サーバー）名")
    region: str = Field(..., description="配置されているリージョン")
    status: NodeStatus = Field(..., description="稼働状況")
    monthly_cost_usd: float = Field(..., description="今月の推定クラウドコスト（USD）")
    book_value_usd: float = Field(..., description="ソフトウェア/ハードウェアの帳簿価格（USD）")
    created_at: datetime = Field(..., description="プロビジョニング日時")

class NodeListResponse(BaseModel):
    """
    APIレスポンス用モデル（スケーラビリティ要件を満たすためのページネーション基礎）
    """
    total_count: int = Field(..., description="総ノード数")
    nodes: list[EdgeNode] = Field(..., description="ノードのリスト")
    has_next: bool = Field(default=False, description="次のページが存在するか")

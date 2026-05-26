from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)


def test_health_check():
    """
    ヘルスチェックエンドポイントが正しく動作することを確認する
    """
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {
        "status": "healthy",
        "message": "FinOps Asset Tracker API is running.",
    }


def test_get_nodes_pagination():
    """
    ノード一覧APIが正しいページネーション（limit/cursor）で動作することを確認する
    """
    # limit=5, cursor=None でリクエスト
    response = client.get("/api/v1/nodes?limit=5")
    assert response.status_code == 200

    data = response.json()
    assert "total_count" in data
    assert "nodes" in data
    assert "has_next" in data

    # 件数の検証
    assert len(data["nodes"]) == 5
    assert data["has_next"] is True

    # データ構造の検証（NDA遵守・抽象化されたモデルか）
    first_node = data["nodes"][0]
    assert "id" in first_node
    assert "name" in first_node
    assert "monthly_cost_usd" in first_node
    assert "book_value_usd" in first_node
    assert "status" in first_node

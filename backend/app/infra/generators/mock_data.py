from faker import Faker
from app.domain.models import EdgeNode, NodeStatus
import random

fake = Faker()
Faker.seed(42) # データの一貫性を保つための固定シード

def generate_mock_nodes(count: int = 20) -> list[EdgeNode]:
    """
    Fakerを用いて、NDAに抵触しない架空のクラウドインフラデータを生成する
    """
    nodes = []
    regions = ["us-east-1", "us-west-2", "eu-central-1", "ap-northeast-1", "ap-southeast-2"]
    
    for _ in range(count):
        # ランダムなコストと簿価（FinOpsダッシュボードで映える数値）
        monthly_cost = round(random.uniform(50.0, 2500.0), 2)
        book_value = round(random.uniform(1000.0, 50000.0), 2)
        
        node = EdgeNode(
            id=fake.uuid4(),
            name=f"node-{fake.word()}-{fake.pyint(min_value=10, max_value=99)}",
            region=random.choice(regions),
            status=random.choices(list(NodeStatus), weights=[0.7, 0.2, 0.1])[0], # 7割が稼働中
            monthly_cost_usd=monthly_cost,
            book_value_usd=book_value,
            created_at=fake.date_time_between(start_date="-2y", end_date="now")
        )
        nodes.append(node)
    
    # コストが高い順にソート（ダッシュボードで見栄えが良いため）
    return sorted(nodes, key=lambda x: x.monthly_cost_usd, reverse=True)

---
title: "ADR 006: フェーズ3におけるアーキテクチャ拡張計画 (データ可視化とCD)"
description: "FinOpsダッシュボードとしての価値を最大化するための将来のUI拡張およびクラウドデプロイ方針"
---

# ADR 006: フェーズ3におけるアーキテクチャ拡張計画 (データ可視化とCD)

- **Date:** 2026-05-27
- **Status:** Proposed (提案段階)
- **Context (背景):**
  フェーズ2までの開発により、本プロジェクトは Clean Architecture、Schema-Driven Development、Cursor-Based Pagination、そして CI（継続的インテグレーション）を備えた「プロダクションレディ」な基盤を確立した。
  しかし、「FinOps（クラウドコスト最適化）」というビジネス上の目的をユーザー（IT管理者やCTO）に直感的に伝えるためには、単なるデータのリスト表示だけでなく、視覚的なインサイト（グラフ等）の提供が必要である。
  さらに、技術ポートフォリオとして完成させるためには、CIでビルドしたコンテナを実際にクラウド環境で稼働させ、Live Demoとして公開する CD（継続的デプロイ）の仕組みが欠かせない。

- **Decision (決定事項/今後の実装方針):**
  次期フェーズ（フェーズ3）において、以下の2つの主要なアーキテクチャ拡張を実施することを計画する。

  1. **Data Visualization (データ可視化 UI層の拡張):**
     - Flutter 側のエコシステムにおいてデファクトスタンダードである `fl_chart` パッケージを導入する。
     - ダッシュボード（`DashboardScreen`）の上部に、取得したインフラ資産データ（`EdgeNode`）を集計した「リージョン別のコスト割合（円グラフ）」や「ステータス別の稼働状況（バーチャート）」を配置する。
     - バックエンド側に集計用のエンドポイント（`/api/v1/nodes/summary`等）を新設するか、フロントエンドの Riverpod 内で取得済みデータをクライアントサイドで集計（Aggregations）するかのトレードオフを今後検証する。

  2. **Continuous Deployment (CD) と Cloud Run へのデプロイ:**
     - 運用コストを最小化（Scale-to-Zero）しつつ、コンテナ化された FastAPI を本番稼働させるため、**Google Cloud Run (GCP)** をデプロイ先として選定する。
     - GitHub Actions のワークフロー（`ci.yml`）を拡張し、テストとビルド（CI）が成功した後に、Google Cloud へ認証（Workload Identity Federation を推奨）し、Artifact Registry へのイメージプッシュと Cloud Run へのデプロイを自動化する。

- **Consequences (期待される結果と影響):**
  - **メリット:** 
    - UIの表現力が向上し、FinOpsダッシュボードとしての説得力（プロダクト価値）が大幅に向上する。
    - 完全な CI/CD パイプラインが完成し、実際のインフラ運用（DevOps）スキルを証明できる。
  - **リスク・制約事項:**
    - UI側にグラフ描画処理が加わることで、レンダリングパフォーマンスへの影響を考慮する必要がある。
    - Cloud Run の無料枠（Free Tier）を利用するものの、GCPアカウントへのクレジットカード登録と予算アラートの設定が運用上必須となる。

- **References (参考資料):**
  - fl_chart Official Documentation
  - Deploy to Cloud Run from GitHub Actions (Google Cloud Docs)

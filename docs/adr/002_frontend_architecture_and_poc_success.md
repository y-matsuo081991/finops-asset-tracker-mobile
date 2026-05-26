# ADR 002: フロントエンド(Flutter)のアーキテクチャと技術的実現性の証明(PoC)

- **Date:** 2026-05-26
- **Status:** Accepted
- **Context (背景):**
  本プロジェクト（FinOps Asset Tracker）において、バックエンド（FastAPI）で構築したダミーデータ生成APIを、フロントエンドのモバイルアプリとしてどのように消費・描画するかを決定する必要があった。
  また、本アプリはポートフォリオとしての価値を最大化するため、「モダンな状態管理」と「APIとの疎結合（Schema-Drivenを前提とした設計）」を両立する必要があった。

- **Decision (決定事項):**

  **1. 状態管理に `hooks_riverpod` を採用**
  Flutterの標準的な状態管理手法として、Providerの弱点を克服した `Riverpod`（および `flutter_hooks`）を採用する。これにより、UIコンポーネント（Widget）とビジネスロジック・非同期データ取得（FutureProvider）を完全に分離する。

  **2. 技術的実現性 (Technical Feasibility) の証明完了**
  初期フェーズとして、以下のフローがローカル環境（Windowsデスクトップビルド）で正常に動作することを実証した。
  - FastAPIが起動し、`Faker` で生成された105件のクラウド資産データ（EdgeNode）をJSONとして提供。
  - Flutterアプリが `http` パッケージを用いてAPI (`GET /api/v1/nodes`) をコール。
  - `FutureProvider` が非同期にデータをパースし、Flutterの `ListView.builder` を用いて、稼働ステータスやコストをダークテーマのダッシュボードとしてリアルタイム描画。

- **Consequences (結果と影響):**
  - **ポジティブな影響:** 
    - フロントエンドとバックエンドの通信基盤が確立され、PoC（概念実証）としての最大のハードルをクリアした。
    - Riverpodを採用したことで、今後の拡張（無限スクロールや検索フィルタリング）を副作用なく安全に実装できる土台が整った。
  - **今後の課題 (Next Steps):**
    - 現在は初期の20件（または50件）を取得しているのみであるため、`ListView` のスクロールイベントを検知し、`offset` をインクリメントして追加データを取得する「ページネーション（無限スクロール）」の実装が必要である。
    - 取得したデータを視覚的にサマリー化するチャート（グラフ）コンポーネントの導入を検討する。

- **References (参考資料):**
  - [Riverpod Official Documentation](https://riverpod.dev/)

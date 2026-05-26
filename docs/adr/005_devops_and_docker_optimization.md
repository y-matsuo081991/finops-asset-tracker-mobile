---
title: "ADR 005: DevOps基盤の構築とメモリ最適化Docker戦略"
description: "PoCにおけるインフラコスト最小化と、GitHub Actionsを用いたプロダクションレディなCIパイプラインの導入"
---

# ADR 005: DevOps基盤の構築とメモリ最適化Docker戦略

- **Date:** 2026-05-27
- **Status:** Accepted
- **Context (背景):**
  フロントエンドおよびバックエンドのアーキテクチャ改修（ADR 004）が完了し、アプリケーションはプロダクションレディな状態となった。
  しかし、本プロジェクトは「FinOps（クラウドコスト最適化）」をテーマとしたポートフォリオであるため、バックエンドのコンテナ（Docker）自体も無駄なメモリやコンピュート資源を消費しないエコな設計であることが求められた。
  また、手動でのテスト実行から脱却し、CI/CDパイプラインを構築して継続的インテグレーションを証明する必要があった。

- **Decision (決定事項):**
  インフラストラクチャおよびDevOps領域において、以下の決定を行った。

  1. **メモリフットプリントを極小化する Docker 戦略:**
     - フルサイズのPythonイメージではなく、`python:3.11-slim` を採用。
     - **Multi-stage Build:** 依存関係のインストール層（Builder）と実行層を完全に分離し、最終イメージからコンパイラ（gcc等）を排除。
     - **Gunicorn `--preload`:** Uvicornワーカー起動時に Copy-on-Write (CoW) を活用してメモリ空間を共有し、複数ワーカー実行時のRAM消費量を30〜50%削減する設計を採用した。

  2. **環境変数 (`.env`) の分離と CI 上での動的生成:**
     - セキュリティの観点から `.env` をリポジトリに含めない（`.gitignore`）標準プラクティスを採用。
     - Flutterのビルド仕様（アセットとして物理ファイルが必要）を回避するため、GitHub Actionsのステップ内で `echo` コマンドを用いて動的にダミーの `.env` を生成するワークフローを構築した。

  3. **安定性重視の CI パイプライン (GitHub Actions):**
     - 最新機能の追従よりもパイプラインの安定性を重視。Flutterのチャネルは `stable` に固定し、それに伴い `flutter_lints` を最新版（^6.0.0）から Dart 3.5.0 と互換性のある `^4.0.0` へ意図的にダウングレードした（未来のSDKを要求してCIがクラッシュするのを防ぐため）。
     - Pytest実行時は `python -m pytest` を用いてモジュールパス（`PYTHONPATH`）解決エラーを回避した。

- **Consequences (結果と影響):**
  - **メリット:** 
    - メモリ制限の厳しい無料枠（Cloud Run や Render）にデプロイしても、OOM (Out Of Memory) キラーに落とされにくい、堅牢でエコなコンテナが完成した。
    - プッシュのたびに自動で Linter, Pytest, Flutter Test, Docker Build が実行され、常に GREEN 状態が保証される DevOps 基盤が確立した。
  - **デメリット（トレードオフ）:**
    - CI環境特有の罠（環境変数の物理ファイル制約や、SDKバージョン不整合）に対処するため、ワークフローファイル（`ci.yml`）の設定がやや複雑化した。

- **References (参考資料):**
  - Gunicorn Preload Best Practices (2025)
  - GitHub Actions for Flutter & dotenv

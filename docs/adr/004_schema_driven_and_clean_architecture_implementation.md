---
title: "ADR 004: Schema-Driven Development と フロントエンドの Clean Architecture 化"
description: "openapi-generator を用いた型安全な自動生成と、Riverpod AsyncNotifier によるページネーションの標準化"
---

# ADR 004: Schema-Driven Development と フロントエンドの Clean Architecture 化

- **Date:** 2026-05-27
- **Status:** Accepted
- **Context (背景):**
  ADR 002 にて初期PoCとして Flutter と FastAPI の連携は成功したが、フロントエンド（`main.dart`）にすべてのドメインモデル（`EdgeNode`）や API 通信処理がハードコードされており、モノリシックな状態であった。
  また、ADR 003 にてフェーズ2の最優先事項とされた「Cursor-Based Pagination」を実装するにあたり、手動での JSON パースや古い状態管理（`ChangeNotifier` 等）を用い続けることは、世界標準のポートフォリオとして「Architecture Drift（設計の乖離）」を引き起こすリスクがあった。

- **Decision (決定事項):**
  本プロジェクトをプロダクションレディな品質に引き上げるため、以下のアーキテクチャ変更を決定・実施した。

  1. **Schema-Driven Development の導入:**
     - FastAPI から出力される `openapi.json` を SSOT (Single Source of Truth) とし、`@openapitools/openapi-generator-cli` を用いて Dart の API クライアントおよびモデル群を完全自動生成する。
     - これにより、フロントエンド側での手動の JSON パース処理を廃止し、API Drift を完全に防ぐ。

  2. **フロントエンドの Clean Architecture 分割:**
     - `main.dart` の責務を分割し、`lib/data/repositories` (API通信のラップ)、`lib/providers` (Riverpod 状態管理)、`lib/presentation` (UI) の3層構造へリファクタリングした。

  3. **Riverpod 2.x の王道パターンによる無限スクロール:**
     - 妥協的な `ChangeNotifier` パターンを避け、Riverpod 2.x 以降の世界標準である **`AutoDisposeAsyncNotifier`** を採用した。
     - ページネーションの追加読み込み（`fetchNextPage`）時において、`state = const AsyncLoading().copyWithPrevious(state)` を用いることで、UI側で「既存のリストを表示したまま下部にローディングスピナーを出す」UXを堅牢に実装した。
     - 例外処理は `AsyncValue.guard()` を用いて自動ハンドリングする。

  **【変更後のアーキテクチャ図】**
  ```mermaid
  graph TD
      classDef mobile fill:#e1f5fe,stroke:#0288d1,stroke-width:2px;
      classDef auto fill:#f3e5f5,stroke:#388e3c,stroke-width:2px;
      
      subgraph Frontend Clean Architecture
          UI["Presentation Layer\n(DashboardScreen)"]:::mobile
          STATE["Provider Layer\n(NodeNotifier : AsyncNotifier)"]:::mobile
          REPO["Data Layer\n(NodeRepository)"]:::mobile
          CLIENT["Auto-Generated API Client\n(openapi-generator)"]:::auto
          
          UI -->|"watch/read"| STATE
          STATE -->|"getNodes(cursor)"| REPO
          REPO -->|"API Call"| CLIENT
      end
  ```

- **Consequences (結果と影響):**
  - **メリット:** 
    - 非常に高い型安全性とスケーラビリティを獲得した。バックエンドの仕様変更に対して、自動生成コマンドを再実行するだけでコンパイルエラーとして検知できるようになった。
    - Riverpod のモダンなベストプラクティスを証明するリファレンス実装となった。
  - **デメリット（トレードオフ）:**
    - `openapi-generator-cli` を実行するため、開発者のローカル環境に **Java 17 以上** のインストールが必須となった（開発環境の依存追加）。

- **References (参考資料):**
  - Riverpod Official Documentation (AsyncNotifier, AsyncValue.guard)
  - OpenAPI Generator Dart Client Guidelines

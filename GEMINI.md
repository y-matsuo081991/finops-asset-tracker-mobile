# プロジェクト概要: FinOps Asset Tracker Mobile

本プロジェクトは、グローバル標準のアーキテクチャ（Flutter × FastAPI × Clean Architecture）を用いた、クラウド資産およびFinOps管理のモバイルダッシュボードのPoC（概念実証）ポートフォリオです。

## 🛡️ 【最重要】NDA遵守とデータ抽象化の絶対ルール (Anti-Leak Policy)
本リポジトリは公開ポートフォリオとして使用される前提であるため、以下の機密保持（NDA）ルールをすべてのコード・ドキュメント生成において絶対に遵守すること。

1. **ドメインの完全抽象化 (White-labeling):**
   - 過去の所属企業や特定の業界、実在の社内システム名・アーキテクチャを推測できる変数名、コメント、ドキュメントの記述を**一切禁止する**。
   - すべてのドメインモデルは、汎用的なITインフラ用語（例: `EdgeNode`, `CloudInstance`, `Region`, `CostAllocation` 等）に置換して実装すること。
2. **合成データ (Synthetic Data) の強制:**
   - 本物のコストデータやサーバーIP等の実データは絶対に使用・ハードコードしない。
   - 開発およびテスト用のデータはすべて `Faker` 等のライブラリを用いた架空の合成データジェネレーターによって生成すること（例: 架空の企業名 `ACME Corp` 等）。
3. **機械的防御とシークレットの排除 (Shift-Left Security):**
   - APIキー等の機密情報はすべて `.env` 管理とする。
   - 人間の注意力に依存せず、Git Hooks (`pre-commit`) 等を導入し、禁止キーワードやハードコードされた認証情報がコミット差分に含まれていた場合に機械的にブロックする防衛網を構築すること。

## 🏗️ アーキテクチャと技術スタック (Global Standard)
- **Frontend (Mobile):** Flutter (Dart)
  - 状態管理: Riverpod または BLoC
- **Backend (API):** Python (FastAPI)
  - アーキテクチャ: Clean Architecture (Domain-Driven Designに基づく層分離)
- **API通信:** gRPC または REST (OpenAPI)
- **Infrastructure:** Docker, Google Cloud Run (Free Tier前提のサーバーレス運用)

## 🎯 非機能要件 (NFR) および開発標準

1. **テスト戦略とQA自動化 (Testing Trophy):**
   - **Backend:** Clean Architectureの利点を活かし、ドメイン層・ユースケース層はインフラ（DB等）から完全にモック化した状態で、`Pytest` を用いた TDD (Test-Driven Development) を徹底すること。
   - Frontend: ビジネスロジックを持つWidgetやProviderに対してテストを記述し、UIの安定性を担保すること。
   2. **Schema-Driven Development の自動化:**
   - フロントエンドとバックエンドの仕様ズレを防ぐため、FastAPIの OpenAPI Schema を正として、Flutter側の型定義およびAPIクライアントコードをツール（`openapi-generator` 等）を用いて自動生成するパイプラインを確立すること。
   3. **データスケーラビリティとUX保護 (Pagination):**
   - Faker等で大量のダミーデータを生成・取得する一覧系APIにおいては、必ず **ページネーション (Cursor/Offset-based)** を実装すること。モバイルフロントエンド側は無限スクロールを用いて、メモリ圧迫やUIフリーズを防ぐ設計とすること。

   ## ⚠️ 4. Frontend (Flutter) 実装の絶対ルールと罠 (Architecture Drift Prevention)
   *   **ALWAYS [Riverpod 2.x Pagination]:** 無限スクロール（ページネーション）を実装する際は、古い `ChangeNotifier` などの妥協的なパターンを絶対に使ってはならない。必ず Riverpod の王道パターンである **`AutoDisposeAsyncNotifier` と `AsyncValue.guard`, `copyWithPrevious`** を使用すること。
   *   **NEVER [Riverpod Import Trap]:** `AutoDisposeAsyncNotifier` で `state` や `ref` が「見つからない」という連鎖エラーが起きた場合、パッケージのバージョン（例: `hooks_riverpod` が古すぎないか）や、Providerのジェネリクス指定 (`AsyncNotifierProvider.autoDispose<Notifier, State>(Notifier.new)`) を間違えている可能性が高い。エラーが出たからといって、絶対に諦めて別の古いパターンに逃げてはならない。
   *   **ALWAYS [OpenAPI Generator]:** `openapi-generator-cli` は **Java 17 以上** に依存している。実行時に `UnsupportedClassVersionError` が出た場合は、ローカルの Java バージョン（PATH）が正しくセットされているかを必ず確認すること。

   ## ⚠️ 5. CI/CD Pipeline の絶対ルールと罠 (DevOps Gotchas)
   *   **ALWAYS [Pytest PYTHONPATH]:** GitHub Actions などの Linux 環境で Pytest を実行する際、カレントディレクトリがパスに含まれず `ModuleNotFoundError: No module named 'app'` が発生する。必ず `pytest tests/` ではなく **`python -m pytest tests/`** を使用して実行すること。
   *   **NEVER [Flutter SDK Version Trap]:** CI (`subosito/flutter-action`) の設定で `channel: stable` を指定している場合、`pubspec.yaml` の `flutter_lints` のバージョンを無闇に最新（例: `^6.0.0`）にしてはならない。最新のLintは、まだStableに降りてきていない未来の Dart SDK（例: `^3.8.0`）を要求してしまい、CIでの依存関係解決 (`pub get`) がクラッシュする原因となる。常に安定板のSDKと互換性のあるバージョン（例: `^4.0.0`）を維持すること。

# Flutter 最短セットアップガイド (Windows版)

本ガイドは、`finops-asset-tracker-mobile` プロジェクトのフロントエンド開発を開始するために、Windows環境へ最短でFlutter SDKを導入するための手順です。

---

## 🚀 Step 1: Flutter SDK のダウンロードと配置

1. **ダウンロード:**
   公式のダウンロードページから、最新の Windows 用 `.zip` ファイルをダウンロードします。
   👉 [Flutter Windows SDK ダウンロード](https://docs.flutter.dev/get-started/install/windows/download)

2. **展開（解凍）と配置:**
   ダウンロードした `.zip` を解凍し、中身の `flutter` フォルダを `C:\src\flutter` などのパスに配置します。
   *(※注意: `C:\Program Files\` のような高い権限が要求される場所や、パスに日本語・スペースが含まれる場所は避けてください)*

## 🔗 Step 2: 環境変数（Path）を通す

1. Windowsのスタートメニューで「環境変数」と検索し、「システム環境変数の編集」を開きます。
2. 「環境変数」ボタンをクリックし、**ユーザー環境変数** の中にある `Path` を選択して「編集」をクリックします。
3. 「新規」をクリックし、先ほど配置したFlutterの `bin` フォルダのパスを追加します。
   - 例: `C:\src\flutter\bin`
4. すべてのウィンドウを「OK」で閉じます。

## 🩺 Step 3: インストール状態の診断 (flutter doctor)

PowerShell（またはコマンドプロンプト）を**新しく開き直し**、以下のコマンドを実行します。

```powershell
flutter doctor
```

このコマンドは、Flutterの開発に必要なツールが揃っているかを自動で診断し、不足しているものをリストアップしてくれます。

---

## 🛠️ Step 4: 不足ツールの補完 (Android Studio / Visual Studio)

`flutter doctor` の結果、赤い `[X]` が出ている項目を潰していきます。モバイルアプリ開発のためには、主に以下のどちらか（または両方）の準備が必要です。

### A. Androidアプリとして動かしたい場合 (必須級)
1. **Android Studio のインストール:**
   👉 [Android Studio ダウンロード](https://developer.android.com/studio)
2. インストール後、起動して初期セットアップ（SDK等のダウンロード）を済ませます。
3. PowerShellで以下のコマンドを実行し、Androidライセンスに同意します（`y` を連打）。
   ```powershell
   flutter doctor --android-licenses
   ```

### B. Windowsデスクトップアプリとして動かしたい場合 (手軽な検証用)
スマホエミュレータを立ち上げず、Windowsのネイティブアプリとしてサクッと画面の検証を行いたい場合は、**Visual Studio** (VS Codeではなく) の C++ ワークロードが必要です。
1. 👉 [Visual Studio ダウンロード](https://visualstudio.microsoft.com/ja/downloads/) (Community版でOK)
2. インストーラーで「C++ によるデスクトップ開発」にチェックを入れてインストールします。

---

## 🎉 Step 5: セットアップ完了の確認

再度 `flutter doctor` を実行し、主要な項目（Flutter, Android toolchain 等）に緑の `[✓]` がついていれば準備完了です！
（※VS Codeの拡張機能に関する警告などは、適宜エディタからインストールしてください）

準備が完了したら、AI（Gemini CLI）に以下のように伝えてください。
> **「Flutterのインストールが終わったので、mobile_app の初期化を始めて」**

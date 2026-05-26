# Stage 1: Builder (依存関係のインストールのみを行い、ビルドツールを切り離す)
FROM python:3.11-slim AS builder

WORKDIR /app

# コンパイルに必要な軽量パッケージをインストール (C拡張モジュール対策)
RUN apt-get update && apt-get install -y --no-install-recommends gcc && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
# --user を指定してローカルディレクトリにインストールし、イメージサイズを削減
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Runtime (実行用・極小フットプリント)
FROM python:3.11-slim

WORKDIR /app

# セキュリティ対策: 非rootユーザーを作成
RUN useradd -m -s /bin/bash appuser

# builderステージでインストールされたパッケージのみをコピー
COPY --from=builder /root/.local /home/appuser/.local

# ソースコードのコピー
COPY ./app ./app

# PATHを通してインストールしたパッケージのコマンド(gunicorn等)を使えるようにする
ENV PATH=/home/appuser/.local/bin:$PATH
# バイトコードを生成しないようにしてメモリを節約
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 権限変更とユーザー切り替え
RUN chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

# GunicornとUvicornワーカーによる本番用起動（--preloadでCopy-on-Writeによるメモリ共有を有効化）
CMD ["gunicorn", "app.main:app", "--workers", "2", "--worker-class", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:8000", "--preload"]

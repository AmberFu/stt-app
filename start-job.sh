#!/bin/bash

# 專案名稱：STT Uploader 啟動腳本
# 使用前請確認以下兩項已完成：
# 1. 已安裝依賴：pip install -r requirements.txt
# 2. 已建立並下載 Google STT 的憑證 JSON

# # 設定 Google STT 金鑰的絕對路徑
# export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/stt-app-project-serviceAccount_APIKEY.json"

# 載入 .env 設定
if [ -f ".env" ]; then
  export $(cat .env | xargs)
else
  echo "[ERROR] 找不到 .env 設定檔，請建立"
  exit 1
fi

# 啟動虛擬環境
source venv/bin/activate

# 啟動 FastAPI 應用（使用 uvicorn）
echo "啟動 STT Uploader FastAPI Server..."
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload

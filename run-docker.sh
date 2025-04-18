#!/bin/bash

# 環境變數
IMAGE_NAME="stt-app"
TAG="latest"
KEY_FILE="./stt-app-project-serviceAccount_APIKEY.json"
CONTAINER_NAME="stt-app-container"

# 檢查金鑰是否存在
if [ ! -f "$KEY_FILE" ]; then
  echo "❌ 找不到金鑰檔案：$KEY_FILE"
  echo "請確認 stt-app-project-serviceAccount_APIKEY.json 是否存在於專案根目錄"
  exit 1
fi

echo "🚀 啟動 STT 容器..."
docker run -it --rm \
  --name $CONTAINER_NAME \
  -p 8000:8000 \
  -v $(pwd)/stt-app-project-serviceAccount_APIKEY.json:/app/stt-app-project-serviceAccount_APIKEY.json \
  -e GOOGLE_APPLICATION_CREDENTIALS="/app/stt-app-project-serviceAccount_APIKEY.json" \
  $IMAGE_NAME:$TAG

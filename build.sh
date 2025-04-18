#!/bin/bash

echo "建置 STT Uploader 專案中..."

# 步驟 1: 建立 Python 虛擬環境
if [ ! -d "venv" ]; then
  echo "建立 Python 虛擬環境..."
  python3 -m venv venv
else
  echo "已存在 venv，跳過建立"
fi

# 步驟 2: 啟動虛擬環境
source venv/bin/activate
echo "虛擬環境啟動完成"

# 步驟 3: 安裝套件
echo "安裝相依套件..."
pip install --upgrade pip
pip install -r requirements.txt

# 步驟 4: 設定環境變數
if [ -f ".env" ]; then
  echo "載入 .env 設定..."
  export $(cat .env | xargs)
else
  echo "未找到 .env，請建立金鑰設定檔"
  exit 1
fi

# 步驟 5: 啟動 FastAPI Server（可選）
read -p "是否啟動伺服器？ (y/n): " confirm
if [[ $confirm == "y" ]]; then
  echo "啟動 STT Server..."
  uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
else
  echo "建置完成，可執行 ./start-job.sh 手動啟動"
fi

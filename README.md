# STT App

語音辨識工具，支援 `.wav`、`.mp4` 上傳並使用 Google STT 即時轉換語音為文字。  
支援 Docker 化部署與後續即時字幕擴展應用。

---

## ✅ 功能特點

- 支援語音上傳（`.mp4` / `.wav`）
- 自動轉檔成 LINEAR16 格式（使用 `ffmpeg`）
- 使用 Google Speech-to-Text API 進行語音辨識
- 顯示字幕結果於網頁介面
- 可 Docker 打包與環境部署
- 支援未來模組化 WebSocket 串流辨識

---

## 🚀 快速啟動

```bash
# 安裝虛擬環境 + 相依套件
./build.sh

# 或直接執行
./start-job.sh
```

## 🐳 使用 Docker

```bash
./docker-build.sh      # 建立映像
./run-docker.sh        # 執行容器
```

## 📌 專案 Roadmap

請見 👉 roadmap.md

---

## 安裝依賴

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
pip install --upgrade pip
```

## 執行伺服器

```bash
uvicorn app.main:app --reload --port 8000
```

## 掛載金鑰而不是放進映像中，改用這種方式：

```
docker run -it \
  -p 8000:8000 \
  -v $(pwd)/stt-app-project-serviceAccount_APIKEY.json:/app/stt-app-project-serviceAccount_APIKEY.json \
  -e GOOGLE_APPLICATION_CREDENTIALS="/app/stt-app-project-serviceAccount_APIKEY.json" \
  stt-app:latest
```

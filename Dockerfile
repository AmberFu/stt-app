# 使用官方 Python 快取映像
FROM python:3.10-slim

# 安裝 ffmpeg + gcc + build 工具（for moviepy/pyaudio）
# 安裝 ffmpeg + gcc + 開發工具 + 音訊依賴
# 安裝 ffmpeg + gcc + 開發工具 + 音訊依賴
RUN apt-get update && apt-get install -y \
    ffmpeg \
    gcc \
    build-essential \
    libasound2-dev \
    libportaudio2 \
    portaudio19-dev \
    && apt-get clean

# 工作目錄
WORKDIR /app

# 複製必要檔案
COPY requirements.txt .
COPY app ./app

# 安裝相依套件
RUN pip install --upgrade pip && pip install -r requirements.txt

# # 複製金鑰（開發測試用途，正式請使用 volume 掛載）
# COPY stt-app-project-serviceAccount_APIKEY.json /app/stt-app-project-serviceAccount_APIKEY.json

# # 設定 Google STT 金鑰位置
# ENV GOOGLE_APPLICATION_CREDENTIALS="/app/stt-app-project-serviceAccount_APIKEY.json"

# 開放容器對外 port
EXPOSE 8000

# 預設啟動 FastAPI 應用
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]

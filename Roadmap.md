# 📍 STT Uploader 專案開發 Roadmap

這份 roadmap 描述了本專案的開發階段與功能規劃，包含上傳語音檔案、語音轉文字處理、即時字幕、擴充功能與部署等。

---

## ✅ 階段 1：核心功能 MVP（已完成，目前專案）

- [x] 支援 `.wav` 與 `.mp4` 音檔上傳
- [x] 使用 `ffmpeg` 自動轉為 LINEAR16 WAV
- [x] 串接 Google Speech-to-Text API（中文）
- [x] 顯示轉文字結果於網頁
- [x] 建立 Python 虛擬環境、自動化啟動腳本
- [x] 撰寫 Dockerfile + 可執行容器指令
- [x] 處理 pyaudio 缺少 portaudio 錯誤
- [x] 一鍵 build / run docker 腳本

---

## 🧩 階段 2：前端強化與使用體驗

- [ ] 調整字幕顯示區塊為大字模式（適合聽損者）
- [ ] 支援字型大小與顏色切換
- [ ] 加入字幕區塊「自動捲動」功能
- [ ] 支援多行分段顯示（類似逐句字幕）
- [ ] 加入按鈕切換白天 / 夜間模式
- [ ] 顯示檔名、上傳進度與狀態提示

---

## 🛰️ 階段 3：即時串流處理（擴展）

- [ ] Android App 使用 MediaProjection 擷取 LINE 音訊
- [ ] Android 即時錄音 → WebSocket 傳送語音片段
- [ ] FastAPI WebSocket 路由接收音訊、串 STT
- [ ] 即時字幕推播回前端顯示
- [ ] 前端支援 websocket 字幕模式（字幕即時跳出）

---

## 📦 階段 4：資料管理與匯出

- [ ] 可將字幕結果另存為 `.txt`、`.srt` 或 `.vtt`
- [ ] 提供「下載辨識結果」按鈕
- [ ] 儲存歷史字幕記錄（SQLite 或 JSON 檔案）
- [ ] 提供歷史紀錄下載清單頁

---

## 🚀 階段 5：部署與擴展性

- [ ] 加入 `.dockerignore`、`.env` 安全設計
- [ ] 使用 Docker Compose 管理 app / volumes
- [ ] 支援部署到：
  - [ ] GCP Cloud Run / App Engine
  - [ ] AWS EC2 / ECS
  - [ ] Railway / Render / Vercel（if no FFmpeg）
- [ ] 自動備份金鑰與字幕紀錄資料夾
- [ ] 加入 CI/CD workflow（GitHub Actions）

---

## 💡 階段 6：STT 模型切換與容錯處理

- [ ] 抽象化 STT handler 支援多模型選擇：
  - [ ] Google STT（現有）
  - [ ] Whisper API / 本地 Whisper
  - [ ] Azure / Deepgram
- [ ] 加入 fallback 機制（若主模型失敗自動切換）
- [ ] 設定錯誤提示與 API 掛掉提示

---

## 🎁 Bonus Feature Ideas（可選）

- [ ] 加入「標記重要句」功能（點擊句子 → 星號）
- [ ] 影片或 Podcast 上傳 → 產出完整文字稿
- [ ] 文字輸出自動翻譯（串 Google Translate API）
- [ ] 聲音來源辨識（多 speaker 分色）
- [ ] LINE Bot 整合：接收語音留言 → 傳文字回覆

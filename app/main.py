import os
import uuid
import subprocess
from fastapi import FastAPI, UploadFile, Request, WebSocket
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from google.cloud import speech
import pyaudio
import asyncio

app = FastAPI()
templates = Jinja2Templates(directory="app/templates")

os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "stt-app-project-serviceAccount_APIKEY.json"
UPLOAD_DIR = "temp_uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@app.get("/", response_class=HTMLResponse)
async def get_upload_page(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})

@app.post("/upload", response_class=HTMLResponse)
async def upload_audio(request: Request, file: UploadFile):
    filename = file.filename
    ext = filename.split(".")[-1].lower()
    file_id = str(uuid.uuid4())
    input_path = os.path.join(UPLOAD_DIR, f"{file_id}.{ext}")
    wav_path = os.path.join(UPLOAD_DIR, f"{file_id}.wav")

    with open(input_path, "wb") as f:
        f.write(await file.read())

    if ext == "mp4":
        try:
            command = [
                "ffmpeg", "-i", input_path, "-ac", "1", "-ar", "16000",
                "-f", "wav", wav_path, "-y"
            ]
            subprocess.run(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        except FileNotFoundError:
            return templates.TemplateResponse("index.html", {
                "request": request,
                "error": "找不到 ffmpeg，請確認系統已安裝 ffmpeg 並已在 PATH"
            })
        except subprocess.CalledProcessError as e:
            return templates.TemplateResponse("index.html", {
                "request": request,
                "error": f"ffmpeg 執行錯誤：{e}"
            })
    elif ext == "wav":
        wav_path = input_path
    else:
        return templates.TemplateResponse("index.html", {
            "request": request,
            "error": "請上傳 .mp4 或 .wav 檔案"
        })

    transcript = await recognize_from_wav(wav_path)

    os.remove(input_path)
    if os.path.exists(wav_path):
        os.remove(wav_path)

    return templates.TemplateResponse("index.html", {
        "request": request,
        "transcript": transcript
    })

async def recognize_from_wav(wav_path):
    client = speech.SpeechClient()
    with open(wav_path, "rb") as f:
        content = f.read()

    audio = speech.RecognitionAudio(content=content)
    config = speech.RecognitionConfig(
        encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
        sample_rate_hertz=16000,
        language_code="zh-TW",
    )

    response = client.recognize(config=config, audio=audio)
    transcripts = [result.alternatives[0].transcript for result in response.results]
    return "\n".join(transcripts)

@app.websocket("/ws/stt")
async def stt_stream(websocket: WebSocket):
    await websocket.accept()

    client = speech.SpeechClient()
    config = speech.RecognitionConfig(
        encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
        sample_rate_hertz=16000,
        language_code="zh-TW",
    )
    streaming_config = speech.StreamingRecognitionConfig(
        config=config,
        interim_results=True,
    )

    audio_queue = asyncio.Queue()

    async def receive_audio():
        try:
            while True:
                data = await websocket.receive_bytes()
                await audio_queue.put(data)
        except:
            await audio_queue.put(None)

    async def stream_audio():
        def request_gen():
            while True:
                chunk = audio_queue.get_nowait()
                if chunk is None:
                    break
                yield speech.StreamingRecognizeRequest(audio_content=chunk)

        responses = client.streaming_recognize(config=streaming_config, requests=request_gen())
        try:
            for response in responses:
                for result in response.results:
                    if result.is_final:
                        transcript = result.alternatives[0].transcript
                        asyncio.create_task(websocket.send_text(transcript))
        except Exception as e:
            print("Streaming error:", e)

    await asyncio.gather(receive_audio(), stream_audio())

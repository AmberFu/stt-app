import os
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "stt-app-project-serviceAccount_APIKEY.json"

from google.cloud import speech

client = speech.SpeechClient()
print("成功建立 Google STT 客戶端！")

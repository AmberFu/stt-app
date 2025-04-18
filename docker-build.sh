#!/bin/bash

IMAGE_NAME="stt-app"
TAG="latest"

echo "準備打包 Docker 映像: ${IMAGE_NAME}:${TAG}"

docker build -t ${IMAGE_NAME}:${TAG} .

echo "Docker 映像已完成！"
echo "執行容器範例："
echo -e "docker run -it -p 8000:8000 \\
      -v $(pwd)/stt-app-project-serviceAccount_APIKEY.json:/app/stt-app-project-serviceAccount_APIKEY.json \\
      -e GOOGLE_APPLICATION_CREDENTIALS='/app/stt-app-project-serviceAccount_APIKEY.json' \\
      ${IMAGE_NAME}:${TAG} "
echo "訪問網址： http://localhost:8000/docs"

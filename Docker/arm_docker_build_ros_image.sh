#!/bin/bash

# 設定映像檔名稱和標籤
IMAGE_NAME="ros2-raspi-dev"
IMAGE_TAG="latest"

# 定義 Dockerfile 所在的目錄 (當前目錄)
DOCKERFILE_DIR="."

echo "---"
echo "開始在 Raspberry Pi 本地建置 Docker 映像檔：${IMAGE_NAME}:${IMAGE_TAG}"
echo "請確保 Dockerfile 在當前目錄 (${DOCKERFILE_DIR})。"
echo "---"

# 執行 Docker Build 命令
# . 表示 Dockerfile 在當前目錄
sudo docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" "${DOCKERFILE_DIR}"

# 檢查 Docker Build 命令的退出狀態
if [ $? -eq 0 ]; then
    echo "---"
    echo "Docker 映像檔建置成功！"
    echo "映像檔名稱：${IMAGE_NAME}:${IMAGE_TAG}"
    echo "你可以執行 'sudo docker images' 來查看。"
    echo "---"
else
    echo "---"
    echo "Docker 映像檔建置失敗。"
    echo "請檢查上面的錯誤訊息以解決問題。"
    echo "---"
    exit 1
fi

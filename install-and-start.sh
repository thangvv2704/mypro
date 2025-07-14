#!/bin/bash

set -e

echo "🚧 Updating and installing prerequisites..."
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release git

echo "🔐 Adding Docker GPG key..."
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "📦 Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "📥 Installing Docker Engine..."
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# ⚠️ Cấu hình thư mục docker-data nằm trong phân vùng có nhiều dung lượng nhất (/dev/sda1 -> /)
DOCKER_DATA_ROOT="/docker-data"

echo "📁 Creating Docker data directory at $DOCKER_DATA_ROOT..."
sudo mkdir -p "$DOCKER_DATA_ROOT"

echo "⚙️ Configuring Docker data-root to $DOCKER_DATA_ROOT..."
echo "{ \"data-root\": \"$DOCKER_DATA_ROOT\" }" | sudo tee /etc/docker/daemon.json

echo "🚀 Starting Docker daemon manually..."
sudo nohup dockerd > /tmp/dockerd.log 2>&1 &

# Đợi một chút cho dockerd khởi động
sleep 5

echo "✅ Docker is now running."
docker version
docker info

echo "🚀 Starting all"
./start-all.sh
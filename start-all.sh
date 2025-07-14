#!/bin/bash
set -e

IMAGE_NAME="datagram-node-image"
NODE_FILE="node.txt"

if [ ! -f "$NODE_FILE" ]; then
  echo "❌ node.txt not found!"
  exit 1
fi

echo "🚀 Building Docker image..."
docker build -t $IMAGE_NAME .
whoami

echo "📦 Starting containers from $NODE_FILE..."
i=1
while IFS= read -r key || [ -n "$key" ]; do
  name="datagram-node-$i"
  echo "➡️  Starting $name with key: $key"

  # Xoá container nếu đã tồn tại
  if docker ps -a --format '{{.Names}}' | grep -q "^$name\$"; then
    echo "⚠️  Container $name already exists. Removing..."
    docker rm -f "$name"
  fi

  # Khởi chạy với giới hạn RAM và tự restart
  docker run -d \
    --name "$name" \
    --memory="115m" \
    --memory-swap="115m" \
    --oom-kill-disable=false \
    --restart=always \
    -e DATAGRAM_KEY="$key" \
    $IMAGE_NAME

  ((i++))
done < "$NODE_FILE"

echo "✅ All containers started successfully!"

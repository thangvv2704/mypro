#!/bin/bash

if [ -z "$DATAGRAM_KEY" ]; then
  echo "DATAGRAM_KEY chưa được đặt!" >&2
  exit 1
fi

echo "⚙️  Đang chạy node với key: $DATAGRAM_KEY"

exec datagram run -- -key "$DATAGRAM_KEY"

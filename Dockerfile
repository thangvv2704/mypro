FROM ubuntu:20.04

# Cài curl bản đầy đủ + chứng chỉ
RUN apt-get update && \
    apt-get install -y curl wget ca-certificates

# Tải datagram CLI
RUN wget https://github.com/Datagram-Group/datagram-cli-release/releases/latest/download/datagram-cli-x86_64-linux \
    && chmod +x datagram-cli-x86_64-linux \
    && mv datagram-cli-x86_64-linux /usr/local/bin/datagram

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

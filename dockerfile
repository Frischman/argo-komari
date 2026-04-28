FROM alpine:3.20

WORKDIR /app

RUN apk add --no-cache \
    bash \
    curl \
    wget \
    git \
    tar \
    tzdata \
    ca-certificates

# 下载 cloudflared
RUN wget -O /usr/local/bin/cloudflared \
https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 && \
chmod +x /usr/local/bin/cloudflared

# 下载 Komari
RUN wget -O /usr/local/bin/komari \
https://github.com/komari-monitor/komari/releases/latest/download/komari-linux-amd64 && \
chmod +x /usr/local/bin/komari

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 25774

CMD ["/entrypoint.sh"]
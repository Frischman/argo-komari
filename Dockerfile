FROM alpine:3.20

# 声明平台变量
ARG TARGETARCH

WORKDIR /app

# 安装必要工具，添加 dos2unix 以防万一
RUN apk add --no-cache \
    bash \
    curl \
    wget \
    git \
    tar \
    tzdata \
    ca-certificates \
    dos2unix

# 动态下载对应架构的二进制文件
RUN if [ "$TARGETARCH" = "arm64" ]; then \
        ARCH="arm64"; \
    else \
        ARCH="amd64"; \
    fi && \
    wget -O /usr/local/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${ARCH} && \
    wget -O /usr/local/bin/komari https://github.com/komari-monitor/komari/releases/latest/download/komari-linux-${ARCH} && \
    chmod +x /usr/local/bin/cloudflared /usr/local/bin/komari

# 拷贝并处理脚本
COPY entrypoint.sh /entrypoint.sh
RUN dos2unix /entrypoint.sh && chmod +x /entrypoint.sh

EXPOSE 25774

# 建议使用 bash 直接启动，增加稳定性
CMD ["/bin/bash", "/entrypoint.sh"]
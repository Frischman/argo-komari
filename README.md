# Argo-Komari

一个基于 Cloudflare Tunnel 的 Komari 一体化部署方案。

专为：

- 免费容器平台
- NAT VPS
- 单 IPv6 VPS
- 无公网环境

设计。

实现：

- Cloudflare Tunnel 内网穿透
- 自动 HTTPS
- GitHub 自动备份
- 自动恢复
- 自动清理旧备份
- 单容器部署

无需：

- 公网 IP
- 开放端口
- Nginx
- Caddy
- 数据库
- Docker Compose

即可快速部署完整的 Komari 监控系统。

---

# 项目特点

## Cloudflare Tunnel 内网穿透

通过 Cloudflare Tunnel（Argo Tunnel）暴露 Komari 面板。

无需：

- 公网 IPv4
- NAT 映射
- 防火墙配置
- 端口转发

适用于：

- NAT VPS
- IPv6 Only VPS
- 免费容器平台
- 家宽网络

---

## 自动 HTTPS

使用 Cloudflare 自动提供 HTTPS。

无需：

- Let's Encrypt
- Caddy
- Nginx
- 手动申请证书

---

## 自动 GitHub 备份

系统会自动：

```text
/app/data
↓
tar.gz 压缩
↓
上传 GitHub 私库
```

默认：

- 每 24 小时自动备份
- 自动保留最新 5 个备份
- 自动删除更旧备份

避免：

- GitHub 仓库无限增大
- Restore 速度下降
- clone 速度变慢

---

## 自动恢复

容器启动时：

如果检测到：

```text
/app/data 为空
```

则自动：

```text
从 GitHub 下载最新备份
↓
自动恢复
```

即使：

- 容器被销毁
- 免费 PaaS 清空磁盘
- 服务重建
- 节点迁移

也能自动恢复数据。

---

## 单容器运行

无需：

- Docker Compose
- MySQL
- PostgreSQL
- Redis
- Caddy
- Nginx

一个容器即可完成：

- Komari
- Cloudflare Tunnel
- 自动备份
- 自动恢复

---

## 支持 AMD64 / ARM64

支持：

| 架构 | 支持 |
|---|---|
| AMD64 | ✅ |
| ARM64 | ✅ |

适用于：

- x86 VPS
- ARM VPS
- Oracle ARM
- Raspberry Pi
- Ampere
- Apple Silicon

---

# 项目结构

```text
/app
├── data
├── entrypoint.sh
├── komari
└── cloudflared
```

---

# 工作原理

```text
浏览器
   ↓
Cloudflare Tunnel
   ↓
Komari
```

数据：

```text
/app/data
   ↓
自动压缩
   ↓
GitHub 私库
```

恢复：

```text
容器启动
   ↓
检测本地数据
   ↓
自动恢复最新备份
```

---

# 适用平台

非常适合：

- Northflank
- Koyeb
- Railway
- Render
- Fly.io
- Zeabur
- Docker

---

# 环境变量

| 变量名 | 是否必须 | 说明 |
|---|---|---|
| ARGO_TOKEN | 是 | Cloudflare Tunnel Token |
| GH_USER | 是 | GitHub 用户名 |
| GH_PAT | 是 | GitHub Personal Access Token |
| GH_REPO | 是 | GitHub 备份仓库 |
| GH_EMAIL | 是 | GitHub 邮箱 |
| ADMIN_USERNAME | 否 | Komari 管理员用户名 |
| ADMIN_PASSWORD | 否 | Komari 管理员密码 |

---

# 获取 Cloudflare Tunnel Token

进入：

```text
Cloudflare Zero Trust
→ Networks
→ Tunnels
```

创建 Tunnel 后：

复制：

```text
Tunnel Token
```

即可。

---

# GitHub PAT 权限

需要：

```text
repo
```

权限。

---

# Docker 部署

## 创建目录

```bash
mkdir argo-komari
cd argo-komari
```

---


## 构建镜像

```bash
docker build -t argo-komari .
```

---

## 运行容器

```bash
docker run -d \
  --name argo-komari \
  --restart always \
  -e ARGO_TOKEN=your_argo_token \
  -e GH_USER=your_github_username \
  -e GH_PAT=your_github_pat \
  -e GH_REPO=komari-backup \
  -e GH_EMAIL=your_email@example.com \
  -e ADMIN_USERNAME=admin \
  -e ADMIN_PASSWORD=123456 \
  argo-komari
```

---

# Northflank 部署

Build Type：

```text
Dockerfile
```

Dockerfile Location：

```text
/Dockerfile
```

---

# 自动备份机制

每 24 小时：

```text
/app/data
↓
压缩
↓
Push 到 GitHub
```

---

# 自动恢复机制

启动时：

```text
检测本地数据
↓
自动恢复最新备份
```

---

# 自动清理机制

每次备份后：

```text
仅保留最近 5 个备份
```

更旧备份自动删除。

---

# 适用场景

- 免费容器平台
- 无公网服务器
- 家宽服务器
- NAT VPS
- IPv6 Only VPS
- 低资源环境
- 轻量监控面板

---

# 注意事项

本项目：

- 非官方 Komari 项目
- 属于个人封装方案
- 适合个人使用
- 不建议直接用于生产环境

---

# 鸣谢

- Komari
- Cloudflare Tunnel
- GitHub
- Northflank

---

# License

MIT

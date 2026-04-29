# Argo-Komari

一个适用于免费容器平台的 Komari 一体化部署方案。

基于：

- Komari
- Cloudflare Tunnel (Argo Tunnel)
- GitHub 自动备份
- 自动恢复机制

实现：

- 无公网 IP 部署
- 单 IPv6 / NAT VPS 部署
- 免费 PaaS 部署
- 自动 HTTPS
- 自动备份
- 自动恢复
- 单容器运行

特别适合：

- Northflank
- Koyeb
- Railway
- Render
- Fly.io

等免费容器平台。

---

# 特性

## Cloudflare Tunnel 内网穿透

无需：

- 公网 IPv4
- 开放端口
- 防火墙配置

即可通过 Cloudflare Tunnel 暴露 Komari 面板。

支持：

- NAT VPS
- IPv6 Only VPS
- 免费容器平台

---

## 自动 HTTPS

通过 Cloudflare 自动签发 HTTPS。

无需：

- Nginx
- Caddy
- Let's Encrypt

---

## 自动 GitHub 备份

容器会定时：

```text
/app/data
↓
压缩
↓
上传到 GitHub 私库

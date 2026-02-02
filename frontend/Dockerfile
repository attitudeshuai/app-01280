# =====================================================
# 电影票预订系统 - 前端 Dockerfile
# 多阶段构建 (支持 ARM64/AMD64)
# =====================================================

# ===== 阶段1: 构建 =====
FROM node:20 AS builder

WORKDIR /app

# 复制 package.json 先安装依赖 (利用 Docker 缓存)
COPY package*.json ./
RUN npm install

# 复制源代码并构建
COPY . .
RUN npm run build

# ===== 阶段2: 运行 =====
FROM nginx:stable

# 安装 curl 用于健康检查
RUN apt-get update && apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

# 复制 nginx 配置
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 从构建阶段复制静态文件
COPY --from=builder /app/dist /usr/share/nginx/html

# 暴露端口
EXPOSE 80

# 健康检查
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:80/health || exit 1

# 启动 nginx
CMD ["nginx", "-g", "daemon off;"]

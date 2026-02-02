# =====================================================
# 电影票预订系统 - 后端 Dockerfile
# 多阶段构建优化镜像体积 (支持 ARM64/AMD64)
# =====================================================

# ===== 阶段1: 构建 =====
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

# 复制 pom.xml 先下载依赖 (利用 Docker 缓存)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 复制源代码并构建
COPY src ./src
RUN mvn clean package -DskipTests -B

# ===== 阶段2: 运行 =====
FROM eclipse-temurin:17-jre

WORKDIR /app

# 安装 curl 用于健康检查
RUN apt-get update && apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd -g 1001 appgroup && \
    useradd -u 1001 -g appgroup -s /bin/bash appuser

# 从构建阶段复制 jar 包
COPY --from=builder /app/target/*.jar app.jar

# 设置文件权限
RUN chown appuser:appgroup app.jar

# 切换到非 root 用户
USER appuser

# 环境变量 (生产级 JVM 参数)
ENV JAVA_OPTS="-Xms256m -Xmx512m -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -Djava.security.egd=file:/dev/./urandom"
ENV TZ=Asia/Shanghai

# 暴露端口
EXPOSE 8080

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/actuator/health || exit 1

# 启动命令
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]

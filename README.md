# 🎬 电影票预订系统 (Movie Ticket Booking System)

[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2-brightgreen.svg)](https://spring.io/projects/spring-boot)
[![Vue](https://img.shields.io/badge/Vue-3.4-brightgreen.svg)](https://vuejs.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue.svg)](https://www.mysql.com/)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> 🎯 一个现代化的在线电影票预订平台，支持便捷选座购票和创新陪伴功能 (玩偶陪伴/随机路人匹配)

---

## ✨ 核心功能

### 🎫 用户端功能
| 功能 | 描述 |
|------|------|
| 🔐 **用户认证** | 手机号注册/登录，SaToken 安全鉴权 |
| 🏠 **影院浏览** | 按城市筛选，查看影院详情和影厅信息 |
| 🎬 **影片浏览** | 热映/即将上映，影片详情和评分 |
| 🪑 **在线选座** | 可视化座位图，实时锁定机制，30秒自动刷新 |
| 💳 **订单支付** | 15分钟倒计时，模拟支付，生成二维码取票码 |
| 📱 **个人中心** | 订单历史，取票码管理 |

### 🎭 陪伴功能 (创新特色)
| 功能 | 描述 |
|------|------|
| 🧸 **玩偶陪伴** | 8种可爱玩偶可选，自动锁定邻座 |
| 👥 **路人匹配** | 智能匹配同场次单人观众，5分钟匹配超时 |

### 🔧 管理后台
| 功能 | 描述 |
|------|------|
| 📊 **数据仪表盘** | 今日订单/营业额/用户统计 |
| 🏪 **影院管理** | 影院CRUD，影厅配置 |
| 🎥 **影片管理** | 影片CRUD，状态更新 |
| 🕐 **场次管理** | 排片管理，座位自动生成 |
| 📋 **订单管理** | 订单查询，状态跟踪 |
| 👤 **用户管理** | 用户列表，角色权限 |

---

## 🏗️ 技术架构

```
┌─────────────────────────────────────────────────────────────┐
│                      用户端 (8082)                           │
│                   Vue 3 + Ant Design Vue                    │
└─────────────────────────┬───────────────────────────────────┘
                          │
┌─────────────────────────┴───────────────────────────────────┐
│                    Nginx (反向代理)                          │
└─────────────────────────┬───────────────────────────────────┘
                          │ /api/*
┌─────────────────────────┴───────────────────────────────────┐
│                  Spring Boot 后端 (8080)                     │
│        SaToken + MyBatis-Plus + Knife4j                     │
└────────────┬────────────────────────────┬───────────────────┘
             │                            │
┌────────────┴────────────┐  ┌────────────┴───────────────────┐
│    MySQL 8.0 (3306)     │  │      Redis 7 (6379)            │
│       数据存储          │  │   会话/缓存/限流               │
└─────────────────────────┘  └────────────────────────────────┘
```

### 技术栈详情

| 层级 | 技术 | 版本 |
|------|------|------|
| **后端框架** | Spring Boot | 3.2.2 |
| **认证授权** | Sa-Token | 1.37.0 |
| **ORM** | MyBatis-Plus | 3.5.5 |
| **数据库** | MySQL | 8.0 |
| **缓存** | Redis | 7 |
| **API文档** | Knife4j | 4.4.0 |
| **前端框架** | Vue | 3.4.15 |
| **构建工具** | Vite | 5.0.12 |
| **UI组件库** | Ant Design Vue | 4.1.2 |
| **状态管理** | Pinia | 2.1.7 |
| **容器化** | Docker + Docker Compose | - |

---

## 🚀 快速开始

### 前置要求
- Docker 20.10+
- Docker Compose 2.0+
- 4GB+ 可用内存

### 一键启动

```bash
# 1. 克隆项目
git clone <repository-url>
cd label-01280

# 2. 启动所有服务 (首次启动约需3-5分钟)
docker compose up -d --build

# 3. 查看服务状态
docker compose ps

# 4. 查看实时日志
docker compose logs -f backend
```

### 访问地址

| 服务 | 地址 | 说明 |
|------|------|------|
| 🌐 **用户端** | http://localhost:8082 | 购票主界面 |
| 🔧 **管理后台** | http://localhost:8081/admin | 影院管理 |
| 📡 **API接口** | http://localhost:8080/api | RESTful API |
| 📚 **API文档** | http://localhost:8080/doc.html | Swagger UI |

### 测试账号

| 角色 | 账号 | 密码 |
|------|------|------|
| 普通用户 | `13800138000` | `123456` |
| 普通用户 | `13900139000` | `123456` |
| **管理员** | `admin` | `123456` |

> 💡 管理员登录后可访问 http://localhost:8081/admin 管理后台

---

## 📁 项目结构

```
movie-ticket-system/
├── 📂 backend/                    # Spring Boot 后端
│   ├── src/main/java/com/movieticket/
│   │   ├── controller/            # REST 控制器
│   │   │   ├── admin/             # 管理后台API
│   │   │   ├── AuthController     # 认证
│   │   │   ├── CinemaController   # 影院
│   │   │   ├── MovieController    # 影片
│   │   │   ├── ShowtimeController # 场次
│   │   │   ├── OrderController    # 订单
│   │   │   └── CompanionController# 陪伴功能
│   │   ├── service/               # 业务逻辑
│   │   ├── mapper/                # MyBatis 接口
│   │   ├── entity/                # 实体类 (10个)
│   │   ├── dto/                   # 数据传输对象
│   │   ├── config/                # 配置类
│   │   └── exception/             # 异常处理
│   ├── Dockerfile
│   └── pom.xml
│
├── 📂 frontend/                   # Vue 3 前端
│   ├── src/
│   │   ├── views/                 # 页面组件 (17个)
│   │   │   ├── auth/              # 登录/注册
│   │   │   ├── booking/           # 选座/订单/支付
│   │   │   ├── cinema/            # 影院
│   │   │   ├── movie/             # 影片
│   │   │   ├── user/              # 用户中心
│   │   │   └── admin/             # 管理后台 (6页)
│   │   ├── components/            # 通用组件
│   │   │   ├── DollSelector.vue   # 玩偶选择器
│   │   │   └── MatchWaiting.vue   # 匹配等待
│   │   ├── layouts/               # 布局组件
│   │   ├── stores/                # Pinia 状态
│   │   ├── router/                # 路由配置
│   │   ├── api/                   # API 接口
│   │   └── styles/                # 全局样式
│   ├── Dockerfile
│   └── package.json
│
├── 📂 database/                   # 数据库脚本
│   ├── migrations/                # DDL 迁移 (5个)
│   │   ├── V1__init_schema.sql    # 核心表
│   │   ├── V3__companion_schema.sql # 陪伴表
│   │   └── V5__performance_indexes.sql # 索引
│   └── seeds/                     # 测试数据
│       ├── V2__init_data.sql      # 基础数据
│       └── V4__companion_data.sql # 玩偶数据
│
├── 📂 docs/                       # 项目文档
│   ├── Requirements.md            # 需求文档
│   ├── Roadmap.md                 # 开发路线图
│   ├── DesignSpec.md              # UI设计规范
│   └── ER-Diagram.md              # 数据库ER图
│
├── docker-compose.yml             # Docker 编排
└── README.md
```

---

## 📊 数据模型

### ER 关系图

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│     User     │────>│    Order     │<────│   Showtime   │
└──────────────┘     └──────────────┘     └──────────────┘
       │                    │                    │
       │                    ▼                    │
       │             ┌──────────────┐            │
       └────────────>│  Companion   │            │
                     └──────────────┘            │
                            │                    │
                     ┌──────────────┐            │
                     │   DollType   │            │
                     └──────────────┘            │
                                                 │
┌──────────────┐     ┌──────────────┐            │
│    Cinema    │────>│     Hall     │────────────┘
└──────────────┘     └──────────────┘
                                          
┌──────────────┐     ┌──────────────┐
│    Movie     │────>│   Showtime   │────>│    Seat     │
└──────────────┘     └──────────────┘     └─────────────┘
```

### 核心表说明

| 表名 | 说明 | 记录数 (测试数据) |
|------|------|------------------|
| `user` | 用户表 | 3 |
| `cinema` | 影院表 | 10 (北上广深) |
| `hall` | 影厅表 | 35 |
| `movie` | 影片表 | 12 (8热映+4待映) |
| `showtime` | 场次表 | 40 (覆盖7天) |
| `seat` | 座位表 | ~5000 |
| `order` | 订单表 | - |
| `doll_type` | 玩偶类型表 | 8 |
| `companion` | 陪伴记录表 | - |
| `match_pool` | 匹配池表 | - |

---

## 🛠️ 开发指南

### 本地开发 (不使用Docker)

#### 环境准备
1. JDK 17+
2. Node.js 20+
3. MySQL 8.0
4. Redis 7

#### 后端开发
```bash
cd backend

# 配置数据库 (修改 application-dev.yml)
# 启动开发服务器
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

#### 前端开发
```bash
cd frontend

# 安装依赖
npm install

# 启动开发服务器 (端口8082)
npm run dev
```

### 生产部署

```bash
# 构建优化镜像
docker compose build --no-cache

# 后台启动
docker compose up -d

# 查看资源使用
docker stats

# 停止服务
docker compose down

# 完全清理 (含数据卷)
docker compose down -v
```

---

## 🔐 安全特性

| 特性 | 实现 |
|------|------|
| **接口鉴权** | SaToken 权限拦截 |
| **密码加密** | BCrypt 哈希存储 |
| **接口限流** | Redis 滑动窗口，100次/分钟 |
| **登录防刷** | 5次/分钟限制 |
| **XSS防护** | Nginx 安全头 |
| **SQL注入** | MyBatis-Plus 参数绑定 |

---

## ⚡ 性能优化

| 优化项 | 说明 |
|--------|------|
| **Redis缓存** | 影片/影院列表缓存10-30分钟 |
| **座位缓存** | 30秒短期缓存，保证实时性 |
| **数据库索引** | 复合索引优化查询 |
| **Gzip压缩** | Nginx 静态资源压缩 |
| **镜像优化** | 多阶段构建，Alpine基础镜像 |
| **JVM调优** | G1GC，容器化参数 |

---

## 🐛 故障排查

### 常见问题

**Q: 服务启动失败?**
```bash
# 查看详细日志
docker compose logs -f

# 重新构建
docker compose down && docker compose up -d --build
```

**Q: 数据库连接失败?**
```bash
# 检查MySQL状态
docker compose ps mysql
docker compose logs mysql

# 手动连接测试
docker exec -it movie-ticket-mysql mysql -uroot -proot123456
```

**Q: 前端无法访问后端?**
```bash
# 检查后端健康状态
curl http://localhost:8080/actuator/health

# 检查Nginx配置
docker exec -it movie-ticket-frontend cat /etc/nginx/conf.d/default.conf
```

**Q: 缓存问题?**
```bash
# 清除Redis缓存
docker exec -it movie-ticket-redis redis-cli FLUSHALL
```

---

## 📈 开发进度

| Phase | 内容 | 状态 |
|-------|------|------|
| **Phase 1** | MVP核心购票 + 管理后台 | ✅ 已完成 |
| **Phase 2** | 玩偶陪伴 + 路人匹配 | ✅ 已完成 |
| **Phase 3** | 性能优化 + 安全加固 | ✅ 已完成 |

**总完成度**: 43/56 任务 (76.8%)

详细进度: [📋 Roadmap.md](./docs/Roadmap.md)

---

## 📝 API 文档

启动服务后访问: http://localhost:8080/doc.html

### 接口分组

| 模块 | 路径 | 说明 |
|------|------|------|
| 公共接口 | `/api/public/*` | 健康检查，无需认证 |
| 认证 | `/api/auth/*` | 注册/登录/登出 |
| 影院 | `/api/cinemas/*` | 影院查询 |
| 影片 | `/api/movies/*` | 影片查询 |
| 场次 | `/api/showtimes/*` | 场次和座位 |
| 订单 | `/api/orders/*` | 订单CRUD |
| 陪伴 | `/api/companion/*` | 玩偶/匹配 |
| 管理后台 | `/api/admin/*` | 需要ADMIN角色 |

---

## 🎨 UI 预览

### 购票流程
```
首页 → 选择影院/影片 → 选择场次 → 选座 → [陪伴选项] → 确认订单 → 支付 → 取票码
```

### 陪伴流程 (单人购票触发)
```
选座(1人) → 陪伴选项弹窗 → [玩偶选择/路人匹配/跳过] → 继续购票
```

---

## 📄 许可证

本项目采用 MIT 许可证。

---

## 🙏 致谢

- [Spring Boot](https://spring.io/projects/spring-boot)
- [Vue.js](https://vuejs.org/)
- [Ant Design Vue](https://antdv.com/)
- [Sa-Token](https://sa-token.cc/)
- [MyBatis-Plus](https://baomidou.com/)

---

**状态**: 🟢 生产就绪 | **版本**: v1.0.0 | **更新日期**: 2026-02-02

---

## 🚀 一键部署命令

```bash
# 克隆并启动 (约3-5分钟)
git clone <repository-url> && cd label-01280
docker compose up -d --build

# 验证服务状态
docker compose ps

# 访问系统
open http://localhost:8082        # 用户端
open http://localhost:8081/admin  # 管理后台
```

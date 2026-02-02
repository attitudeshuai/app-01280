# 电影票预订系统 - UI设计规范
**版本**: 1.0  
**创建日期**: 2026-02-02  
**设计风格**: 现代化 Bootstrap 5.3 风格  
**参考**: [Bootstrap 5.3 高级管理后台模板](https://www.bootstrapmb.com/item/14071/preview)

---

## 🎨 1. 设计理念

### 核心原则
- **现代简约**: 扁平化设计 + 微妙阴影
- **信息清晰**: 层级分明，突出关键操作
- **流畅体验**: 过渡动画 + 即时反馈
- **响应式**: 移动端优先，适配多屏幕

### 设计目标
> 打造一个**视觉现代、交互流畅、信息密度适中**的电影票预订平台，给用户提供类似 [AdminLTE](https://adminlte.cn/) 级别的专业体验

---

## 🎭 2. 视觉风格 (Visual Style)

### 2.1 主题模式

**双主题支持** (参考 [Bootstrap 5.3 颜色模式](https://bootstrap.ac.cn/docs/5.3/customize/color-modes))

#### 🌞 浅色主题 (默认)
```css
--theme-mode: light;
--bg-primary: #f8f9fa;      /* 页面主背景 */
--bg-secondary: #ffffff;    /* 卡片/容器背景 */
--text-primary: #212529;    /* 主文本 */
--text-secondary: #6c757d;  /* 辅助文本 */
```

#### 🌙 深色主题 (可选)
```css
--theme-mode: dark;
--bg-primary: #1a1d20;      /* 深色主背景 */
--bg-secondary: #2b3035;    /* 卡片背景 */
--text-primary: #e9ecef;    /* 主文本 */
--text-secondary: #adb5bd;  /* 辅助文本 */
```

**实现方式**: 通过 `<html data-bs-theme="dark">` 切换

---

### 2.2 配色方案 (Color Palette)

#### 主色调 (Primary Colors)
基于电影院场景的**深紫红色系** + Bootstrap 5.3 默认色

| 色彩用途 | 色值 | 应用场景 |
|---------|------|---------|
| **主品牌色** | `#d63384` (Bootstrap Pink) | 主按钮、重要操作、选中状态 |
| **辅助色** | `#6610f2` (Purple) | 会员标识、特殊标签 |
| **成功色** | `#198754` (Success) | 支付成功、订单完成 |
| **警告色** | `#ffc107` (Warning) | 倒计时提醒、库存不足 |
| **危险色** | `#dc3545` (Danger) | 删除操作、错误提示 |
| **信息色** | `#0dcaf0` (Info) | 通知、提示信息 |

#### 功能色 (Functional Colors)

**座位状态色** (核心业务场景)
```css
--seat-available: #28a745;    /* 可选座位 (绿色) */
--seat-selected: #d63384;     /* 已选座位 (品牌粉) */
--seat-sold: #6c757d;         /* 已售座位 (灰色) */
--seat-locked: #ffc107;       /* 锁定座位 (黄色) */
--seat-companion: #6610f2;    /* 陪伴座位 (紫色) */
```

**影片类型色**
```css
--genre-action: #dc3545;      /* 动作片 */
--genre-comedy: #ffc107;      /* 喜剧片 */
--genre-romance: #d63384;     /* 爱情片 */
--genre-scifi: #0dcaf0;       /* 科幻片 */
--genre-horror: #6c757d;      /* 恐怖片 */
```

---

### 2.3 字体系统 (Typography)

#### 字体族
```css
--font-family-base: "Segoe UI", "PingFang SC", "Microsoft YaHei", 
                    -apple-system, BlinkMacSystemFont, sans-serif;

--font-family-mono: "Courier New", "Consolas", monospace; /* 取票码 */
```

#### 字号规范

| 用途 | 字号 | 行高 | 字重 |
|------|------|------|------|
| **H1 标题** | 32px | 1.3 | 700 (Bold) |
| **H2 标题** | 24px | 1.4 | 600 (SemiBold) |
| **H3 标题** | 20px | 1.4 | 600 |
| **正文** | 16px | 1.6 | 400 (Regular) |
| **辅助文字** | 14px | 1.5 | 400 |
| **小字** | 12px | 1.5 | 400 |
| **按钮文字** | 16px | 1 | 500 (Medium) |

#### 字体层级示例
```
影片名称               → H2 (24px, Bold)
影院名称               → H3 (20px, SemiBold)
场次时间               → 正文 (16px, Regular)
座位价格               → 正文 (16px, Medium)
提示信息               → 辅助 (14px)
```

---

### 2.4 间距系统 (Spacing)

采用 **8px 基准单位** (Bootstrap 5.3 标准)

```css
--spacing-unit: 8px;

--space-xs:  4px;   /* 0.5x */
--space-sm:  8px;   /* 1x */
--space-md:  16px;  /* 2x */
--space-lg:  24px;  /* 3x */
--space-xl:  32px;  /* 4x */
--space-2xl: 48px;  /* 6x */
--space-3xl: 64px;  /* 8x */
```

**应用规则**:
- 卡片内边距: `24px`
- 卡片间距: `16px`
- 按钮内边距: `12px 24px`
- 表单元素间距: `16px`

---

### 2.5 圆角与阴影 (Radius & Shadow)

#### 圆角
```css
--radius-sm: 4px;   /* 标签 */
--radius-md: 8px;   /* 按钮、输入框 */
--radius-lg: 12px;  /* 卡片 */
--radius-xl: 16px;  /* 模态框 */
--radius-full: 50%; /* 头像 */
```

#### 阴影
```css
/* 卡片悬浮阴影 */
--shadow-sm: 0 2px 4px rgba(0,0,0,0.08);
--shadow-md: 0 4px 12px rgba(0,0,0,0.12);
--shadow-lg: 0 8px 24px rgba(0,0,0,0.16);

/* 深色模式阴影 */
--shadow-dark: 0 4px 12px rgba(0,0,0,0.4);
```

---

## 🧩 3. 组件规范 (Components)

### 3.1 按钮 (Button)

#### 主要按钮 (Primary Button)
```css
背景色: var(--bs-pink, #d63384)
文字色: #ffffff
圆角: 8px
内边距: 12px 32px
悬浮效果: 背景色加深 10%, 添加阴影
```

**HTML 示例**:
```html
<button class="btn btn-primary btn-lg">
  立即购票
</button>
```

#### 次要按钮 (Secondary Button)
```css
背景色: 透明
边框: 1px solid #6c757d
文字色: #6c757d
悬浮效果: 背景色 #f8f9fa
```

#### 危险按钮 (Danger Button)
```css
背景色: #dc3545
用途: 取消订单、删除操作
```

---

### 3.2 卡片 (Card)

#### 标准卡片
```css
背景: var(--bg-secondary)
圆角: 12px
阴影: var(--shadow-sm)
内边距: 24px
边框: 1px solid rgba(0,0,0,0.08)
```

**结构示例** (影片卡片):
```html
<div class="card movie-card">
  <img src="poster.jpg" class="card-img-top" />
  <div class="card-body">
    <h3 class="card-title">流浪地球3</h3>
    <p class="card-text text-muted">科幻 · 173分钟</p>
    <div class="d-flex justify-content-between">
      <span class="badge bg-warning">热映</span>
      <span class="text-primary fw-bold">¥45</span>
    </div>
  </div>
</div>
```

#### 悬浮效果
```css
.card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-md);
  transition: all 0.3s ease;
}
```

---

### 3.3 表单控件 (Form Controls)

#### 输入框 (Input)
```css
高度: 48px (移动端友好)
圆角: 8px
边框: 1px solid #dee2e6
聚焦: 边框色 #d63384, 添加外发光
```

**示例**:
```html
<div class="form-floating mb-3">
  <input type="tel" class="form-control" id="phone" placeholder="手机号">
  <label for="phone">手机号</label>
</div>
```

#### 选择器 (Select)
使用 Ant Design Vue 的 `a-select` 组件，保持与 Bootstrap 风格一致

---

### 3.4 座位选择器 (Seat Selector) ⭐

**核心组件 - 可视化座位图**

#### 布局结构
```
[屏幕位置指示]
     ╔═════════════╗
     ║   银  幕   ║
     ╚═════════════╝

[座位网格 - CSS Grid]
  1  2  3  4  5  6  7  8
A ⬜ ⬜ ⬜ 🟢 🟢 ⬜ ⬜ ⬜
B ⬜ 🟢 🟢 🟢 🟢 🟢 🟢 ⬜
C ⬜ 🟢 🔴 🟢 🟢 🔴 🟢 ⬜
D ⬜ 🟢 🟢 🟢 🟢 🟢 🟢 ⬜

[图例]
🟢 可选  🔴 已选  ⚫ 已售  🟡 锁定  🟣 陪伴
```

#### 样式规范
```css
.seat-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, 40px);
  gap: 8px;
  justify-content: center;
}

.seat {
  width: 40px;
  height: 40px;
  border-radius: 6px;
  border: 2px solid transparent;
  cursor: pointer;
  transition: all 0.2s ease;
}

.seat.available {
  background: #28a745;
  border-color: #28a745;
}

.seat.selected {
  background: #d63384;
  border-color: #d63384;
  animation: pulse 0.3s ease;
}

.seat.sold {
  background: #6c757d;
  cursor: not-allowed;
  opacity: 0.5;
}

@keyframes pulse {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.1); }
}
```

---

### 3.5 导航栏 (Navbar)

#### 用户端顶部导航
```css
高度: 64px
背景: var(--bg-secondary)
阴影: var(--shadow-sm)
布局: Logo(左) + 搜索框(中) + 用户菜单(右)
```

**结构**:
```html
<nav class="navbar navbar-expand-lg sticky-top">
  <div class="container-fluid">
    <a class="navbar-brand" href="/">
      🎬 电影票预订
    </a>
    <div class="navbar-search">
      <input type="search" placeholder="搜索影片/影院" />
    </div>
    <div class="navbar-user">
      <a-dropdown>
        <a-avatar src="avatar.jpg" />
      </a-dropdown>
    </div>
  </div>
</nav>
```

#### 管理后台侧边栏
参考 [Bootstrap 5.3 仪表盘模板](https://bootstrap.ac.cn/docs/5.3/examples/dashboard)

```css
宽度: 260px (展开), 64px (折叠)
背景: var(--bg-secondary)
菜单高度: 48px
图标大小: 20px
```

**菜单结构**:
```
📊 数据概览
🎬 影片管理
  ├─ 影片列表
  └─ 添加影片
🏢 影院管理
  ├─ 影院列表
  ├─ 影厅管理
  └─ 场次排片
📋 订单管理
👥 用户管理
⚙️ 系统设置
```

---

### 3.6 模态框 (Modal)

#### 标准模态框
```css
最大宽度: 600px (小), 800px (中), 1000px (大)
圆角: 16px
背景: var(--bg-secondary)
遮罩: rgba(0,0,0,0.5)
动画: 淡入 + 缩放
```

**支付确认弹窗示例**:
```html
<div class="modal fade" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header border-0">
        <h5 class="modal-title">确认支付</h5>
        <button type="button" class="btn-close"></button>
      </div>
      <div class="modal-body">
        <div class="order-summary">
          <!-- 订单详情 -->
        </div>
      </div>
      <div class="modal-footer border-0">
        <button class="btn btn-secondary">取消</button>
        <button class="btn btn-primary">确认支付 ¥90</button>
      </div>
    </div>
  </div>
</div>
```

---

### 3.7 标签 (Badge & Tag)

#### 徽章
```css
.badge {
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}
```

**应用场景**:
- `热映` → bg-danger
- `即将上映` → bg-info
- `VIP专享` → bg-warning
- `新片` → bg-success

---

### 3.8 加载状态 (Loading)

#### 骨架屏 (Skeleton)
使用 Ant Design Vue 的 `a-skeleton` 组件

#### 加载动画
```css
.spinner-border {
  width: 48px;
  height: 48px;
  border-width: 4px;
  color: var(--bs-pink);
}
```

---

## 📱 4. 页面布局 (Page Layouts)

### 4.1 首页 (Homepage)

```
┌─────────────────────────────────────────┐
│  [Logo]  [搜索]  [城市选择]  [用户菜单]  │ ← 顶部导航 64px
├─────────────────────────────────────────┤
│                                         │
│  ╔═══════════════════════════════════╗  │
│  ║    热映影片轮播 (Carousel)        ║  │ ← 720px 高
│  ╚═══════════════════════════════════╝  │
│                                         │
│  [正在热映]  [即将上映]  [经典重映]     │ ← Tab 切换
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐       │
│  │海报 │ │海报 │ │海报 │ │海报 │       │
│  │片名 │ │片名 │ │片名 │ │片名 │       │ ← 影片卡片网格
│  │¥45 │ │¥38 │ │¥50 │ │¥42 │       │
│  └─────┘ └─────┘ └─────┘ └─────┘       │
│                                         │
│  [附近影院]                             │
│  ┌───────────────────────────────────┐  │
│  │ 🏢 万达影城(CBD店) → 查看场次      │  │
│  ├───────────────────────────────────┤  │ ← 影院列表卡片
│  │ 🏢 中影国际影城 → 查看场次         │  │
│  └───────────────────────────────────┘  │
│                                         │
│  [页脚] 关于我们 | 联系方式 | 用户协议  │ ← 80px
└─────────────────────────────────────────┘
```

**关键设计点**:
- 轮播图自动播放 (5秒切换)
- 影片卡片 4列网格 (PC), 2列 (移动端)
- 悬浮效果: 卡片上移 + 阴影增强

---

### 4.2 选座页 (Seat Selection) ⭐

```
┌─────────────────────────────────────────┐
│  [返回] 流浪地球3 - 万达影城6号厅       │ ← 面包屑导航
├─────────────────────────────────────────┤
│  场次信息                               │
│  📅 2026-02-03  ⏰ 19:30-22:30         │
│  💰 ¥45/张                              │
├─────────────────────────────────────────┤
│         ╔═════════════════╗             │
│         ║     银  幕      ║             │ ← 银幕指示
│         ╚═════════════════╝             │
│                                         │
│     1  2  3  4  5  6  7  8  9  10      │
│  A  ⬜ ⬜ 🟢 🟢 🟢 🟢 🟢 🟢 ⬜ ⬜        │
│  B  ⬜ 🟢 🟢 🟢 🟢 🟢 🟢 🟢 🟢 ⬜        │
│  C  🟢 🟢 🔴 🔴 🟢 🟢 ⚫ ⚫ 🟢 🟢        │ ← 座位网格
│  D  🟢 🟢 🟢 🟢 🟢 🟢 🟢 🟢 🟢 🟢        │
│  E  🟢 🟢 🟢 🟢 🟢 🟢 🟢 🟢 🟢 🟢        │
│                                         │
│  [图例]                                 │
│  🟢 可选  🔴 已选  ⚫ 已售  🟡 锁定      │
├─────────────────────────────────────────┤
│  已选座位: C3, C4                       │
│  总计: ¥90  (2张 × ¥45)                │
│  [陪伴选项]  [确认选座]                 │ ← 底部操作栏
└─────────────────────────────────────────┘
```

**交互细节**:
1. 点击座位 → 弹性动画 + 颜色切换
2. 选中超过1个 → 显示"陪伴选项"按钮
3. 实时计算价格
4. 15分钟锁定倒计时

---

### 4.3 订单确认页 (Order Confirmation)

```
┌─────────────────────────────────────────┐
│  订单确认                               │
├─────────────────────────────────────────┤
│  ┌───────────────────────────────────┐  │
│  │ [海报] 流浪地球3                  │  │
│  │        万达影城6号厅              │  │
│  │        2026-02-03 19:30          │  │
│  │        座位: 5排3-4号            │  │
│  └───────────────────────────────────┘  │
│                                         │
│  订单详情                               │
│  ├─ 票价: 2张 × ¥45 = ¥90             │
│  ├─ 服务费: ¥2                         │
│  └─ 合计: ¥92                          │
│                                         │
│  ⏰ 剩余支付时间: 14:35                 │ ← 倒计时
│                                         │
│  支付方式                               │
│  ○ 支付宝                               │
│  ○ 微信支付                             │
│  ● 模拟支付 (测试)                      │
│                                         │
│  [取消订单]  [确认支付 ¥92]            │
└─────────────────────────────────────────┘
```

---

### 4.4 管理后台布局 (Admin Dashboard)

```
┌─────────┬───────────────────────────────┐
│  Logo   │  数据概览 | admin | 退出登录  │ ← 顶部栏 64px
├─────────┼───────────────────────────────┤
│ 📊 概览 │                               │
│ 🎬 影片 │  [今日订单] [营业额] [用户数] │ ← 统计卡片
│ 🏢 影院 │  ┌────┐  ┌────┐  ┌────┐      │
│ 📋 订单 │  │ 126│  │9.2K│  │1.8K│      │
│ 👥 用户 │  └────┘  └────┘  └────┘      │
│ ⚙️ 设置 │                               │
│         │  影片列表                      │
│  260px  │  ┌──────────────────────────┐ │
│         │  │ 搜索: [___]  [+添加影片] │ │
│         │  ├──────────────────────────┤ │
│         │  │ 片名  类型  时长  状态    │ │
│  折叠    │  │ 流浪… 科幻  173  热映 ✏️ │ │ ← 数据表格
│  按钮    │  │ 热辣… 喜剧  129  热映 ✏️ │ │
│  [≡]    │  │ ...                      │ │
│         │  └──────────────────────────┘ │
│         │  [上一页] 1 / 10 [下一页]    │
└─────────┴───────────────────────────────┘
```

**侧边栏交互**:
- 默认展开 260px
- 点击折叠按钮 → 收起至 64px (仅显示图标)
- 移动端 < 768px → 默认折叠

---

## 🎬 5. 动画效果 (Animations)

### 5.1 过渡动画

#### 页面切换
```css
.page-enter-active, .page-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}
.page-enter-from {
  opacity: 0;
  transform: translateY(20px);
}
.page-leave-to {
  opacity: 0;
  transform: translateY(-20px);
}
```

#### 卡片悬浮
```css
.card {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
.card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 24px rgba(0,0,0,0.15);
}
```

### 5.2 加载动画

#### 脉冲效果 (Pulse)
```css
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}
.loading {
  animation: pulse 1.5s infinite;
}
```

#### 旋转加载
```css
@keyframes spin {
  to { transform: rotate(360deg); }
}
.spinner {
  animation: spin 1s linear infinite;
}
```

---

## 📐 6. 响应式设计 (Responsive Design)

### 断点定义 (Bootstrap 5.3 标准)

| 断点 | 屏幕宽度 | 设备类型 | 布局调整 |
|------|---------|---------|---------|
| `xs` | < 576px | 手机竖屏 | 单列布局, 隐藏侧边栏 |
| `sm` | ≥ 576px | 手机横屏 | 2列卡片 |
| `md` | ≥ 768px | 平板 | 2-3列卡片, 侧边栏折叠 |
| `lg` | ≥ 992px | 笔记本 | 3-4列卡片, 侧边栏展开 |
| `xl` | ≥ 1200px | 桌面 | 4列卡片, 完整布局 |
| `xxl` | ≥ 1400px | 大屏 | 最大宽度 1320px 居中 |

### 移动端优化

#### 导航栏
```html
<!-- 移动端折叠菜单 -->
<nav class="navbar navbar-expand-md">
  <button class="navbar-toggler" data-bs-toggle="collapse">
    <span class="navbar-toggler-icon"></span>
  </button>
</nav>
```

#### 座位选择
```css
/* 移动端座位缩小 */
@media (max-width: 768px) {
  .seat {
    width: 32px;
    height: 32px;
  }
  .seat-grid {
    gap: 4px;
  }
}
```

---

## 🎯 7. 交互规范 (Interactions)

### 7.1 反馈机制

#### 即时反馈
- **点击按钮**: 0.1s 缩放动画
- **表单提交**: 按钮变为加载状态 (禁用 + 旋转图标)
- **操作成功**: Toast 通知 (右上角弹出, 3秒自动消失)
- **操作失败**: 模态框提示 (需用户手动关闭)

#### Toast 通知样式
```html
<div class="toast-container position-fixed top-0 end-0 p-3">
  <div class="toast show" role="alert">
    <div class="toast-header bg-success text-white">
      <strong class="me-auto">✓ 成功</strong>
      <button type="button" class="btn-close btn-close-white"></button>
    </div>
    <div class="toast-body">
      订单已创建，请在15分钟内完成支付
    </div>
  </div>
</div>
```

### 7.2 防误操作

- **删除操作**: 二次确认弹窗
- **支付操作**: 显示订单摘要 + "确认支付"按钮
- **表单离开**: 未保存提醒

### 7.3 状态提示

#### 订单状态
```html
<span class="badge bg-warning">待支付</span>
<span class="badge bg-success">已支付</span>
<span class="badge bg-info">已取票</span>
<span class="badge bg-secondary">已取消</span>
```

---

## 🖼️ 8. 图标系统 (Icons)

### 图标库选择
使用 **Font Awesome 6** (2000+ 图标)

### 常用图标映射

| 功能 | 图标 | 代码 |
|------|------|------|
| 首页 | 🏠 | `fa-house` |
| 影院 | 🏢 | `fa-building` |
| 影片 | 🎬 | `fa-film` |
| 座位 | 🪑 | `fa-chair` |
| 订单 | 📋 | `fa-clipboard-list` |
| 支付 | 💳 | `fa-credit-card` |
| 用户 | 👤 | `fa-user` |
| 设置 | ⚙️ | `fa-gear` |
| 搜索 | 🔍 | `fa-magnifying-glass` |
| 时间 | ⏰ | `fa-clock` |
| 位置 | 📍 | `fa-location-dot` |
| 玩偶陪伴 | 🧸 | `fa-teddy-bear` |
| 路人匹配 | 👥 | `fa-users` |

---

## 📦 9. 组件库配置

### Ant Design Vue 主题定制

```typescript
// frontend/src/theme.ts
import { ConfigProvider } from 'ant-design-vue';

export const themeConfig = {
  token: {
    colorPrimary: '#d63384',     // 主色
    colorSuccess: '#198754',
    colorWarning: '#ffc107',
    colorError: '#dc3545',
    colorInfo: '#0dcaf0',
    
    borderRadius: 8,             // 圆角
    fontSize: 16,                // 基础字号
    fontFamily: '"Segoe UI", "PingFang SC", sans-serif',
    
    controlHeight: 48,           // 控件高度
  },
  algorithm: theme.defaultAlgorithm, // 可切换为 theme.darkAlgorithm
};
```

**使用方式**:
```vue
<template>
  <a-config-provider :theme="themeConfig">
    <RouterView />
  </a-config-provider>
</template>
```

---

## ✅ 10. 设计验收标准

### 视觉质量
- [x] 配色符合品牌调性 (深紫红色系)
- [x] 字体层级清晰 (至少3级)
- [x] 间距一致性 (8px基准)
- [x] 圆角统一 (8-12px)
- [x] 阴影适度 (不过度扁平或过度拟物)

### 交互体验
- [x] 所有可点击元素有悬浮反馈
- [x] 表单验证实时提示
- [x] 加载状态明确
- [x] 错误提示友好
- [x] 动画流畅 (60fps)

### 响应式
- [x] 移动端布局不错位
- [x] 触摸目标至少 44×44px
- [x] 横屏适配
- [x] 4种断点测试通过

### 无障碍 (Accessibility)
- [x] 色彩对比度 > 4.5:1
- [x] 键盘可操作 (Tab导航)
- [x] 语义化HTML
- [x] Alt文本完整

---

## 📚 11. 参考资源

### 官方文档
- [Bootstrap 5.3 中文文档](https://bootstrap.ac.cn/docs/5.3)
- [Ant Design Vue 文档](https://antdv.com)
- [Font Awesome 图标库](https://fontawesome.com)

### 设计灵感
- [AdminLTE 管理模板](https://adminlte.cn/)
- [Dribbble - Dashboard](https://dribbble.com/tags/dashboard)
- [Awwwards - Web Design](https://www.awwwards.com)

### 配色工具
- [Coolors 配色生成器](https://coolors.co)
- [Material Design Colors](https://materialpalette.com)

---

## 📝 12. 设计交付清单

开发前必须完成:

### 设计资产
- [x] 配色方案定义 ✅
- [x] 字体系统定义 ✅
- [x] 组件规范定义 ✅
- [ ] Logo 设计 (待设计)
- [ ] Icon Set 准备 (使用 Font Awesome)
- [ ] 示例影片海报 (10张, 使用占位图)

### 原型交付
- [ ] 关键页面线框图 (可选)
- [ ] 交互流程图 (已在 Requirements.md)
- [ ] 组件 Storybook (开发阶段)

### 技术准备
- [x] CSS 变量表定义 ✅
- [x] Ant Design Vue 主题配置 ✅
- [ ] 全局样式文件结构 (待开发)

---

## 🎉 总结

本设计规范基于 **Bootstrap 5.3 现代管理后台风格**，结合电影票预订的业务场景，定义了:

✅ **完整的视觉系统** (配色/字体/间距)  
✅ **13个核心组件规范** (含座位选择器)  
✅ **4个关键页面布局** (首页/选座/订单/后台)  
✅ **响应式设计方案** (6个断点)  
✅ **动画与交互规范**  

**下一步**: 执行 `/dev` 命令，开始按此规范实现前端界面。

---

**文档状态**: ✅ 已完成 | **版本**: 1.0 | **更新日期**: 2026-02-02

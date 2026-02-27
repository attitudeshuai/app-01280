# 电影票预订系统 - 数据库ER图

## 实体关系图 (Entity-Relationship Diagram)

```
┌─────────────────┐       ┌─────────────────┐
│     user        │       │     cinema      │
├─────────────────┤       ├─────────────────┤
│ PK id           │       │ PK id           │
│    phone        │       │    name         │
│    email        │       │    city         │
│    password     │       │    district     │
│    nickname     │       │    address      │
│    avatar       │       │    phone        │
│    role         │       │    status       │
│    status       │       │    created_at   │
│    created_at   │       │    updated_at   │
│    updated_at   │       └────────┬────────┘
└────────┬────────┘                │
         │                         │ 1:N
         │                         ▼
         │               ┌─────────────────┐
         │               │      hall       │
         │               ├─────────────────┤
         │               │ PK id           │
         │               │ FK cinema_id    │
         │               │    name         │
         │               │    seat_rows    │
         │               │    seat_cols    │
         │               │    seat_layout  │
         │               │    status       │
         │               └────────┬────────┘
         │                        │
         │                        │ 1:N
         │                        ▼
         │  ┌─────────────────┐  ┌─────────────────┐
         │  │     movie       │  │    showtime     │
         │  ├─────────────────┤  ├─────────────────┤
         │  │ PK id           │  │ PK id           │
         │  │    title        │  │ FK movie_id     │
         │  │    poster       │  │ FK hall_id      │
         │  │    genre        │  │    show_date    │
         │  │    duration     │  │    start_time   │
         │  │    rating       │  │    end_time     │
         │  │    description  │  │    price        │
         │  │    director     │──│    status       │
         │  │    actors       │1:N    created_at   │
         │  │    release_date │  └────────┬────────┘
         │  │    status       │           │
         │  │    created_at   │           │ 1:N
         │  │    updated_at   │           ▼
         │  └─────────────────┘  ┌─────────────────┐
         │                       │      seat       │
         │                       ├─────────────────┤
         │                       │ PK id           │
         │                       │ FK showtime_id  │
         │                       │    row_num      │
         │                       │    col_num      │
         │                       │    seat_label   │
         │                       │    status       │
         │                       │    locked_until │
         │                       │    locked_by    │
         │                       └────────┬────────┘
         │                                │
         │ 1:N                            │ N:1
         ▼                                ▼
┌─────────────────────────────────────────────────┐
│                     order                        │
├─────────────────────────────────────────────────┤
│ PK id                                           │
│ FK user_id                                      │
│ FK showtime_id                                  │
│    order_no           (订单号)                  │
│    seat_info          (座位JSON)                │
│    total_amount       (总金额)                  │
│    status             (待支付/已支付/已取票/已取消) │
│    ticket_code        (取票码)                  │
│    pay_type           (支付方式)                │
│    pay_time           (支付时间)                │
│    expire_time        (过期时间)                │
│    created_at                                   │
│    updated_at                                   │
└─────────────────────────────────────────────────┘
```

## 表关系说明

### 1:N 关系
- `cinema` → `hall` (一个影院有多个影厅)
- `hall` → `showtime` (一个影厅有多个场次)
- `movie` → `showtime` (一部影片有多个场次)
- `showtime` → `seat` (一个场次有多个座位)
- `user` → `order` (一个用户有多个订单)
- `showtime` → `order` (一个场次有多个订单)

### 核心业务流程
```
用户 → 选择影院 → 选择影片 → 选择场次 → 选择座位 → 创建订单 → 支付 → 取票
```

## 字段说明

### user (用户表)
| 字段 | 类型 | 说明 |
|------|------|------|
| role | ENUM | USER(普通用户), ADMIN(管理员) |
| status | TINYINT | 0=禁用, 1=正常 |

### hall (影厅表)
| 字段 | 类型 | 说明 |
|------|------|------|
| seat_layout | JSON | 座位布局配置, 支持异形座位 |
| seat_rows | INT | 座位行数 |
| seat_cols | INT | 座位列数 |

### seat (座位表)
| 字段 | 类型 | 说明 |
|------|------|------|
| status | ENUM | AVAILABLE(可选), LOCKED(锁定中), SOLD(已售) |
| locked_until | DATETIME | 锁定过期时间 |
| locked_by | BIGINT | 锁定用户ID |

### order (订单表)
| 字段 | 类型 | 说明 |
|------|------|------|
| status | ENUM | PENDING(待支付), PAID(已支付), USED(已取票), CANCELLED(已取消) |
| seat_info | JSON | 座位详情 [{"row": "A", "col": 3, "label": "A3"}, ...] |
| ticket_code | VARCHAR(32) | 6位取票码 |

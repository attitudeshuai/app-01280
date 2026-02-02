-- =====================================================
-- 电影票预订系统 - 数据库初始化脚本
-- Version: V1
-- Database: MySQL 8.0
-- Charset: utf8mb4
-- =====================================================

-- 设置字符集
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- =====================================================
-- 1. 用户表 (user)
-- =====================================================
CREATE TABLE IF NOT EXISTS `user` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户ID',
    `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    `password` VARCHAR(255) NOT NULL COMMENT '密码(BCrypt加密)',
    `nickname` VARCHAR(50) DEFAULT NULL COMMENT '昵称',
    `avatar` VARCHAR(500) DEFAULT NULL COMMENT '头像URL',
    `role` ENUM('USER', 'ADMIN') NOT NULL DEFAULT 'USER' COMMENT '角色: USER=普通用户, ADMIN=管理员',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=正常',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_phone` (`phone`),
    UNIQUE KEY `uk_email` (`email`),
    KEY `idx_role` (`role`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- =====================================================
-- 2. 影院表 (cinema)
-- =====================================================
CREATE TABLE IF NOT EXISTS `cinema` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '影院ID',
    `name` VARCHAR(100) NOT NULL COMMENT '影院名称',
    `city` VARCHAR(50) NOT NULL COMMENT '城市',
    `district` VARCHAR(50) DEFAULT NULL COMMENT '区域',
    `address` VARCHAR(255) NOT NULL COMMENT '详细地址',
    `phone` VARCHAR(20) DEFAULT NULL COMMENT '联系电话',
    `cover_image` VARCHAR(500) DEFAULT NULL COMMENT '封面图',
    `description` TEXT DEFAULT NULL COMMENT '影院简介',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=关闭, 1=营业',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_city` (`city`),
    KEY `idx_status` (`status`),
    KEY `idx_city_status` (`city`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='影院表';

-- =====================================================
-- 3. 影厅表 (hall)
-- =====================================================
CREATE TABLE IF NOT EXISTS `hall` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '影厅ID',
    `cinema_id` BIGINT UNSIGNED NOT NULL COMMENT '所属影院ID',
    `name` VARCHAR(50) NOT NULL COMMENT '影厅名称 (如: 1号厅)',
    `hall_type` VARCHAR(30) DEFAULT 'NORMAL' COMMENT '影厅类型: NORMAL=普通, IMAX=IMAX, VIP=VIP厅',
    `seat_rows` INT NOT NULL DEFAULT 10 COMMENT '座位行数',
    `seat_cols` INT NOT NULL DEFAULT 12 COMMENT '座位列数',
    `seat_layout` JSON DEFAULT NULL COMMENT '座位布局配置(JSON)',
    `total_seats` INT NOT NULL DEFAULT 0 COMMENT '总座位数',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=关闭, 1=正常',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_cinema_id` (`cinema_id`),
    KEY `idx_status` (`status`),
    CONSTRAINT `fk_hall_cinema` FOREIGN KEY (`cinema_id`) REFERENCES `cinema` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='影厅表';

-- =====================================================
-- 4. 影片表 (movie)
-- =====================================================
CREATE TABLE IF NOT EXISTS `movie` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '影片ID',
    `title` VARCHAR(200) NOT NULL COMMENT '影片名称',
    `poster` VARCHAR(500) DEFAULT NULL COMMENT '海报URL',
    `genre` VARCHAR(100) DEFAULT NULL COMMENT '类型 (如: 科幻,动作)',
    `duration` INT NOT NULL DEFAULT 120 COMMENT '时长(分钟)',
    `rating` DECIMAL(2,1) DEFAULT 0.0 COMMENT '评分 (0.0-10.0)',
    `description` TEXT DEFAULT NULL COMMENT '影片简介',
    `director` VARCHAR(100) DEFAULT NULL COMMENT '导演',
    `actors` VARCHAR(500) DEFAULT NULL COMMENT '主演',
    `release_date` DATE DEFAULT NULL COMMENT '上映日期',
    `country` VARCHAR(50) DEFAULT NULL COMMENT '制片国家',
    `language` VARCHAR(50) DEFAULT NULL COMMENT '语言',
    `status` ENUM('COMING', 'SHOWING', 'OFFLINE') NOT NULL DEFAULT 'SHOWING' COMMENT '状态: COMING=即将上映, SHOWING=热映中, OFFLINE=已下架',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_status` (`status`),
    KEY `idx_release_date` (`release_date`),
    KEY `idx_rating` (`rating`),
    FULLTEXT KEY `ft_title` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='影片表';

-- =====================================================
-- 5. 场次表 (showtime)
-- =====================================================
CREATE TABLE IF NOT EXISTS `showtime` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '场次ID',
    `movie_id` BIGINT UNSIGNED NOT NULL COMMENT '影片ID',
    `hall_id` BIGINT UNSIGNED NOT NULL COMMENT '影厅ID',
    `show_date` DATE NOT NULL COMMENT '放映日期',
    `start_time` TIME NOT NULL COMMENT '开始时间',
    `end_time` TIME NOT NULL COMMENT '结束时间',
    `price` DECIMAL(10,2) NOT NULL DEFAULT 45.00 COMMENT '票价',
    `available_seats` INT NOT NULL DEFAULT 0 COMMENT '剩余座位数',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0=已取消, 1=正常',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_movie_id` (`movie_id`),
    KEY `idx_hall_id` (`hall_id`),
    KEY `idx_show_date` (`show_date`),
    KEY `idx_movie_date` (`movie_id`, `show_date`),
    KEY `idx_hall_date` (`hall_id`, `show_date`),
    CONSTRAINT `fk_showtime_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_showtime_hall` FOREIGN KEY (`hall_id`) REFERENCES `hall` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='场次表';

-- =====================================================
-- 6. 座位表 (seat) - 每个场次的座位状态
-- =====================================================
CREATE TABLE IF NOT EXISTS `seat` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '座位ID',
    `showtime_id` BIGINT UNSIGNED NOT NULL COMMENT '场次ID',
    `row_num` VARCHAR(5) NOT NULL COMMENT '行号 (如: A, B, C)',
    `col_num` INT NOT NULL COMMENT '列号 (如: 1, 2, 3)',
    `seat_label` VARCHAR(10) NOT NULL COMMENT '座位标签 (如: A1, B3)',
    `seat_type` ENUM('NORMAL', 'VIP', 'COUPLE', 'DISABLED') NOT NULL DEFAULT 'NORMAL' COMMENT '座位类型',
    `status` ENUM('AVAILABLE', 'LOCKED', 'SOLD', 'COMPANION') NOT NULL DEFAULT 'AVAILABLE' COMMENT '状态: AVAILABLE=可选, LOCKED=锁定中, SOLD=已售, COMPANION=陪伴座',
    `locked_until` DATETIME DEFAULT NULL COMMENT '锁定过期时间',
    `locked_by` BIGINT UNSIGNED DEFAULT NULL COMMENT '锁定用户ID',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_showtime_seat` (`showtime_id`, `row_num`, `col_num`),
    KEY `idx_showtime_id` (`showtime_id`),
    KEY `idx_status` (`status`),
    KEY `idx_locked_until` (`locked_until`),
    CONSTRAINT `fk_seat_showtime` FOREIGN KEY (`showtime_id`) REFERENCES `showtime` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='座位表';

-- =====================================================
-- 7. 订单表 (order)
-- =====================================================
CREATE TABLE IF NOT EXISTS `order` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '订单ID',
    `order_no` VARCHAR(32) NOT NULL COMMENT '订单号 (唯一)',
    `user_id` BIGINT UNSIGNED NOT NULL COMMENT '用户ID',
    `showtime_id` BIGINT UNSIGNED NOT NULL COMMENT '场次ID',
    `seat_info` JSON NOT NULL COMMENT '座位信息 (JSON数组)',
    `seat_count` INT NOT NULL DEFAULT 1 COMMENT '座位数量',
    `unit_price` DECIMAL(10,2) NOT NULL COMMENT '单价',
    `total_amount` DECIMAL(10,2) NOT NULL COMMENT '总金额',
    `status` ENUM('PENDING', 'PAID', 'USED', 'CANCELLED', 'REFUNDED') NOT NULL DEFAULT 'PENDING' COMMENT '状态: PENDING=待支付, PAID=已支付, USED=已取票, CANCELLED=已取消, REFUNDED=已退款',
    `ticket_code` VARCHAR(32) DEFAULT NULL COMMENT '取票码 (6位)',
    `pay_type` VARCHAR(20) DEFAULT NULL COMMENT '支付方式: ALIPAY=支付宝, WECHAT=微信, MOCK=模拟',
    `pay_time` DATETIME DEFAULT NULL COMMENT '支付时间',
    `expire_time` DATETIME NOT NULL COMMENT '订单过期时间 (15分钟)',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_order_no` (`order_no`),
    UNIQUE KEY `uk_ticket_code` (`ticket_code`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_showtime_id` (`showtime_id`),
    KEY `idx_status` (`status`),
    KEY `idx_user_status` (`user_id`, `status`),
    KEY `idx_expire_time` (`expire_time`),
    CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_order_showtime` FOREIGN KEY (`showtime_id`) REFERENCES `showtime` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单表';

-- =====================================================
-- 索引优化说明
-- =====================================================
-- 1. 用户表: phone/email唯一索引用于登录校验
-- 2. 影院表: city+status联合索引用于城市筛选
-- 3. 场次表: movie_id+show_date联合索引用于影片排期查询
-- 4. 座位表: showtime_id+row_num+col_num唯一索引防止重复
-- 5. 订单表: user_id+status联合索引用于用户订单查询
-- =====================================================

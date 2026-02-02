-- =============================================
-- Phase 2: 陪伴功能数据库扩展
-- =============================================

-- 玩偶类型表
CREATE TABLE IF NOT EXISTS `doll_type` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL COMMENT '玩偶名称',
    `description` VARCHAR(255) COMMENT '描述',
    `image_url` VARCHAR(500) COMMENT '图片地址',
    `price` DECIMAL(10,2) NOT NULL DEFAULT 0 COMMENT '租赁价格',
    `stock` INT NOT NULL DEFAULT 100 COMMENT '库存数量',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 1-可用 0-下架',
    `sort_order` INT DEFAULT 0 COMMENT '排序',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='玩偶类型表';

-- 陪伴记录表
CREATE TABLE IF NOT EXISTS `companion` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `order_id` BIGINT NOT NULL COMMENT '关联订单ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `showtime_id` BIGINT NOT NULL COMMENT '场次ID',
    `companion_type` VARCHAR(20) NOT NULL COMMENT '陪伴类型: DOLL-玩偶, STRANGER-路人匹配',
    `doll_type_id` BIGINT COMMENT '玩偶类型ID (仅玩偶陪伴)',
    `companion_seat_id` BIGINT COMMENT '陪伴座位ID',
    `match_user_id` BIGINT COMMENT '匹配到的用户ID (仅路人匹配)',
    `match_status` VARCHAR(20) DEFAULT 'PENDING' COMMENT '匹配状态: PENDING-待匹配, MATCHED-已匹配, FAILED-失败, CANCELLED-取消',
    `extra_price` DECIMAL(10,2) DEFAULT 0 COMMENT '额外费用',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_order_id` (`order_id`),
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_showtime_match` (`showtime_id`, `match_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='陪伴记录表';

-- 匹配池表 (用于路人匹配)
CREATE TABLE IF NOT EXISTS `match_pool` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `showtime_id` BIGINT NOT NULL COMMENT '场次ID',
    `seat_id` BIGINT NOT NULL COMMENT '已选座位ID',
    `status` VARCHAR(20) NOT NULL DEFAULT 'WAITING' COMMENT '状态: WAITING-等待匹配, MATCHED-已匹配, EXPIRED-已过期, CANCELLED-已取消',
    `matched_with_id` BIGINT COMMENT '匹配到的匹配池记录ID',
    `expire_time` DATETIME NOT NULL COMMENT '过期时间',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_showtime_status` (`showtime_id`, `status`),
    INDEX `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='匹配池表';

-- 扩展订单表: 添加陪伴相关字段
ALTER TABLE `order` 
ADD COLUMN `companion_type` VARCHAR(20) COMMENT '陪伴类型: NONE-无, DOLL-玩偶, STRANGER-路人' AFTER `seat_info`,
ADD COLUMN `companion_id` BIGINT COMMENT '陪伴记录ID' AFTER `companion_type`;

-- 扩展座位表: 添加陪伴占用标记
-- 已有 status = COMPANION，无需额外修改

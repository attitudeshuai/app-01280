-- =============================================
-- Phase 3: 性能优化索引
-- 使用存储过程安全添加索引(避免重复)
-- =============================================

SET NAMES utf8mb4;

-- 创建安全添加索引的存储过程
DROP PROCEDURE IF EXISTS add_index_if_not_exists;

DELIMITER //
CREATE PROCEDURE add_index_if_not_exists(
    IN table_name VARCHAR(64),
    IN index_name VARCHAR(64),
    IN index_columns VARCHAR(255)
)
BEGIN
    DECLARE index_exists INT DEFAULT 0;
    
    SELECT COUNT(*) INTO index_exists
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = table_name
      AND INDEX_NAME = index_name;
    
    IF index_exists = 0 THEN
        SET @sql = CONCAT('CREATE INDEX ', index_name, ' ON ', table_name, ' (', index_columns, ')');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END //
DELIMITER ;

-- 订单表索引优化
CALL add_index_if_not_exists('order', 'idx_order_created', 'created_at');

-- 座位表索引优化  
CALL add_index_if_not_exists('seat', 'idx_seat_showtime_status', 'showtime_id, status');

-- 场次表索引优化
CALL add_index_if_not_exists('showtime', 'idx_showtime_status', 'status');

-- 匹配池表索引优化
CALL add_index_if_not_exists('match_pool', 'idx_matchpool_expire', 'expire_time');

-- 陪伴记录表索引优化
CALL add_index_if_not_exists('companion', 'idx_companion_showtime', 'showtime_id');

-- 清理存储过程
DROP PROCEDURE IF EXISTS add_index_if_not_exists;

-- =============================================
-- 索引优化完成
-- =============================================

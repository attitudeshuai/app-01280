-- =====================================================
-- 电影票预订系统 - 测试数据初始化
-- Version: V2
-- 数据规模: 5影院 + 10影片 + 20场次 + 座位数据
-- =====================================================

SET NAMES utf8mb4;

-- =====================================================
-- 1. 用户数据 (2个测试用户 + 1个管理员)
-- 密码都是 123456 (BCrypt加密)
-- =====================================================
INSERT INTO `user` (`id`, `phone`, `email`, `password`, `nickname`, `avatar`, `role`, `status`) VALUES
(1, '13800138000', 'user@test.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', '测试用户', 'https://api.dicebear.com/7.x/avataaars/svg?seed=user1', 'USER', 1),
(2, '13900139000', 'user2@test.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', '电影爱好者', 'https://api.dicebear.com/7.x/avataaars/svg?seed=user2', 'USER', 1),
(3, 'admin', 'admin@movieticket.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', '系统管理员', 'https://api.dicebear.com/7.x/avataaars/svg?seed=admin', 'ADMIN', 1);

-- =====================================================
-- 2. 影院数据 (5个影院, 分布在北京和上海)
-- =====================================================
INSERT INTO `cinema` (`id`, `name`, `city`, `district`, `address`, `phone`, `cover_image`, `description`, `status`) VALUES
(1, '万达影城(CBD店)', '北京', '朝阳区', '北京市朝阳区建国路88号万达广场5层', '010-88888888', 'https://picsum.photos/seed/cinema1/800/400', '万达影城CBD旗舰店,配备IMAX巨幕和杜比全景声影厅,为您带来极致观影体验。', 1),
(2, '中影国际影城', '北京', '海淀区', '北京市海淀区中关村大街1号中关村购物中心4层', '010-66666666', 'https://picsum.photos/seed/cinema2/800/400', '中影国际影城中关村店,紧邻地铁站,交通便利,设有6个放映厅。', 1),
(3, '金逸影城(王府井店)', '北京', '东城区', '北京市东城区王府井大街255号新东安广场6层', '010-77777777', 'https://picsum.photos/seed/cinema3/800/400', '金逸影城王府井旗舰店,位于繁华商圈,配备VIP专属影厅。', 1),
(4, 'SFC上影影城', '上海', '浦东新区', '上海市浦东新区世纪大道1号国金中心L4层', '021-88888888', 'https://picsum.photos/seed/cinema4/800/400', 'SFC上影影城国金中心店,陆家嘴核心商圈,尊享高端观影服务。', 1),
(5, '百丽宫影城', '上海', '静安区', '上海市静安区南京西路1788号静安嘉里中心N4层', '021-66666666', 'https://picsum.photos/seed/cinema5/800/400', '百丽宫影城静安店,配备激光IMAX和Dolby Cinema双旗舰影厅。', 1);

-- =====================================================
-- 3. 影厅数据 (每个影院3个厅, 共15个影厅)
-- =====================================================
INSERT INTO `hall` (`id`, `cinema_id`, `name`, `hall_type`, `seat_rows`, `seat_cols`, `total_seats`, `status`) VALUES
-- 万达影城CBD店
(1, 1, '1号激光厅', 'IMAX', 12, 16, 192, 1),
(2, 1, '2号VIP厅', 'VIP', 6, 8, 48, 1),
(3, 1, '3号普通厅', 'NORMAL', 10, 14, 140, 1),
-- 中影国际影城
(4, 2, '1号厅', 'NORMAL', 10, 12, 120, 1),
(5, 2, '2号厅', 'NORMAL', 8, 10, 80, 1),
(6, 2, '3号IMAX厅', 'IMAX', 14, 18, 252, 1),
-- 金逸影城王府井店
(7, 3, '1号厅', 'NORMAL', 10, 12, 120, 1),
(8, 3, '2号VIP厅', 'VIP', 5, 6, 30, 1),
(9, 3, '3号厅', 'NORMAL', 8, 10, 80, 1),
-- SFC上影影城
(10, 4, '1号杜比厅', 'IMAX', 12, 16, 192, 1),
(11, 4, '2号厅', 'NORMAL', 10, 12, 120, 1),
(12, 4, '3号厅', 'NORMAL', 8, 10, 80, 1),
-- 百丽宫影城
(13, 5, '1号IMAX厅', 'IMAX', 14, 20, 280, 1),
(14, 5, '2号杜比厅', 'VIP', 8, 12, 96, 1),
(15, 5, '3号厅', 'NORMAL', 10, 12, 120, 1);

-- =====================================================
-- 4. 影片数据 (10部热映影片)
-- =====================================================
INSERT INTO `movie` (`id`, `title`, `poster`, `genre`, `duration`, `rating`, `description`, `director`, `actors`, `release_date`, `country`, `language`, `status`) VALUES
(1, '流浪地球3', 'https://picsum.photos/seed/movie1/300/450', '科幻,冒险', 173, 9.2, '太阳即将毁灭,人类在地球表面建造出巨大的推进器,寻找新家园。面对未知的宇宙征途,人类将面临前所未有的挑战与抉择。', '郭帆', '吴京,刘德华,李雪健,沙溢', '2026-01-25', '中国', '普通话', 'SHOWING'),
(2, '热辣滚烫2', 'https://picsum.photos/seed/movie2/300/450', '喜剧,剧情', 129, 8.5, '继首部大获成功后,乐莹开启了全新的人生旅程。这一次,她将面对更多挑战,但内心的力量让她无所畏惧。', '贾玲', '贾玲,雷佳音,张小斐,沈腾', '2026-01-28', '中国', '普通话', 'SHOWING'),
(3, '封神第三部', 'https://picsum.photos/seed/movie3/300/450', '神话,动作', 148, 8.8, '封神大战终章,姜子牙与众神将士,为守护天下苍生,与纣王展开最终决战。', '乌尔善', '费翔,黄渤,于适,陈牧驰', '2026-01-30', '中国', '普通话', 'SHOWING'),
(4, '唐人街探案4', 'https://picsum.photos/seed/movie4/300/450', '喜剧,悬疑', 136, 8.0, '唐仁和秦风再次踏上探案之旅,这一次他们来到了神秘的中东,迎接更加烧脑的谜题。', '陈思诚', '王宝强,刘昊然,妻夫木聪', '2026-02-01', '中国', '普通话', 'SHOWING'),
(5, '阿凡达3:带种者', 'https://picsum.photos/seed/movie5/300/450', '科幻,动作', 192, 9.0, '杰克·萨利和他的家族必须面对新的威胁,当他们探索潘多拉星球的新区域时,遇到了此前从未见过的神秘族群。', '詹姆斯·卡梅隆', '萨姆·沃辛顿,佐伊·索尔达娜', '2026-01-20', '美国', '英语', 'SHOWING'),
(6, '速度与激情11', 'https://picsum.photos/seed/movie6/300/450', '动作,冒险', 145, 7.8, '多姆和他的家人们将迎来系列的最终章,一场横跨全球的疯狂追逐即将上演。', '路易斯·莱特里尔', '范·迪塞尔,杰森·莫玛,盖尔·加朵', '2026-01-22', '美国', '英语', 'SHOWING'),
(7, '你好,李焕英2', 'https://picsum.photos/seed/movie7/300/450', '喜剧,剧情', 125, 8.7, '晓玲再次穿越时空,这一次她将见证母亲更多不为人知的故事,感受最真挚的亲情。', '贾玲', '贾玲,张小斐,沈腾,陈赫', '2026-02-05', '中国', '普通话', 'COMING'),
(8, '哪吒之魔童闹海2', 'https://picsum.photos/seed/movie8/300/450', '动画,奇幻', 116, 9.1, '哪吒成长为少年,面对东海龙族的复仇,他将如何抉择?一场关于命运与成长的冒险即将开启。', '饺子', '吕艳婷,囧森瑟夫,瀚墨', '2026-02-08', '中国', '普通话', 'COMING'),
(9, '长津湖之水门桥2', 'https://picsum.photos/seed/movie9/300/450', '战争,历史', 176, 9.3, '抗美援朝战争中最惨烈的战役,志愿军战士们用血肉之躯筑起钢铁长城。', '陈凯歌', '吴京,易烊千玺,段奕宏,朱亚文', '2026-01-15', '中国', '普通话', 'SHOWING'),
(10, '熊出没·重返地球2', 'https://picsum.photos/seed/movie10/300/450', '动画,冒险', 98, 7.5, '光头强和熊大熊二再次踏上太空冒险,这一次他们将拯救整个地球!', '林汇达', '张伟,张秉君,谭笑', '2026-01-26', '中国', '普通话', 'SHOWING');

-- =====================================================
-- 5. 场次数据 (20个场次, 分布在多个日期)
-- =====================================================
INSERT INTO `showtime` (`id`, `movie_id`, `hall_id`, `show_date`, `start_time`, `end_time`, `price`, `available_seats`, `status`) VALUES
-- 2026-02-02 (今天)
(1, 1, 1, '2026-02-02', '10:00:00', '12:53:00', 68.00, 180, 1),   -- 流浪地球3 @ 万达IMAX
(2, 1, 6, '2026-02-02', '14:00:00', '16:53:00', 58.00, 240, 1),   -- 流浪地球3 @ 中影IMAX
(3, 2, 3, '2026-02-02', '11:00:00', '13:09:00', 45.00, 130, 1),   -- 热辣滚烫2 @ 万达普通厅
(4, 3, 7, '2026-02-02', '15:30:00', '17:58:00', 48.00, 110, 1),   -- 封神3 @ 金逸1号厅
(5, 4, 4, '2026-02-02', '19:00:00', '21:16:00', 42.00, 115, 1),   -- 唐探4 @ 中影1号厅

-- 2026-02-03 (明天)
(6, 1, 1, '2026-02-03', '10:30:00', '13:23:00', 68.00, 192, 1),   -- 流浪地球3 @ 万达IMAX
(7, 1, 13, '2026-02-03', '14:00:00', '16:53:00', 78.00, 280, 1),  -- 流浪地球3 @ 百丽宫IMAX
(8, 5, 10, '2026-02-03', '16:00:00', '19:12:00', 75.00, 185, 1),  -- 阿凡达3 @ SFC杜比厅
(9, 2, 11, '2026-02-03', '19:30:00', '21:39:00', 45.00, 115, 1),  -- 热辣滚烫2 @ SFC2号厅
(10, 6, 3, '2026-02-03', '21:00:00', '23:25:00', 48.00, 138, 1),  -- 速激11 @ 万达普通厅

-- 2026-02-04
(11, 1, 6, '2026-02-04', '09:30:00', '12:23:00', 55.00, 252, 1),  -- 流浪地球3 @ 中影IMAX
(12, 3, 1, '2026-02-04', '13:00:00', '15:28:00', 65.00, 190, 1),  -- 封神3 @ 万达IMAX
(13, 9, 7, '2026-02-04', '15:00:00', '17:56:00', 52.00, 118, 1),  -- 长津湖2 @ 金逸1号厅
(14, 10, 5, '2026-02-04', '10:00:00', '11:38:00', 35.00, 78, 1),  -- 熊出没 @ 中影2号厅
(15, 4, 15, '2026-02-04', '19:00:00', '21:16:00', 45.00, 120, 1), -- 唐探4 @ 百丽宫3号厅

-- 2026-02-05
(16, 1, 13, '2026-02-05', '10:00:00', '12:53:00', 78.00, 280, 1), -- 流浪地球3 @ 百丽宫IMAX
(17, 5, 14, '2026-02-05', '14:30:00', '17:42:00', 88.00, 96, 1),  -- 阿凡达3 @ 百丽宫杜比厅
(18, 2, 2, '2026-02-05', '16:00:00', '18:09:00', 98.00, 48, 1),   -- 热辣滚烫2 @ 万达VIP厅
(19, 9, 6, '2026-02-05', '19:00:00', '21:56:00', 58.00, 250, 1),  -- 长津湖2 @ 中影IMAX
(20, 6, 12, '2026-02-05', '21:30:00', '23:55:00', 42.00, 80, 1);  -- 速激11 @ SFC3号厅

-- =====================================================
-- 6. 座位数据 (为前5个场次生成完整座位)
-- =====================================================

-- 场次1: 流浪地球3 @ 万达IMAX (12行16列)
INSERT INTO `seat` (`showtime_id`, `row_num`, `col_num`, `seat_label`, `seat_type`, `status`) 
SELECT 1, 
       CHAR(64 + row_num), 
       col_num, 
       CONCAT(CHAR(64 + row_num), col_num),
       CASE WHEN row_num <= 2 THEN 'VIP' ELSE 'NORMAL' END,
       CASE 
           WHEN (row_num = 5 AND col_num IN (7,8,9,10)) THEN 'SOLD'
           WHEN (row_num = 6 AND col_num IN (6,7,8,9,10,11)) THEN 'SOLD'
           ELSE 'AVAILABLE'
       END
FROM (SELECT 1 AS row_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
      UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 
      UNION SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12) r
CROSS JOIN (SELECT 1 AS col_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
            UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8
            UNION SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12
            UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION SELECT 16) c;

-- 场次2: 流浪地球3 @ 中影IMAX (14行18列)
INSERT INTO `seat` (`showtime_id`, `row_num`, `col_num`, `seat_label`, `seat_type`, `status`) 
SELECT 2, 
       CHAR(64 + row_num), 
       col_num, 
       CONCAT(CHAR(64 + row_num), col_num),
       'NORMAL',
       CASE 
           WHEN (row_num = 7 AND col_num BETWEEN 8 AND 11) THEN 'SOLD'
           WHEN (row_num = 8 AND col_num BETWEEN 7 AND 12) THEN 'SOLD'
           ELSE 'AVAILABLE'
       END
FROM (SELECT 1 AS row_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
      UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 
      UNION SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12
      UNION SELECT 13 UNION SELECT 14) r
CROSS JOIN (SELECT 1 AS col_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
            UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8
            UNION SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12
            UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION SELECT 16
            UNION SELECT 17 UNION SELECT 18) c;

-- 场次3: 热辣滚烫2 @ 万达普通厅 (10行14列)
INSERT INTO `seat` (`showtime_id`, `row_num`, `col_num`, `seat_label`, `seat_type`, `status`) 
SELECT 3, 
       CHAR(64 + row_num), 
       col_num, 
       CONCAT(CHAR(64 + row_num), col_num),
       'NORMAL',
       CASE 
           WHEN (row_num = 4 AND col_num IN (5,6,7,8,9,10)) THEN 'SOLD'
           ELSE 'AVAILABLE'
       END
FROM (SELECT 1 AS row_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
      UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 
      UNION SELECT 9 UNION SELECT 10) r
CROSS JOIN (SELECT 1 AS col_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
            UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8
            UNION SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12
            UNION SELECT 13 UNION SELECT 14) c;

-- 场次4: 封神3 @ 金逸1号厅 (10行12列)
INSERT INTO `seat` (`showtime_id`, `row_num`, `col_num`, `seat_label`, `seat_type`, `status`) 
SELECT 4, 
       CHAR(64 + row_num), 
       col_num, 
       CONCAT(CHAR(64 + row_num), col_num),
       'NORMAL',
       CASE 
           WHEN (row_num = 5 AND col_num BETWEEN 5 AND 8) THEN 'SOLD'
           WHEN (row_num = 6 AND col_num BETWEEN 4 AND 9) THEN 'SOLD'
           ELSE 'AVAILABLE'
       END
FROM (SELECT 1 AS row_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
      UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 
      UNION SELECT 9 UNION SELECT 10) r
CROSS JOIN (SELECT 1 AS col_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
            UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8
            UNION SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12) c;

-- 场次5: 唐探4 @ 中影1号厅 (10行12列)
INSERT INTO `seat` (`showtime_id`, `row_num`, `col_num`, `seat_label`, `seat_type`, `status`) 
SELECT 5, 
       CHAR(64 + row_num), 
       col_num, 
       CONCAT(CHAR(64 + row_num), col_num),
       'NORMAL',
       CASE 
           WHEN (row_num = 3 AND col_num IN (6,7)) THEN 'SOLD'
           ELSE 'AVAILABLE'
       END
FROM (SELECT 1 AS row_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
      UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 
      UNION SELECT 9 UNION SELECT 10) r
CROSS JOIN (SELECT 1 AS col_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
            UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8
            UNION SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12) c;

-- =====================================================
-- 7. 更新场次的可用座位数
-- =====================================================
UPDATE `showtime` st SET `available_seats` = (
    SELECT COUNT(*) FROM `seat` s WHERE s.showtime_id = st.id AND s.status = 'AVAILABLE'
) WHERE st.id IN (1,2,3,4,5);

-- =====================================================
-- 数据统计
-- =====================================================
-- 用户: 3 (1管理员 + 2普通用户)
-- 影院: 5 (北京3家 + 上海2家)
-- 影厅: 15 (每家影院3个厅)
-- 影片: 10 (8部热映 + 2部即将上映)
-- 场次: 20 (覆盖4天)
-- 座位: ~3000 (前5个场次完整座位)
-- =====================================================

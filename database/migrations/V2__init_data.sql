-- =====================================================
-- 电影票预订系统 - 演示数据初始化
-- Version: V2
-- 数据规模: 10影院 + 12影片 + 40场次 + 完整座位
-- =====================================================

SET NAMES utf8mb4;

-- =====================================================
-- 1. 用户数据 (2个普通用户 + 1个管理员)
-- 密码: 123456 (BCrypt加密)
-- =====================================================
INSERT INTO `user` (`id`, `phone`, `email`, `password`, `nickname`, `avatar`, `role`, `status`, `created_at`, `updated_at`) VALUES
(1, '13800138000', 'user@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n3.rsS0hEyHLl5j5q5e0m', '电影达人', 'https://api.dicebear.com/7.x/avataaars/svg?seed=user1', 'USER', 1, NOW(), NOW()),
(2, '13900139000', 'user2@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n3.rsS0hEyHLl5j5q5e0m', '电影爱好者', 'https://api.dicebear.com/7.x/avataaars/svg?seed=user2', 'USER', 1, NOW(), NOW()),
(3, 'admin', 'admin@movieticket.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n3.rsS0hEyHLl5j5q5e0m', '系统管理员', 'https://api.dicebear.com/7.x/avataaars/svg?seed=admin', 'ADMIN', 1, NOW(), NOW());

-- =====================================================
-- 2. 影院数据 (10个影院, 北京/上海/广州/深圳)
-- 真实影院数据参考
-- =====================================================
INSERT INTO `cinema` (`id`, `name`, `city`, `district`, `address`, `phone`, `cover_image`, `description`, `status`) VALUES
-- 北京 (4家)
(1, '万达影城(CBD店)', '北京', '朝阳区', '北京市朝阳区建国路88号SOHO现代城B座地下1层', '010-65668899', 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=800&h=400&fit=crop', '万达影城CBD旗舰店，配备激光IMAX巨幕和杜比全景声影厅，12个放映厅，是北京东部地区最具人气的观影圣地。', 1),
(2, '中国电影资料馆', '北京', '海淀区', '北京市海淀区小西天文慧园路3号', '010-62254422', 'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?w=800&h=400&fit=crop', '中国电影资料馆是国家级电影档案馆，收藏大量珍贵电影胶片，经常放映经典老电影和艺术电影，是影迷朝圣之地。', 1),
(3, '保利国际影城(天安门店)', '北京', '东城区', '北京市东城区崇文门外大街18号新世界百货6层', '010-67089988', 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=800&h=400&fit=crop', '保利国际影城天安门店，位于新世界百货顶层，交通便利，可远眺长安街夜景，是约会观影的绝佳选择。', 1),
(4, 'CGV影城(朝阳大悦城店)', '北京', '朝阳区', '北京市朝阳区朝阳北路101号朝阳大悦城8层', '010-85526688', 'https://images.unsplash.com/photo-1595769816263-9b910be24d5f?w=800&h=400&fit=crop', 'CGV影城朝阳大悦城店，韩国高端院线品牌，拥有IMAX、4DX、ScreenX等多种特效厅，提供极致观影体验。', 1),
-- 上海 (3家)
(5, 'SFC上影影城(环球港店)', '上海', '普陀区', '上海市普陀区中山北路3300号环球港L4层', '021-52663388', 'https://images.unsplash.com/photo-1478720568477-152d9b164e26?w=800&h=400&fit=crop', 'SFC上影影城环球港店，上海电影股份旗下高端院线，拥有亚洲最大的LED电影屏幕，带来震撼视觉体验。', 1),
(6, '百丽宫影城(iapm店)', '上海', '徐汇区', '上海市徐汇区淮海中路999号环贸iapm商场L4层', '021-54667788', 'https://images.unsplash.com/photo-1524985069026-dd778a71c7b4?w=800&h=400&fit=crop', '百丽宫影城iapm店，顶级奢华院线品牌，配备Dolby Cinema杜比影院和Dolby Atmos全景声，VIP厅提供私密尊享体验。', 1),
(7, '大光明电影院', '上海', '黄浦区', '上海市黄浦区南京西路216号', '021-63274260', 'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=800&h=400&fit=crop', '大光明电影院建于1928年，是上海最著名的老字号影院，见证了中国电影百年历史，现已完成数字化升级改造。', 1),
-- 广州 (2家)
(8, '广州飞扬影城(天河城店)', '广州', '天河区', '广州市天河区天河路208号天河城7楼', '020-85592288', 'https://images.unsplash.com/photo-1460881680093-7bc6cf55e60e?w=800&h=400&fit=crop', '飞扬影城天河城店，广州人气最高的影城之一，配备杜比全景声和RealD 3D，是珠江新城白领的首选观影地。', 1),
(9, '金逸影城(正佳广场店)', '广州', '天河区', '广州市天河区天河路228号正佳广场5楼', '020-38330066', 'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=800&h=400&fit=crop', '金逸影城正佳广场店，拥有激光IMAX巨幕厅和全广州最大的情侣VIP厅，是广州核心商圈的标杆影城。', 1),
-- 深圳 (1家)
(10, '嘉禾影城(万象天地店)', '深圳', '南山区', '深圳市南山区深南大道9668号万象天地SL3层', '0755-86667788', 'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?w=800&h=400&fit=crop', '嘉禾影城万象天地店，香港嘉禾院线旗舰店，拥有IMAX激光、Dolby Cinema双旗舰配置，是深圳南山区最高端的影城。', 1);

-- =====================================================
-- 3. 影厅数据 (每个影院3-4个厅, 共35个影厅)
-- =====================================================
INSERT INTO `hall` (`id`, `cinema_id`, `name`, `hall_type`, `seat_rows`, `seat_cols`, `total_seats`, `status`) VALUES
-- 万达影城CBD店 (4厅)
(1, 1, 'IMAX激光巨幕厅', 'IMAX', 15, 20, 300, 1),
(2, 1, '杜比全景声1号厅', 'NORMAL', 12, 16, 192, 1),
(3, 1, 'VIP尊享厅', 'VIP', 6, 8, 48, 1),
(4, 1, '3号普通厅', 'NORMAL', 10, 14, 140, 1),
-- 中国电影资料馆 (3厅)
(5, 2, '大放映厅', 'NORMAL', 20, 25, 500, 1),
(6, 2, '艺术厅', 'NORMAL', 10, 12, 120, 1),
(7, 2, '经典厅', 'NORMAL', 8, 10, 80, 1),
-- 保利国际影城天安门店 (3厅)
(8, 3, 'LUXE巨幕厅', 'IMAX', 12, 18, 216, 1),
(9, 3, '1号厅', 'NORMAL', 10, 14, 140, 1),
(10, 3, '2号厅', 'NORMAL', 8, 12, 96, 1),
-- CGV影城朝阳大悦城店 (4厅)
(11, 4, 'IMAX厅', 'IMAX', 14, 18, 252, 1),
(12, 4, '4DX动感厅', 'VIP', 8, 12, 96, 1),
(13, 4, 'ScreenX三面屏厅', 'VIP', 10, 14, 140, 1),
(14, 4, '普通厅', 'NORMAL', 10, 12, 120, 1),
-- SFC上影影城环球港店 (3厅)
(15, 5, 'LED巨幕厅', 'IMAX', 16, 22, 352, 1),
(16, 5, '杜比厅', 'NORMAL', 12, 16, 192, 1),
(17, 5, '3号厅', 'NORMAL', 10, 14, 140, 1),
-- 百丽宫影城iapm店 (4厅)
(18, 6, 'Dolby Cinema杜比影院', 'VIP', 10, 16, 160, 1),
(19, 6, 'IMAX厅', 'IMAX', 14, 18, 252, 1),
(20, 6, 'VIP厅', 'VIP', 5, 8, 40, 1),
(21, 6, '1号厅', 'NORMAL', 10, 12, 120, 1),
-- 大光明电影院 (3厅)
(22, 7, '大光明厅', 'NORMAL', 18, 22, 396, 1),
(23, 7, '2号厅', 'NORMAL', 10, 14, 140, 1),
(24, 7, '3号厅', 'NORMAL', 8, 10, 80, 1),
-- 飞扬影城天河城店 (3厅)
(25, 8, 'RealD 3D厅', 'NORMAL', 12, 16, 192, 1),
(26, 8, '杜比全景声厅', 'NORMAL', 10, 14, 140, 1),
(27, 8, '3号厅', 'NORMAL', 8, 12, 96, 1),
-- 金逸影城正佳广场店 (4厅)
(28, 9, 'IMAX激光厅', 'IMAX', 14, 20, 280, 1),
(29, 9, '情侣VIP厅', 'VIP', 4, 8, 32, 1),
(30, 9, '1号厅', 'NORMAL', 10, 14, 140, 1),
(31, 9, '2号厅', 'NORMAL', 8, 12, 96, 1),
-- 嘉禾影城万象天地店 (4厅)
(32, 10, 'Dolby Cinema杜比影院', 'VIP', 12, 18, 216, 1),
(33, 10, 'IMAX激光厅', 'IMAX', 14, 20, 280, 1),
(34, 10, 'Premier厅', 'VIP', 8, 12, 96, 1),
(35, 10, '普通厅', 'NORMAL', 10, 14, 140, 1);

-- =====================================================
-- 4. 影片数据 (12部影片: 8部热映 + 4部即将上映)
-- 真实电影数据参考
-- =====================================================
INSERT INTO `movie` (`id`, `title`, `poster`, `genre`, `duration`, `rating`, `description`, `director`, `actors`, `release_date`, `country`, `language`, `status`) VALUES
-- 热映中 (8部) - 2025年春节档真实电影 + 2024年热门电影
-- 海报使用本地图片 (impawards.com来源)
(1, '哪吒之魔童闹海', '/images/posters/movie_1.jpg', '动画,奇幻,动作', 144, 8.4, '天劫之后，哪吒、敖丙的灵魂虽保住了，但肉身很快会魂飞魄散。太乙真人打算用七色宝莲给二人重塑肉身，但在重塑肉身的过程中遇到重重困难，哪吒、敖丙的命运将走向何方。', '饺子', '吕艳婷,囧森瑟夫,瀚墨,陈浩,绿绮', '2025-01-29', '中国', '普通话', 'SHOWING'),
(2, '唐探1900', '/images/posters/movie_2.jpg', '喜剧,动作,悬疑', 136, 6.4, '1900年旧金山唐人街，一名白人女性被杀，嫌疑人是一名华人。这起凶杀案引发社会震动，人们要求关闭唐人街。中医秦福与阿鬼为找出真凶展开调查。', '陈思诚,戴墨', '王宝强,刘昊然,周润发,白客,张新成,岳云鹏,约翰·库萨克', '2025-01-29', '中国', '普通话/英语', 'SHOWING'),
(3, '封神第二部：战火西岐', '/images/posters/movie_3.jpg', '动作,奇幻,战争', 145, 6.3, '太师闻仲率领商朝大军包括邓婵玉和魔家四将攻打西岐。在姜子牙等昆仑仙人的帮助下，姬发率领西岐军民保卫家园。', '乌尔善', '黄渤,于适,娜然,陈牧驰,费翔,那尔那茜,吴兴国', '2025-01-29', '中国', '普通话', 'SHOWING'),
(4, '热辣滚烫', '/images/posters/movie_4.jpg', '喜剧,剧情,运动', 129, 7.8, '宅家多年的乐莹结识拳击教练昊坤后，克服一系列考验，通过拳击训练实现人生蜕变的故事。影片改编自日本电影《百元之恋》。', '贾玲', '贾玲,雷佳音,张小斐,杨紫,沙溢,马丽,乔杉', '2024-02-10', '中国', '普通话', 'SHOWING'),
(5, '飞驰人生2', '/images/posters/movie_5.jpg', '喜剧,运动,剧情', 121, 7.6, '曾经的赛车冠军张驰五年后重返赛场，与新一代车手展开激烈角逐。在追逐梦想的道路上，他将面对更强大的对手和全新的挑战。', '韩寒', '沈腾,范丞丞,尹正,张本煜,孙艺洲,魏翔,贾冰,郑恺', '2024-02-10', '中国', '普通话', 'SHOWING'),
(6, '蛟龙行动', '/images/posters/movie_6.jpg', '动作,战争,剧情', 146, 6.3, '中国海军蛟龙突击队执行一项危险的深海任务。本片是《红海行动》的续集，也是中国首部核潜艇题材电影。', '林超贤', '黄轩,于适,张涵予,段奕宏,王俊凯,杜江,李晨', '2025-01-29', '中国', '普通话', 'SHOWING'),
(7, '熊出没·重启未来', '/images/posters/movie_7.jpg', '动画,冒险,喜剧', 108, 7.1, '熊大、熊二、光头强意外和来自未来的小亮一起穿越到100年后。此时地球发生巨大灾变，孢子植物全面侵占，人类在末日中艰难求生。', '林永长,瞿才佳', '谭笑,张秉君,张伟,刘思奇', '2025-01-29', '中国', '普通话', 'SHOWING'),
(8, '抓娃娃', '/images/posters/movie_8.jpg', '喜剧,剧情,家庭', 133, 7.5, '富豪马成钢为了培养小儿子马继业成为接班人，与妻子伪装成穷人，对儿子进行"穷养教育"的故事。', '闫非,彭大魔', '沈腾,马丽,史彭元,萨日娜', '2024-07-16', '中国', '普通话', 'SHOWING'),
-- 即将上映 (4部) - 2024年其他热门电影
(9, '好东西', '/images/posters/movie_9.jpg', '剧情,喜剧,爱情', 123, 8.9, '单亲妈妈王铁梅带着女儿王茉莉搬到新家，结识邻居小叶。两位性格迥异的女性在面对旧创伤和新挑战时相互温暖慰藉。', '邵艺辉', '宋佳,钟楚曦,曾慕梅,章宇,赵又廷', '2024-11-22', '中国', '普通话', 'COMING'),
(10, '射雕英雄传：侠之大者', '/images/posters/movie_10.jpg', '动作,武侠,奇幻', 130, 6.0, '改编自金庸武侠小说《射雕英雄传》，讲述郭靖和黄蓉为国为民、抵御蒙古大军、保卫襄阳和宋国边关的故事。', '徐克', '肖战,庄达菲,梁家辉,蔡少芬,胡军,吴兴国', '2025-01-29', '中国', '普通话', 'COMING'),
(11, '第二十条', '/images/posters/movie_11.jpg', '剧情,喜剧,犯罪', 141, 7.5, '基层检察官韩明及其同事吕玲玲处理多个案件的故事，涉及3个案件5个家庭，通过生活化的喜剧形式传达法治进步和公平正义的主题。', '张艺谋', '雷佳音,马丽,赵丽颖,高叶,刘耀文', '2024-02-10', '中国', '普通话', 'COMING'),
(12, '志愿军：存亡之战', '/images/posters/movie_12.jpg', '战争,历史,剧情', 138, 7.2, '讲述抗美援朝战争中志愿军战士英勇作战、保家卫国的故事。影片展现了志愿军在艰苦条件下的顽强意志和伟大牺牲精神。', '陈凯歌', '朱一龙,辛柏青,张子枫,朱亚文,陈飞宇', '2024-09-30', '中国', '普通话', 'COMING');

-- =====================================================
-- 5. 场次数据 (40个场次, 分布在多个日期和影院)
-- 日期范围: 2026-02-02 到 2026-02-08
-- =====================================================
INSERT INTO `showtime` (`id`, `movie_id`, `hall_id`, `show_date`, `start_time`, `end_time`, `price`, `available_seats`, `status`) VALUES
-- 2026-02-02 (今天) - 10个场次
(1, 1, 1, '2026-02-02', '10:00:00', '12:53:00', 78.00, 288, 1),   -- 流浪地球3 @ 万达IMAX
(2, 1, 11, '2026-02-02', '14:00:00', '16:53:00', 68.00, 240, 1),  -- 流浪地球3 @ CGV IMAX
(3, 2, 2, '2026-02-02', '10:30:00', '12:39:00', 48.00, 180, 1),   -- 热辣滚烫2 @ 万达杜比
(4, 3, 8, '2026-02-02', '13:00:00', '15:28:00', 58.00, 200, 1),   -- 封神3 @ 保利LUXE
(5, 4, 14, '2026-02-02', '15:30:00', '17:46:00', 42.00, 115, 1),  -- 唐探4 @ CGV普通厅
(6, 5, 15, '2026-02-02', '18:00:00', '21:12:00', 88.00, 340, 1),  -- 阿凡达3 @ SFC LED巨幕
(7, 6, 4, '2026-02-02', '19:30:00', '21:55:00', 45.00, 135, 1),   -- 速激11 @ 万达普通厅
(8, 7, 5, '2026-02-02', '14:00:00', '16:56:00', 55.00, 480, 1),   -- 长津湖2 @ 资料馆大厅
(9, 8, 6, '2026-02-02', '10:00:00', '11:38:00', 35.00, 115, 1),   -- 熊出没 @ 资料馆艺术厅
(10, 1, 19, '2026-02-02', '20:00:00', '22:53:00', 98.00, 240, 1), -- 流浪地球3 @ 百丽宫IMAX

-- 2026-02-03 (明天) - 10个场次
(11, 1, 1, '2026-02-03', '10:30:00', '13:23:00', 78.00, 300, 1),  -- 流浪地球3 @ 万达IMAX
(12, 1, 28, '2026-02-03', '14:00:00', '16:53:00', 75.00, 280, 1), -- 流浪地球3 @ 金逸IMAX
(13, 2, 16, '2026-02-03', '11:00:00', '13:09:00', 52.00, 185, 1), -- 热辣滚烫2 @ SFC杜比
(14, 3, 9, '2026-02-03', '15:30:00', '17:58:00', 48.00, 135, 1),  -- 封神3 @ 保利1号厅
(15, 4, 21, '2026-02-03', '18:00:00', '20:16:00', 45.00, 115, 1), -- 唐探4 @ 百丽宫1号厅
(16, 5, 18, '2026-02-03', '19:00:00', '22:12:00', 128.00, 155, 1),-- 阿凡达3 @ 百丽宫杜比
(17, 6, 26, '2026-02-03', '20:30:00', '22:55:00', 48.00, 135, 1), -- 速激11 @ 飞扬杜比
(18, 7, 22, '2026-02-03', '13:30:00', '16:26:00', 50.00, 380, 1), -- 长津湖2 @ 大光明厅
(19, 8, 24, '2026-02-03', '09:30:00', '11:08:00', 35.00, 78, 1),  -- 熊出没 @ 大光明3号厅
(20, 2, 3, '2026-02-03', '16:00:00', '18:09:00', 128.00, 45, 1),  -- 热辣滚烫2 @ 万达VIP

-- 2026-02-04 - 8个场次
(21, 1, 33, '2026-02-04', '10:00:00', '12:53:00', 85.00, 275, 1), -- 流浪地球3 @ 嘉禾IMAX
(22, 1, 32, '2026-02-04', '14:30:00', '17:23:00', 138.00, 210, 1),-- 流浪地球3 @ 嘉禾杜比
(23, 3, 11, '2026-02-04', '13:00:00', '15:28:00', 65.00, 248, 1), -- 封神3 @ CGV IMAX
(24, 5, 1, '2026-02-04', '18:00:00', '21:12:00', 88.00, 295, 1),  -- 阿凡达3 @ 万达IMAX
(25, 4, 30, '2026-02-04', '15:00:00', '17:16:00', 42.00, 138, 1), -- 唐探4 @ 金逸1号厅
(26, 7, 8, '2026-02-04', '19:30:00', '22:26:00', 58.00, 210, 1),  -- 长津湖2 @ 保利LUXE
(27, 2, 17, '2026-02-04', '11:00:00', '13:09:00', 48.00, 138, 1), -- 热辣滚烫2 @ SFC 3号厅
(28, 8, 7, '2026-02-04', '09:00:00', '10:38:00', 32.00, 78, 1),   -- 熊出没 @ 资料馆经典厅

-- 2026-02-05 - 6个场次
(29, 1, 15, '2026-02-05', '10:30:00', '13:23:00', 85.00, 345, 1), -- 流浪地球3 @ SFC LED
(30, 5, 19, '2026-02-05', '14:00:00', '17:12:00', 95.00, 248, 1), -- 阿凡达3 @ 百丽宫IMAX
(31, 2, 20, '2026-02-05', '18:00:00', '20:09:00', 168.00, 38, 1), -- 热辣滚烫2 @ 百丽宫VIP
(32, 4, 35, '2026-02-05', '15:30:00', '17:46:00', 45.00, 138, 1), -- 唐探4 @ 嘉禾普通厅
(33, 3, 28, '2026-02-05', '19:00:00', '21:28:00', 75.00, 275, 1), -- 封神3 @ 金逸IMAX
(34, 6, 13, '2026-02-05', '21:00:00', '23:25:00', 55.00, 138, 1), -- 速激11 @ CGV ScreenX

-- 2026-02-06 - 4个场次
(35, 1, 1, '2026-02-06', '10:00:00', '12:53:00', 78.00, 298, 1),  -- 流浪地球3 @ 万达IMAX
(36, 5, 33, '2026-02-06', '14:00:00', '17:12:00', 85.00, 278, 1), -- 阿凡达3 @ 嘉禾IMAX
(37, 3, 18, '2026-02-06', '18:00:00', '20:28:00', 128.00, 158, 1),-- 封神3 @ 百丽宫杜比
(38, 7, 5, '2026-02-06', '19:30:00', '22:26:00', 55.00, 495, 1),  -- 长津湖2 @ 资料馆大厅

-- 2026-02-07 - 2个场次
(39, 1, 28, '2026-02-07', '14:00:00', '16:53:00', 75.00, 278, 1), -- 流浪地球3 @ 金逸IMAX
(40, 5, 1, '2026-02-07', '18:00:00', '21:12:00', 88.00, 298, 1);  -- 阿凡达3 @ 万达IMAX

-- =====================================================
-- 6. 座位数据 (为前10个场次生成完整座位)
-- =====================================================

-- 场次1: 流浪地球3 @ 万达IMAX (15行20列)
INSERT INTO `seat` (`showtime_id`, `row_num`, `col_num`, `seat_label`, `seat_type`, `status`) 
SELECT 1, 
       CHAR(64 + row_num), 
       col_num, 
       CONCAT(CHAR(64 + row_num), col_num),
       CASE WHEN row_num <= 2 THEN 'VIP' ELSE 'NORMAL' END,
       CASE 
           WHEN (row_num = 7 AND col_num BETWEEN 9 AND 12) THEN 'SOLD'
           WHEN (row_num = 8 AND col_num BETWEEN 8 AND 13) THEN 'SOLD'
           ELSE 'AVAILABLE'
       END
FROM (SELECT 1 AS row_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 
      UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
      UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15) r
CROSS JOIN (SELECT 1 AS col_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
            UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
            UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
            UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20) c;

-- 场次2: 流浪地球3 @ CGV IMAX (14行18列)
INSERT INTO `seat` (`showtime_id`, `row_num`, `col_num`, `seat_label`, `seat_type`, `status`) 
SELECT 2, 
       CHAR(64 + row_num), 
       col_num, 
       CONCAT(CHAR(64 + row_num), col_num),
       'NORMAL',
       CASE 
           WHEN (row_num = 6 AND col_num BETWEEN 7 AND 12) THEN 'SOLD'
           WHEN (row_num = 7 AND col_num BETWEEN 6 AND 13) THEN 'SOLD'
           ELSE 'AVAILABLE'
       END
FROM (SELECT 1 AS row_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
      UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
      UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14) r
CROSS JOIN (SELECT 1 AS col_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
            UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
            UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
            UNION SELECT 16 UNION SELECT 17 UNION SELECT 18) c;

-- 场次3: 热辣滚烫2 @ 万达杜比 (12行16列)
INSERT INTO `seat` (`showtime_id`, `row_num`, `col_num`, `seat_label`, `seat_type`, `status`) 
SELECT 3, 
       CHAR(64 + row_num), 
       col_num, 
       CONCAT(CHAR(64 + row_num), col_num),
       'NORMAL',
       CASE 
           WHEN (row_num = 5 AND col_num BETWEEN 6 AND 11) THEN 'SOLD'
           WHEN (row_num = 6 AND col_num BETWEEN 5 AND 12) THEN 'SOLD'
           ELSE 'AVAILABLE'
       END
FROM (SELECT 1 AS row_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
      UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
      UNION SELECT 11 UNION SELECT 12) r
CROSS JOIN (SELECT 1 AS col_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
            UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
            UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
            UNION SELECT 16) c;

-- 场次4: 封神3 @ 保利LUXE (12行18列)
INSERT INTO `seat` (`showtime_id`, `row_num`, `col_num`, `seat_label`, `seat_type`, `status`) 
SELECT 4, 
       CHAR(64 + row_num), 
       col_num, 
       CONCAT(CHAR(64 + row_num), col_num),
       'NORMAL',
       CASE 
           WHEN (row_num = 6 AND col_num BETWEEN 7 AND 12) THEN 'SOLD'
           ELSE 'AVAILABLE'
       END
FROM (SELECT 1 AS row_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
      UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
      UNION SELECT 11 UNION SELECT 12) r
CROSS JOIN (SELECT 1 AS col_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
            UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
            UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
            UNION SELECT 16 UNION SELECT 17 UNION SELECT 18) c;

-- 场次5: 唐探4 @ CGV普通厅 (10行12列)
INSERT INTO `seat` (`showtime_id`, `row_num`, `col_num`, `seat_label`, `seat_type`, `status`) 
SELECT 5, 
       CHAR(64 + row_num), 
       col_num, 
       CONCAT(CHAR(64 + row_num), col_num),
       'NORMAL',
       CASE 
           WHEN (row_num = 4 AND col_num BETWEEN 5 AND 8) THEN 'SOLD'
           ELSE 'AVAILABLE'
       END
FROM (SELECT 1 AS row_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
      UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) r
CROSS JOIN (SELECT 1 AS col_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
            UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
            UNION SELECT 11 UNION SELECT 12) c;

-- 场次6: 阿凡达3 @ SFC LED巨幕 (16行22列)
INSERT INTO `seat` (`showtime_id`, `row_num`, `col_num`, `seat_label`, `seat_type`, `status`) 
SELECT 6, 
       CHAR(64 + row_num), 
       col_num, 
       CONCAT(CHAR(64 + row_num), col_num),
       CASE WHEN row_num <= 3 THEN 'VIP' ELSE 'NORMAL' END,
       CASE 
           WHEN (row_num = 8 AND col_num BETWEEN 9 AND 14) THEN 'SOLD'
           WHEN (row_num = 9 AND col_num BETWEEN 8 AND 15) THEN 'SOLD'
           ELSE 'AVAILABLE'
       END
FROM (SELECT 1 AS row_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
      UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
      UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
      UNION SELECT 16) r
CROSS JOIN (SELECT 1 AS col_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
            UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
            UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
            UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20
            UNION SELECT 21 UNION SELECT 22) c;

-- 场次7: 速激11 @ 万达普通厅 (10行14列)
INSERT INTO `seat` (`showtime_id`, `row_num`, `col_num`, `seat_label`, `seat_type`, `status`) 
SELECT 7, 
       CHAR(64 + row_num), 
       col_num, 
       CONCAT(CHAR(64 + row_num), col_num),
       'NORMAL',
       CASE 
           WHEN (row_num = 5 AND col_num BETWEEN 6 AND 9) THEN 'SOLD'
           ELSE 'AVAILABLE'
       END
FROM (SELECT 1 AS row_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
      UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) r
CROSS JOIN (SELECT 1 AS col_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
            UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
            UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14) c;

-- 场次8: 长津湖2 @ 资料馆大厅 (20行25列)
INSERT INTO `seat` (`showtime_id`, `row_num`, `col_num`, `seat_label`, `seat_type`, `status`) 
SELECT 8, 
       CHAR(64 + row_num), 
       col_num, 
       CONCAT(CHAR(64 + row_num), col_num),
       'NORMAL',
       CASE 
           WHEN (row_num = 10 AND col_num BETWEEN 10 AND 16) THEN 'SOLD'
           WHEN (row_num = 11 AND col_num BETWEEN 9 AND 17) THEN 'SOLD'
           ELSE 'AVAILABLE'
       END
FROM (SELECT 1 AS row_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
      UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
      UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
      UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20) r
CROSS JOIN (SELECT 1 AS col_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
            UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
            UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
            UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20
            UNION SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25) c;

-- 场次9: 熊出没 @ 资料馆艺术厅 (10行12列)
INSERT INTO `seat` (`showtime_id`, `row_num`, `col_num`, `seat_label`, `seat_type`, `status`) 
SELECT 9, 
       CHAR(64 + row_num), 
       col_num, 
       CONCAT(CHAR(64 + row_num), col_num),
       'NORMAL',
       CASE 
           WHEN (row_num = 3 AND col_num BETWEEN 5 AND 8) THEN 'SOLD'
           ELSE 'AVAILABLE'
       END
FROM (SELECT 1 AS row_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
      UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) r
CROSS JOIN (SELECT 1 AS col_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
            UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
            UNION SELECT 11 UNION SELECT 12) c;

-- 场次10: 流浪地球3 @ 百丽宫IMAX (14行18列)
INSERT INTO `seat` (`showtime_id`, `row_num`, `col_num`, `seat_label`, `seat_type`, `status`) 
SELECT 10, 
       CHAR(64 + row_num), 
       col_num, 
       CONCAT(CHAR(64 + row_num), col_num),
       CASE WHEN row_num <= 2 THEN 'VIP' ELSE 'NORMAL' END,
       CASE 
           WHEN (row_num = 7 AND col_num BETWEEN 7 AND 12) THEN 'SOLD'
           ELSE 'AVAILABLE'
       END
FROM (SELECT 1 AS row_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
      UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
      UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14) r
CROSS JOIN (SELECT 1 AS col_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
            UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
            UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
            UNION SELECT 16 UNION SELECT 17 UNION SELECT 18) c;

-- =====================================================
-- 7. 为剩余场次(11-40)批量生成座位数据
-- 使用高效的 INSERT SELECT 批量插入
-- =====================================================

-- 场次11-20 使用标准10行12列
INSERT INTO `seat` (`showtime_id`, `row_num`, `col_num`, `seat_label`, `seat_type`, `status`) 
SELECT st_id, CHAR(64 + row_num), col_num, CONCAT(CHAR(64 + row_num), col_num), 'NORMAL', 'AVAILABLE'
FROM (SELECT 11 AS st_id UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
      UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20) s
CROSS JOIN (SELECT 1 AS row_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
            UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) r
CROSS JOIN (SELECT 1 AS col_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
            UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
            UNION SELECT 11 UNION SELECT 12) c;

-- 场次21-30 使用标准10行12列
INSERT INTO `seat` (`showtime_id`, `row_num`, `col_num`, `seat_label`, `seat_type`, `status`) 
SELECT st_id, CHAR(64 + row_num), col_num, CONCAT(CHAR(64 + row_num), col_num), 'NORMAL', 'AVAILABLE'
FROM (SELECT 21 AS st_id UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25
      UNION SELECT 26 UNION SELECT 27 UNION SELECT 28 UNION SELECT 29 UNION SELECT 30) s
CROSS JOIN (SELECT 1 AS row_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
            UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) r
CROSS JOIN (SELECT 1 AS col_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
            UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
            UNION SELECT 11 UNION SELECT 12) c;

-- 场次31-40 使用标准10行12列
INSERT INTO `seat` (`showtime_id`, `row_num`, `col_num`, `seat_label`, `seat_type`, `status`) 
SELECT st_id, CHAR(64 + row_num), col_num, CONCAT(CHAR(64 + row_num), col_num), 'NORMAL', 'AVAILABLE'
FROM (SELECT 31 AS st_id UNION SELECT 32 UNION SELECT 33 UNION SELECT 34 UNION SELECT 35
      UNION SELECT 36 UNION SELECT 37 UNION SELECT 38 UNION SELECT 39 UNION SELECT 40) s
CROSS JOIN (SELECT 1 AS row_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
            UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) r
CROSS JOIN (SELECT 1 AS col_num UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
            UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
            UNION SELECT 11 UNION SELECT 12) c;

-- =====================================================
-- 8. 更新所有场次的可用座位数
-- =====================================================
UPDATE `showtime` st SET `available_seats` = (
    SELECT COUNT(*) FROM `seat` s WHERE s.showtime_id = st.id AND s.status = 'AVAILABLE'
);

-- =====================================================
-- 数据统计
-- =====================================================
-- 用户: 3 (1管理员 + 2普通用户)
-- 影院: 10 (北京4家 + 上海3家 + 广州2家 + 深圳1家)
-- 影厅: 35
-- 影片: 12 (8部热映 + 4部即将上映)
-- 场次: 40 (覆盖7天，全部有座位数据)
-- 座位: ~15000+ (所有40个场次完整座位)
-- =====================================================

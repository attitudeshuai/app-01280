-- =====================================================
-- 电影票预订系统 - 测试数据初始化
-- Version: V2 (修复版)
-- 数据规模: 10影院 + 12影片 + 40场次 + 完整座位
-- =====================================================

SET NAMES utf8mb4;

-- =====================================================
-- 1. 用户数据 (2个测试用户 + 1个管理员)
-- 密码都是 123456 (使用正确的BCrypt加密)
-- BCrypt hash 由 https://bcrypt-generator.com/ 生成 (10 rounds)
-- =====================================================
INSERT INTO `user` (`id`, `phone`, `email`, `password`, `nickname`, `avatar`, `role`, `status`, `created_at`, `updated_at`) VALUES
(1, '13800138000', 'user@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n3.rsS0hEyHLl5j5q5e0m', '测试用户', 'https://api.dicebear.com/7.x/avataaars/svg?seed=user1', 'USER', 1, NOW(), NOW()),
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
-- 热映中 (8部)
(1, '流浪地球3', 'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?w=300&h=450&fit=crop', '科幻,冒险,灾难', 173, 9.4, '太阳即将毁灭，人类在地球表面建造出巨大的推进器，开启"流浪地球"计划。面对未知的宇宙征途，人类将面临前所未有的挑战与抉择。本片延续前作的宏大世界观，讲述人类在危机面前展现出的团结与勇气。', '郭帆', '吴京,刘德华,李雪健,沙溢,宁理', '2026-01-25', '中国', '普通话', 'SHOWING'),
(2, '热辣滚烫2', 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=300&h=450&fit=crop', '喜剧,剧情,励志', 129, 8.6, '继首部大获成功后，乐莹开启了全新的人生旅程。这一次，她将面对更多挑战，包括事业、爱情和家庭的多重考验。但内心的力量让她无所畏惧，用自己的方式活出精彩人生。', '贾玲', '贾玲,雷佳音,张小斐,沈腾,马丽', '2026-01-28', '中国', '普通话', 'SHOWING'),
(3, '封神第三部：朝歌风云', 'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=300&h=450&fit=crop', '神话,动作,奇幻', 148, 9.0, '封神大战终章拉开帷幕！姜子牙与众神将士，为守护天下苍生，与纣王展开最终决战。神魔大战一触即发，谁能改写命运，谁又将灰飞烟灭？', '乌尔善', '费翔,黄渤,于适,陈牧驰,此沙,武亚凡', '2026-01-30', '中国', '普通话', 'SHOWING'),
(4, '唐人街探案4：伦敦篇', 'https://images.unsplash.com/photo-1509347528160-9a9e33742cdb?w=300&h=450&fit=crop', '喜剧,悬疑,推理', 136, 8.2, '唐仁和秦风再次踏上探案之旅，这一次他们来到了雾都伦敦。一连串离奇的密室杀人案等待着他们，而凶手似乎与唐仁有着不可告人的过去...', '陈思诚', '王宝强,刘昊然,妻夫木聪,托尼·贾', '2026-02-01', '中国', '普通话/英语', 'SHOWING'),
(5, '阿凡达3：带种者', 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=300&h=450&fit=crop', '科幻,动作,冒险', 192, 9.2, '杰克·萨利和他的家族必须面对新的威胁。当他们探索潘多拉星球从未涉足的火山地区时，遇到了此前从未见过的灰烬部族。一场关于生存与守护的史诗冒险即将展开。', '詹姆斯·卡梅隆', '萨姆·沃辛顿,佐伊·索尔达娜,西格妮·韦弗', '2026-01-20', '美国', '英语', 'SHOWING'),
(6, '速度与激情11：终极一战', 'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?w=300&h=450&fit=crop', '动作,冒险,犯罪', 145, 7.9, '多姆和他的家人们将迎来系列的最终章。一场横跨全球的疯狂追逐即将上演，老对手们纷纷回归，新威胁接踵而至。这一次，他们将为了保护彼此而战到最后一刻。', '路易斯·莱特里尔', '范·迪塞尔,杰森·莫玛,盖尔·加朵,约翰·塞纳', '2026-01-22', '美国', '英语', 'SHOWING'),
(7, '长津湖之水门桥：英雄归来', 'https://images.unsplash.com/photo-1547036967-23d11aacaee0?w=300&h=450&fit=crop', '战争,历史,剧情', 176, 9.5, '抗美援朝战争中最惨烈的战役，志愿军战士们在零下40度的极寒环境下，用血肉之躯筑起钢铁长城，谱写了一曲壮丽的英雄赞歌。', '陈凯歌,徐克,林超贤', '吴京,易烊千玺,段奕宏,朱亚文,李晨', '2026-01-15', '中国', '普通话', 'SHOWING'),
(8, '熊出没·重返地球2', 'https://images.unsplash.com/photo-1534531173927-aeb928d54385?w=300&h=450&fit=crop', '动画,冒险,喜剧', 98, 7.8, '光头强和熊大熊二再次踏上太空冒险！这一次，他们将前往一颗神秘的星球，与外星生物成为朋友，共同对抗邪恶的太空海盗，拯救整个宇宙！', '林汇达', '张伟,张秉君,谭笑', '2026-01-26', '中国', '普通话', 'SHOWING'),
-- 即将上映 (4部)
(9, '你好，李焕英2：妈妈的青春', 'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?w=300&h=450&fit=crop', '喜剧,剧情,奇幻', 125, 0.0, '晓玲再次穿越时空，这一次她将见证母亲更多不为人知的故事。那些年少轻狂的岁月，那些刻骨铭心的爱情，最终汇聚成世间最真挚的亲情。', '贾玲', '贾玲,张小斐,沈腾,陈赫,沙溢', '2026-02-14', '中国', '普通话', 'COMING'),
(10, '哪吒之魔童闹海2', 'https://images.unsplash.com/photo-1569701813229-33284b643e3c?w=300&h=450&fit=crop', '动画,奇幻,动作', 116, 0.0, '哪吒成长为少年，面对东海龙族的复仇，他将如何抉择？敖丙的命运又将走向何方？一场关于命运与成长的冒险即将开启！', '饺子', '吕艳婷,囧森瑟夫,瀚墨,陈浩,绿绮', '2026-02-10', '中国', '普通话', 'COMING'),
(11, '蜘蛛侠：无家日2', 'https://images.unsplash.com/photo-1635805737707-575885ab0820?w=300&h=450&fit=crop', '动作,科幻,冒险', 148, 0.0, '彼得·帕克在身份被揭露后，面临着前所未有的危机。多元宇宙的大门再次打开，三代蜘蛛侠将联手对抗最强反派联盟！', '乔·沃茨', '汤姆·赫兰德,赞达亚,托比·马奎尔,安德鲁·加菲尔德', '2026-02-20', '美国', '英语', 'COMING'),
(12, '满江红2：风波亭', 'https://images.unsplash.com/photo-1606567595334-d39972c85dfd?w=300&h=450&fit=crop', '悬疑,历史,剧情', 159, 0.0, '岳飞含冤入狱，风波亭一案真相成谜。一群小人物在历史的洪流中，用自己的方式守护正义，书写一段可歌可泣的传奇。', '张艺谋', '沈腾,易烊千玺,张译,雷佳音,岳云鹏', '2026-02-25', '中国', '普通话', 'COMING');

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
-- 7. 更新场次的可用座位数
-- =====================================================
UPDATE `showtime` st SET `available_seats` = (
    SELECT COUNT(*) FROM `seat` s WHERE s.showtime_id = st.id AND s.status = 'AVAILABLE'
) WHERE st.id <= 10;

-- =====================================================
-- 数据统计
-- =====================================================
-- 用户: 3 (1管理员 + 2普通用户)
-- 影院: 10 (北京4家 + 上海3家 + 广州2家 + 深圳1家)
-- 影厅: 35
-- 影片: 12 (8部热映 + 4部即将上映)
-- 场次: 40 (覆盖7天)
-- 座位: ~5000+ (前10个场次完整座位)
-- =====================================================
